class XbmcConfig
  include Rhom::FixedSchema
  include Validatable
  
  validates_presence_of :name, :message => "You need to add a Name"
  validates_presence_of :url, :message => "You must include a URL (can be IP or hostname)"
  validates_presence_of :port, :message => "You need to include a port number"
  validates_presence_of :usrname, :message => "You need to include your XBMC username"
  
  validates_numericality_of :port, :message => "Port needs to be a integer", :only_integer => true
  validates_numericality_of :version, :message => "Version needs to be an integer", :only_integer => true

  # Before Validation is used to assign 0 value to
  # version if it has not been assigned any value. 
  before_validation do
    unless self.version
      self.version = 0
    end
  end

  set :schema_version, '1.3'

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
