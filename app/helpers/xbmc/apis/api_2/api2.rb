# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Adds namespaces in the following format "Api::V2::"
module ApiV2
  
  # Version of which JSONRPC API this reflects
  VERSION = 2
  
  # Holds the commands for VideoPlayer, AudioPlayer and PicturePlayer
  # Is accessed by "Api::V2::Playback.<command>" The commands are found in
  # the file listed in the require.
  class Playback
    require 'helpers/xbmc/apis/api_2/api2_controls'

    class << self
      include Control2
    end
  end
  
  # Holds the commands for the VideoLibrary. Is accessed by:
  # "Api::V2::VideoLibrary.<command>" 
  class VideoLibrary
    require 'helpers/xbmc/apis/api_2/api2_video'
    
    class << self
      include VideoLibrary2
    end
  end
  
end