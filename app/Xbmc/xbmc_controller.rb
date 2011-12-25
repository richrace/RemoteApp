require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'json'

# A simple XBMC JSON RPC API Client. See README for details.
class XbmcController < Rho::RhoController
  include ApplicationHelper
  include BrowserHelper
  
  ERROR401 = "Unauthorised"
  ERRORURL = "Error"
  ERRORAPI = "API Missing" 
  ERRORNO = "None"
  NOCALLB = "NOCALLB"
   
  # Returns an array of available api commands instantiated as Xbmc::Command objects
  def commands
    puts "**** LOADING COMMANDS"
    XbmcController.load_commands(@params)
  end
  
  class << self
    
    def setup(add, port, usr="", pass="")
      @url = add + ':' + "#{port}" + '/jsonrpc'
      @uname = usr
      @pass = pass
    end  
  
    def async_connect(callback, method, params={})
      puts "**** CONNECTING"
      Rho::AsyncHttp.post(
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
        }.to_json,
        :callback => callback
      )
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
      async_connect(callback,"JSONRPC.Introspect", :getdescriptions => true)  
    end 
    
    def load_commands(params)
      if params['status'] == 'ok'
        XbmcController.api_loaded = true
        @commands ||= params['body'].with_indifferent_access[:result][:commands].map {|c| XbmcController::Command.new(c)}
        @commands.each do |command|
          command.send :define_method!
        end
        XbmcController.error = {:error => XbmcController::ERRORNO, :msg => "Everything went as planned"}
      elsif params['http_error'] == '401'
        XbmcController.error = {:error => XbmcController::ERROR401, :msg => "Couldn't connect. Username and Password incorrect"}
        XbmcController.api_loaded = false
      else
        XbmcController.error = {:error => XbmcController::ERRORURL, :msg => "Couldn't connect. URL and/or Port incorrect"}
        XbmcController.api_loaded = false
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
    
    XbmcController.error = {:error => XbmcController::ERRORAPI, :msg => "API hasn't been loaded; cannot connect to XBMC Server"}
    
  end
end

require 'helpers/command'
