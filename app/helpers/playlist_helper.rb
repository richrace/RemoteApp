# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/xbmc_config_helper'

# Helper for the Playlist controller.
module PlaylistHelper
  include XbmcConfigHelper

  # Selects the current XBMC server API. JSON RPC version 3/4 is 
  # only supported.
  # Loads the Video playlist.
  def update_playlist_helper(callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playlist.get_video_items(callback)
      end
    end
  end

  # Selects the current XBMC server API. JSON RPC version 3/4 is 
  # only supported.
  # Plays the video playlist at a given position.
  def play_viedo_playlist_at_position(position, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playlist.play_video_position(position, callback)
      end
    end
  end

  # Selects the current XBMC server API. JSON RPC version 3/4 is 
  # only supported.
  # Removes a video from the video playlist at a given position.
  def remove_video_playlist_at_position(position, callback)
    version = XbmcConfigHelper.current_config.version.to_i
    unless version.nil?
      if (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::Playlist.remove_video_position(position, callback)
      end
    end
  end

end