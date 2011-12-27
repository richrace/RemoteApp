
module ApiV4
  
  VERSION = 4

  class Playback
    require 'helpers/xbmc/apis/api_4/api4_controls'

    class << self
      include Control4
    end    
  end
  
end
 