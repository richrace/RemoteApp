require 'json'
require 'helpers/xbmc_config_helper'
require 'xbmc/xbmc_controller'

module ControlsHelper
  include XbmcConfigHelper
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def play_pause_player
    active_player = false
    res = XbmcController::Player.get_active_players(XbmcController::NOCALLB)
    if res['status'] != 'ok'
      error_handle(res)
    else
      if res['body'].with_indifferent_access[:result][:audio] == true
        active_player = true
        send_command {XbmcController::AudioPlayer.play_pause(url_for :controller =>   :Controls, :action => :control_callback, :query => {:method => "play_pause"})}
      elsif res['body'].with_indifferent_access[:result][:video] == true
        active_player = true
        send_command {XbmcController::VideoPlayer.play_pause(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"})}
      elsif res['body'].with_indifferent_access[:result][:picture] == true
        active_player = true
        send_command {XbmcController::PicturePlayer.play_pause(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"})}
      else
        @@test = "No active players"
      end
    end
  end
end