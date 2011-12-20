require 'json'

class ConnectionHelper
    
  def initialize(add, port, usr="", pass="") 
    @url = add + ':' + port + '/jsonrpc'
    @uname = usr
    @pass = pass
  end
  
  def connect(callback, method, params={})
    puts "making post."
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
        :method => method, 
        :id => "1"
      }.to_json,
      :callback => callback,
    )
    puts "sent post"
  end
end