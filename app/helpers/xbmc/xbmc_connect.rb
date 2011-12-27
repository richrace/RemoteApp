require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'json'
require 'helpers/error_helper'
require 'helpers/xbmc/apis/xbmc_apis'

class XbmcConnect
  include ApplicationHelper
  include BrowserHelper
  include ErrorHelper
  
  ERROR401 = "Unauthorised"
  ERRORURL = "Error"
  ERRORAPI = "API Missing" 
  ERRORNO = "None"
  NOCALLB = "NOCALLB"
   
  class << self
    
    def setup(add, port, usr="", pass="")
      add.gsub!(/[Hh][Tt][Tt][Pp]:\/\//,"")
      @url = "http://" + add + ':' + "#{port}" + '/jsonrpc'
      @uname = usr
      @pass = pass
    end  
  
    def async_connect(callback, method, params={})
      puts "**** CONNECTING"
      body = {
        :jsonrpc => "2.0", 
        :params => params, 
        :id => "1",
        :method => method
      }.to_json
      Rho::AsyncHttp.post(
        :url => @url,
        :authentication => {
          :type => :basic,
          :username => @uname,
          :password => @pass
        },
        :body => body,
        :callback => callback
      )
      puts "SENDING ---- #{body}"
    end
    
    def sync_connect(method, params={})
      response = Rho::AsyncHttp.post(
        :url => @url,
        :authentication => {
          :type => :basic,
          :username => @uname,
          :password => @pass
        },
        :body => {
          :jsonrpc => "2.0", 
          :params => params, 
          :id => "1",
          :method => method
        }.to_json
      )
      return response
    end
    
    def load_api(callback="app/Xbmc/version")
      puts "***** GETTING VERSION ******"
      async_connect(callback, "JSONRPC.Version")
    end 
    
    def parse_commands_v4(body)
      puts "***** LOADS V4 Commands ******"
      @commands ||= body.with_indifferent_access[:result][:methods].map { |c|
        attrList = c.at(1)
        # Add command name to the specification
        attrList["command"] = c.at(0)
        # Process the command as usual
        XbmcConnect::Command.new(attrList)}
    end
    
    def parse_commands_v2(body)
      puts "***** LOADS V2 Commands *****"
      @commands ||= body.with_indifferent_access[:result][:commands].map {|c| XbmcConnect::Command.new(c)}
    end
    
    def load_version(params)
      puts "********** LOADING VERSION **********"
      if params['status'] == 'ok'
        XbmcConnect.version = params['body'].with_indifferent_access[:result][:version]
        puts "****** LOADING API ********"
        async_connect("app/Xbmc/commands","JSONRPC.Introspect", :getdescriptions => true)
      else
        ErrorHelper.error_handle(params)
      end
    end
    
    def load_commands(params)
      puts "*********** LOADING COMMANDS ************"
      if params['status'] == 'ok'
        @commands = nil
        if XbmcConnect.version == Api::V2::VERSION
          parse_commands_v2(params['body'])
        elsif (XbmcConnect.version == Api::V4::VERSION) || (XbmcConnect.version == 3)
          parse_commands_v4(params['body'])
        end
        @commands.each do |command|
          command.send :define_method!
        end
        XbmcConnect.api_loaded = true
        XbmcConnect.error = {:error => XbmcConnect::ERRORNO, :msg => "Everything went as planned"}
      else
        ErrorHelper.error_handle(params)
      end
    end
    
    def api_loaded?
      if @api_loaded == true
        return true
      else
        return false
      end
    end
    
    def api_loaded=(value)
      @api_loaded = value
    end
    
    def error
      return @error
    end
    
    def error=(value)
      @error = value
    end
    
    def version
      return @version
    end
    
    def version=(value)
      @version = value
    end
    
    XbmcConnect.error = {:error => XbmcConnect::ERRORAPI, :msg => "API hasn't been loaded; cannot connect to XBMC Server"}
    
  end
end

require 'helpers/xbmc/command'
