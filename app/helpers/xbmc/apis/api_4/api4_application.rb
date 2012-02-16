module Application4
  
  def toggle_mute(callback)
    params = {:mute => 'toggle'}
    XbmcConnect::Application.set_mute(callback, params)
  end
  
  def set_mute(callback, bool)
    params = {:mute => bool}
    XbmcConnect::Application.set_mute(callback, params)
  end
  
  def set_volume(callback, vol) 
    params = {:volume => vol.to_i}
    XbmcConnect::Application.set_volume(callback, params)
  end
  
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
  
  def get_volume(callback) 
    params = {:properties => ['volume']}
    XbmcConnect::Application.get_properties(callback, params)
  end
end