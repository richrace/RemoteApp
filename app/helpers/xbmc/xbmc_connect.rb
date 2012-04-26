# Author::    Christoph Olszowka, Modifications by Richard Race (rcr8)
# License::   MIT Licence

require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'json'
require 'helpers/error_helper'
require 'helpers/xbmc/apis/xbmc_apis'

# XbmcConnect class heavily modified by Richard Race to be used within the Rhodes 
# Framework.
# Original by Christoph Olszowka - https://github.com/colszowka/xbmc-client
class XbmcConnect
  include ApplicationHelper
  include BrowserHelper
  
  # Text for a 401 (unauthorised) HTTP Code
  ERROR401 = "Unauthorised"
  # Text for a URL error
  ERRORURL = "Error"
  # Text for no API being Loaded
  ERRORAPI = "API Missing" 
  # Text for no error happening
  ERRORNO = "None"
  # Constant used for params when no Callback is wanted.
  NOCALLB = "NOCALLB"
  
  # Assigns all methods to be constant.
  class << self
    include ErrorHelper
    
    # Array used for what APIs are currently loaded
    attr_accessor :loaded_apis
    # If there is a connection error it will be stored here.
    attr_accessor :error
    # Need to create a new Array
    XbmcConnect.loaded_apis = Array.new
    
    # Sets up the networking information to be used throughout this class.
    # usr and pass can be nill.
    # The address can contain 'http://' or not, it will be stripped if it is present.
    def setup(add, port, usr="", pass="")
      # Regex to strip leading 'http://'
      add.gsub!(/[Hh][Tt][Tt][Pp]:\/\//,"")
      # This is the URL for connecting to the JSON RPC API
      @url = "http://" + add + ':' + "#{port}" + '/jsonrpc'
      # This is needed for downloading of images.
      @base = "http://" + add + ':' + "#{port}/"
      @uname = usr
      @pass = pass
    end  
  
    # Main method used to connecting to the XBMC server; this is asynchronous
    # Uses the Rho::AsyncHTTP.post method as the JSON RPC commands and params are contained 
    # within the body of the post.
    # params parameter can be null.
    # Will not return any data, that is what the callback is used for. The callback need to be 
    # a URL for a controller.
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
    
    # A synchronous method used to connecting to the XBMC server.
    # Uses the Rho::AsyncHTTP.post method as well (see async_connect method).
    # There is no callback needed and will return data.
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
    
    # An asynchronous method for downloading files (images) from a given address. 
    # The address is the XBMC "vfs://special/xxxx" format to be added onto the base address:
    # "http://localhost:8080/vfs://special/xxxx"
    # All the parameters are required. The outcome of the downloading of the file will be sent
    # to the callback method.
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
    
    # Main command for loading the API. Will get the current version of the XBMC server
    # before loading the commands. Can accept a different Callback.
    def load_api(callback="app/Xbmc/version")
      puts "***** GETTING VERSION ******"
      if XbmcConfigHelper.current_config.nil?
        error_handle
      else
        async_connect(callback, "JSONRPC.Version")
      end
    end 
    
    # Assigns the version of the current XBMC server. Calls the Introspect method to load 
    # the available commands.
    def load_version(params)
      puts "********** LOADING VERSION **********"
      xbmc = XbmcConfigHelper.current_config
      xbmc.version = params['body'].with_indifferent_access[:result][:version]
      xbmc.save
      puts "****** LOADING API ********"
      async_connect("app/Xbmc/commands","JSONRPC.Introspect", :getdescriptions => true)
    end
    
    # Loads the commands depending on the version. Double checks that the API is loaded correctly,
    # then sets that the API is loaded into the load_apis array.
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
      unless XbmcConnect.loaded_apis.include?(xbmc.version)
        XbmcConnect.loaded_apis << xbmc.version 
        XbmcConnect.error = {:error => XbmcConnect::ERRORNO, :msg => "Everything went as planned"}
      end
    end
    
    # Parses the commands for XBMC Eden Version 11. Uses the structure that was in place from the 
    # original class.
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

    # Parses the commands for XBMC Dhrama Version 10.1. Uses the structure that was in place from the 
    # original class.
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

