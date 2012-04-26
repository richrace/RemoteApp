# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/obj_helper'

# Model for the TV Seasons
class Tvseason
  include Rhom::FixedSchema
  include Validatable
  include ObjHelper

  # Defines the relationships
  belongs_to :tvshow_id, 'Tvshow'  
  belongs_to :xbmc_id, 'XbmcConfig'

  # Validation rules for the model
  validates_presence_of :xbmc_id, :message => "Needs to have an XBMC Config"
  validates_presence_of :xlib_id, :message => "Requires XBMC Season ID"
  validates_presence_of :tvshow_id, :message => "Requires XBMC TV Show ID"
  validates_presence_of :label, :message => "Requires label"
  validates_presence_of :showtitle, :message => "Requires tv show title"
  validates_presence_of :thumb, :message => "Requires remote thumb"
  validates_presence_of :fanart, :message => "Requires requires remote fanart"

  validates_numericality_of :xbmc_id, :message => "XBMC Config ID needs to be a number"
  validates_numericality_of :xlib_id, :message => "XBMC Season ID needs to be an integer", :only_integer => true
  validates_numericality_of :tvshow_id, :message => "XBMC TV Show ID needs to be an integer", :only_integer => true

  set :schema_version, '1.0'

  # Entries in the table.
  property :xbmc_id, :float
  property :xlib_id, :integer
  property :tvshow_id, :integer
  property :label, :string
  property :showtitle, :string
  property :thumb, :string
  property :fanart, :string

  property :l_thumb, :string
  property :l_fanart, :string
  property :url, :string
  
  # Deletes the Thumbnail images
  def destroy_image
    destroy_thumb_image
  end
end
