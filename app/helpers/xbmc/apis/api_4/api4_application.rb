# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Module that contains Application commands for XBMC JSON RPC API Version 4
module Application4
  
  # Toggles the Mute on/off
  def toggle_mute(callback)
    params = {:mute => 'toggle'}
    XbmcConnect::Application.set_mute(callback, params)
  end
  
  # Sets the Mute by a given Boolean.
  def set_mute(callback, bool)
    params = {:mute => bool}
    XbmcConnect::Application.set_mute(callback, params)
  end
  
  # Sets the volume to give a number
  def set_volume(callback, vol) 
    params = {:volume => vol.to_i}
    XbmcConnect::Application.set_volume(callback, params)
  end
  
  # Increases the volume by an increment of 5.
  # If the current volume is 96-99 it will set the volume at 100.
  # It uses a synchronous method to get the current volume.
  def increase_volume(callback) 
    cur_vol = get_volume(XbmcConnect::NOCALLB)['body'].with_indifferent_access[:result][:volume]
    if (cur_vol == 100)
      return
    elsif (cur_vol > 96)
      set_vol = 100
    else
      set_vol = cur_vol + 5
    end
    set_volume(callback, set_vol)
  end
  
  # Increases the volume by an decrement of 5.
  # If the current volume is 1-4 it will set the volume at 0.
  # It uses a synchronous method to get the current volume.
  def decrease_volume(callback)
    cur_vol = get_volume(XbmcConnect::NOCALLB)['body'].with_indifferent_access[:result][:volume]
    if (cur_vol == 0)
      return
    elsif (cur_vol < 5)
      set_vol = 0
    else
      set_vol = cur_vol - 5
    end
    set_volume(callback, set_vol)
  end
  
  # This is an asynchronous method to load the current volume.
  def get_volume(callback) 
    params = {:properties => ['volume']}
    XbmcConnect::Application.get_properties(callback, params)
  end
end