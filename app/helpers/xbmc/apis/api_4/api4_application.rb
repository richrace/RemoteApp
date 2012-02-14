module Application4
  
  def set_mute(callback, bool)
    params = {:mute => bool}
    XbmcConnect::Application.set_mute(callback, params)
  end
  
  def set_volume(callback, vol) 
    params = {:volume => vol.to_i}
    XbmcConnect::Application.set_volume(callback, params)
  end
end