# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Tvepisode
  include Rhom::PropertyBag
  belongs_to :Tvseason, 'Tvseason'
  belongs_to :Tvshow, 'Tvshow'

  # Uncomment the following line to enable sync with Tvepisode.
  # enable :sync

  #add model specifc code here
end
