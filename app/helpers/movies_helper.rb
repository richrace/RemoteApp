module MoviesHelper
  
  def set_callbacks
    @movies_cb = url_for(:action => :movies_callback)
    @detail_cb = url_for(:action => :detail_callback)
  end
  
end