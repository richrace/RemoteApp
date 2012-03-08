# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class XbmcConfig
  include Rhom::FixedSchema
  include Validatable
  
  validates_presence_of :name, :message => "You need to add a Name"
  validates_presence_of :url, :message => "You must include a URL (can be IP or hostname)"
  validates_presence_of :port, :message => "You need to include a port number"
  validates_presence_of :usrname, :message => "You need to include your XBMC username"
  validates_numericality_of :port, :message => "Port needs to be a number"

  # Uncomment the following line to enable sync with XbmcConfig.
  # enable :sync

  #add model specifc code here
  
  # Set the current version of the fixed schema.
  # Your application may use it for data migrations.
  set :schema_version, '1.3'

  # Define fixed schema attributes.
  # :string and :blob types are supported.
  property :name, :string
  property :url, :string
  property :port, :integer
  property :usrname, :string
  property :password, :string
  property :active, :boolean  
  property :version, :integer  
  
  def is_active?
    if self.active == "true"
      return true
    else
      return false
    end 
  end
end
