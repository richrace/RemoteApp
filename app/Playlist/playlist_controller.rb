require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'helpers/playlist_helper'
require 'helpers/method_helper'
require 'helpers/xbmc/apis/xbmc_apis'
require 'helpers/error_helper'
require 'helpers/movie_helper'
require 'helpers/tv_episode_helper'

class PlaylistController < Rho::RhoController
  include BrowserHelper
  include PlaylistHelper
  include MethodHelper
  include ErrorHelper
  include MovieHelper
  include TvEpisodeHelper
  
  def index
  end

  def update_playlist
  	send_command {Api::V4::Playlist.get_video_items(url_for(:action => :playlist_callback))}
  end

  def playlist_callback
  	puts "PLAYLIST CALLBACK"
  	puts "BODY === #{@params['body']}"

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
          puts "THE FOUND VIDEOS === "
          videos.each {|video| puts "VIDEO TITLE === #{video.title}"}
          WebView.execute_js("updatePlaylist(#{JSON.generate(videos)});")        
        end
      else
        WebView.execute_js("clearList();")  
      end
  	end
  end

  def play_item
    send_command {Api::V4::Playlist.play_video_position(@params['position'], url_for(:action => :play_item_callback))}
  end

  def play_item_callback
    puts "#{@params['body']}"
  end

  def remove_item
    send_command {Api::V4::Playlist.remove_video_position(@params['position'], url_for(:action => :remove_item_callback))}
  end

  def remove_item_callback
    if @params['status'] != 'ok'
      error_handle(@params)
      WebView.execute_js("showToastError('#{XbmcConnect.error[:msg]}');")
    else
      unless @params['body']['result']
        WebView.execute_js("showToastError('Can\\\'t delete Current Playing Media');")
      else
        WebView.execute_js("showToastSuccess('Removed from Playlist');");
        update_playlist
      end
    end
    puts "#{@params['body']}"
  end

end
