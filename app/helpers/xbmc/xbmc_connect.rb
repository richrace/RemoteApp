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
    
    attr_accessor :loaded_apis, :error
    XbmcConnect.loaded_apis = Array.new
    
    def setup(add, port, usr="", pass="")
      add.gsub!(/[Hh][Tt][Tt][Pp]:\/\//,"")
      @url = "http://" + add + ':' + "#{port}" + '/jsonrpc'
      @base = "http://" + add + ':' + "#{port}/"
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
    
    def download_file(address, filename, callback, param) 
      Rho::AsyncHttp.download_file(
        :url => @base + address,
        :authentication => {
          :type => :basic,
          :username => @uname,
          :password => @pass
        },
        :filename => filename,
        :headers => {},
        :callback => callback,
        :callback_param => param
      )
    end
    
    def load_api(callback="app/Xbmc/version")
      puts "***** GETTING VERSION ******"
      if XbmcConfigHelper.current_config.nil?
        error_handle
      else
        async_connect(callback, "JSONRPC.Version")
      end
    end 
    
    def load_version(params)
      puts "********** LOADING VERSION **********"
      xbmc = XbmcConfigHelper.current_config
      xbmc.version = params['body'].with_indifferent_access[:result][:version]
      xbmc.save
      puts "****** LOADING API ********"
      async_connect("app/Xbmc/commands","JSONRPC.Introspect", :getdescriptions => true)
    end
    
    def load_commands(params)
      puts "*********** LOADING COMMANDS ************"
      @commands = nil
      cur_version = XbmcConfigHelper.current_config.version.to_i
      if cur_version == Api::V2::VERSION
        parse_commands_v2(params['body'])
      elsif (cur_version == Api::V4::VERSION) || (cur_version == 3)
        parse_commands_v4(params['body'])
      end
      @commands.each do |command|
        command.send :define_method!
      end
      xbmc = XbmcConfigHelper.current_config
      XbmcConnect.loaded_apis << xbmc.version unless XbmcConnect.loaded_apis.include?(xbmc.version)
      XbmcConnect.error = {:error => XbmcConnect::ERRORNO, :msg => "Everything went as planned"}
    end
    
    def parse_commands_v4(body)
      puts "***** LOADS V4 Commands ******"
      @commands ||= body.with_indifferent_access[:result][:methods].map { |c|
        attrList = c.at(1)
        # Add command name to the specification
        attrList["command"] = c.at(0)
        # Process the command as usual
        XbmcConnect::Command.new(attrList)
      }
    end
    
    def parse_commands_v2(body)
      puts "***** LOADS V2 Commands *****"
      @commands ||= body.with_indifferent_access[:result][:commands].map {|c| XbmcConnect::Command.new(c)}
    end
    
    # Checks the array of loaded APIs to see if the current XBMC API has been loaded.
    def api_loaded? 
      xbmc = XbmcConfigHelper.current_config
      if xbmc.nil?
        error_handle
        return false
      elsif XbmcConnect.loaded_apis.include?(xbmc.version.to_i)
        return true
      else 
        return false
      end
    end
  end
end

# Need the above class defined before can require the following class.
require 'helpers/xbmc/command'

