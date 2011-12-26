require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'json'
require 'helpers/api2'
require 'helpers/api4'

class XbmcConnect
  include ApplicationHelper
  include BrowserHelper
  
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
    
    def load_api(callback="app/Xbmc/commands")
      puts "********** LOADING API **********"
      res = sync_connect("JSONRPC.Version")
      puts res['body']
      if res['status'] == 'ok'
        XbmcConnect.version = res['body'].with_indifferent_access[:result][:version]
        async_connect(callback,"JSONRPC.Introspect", :getdescriptions => true)  
      else
        async_connect(callback,"JSONRPC.Version")
        error_handle(res)
      end
    end 
    
    def parse_commands_v4(body)
      puts "***** LOADS V4 Commands ******"
      @commands ||= body.with_indifferent_access[:result][:methods].map {|c| XbmcConnect::Command.new(c, true)}
    end
    
    def parse_commands_v2(body)
      puts "***** LOADS V2 Commands *****"
      @commands ||= body.with_indifferent_access[:result][:commands].map {|c| XbmcConnect::Command.new(c)}
    end
    
    def load_commands(params)
      puts "*********** LOADING COMMANDS ************"
      if params['status'] == 'ok'
        @commands = nil
        if XbmcConnect.version == ApiV2::VERSION
          parse_commands_v2(params['body'])
        elsif (XbmcConnect.version == ApiV4::VERSION) || (XbmcConnect.version == 3)
          parse_commands_v4(params['body'])
        end
        @commands.each do |command|
          command.send :define_method!
        end
        XbmcConnect.api_loaded = true
        XbmcConnect.error = {:error => XbmcConnect::ERRORNO, :msg => "Everything went as planned"}
      else
        error_handle(params)
      end
    end
    
    def error_handle(params)
      if params['http_code'] == '401'
        XbmcConnect.error = {:error => XbmcConnect::ERROR401, :msg => "Couldn't connect. Username and Password incorrect"}
        XbmcConnect.api_loaded = false
      else
        XbmcConnect.error = {:error => XbmcConnect::ERRORURL, :msg => "Couldn't connect. URL and/or Port incorrect"}
        XbmcConnect.api_loaded = false
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

require 'helpers/command'
