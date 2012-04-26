# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Adds namespaces in the following format "Api::V4::"
module ApiV4

  # Version of which JSONRPC API this reflects
  VERSION = 4

  # Holds the commands for Player.
  # Is accessed by "Api::V4::Playback.<command>" The commands are found in
  # the file listed in the require.
  class Playback
    require 'helpers/xbmc/apis/api_4/api4_controls'

    class << self
      include Control4
    end    
  end
  
  # Holds the commands for the VideoLibrary. Is accessed by:
  # "Api::V4::VideoLibrary.<command>" 
  class VideoLibrary
    require 'helpers/xbmc/apis/api_4/api4_video'
    
    class << self
      include VideoLibrary4
    end
  end

  # Holds the commands for the Input. Is accessed by:
  # "Api::V4::Input.<command>" 
  class Input
    require 'helpers/xbmc/apis/api_4/api4_input'

    class << self
      include Input4 
    end
  end

  # Holds the commands for the Application. Is accessed by:
  # "Api::V4::Application.<command>" 
  class Application
    require 'helpers/xbmc/apis/api_4/api4_application'

    class << self
      include Application4
    end
  end

  # Holds the commands for the Playlist. Is accessed by:
  # "Api::V4::Playlist.<command>" 
  class Playlist
    require 'helpers/xbmc/apis/api_4/api4_playlist'

    class << self
      include Playlist4
    end
  end
  
end
 