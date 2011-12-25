require 'rho/rhocontroller'
require 'helpers/application_helper'
require 'helpers/ruby_ext'
require 'helpers/browser_helper'
require 'json'

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
        XbmcConnect.api_loaded = true
        @commands ||= params['body'].with_indifferent_access[:result][:commands].map {|c| XbmcConnect::Command.new(c)}
        @commands.each do |command|
          command.send :define_method!
        end
        XbmcConnect.error = {:error => XbmcConnect::ERRORNO, :msg => "Everything went as planned"}
      elsif params['http_error'] == '401'
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
    
    XbmcConnect.error = {:error => XbmcConnect::ERRORAPI, :msg => "API hasn't been loaded; cannot connect to XBMC Server"}
    
  end
end

require 'helpers/command'
