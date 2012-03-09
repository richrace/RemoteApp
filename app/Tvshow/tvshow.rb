require 'helpers/obj_helper'

class Tvshow
  include Rhom::FixedSchema
  include Validatable
  include ObjHelper

  belongs_to :xbmc_id, 'XbmcConfig'

  validates_presence_of :xbmc_id, :message => "Needs to have an XBMC Config"
  validates_presence_of :title, :message => "Requires title"
  validates_presence_of :xlib_id, :message => "Requires XBMC TV Show ID"
  validates_presence_of :label, :message => "Requires label"
  validates_presence_of :thumb, :message => "Requires remote thumb"
  validates_presence_of :fanart, :message => "Requires requires remote fanart"
  validates_presence_of :tvdb, :message => "Requires requires TVDB"
  validates_presence_of :plot, :message => "Requires plot"
  validates_presence_of :rating, :message => "Requires rating"
  validates_presence_of :year, :message => "Requires year"

  validates_numericality_of :xbmc_id, :message => "XBMC Config ID must be a number"
  validates_numericality_of :rating, :message => "rating must be a number"
  validates_numericality_of :xlib_id, :message => "XBMC TV Show ID must be an integer", :only_integer => true
  validates_numericality_of :year, :message => "The year must be an integer", :only_integer => true
  validates_numericality_of :playcount, :message => "playcount must be an integer", :only_integer => true

  # Before Validation is used to assign 0 value to playcount if it 
  # has not been assigned any value. 
  before_validation do
    unless self.playcount
      self.playcount = 0
    end
  end

  set :schema_version, '1.0'

  # Required, these must be added to the movie so it is valid
  property :title, :string
  property :xlib_id, :integer
  property :xbmc_id, :float
  property :label, :string
  property :thumb, :string
  property :fanart, :string
  property :tvdb, :string
  property :plot, :string
  property :rating, :float
  property :year, :integer

  # The following are required but are added at a later date.
  property :sorttitle, :string
  property :url, :string
  # These two fields point to a file stored on the device rather than
  # storing an image in the database.
  property :l_thumb, :string
  property :l_fanart, :string

  # These are not required at the moment but are stored in the database
  # in case they are needed in future. Therefore, they are not required
  # to create a Movie object.
  property :playcount, :integer
  property :studio, :string
  property :genre, :string

  def destroy_image
    destroy_thumb_image(self)
  end

  def create_sort_title
    make_sort_title_obj(self)
  end

end
