# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Product
  include Rhom::FixedSchema
  include Validatable

  belongs_to :xbmc_id, 'XbmcConfig'

  validates_presence_of :title, :message => "Product needs to have a title"
  validates_presence_of :xbmc_id, :message => "Needs to have an XBMC Config"

  # Uncomment the following line to enable sync with Product.
  # enable :sync

  #add model specifc code here

  set :schema_version, "1.0"

  property :title, :string
  property :xbmc_id, :float

end
