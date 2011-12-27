require 'telnet'

module TelTest
  
  def teltest
    Thread.new {
    localhost = Net::Telnet::new("Host" => "localhost", "Port" => 9090, "Timeout" => 120, "Prompt" => /[$%#>] \z/n) {|c| puts "TELNET TEST ====== #{c}"}
    localhost.cmd({'jsonrpc'=>'2.0', 'id'=>'1', 'method'=>'JSONRPC.Ping'}.to_json) {|c| puts "TELNET TEST ====== #{c}"}
    }
  end
end