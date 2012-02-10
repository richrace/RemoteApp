module MethodHelper
  
  # Makes sure there is a Current Config and the correct API is loaded 
  # before executing the block. If the API hasn't been loaded it will
  # load the API then execute the block if the API loads successfully.
  def send_command # Block
    if XbmcConfigHelper.current_config.blank? 
      error_handle
    elsif XbmcConnect.api_loaded?
      yield
    else
      XbmcConnect.load_api
      Thread.new {
        start = Time.now
        timeout = 10
        cur_wait = 0
        while (cur_wait <= timeout)
          now = Time.now
          cur_wait = now - start
          sleep(1)
          break if XbmcConnect.api_loaded?
        end
        if XbmcConnect.api_loaded?
          yield
        end
      }
    end
  end
  
end