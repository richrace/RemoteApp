require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'json'
require 'helpers/error_helper'
require 'helpers/xbmc/apis/xbmc_apis'

class XbmcConnect
  include ApplicationHelper
  include BrowserHelper
  
  ERROR401 = "Unauthorised"
  ERRORURL = "Error"
  ERRORAPI = "API Missing" 
  ERRORNO = "None"
  NOCALLB = "NOCALLB"
   
  class << self
    include ErrorHelper
    
    def setup(add, port, usr="", pass="")
      add.gsub!(/[Hh][Tt][Tt][Pp]:\/\//,"")
      @url = "http://" + add + ':' + "#{port}" + '/jsonrpc'
      @uname = usr
      @pass = pass
      #@api_loaded = false;
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
        error_handle(params)
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
        error_handle(params)
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
      puts "API_LOADED SETTER VALUE == #{value}"
      @api_loaded = value
      puts "API_LOADED SETTER AFTER ASSIGN == #{@api_loaded}"
      puts "API_LOADED FROM CONSTANT == #{XbmcConnect.api_loaded?}"
    end
    
    def error
      return @error
    end
    
    def error=(value)
      @error = value
    end
    
    # Only returns the current API version.
    def version
      return @version
    end
    
    def version=(value)
      @version = value
    end
    
    # Checks if there is a current XBMC Config active, the API is loaded and
    # then returns the version number. If there is no current XBMC Config returns
    # nil. Will also return nil if there is no API Loaded, it will also attempt to 
    # load the current XBMC Config API. Before each nil is 
    # returned ErrorHelper Error Handle method is called.
    def get_version
      unless XbmcConfigHelper.current_config.nil?
        puts "GETS VERSION ---- #{XbmcConnect.api_loaded?}"
        if XbmcConnect.api_loaded?
          return @version
        else
          XbmcConnect.load_api # Callback needed.
          #error_handle
          return nil
        end
      else
        error_handle
        return nil
      end
    end
    
  end
end

require 'helpers/xbmc/command'
