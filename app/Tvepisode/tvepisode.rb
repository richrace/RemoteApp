# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Tvepisode
  include Rhom::PropertyBag
  belongs_to :tvseason_id, 'Tvseason'
  belongs_to :tvshow_id, 'Tvshow'
  belongs_to :xbmc_id, 'XbmcConfig'

  # Uncomment the following line to enable sync with Tvepisode.
  # enable :sync

  #add model specifc code here

  def destroy_image
    unless self.l_thumb.blank?
      File.delete(self.l_thumb) if File.exists?(self.l_thumb)
      self.l_thumb = nil
      self.save
    end
  end

end
