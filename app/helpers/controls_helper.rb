require 'json'
require 'helpers/xbmc_config_helper'
require 'helpers/xbmc_connect'

module ControlsHelper
  include XbmcConfigHelper
  
  def get_player
    res = XbmcConnect::Player.get_active_players(XbmcConnect::NOCALLB)
    if res['status'] != 'ok'
      error_handle(res)
      return nil
    else
      return res['body'].with_indifferent_access[:result]
    end
  end
  
  # Used to find out what the current player is. Will be needed before using controls
  # This is needed for XBMC Version 10.1
  def play_pause_player
    cur_player = get_player
    unless cur_player.nil?
      if cur_player[:audio] == true
        send_command {XbmcConnect::AudioPlayer.play_pause(url_for :controller =>   :Controls, :action => :control_callback, :query => {:method => "play_pause"})}
      elsif cur_player[:video] == true
        send_command {XbmcConnect::VideoPlayer.play_pause(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"})}
      elsif cur_player[:picture] == true
        send_command {XbmcConnect::PicturePlayer.play_pause(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "play_pause"})}
      else
        @@test = "No active players"
      end
    end
  end
  
  def stop_player
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        send_command {XbmcConnect::AudioPlayer.stop(url_for :controller =>   :Controls, :action => :control_callback, :query => {:method => "stop"})}
      elsif cur_player[:video] == true
        send_command {XbmcConnect::VideoPlayer.stop(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "stop"})}
      elsif cur_player[:picture] == true
        send_command {XbmcConnect::PicturePlayer.stop(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "stop"})}
      else
        @@test = "No active players"
      end
    end
  end
  
  def big_skip_forward_player
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        send_command {XbmcConnect::AudioPlayer.big_skip_forward(url_for :controller =>   :Controls, :action => :control_callback, :query => {:method => "bs_forward"})}
      elsif cur_player[:video] == true
        send_command {XbmcConnect::VideoPlayer.big_skip_forward(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "bs_forward"})}
      else
        @@test = "No active players"
      end
    end
  end
  
  def sm_skip_forward_player
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        send_command {XbmcConnect::AudioPlayer.small_skip_forward(url_for :controller =>   :Controls, :action => :control_callback, :query => {:method => "ss_forward"})}
      elsif cur_player[:video] == true
        send_command {XbmcConnect::VideoPlayer.small_skip_forward(url_for :controller => :Controls, :action => :control_callback, :query => {:method => "ss_forward"})}
      else
        @@test = "No active players"
      end
    end
  end
end