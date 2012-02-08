require 'helpers/movie_helper'

module MovieHelper
  include XbmcConfigHelper
  
  def set_callbacks
    @movies_cb = url_for(:action => :movies_callback)
    @detail_cb = url_for(:action => :detail_callback)
  end
  
  def filter_movie_xbmc
    xbmc = XbmcConfigHelper.current_config
    puts "XBMC ---- #{xbmc}"
    puts "XBMC IS BLANK? --- #{xbmc.blank?}"
    if !xbmc.blank?
      Movie.find(:all, :conditions => { :xbmc_id => xbmc.object })
    else
      return nil
    end
  end

end