# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

require 'helpers/obj_helper'

# Model for the Movie objects.
class Movie
  include Rhom::FixedSchema
  include Validatable
  include ObjHelper

  # Relationship
  belongs_to :xbmc_id, 'XbmcConfig'

  validates_presence_of :xbmc_id, :message => "Needs to have an XBMC Config"
  validates_presence_of :title, :message => "Requires title"
  validates_presence_of :xlib_id, :message => "Requires XBMC Movie ID"
  validates_presence_of :label, :message => "Requires label"
  validates_presence_of :thumb, :message => "Requires remote thumb"
  validates_presence_of :fanart, :message => "Requires requires remote fanart"
  validates_presence_of :imdbnumber, :message => "Requires requires imdbnumber"
  validates_presence_of :trailer, :message => "Requires youtube trailer code"
  validates_presence_of :plot, :message => "Requires plot"
  validates_presence_of :rating, :message => "Requires rating"
  validates_presence_of :year, :message => "Requires year"

  validates_numericality_of :xbmc_id, :message => "XBMC Config ID must be a number"
  validates_numericality_of :rating, :message => "rating must be a number"
  validates_numericality_of :xlib_id, :message => "XBMC Movie ID must be an integer", :only_integer => true
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
  property :imdbnumber, :string
  property :trailer, :string
  property :plot, :string
  property :rating, :float
  property :year, :integer

  # Required by the application but not needed when creating a Movie
  # object as it should only be used when a Movie is in the Watch Later
  # List. (Would return false)
  property :watch_later, :boolean

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
  property :genre, :string
  property :playcount, :integer
  property :studio, :string
  property :director, :string
  
  # Deletes the images.
  def destroy_image
    destroy_thumb_image
  end

  # Creates the sortable title
  def create_sort_title
    make_sort_title_obj
  end
  
  # Finds out if the Movie is the watch later list or not.
  def watch_later?
    if self.watch_later == "true"
      return true
    else 
      return false
    end
  end
  
end
