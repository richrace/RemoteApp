# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Model for the Products AKA Buy Later List
class Product
  include Rhom::FixedSchema
  include Validatable

  # Relationship to XBMC
  belongs_to :xbmc_id, 'XbmcConfig'

  # Validation checks
  validates_presence_of :title, :message => "Product needs to have a title"
  validates_presence_of :xbmc_id, :message => "Needs to have an XBMC Config"

  validates_numericality_of :xbmc_id, :message => "XBMC Config ID needs to be a number"

  set :schema_version, "1.0"

  # Table Entries
  property :title, :string
  property :xbmc_id, :float

end
