require 'helpers/error_helper'

module Control2
  include ErrorHelper
    
  def get_player
    res = XbmcConnect::Player.get_active_players(XbmcConnect::NOCALLB)
    if res['status'] != 'ok'
      ErrorHelper.error_handle(res)
      return nil
    else
      return res['body'].with_indifferent_access[:result]
    end
  end
  
  def play_pause(callback)
    cur_player = get_player
    unless cur_player.nil?
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.play_pause(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.play_pause(callback)
      elsif cur_player[:picture] == true
        XbmcConnect::PicturePlayer.play_pause(callback)
      end
    end
  end
  
  def stop(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.stop(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.stop(callback)
      elsif cur_player[:picture] == true
        XbmcConnect::PicturePlayer.stop(callback)
      end
    end
  end
  
  def rewind(callback)
     cur_player = get_player
     unless cur_player.nil? 
       if cur_player[:audio] == true
         XbmcConnect::AudioPlayer.rewind(callback)
       elsif cur_player[:video] == true
         XbmcConnect::VideoPlayer.rewind(callback)
       end
     end
   end

   def fast_forward(callback)
      cur_player = get_player
      unless cur_player.nil? 
        if cur_player[:audio] == true
          XbmcConnect::AudioPlayer.forward(callback)
        elsif cur_player[:video] == true
          XbmcConnect::VideoPlayer.forward(callback)
        end
      end
    end

  def big_skip_forward(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.big_skip_forward(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.big_skip_forward(callback)
      end
    end
  end

  def sm_skip_forward(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.small_skip_forward(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.small_skip_forward(callback)
      else
        @@test = "No active players"
      end
    end
  end

  def big_skip_back(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.big_skip_backward(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.big_skip_backward(callback)
      end
    end
  end

  def sm_skip_back(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.small_skip_backward(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.small_skip_backward(callback)
      end
    end
  end

  def skip_next(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.skip_next(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.skip_next(callback)
      elsif cur_player[:picture] == true
        XbmcConnect::PicturePlayer.skip_next(callback)
      end
    end
  end

  def skip_prev(callback)
    cur_player = get_player
    unless cur_player.nil? 
      if cur_player[:audio] == true
        XbmcConnect::AudioPlayer.skip_previous(callback)
      elsif cur_player[:video] == true
        XbmcConnect::VideoPlayer.skip_previous(callback)
      elsif cur_player[:picture] == true
        XbmcConnect::PicturePlayer.skip_previous(callback)
      end
    end
  end
  
end