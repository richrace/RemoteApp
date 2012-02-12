# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Movie
  include Rhom::PropertyBag
  
  belongs_to :xbmc_id, 'XbmcConfig'
    
  # Uncomment the following line to enable sync with Movie.
  # enable :sync

  #add model specifc code here
  
  def destroy_image
    File.delete(self.l_thumb) if File.exists?(self.l_thumb) 
  end
  
end
