# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/playlist_helper'
require 'helpers/method_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'helpers/movie_helper'
require 'helpers/tv_episode_helper'

# Controller for the Playlist interface
class PlaylistController < Rho::RhoController
  include BrowserHelper
  include PlaylistHelper
  include MethodHelper
  include ErrorHelper
  include MovieHelper
  include TvEpisodeHelper
  
  # GET /Playlist
  def index
  end

  # Updates the playlist 
  def update_playlist
  	send_command {update_playlist_helper(url_for(:action => :playlist_callback))}
  end

  # Callback for update the playlist.
  # Will inform the user of a network connection. Will sort the returned items into Movies and TV Episodes.
  # Will update the display with the list of the Movies and TV Episodes. If there are no items it will 
  # clear the list.
  def playlist_callback
  	if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")  	
    else
      result = @params['body'].with_indifferent_access[:result]
      if result[:items]
        videos = []
        result[:items].each do | item |
          if item[:type] == "movie"
            found = find_movie(item[:id])
          elsif item[:type] == "episode"
            found = find_episode(item[:id])
          end
          unless found.blank?
            videos << found
          end
        end
        unless videos.blank?
          WebView.execute_js("updatePlaylist(#{JSON.generate(videos)});")        
        end
      else
        WebView.execute_js("clearList();")  
      end
  	end
  end

  # Will play the given item in the playlist based of the position.
  def play_item
    send_command {play_viedo_playlist_at_position(@params['position'], url_for(:action => :play_item_callback))}
  end

  # Informs the user if the request to play the media was successful or not
  def play_item_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      if @params['body']['result']
        WebView.execute_js("showToastSuccess('Playing from item');")
        update_playlist
      end
    end
  end

  # Will remove the item from the playlist based of the position.
  def remove_item
    send_command {remove_video_playlist_at_position(@params['position'], url_for(:action => :remove_item_callback))}
  end

  # Informs the user if the request to remove item from the playlist was successful or not.
  def remove_item_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      unless @params['body']['result']
        WebView.execute_js("showToastError('Can\\\'t delete Current Playing Media');")
      else
        WebView.execute_js("showToastSuccess('Removed from Playlist');")
        update_playlist
      end
    end
  end

end
