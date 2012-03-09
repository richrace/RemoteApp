class Tvepisode
  include Rhom::FixedSchema
  include Validatable

  belongs_to :tvseason_id, 'Tvseason'
  belongs_to :tvshow_id, 'Tvshow'
  belongs_to :xbmc_id, 'XbmcConfig'

  validates_presence_of :xbmc_id, :message => "Needs to have an XBMC Config"
  validates_presence_of :xlib_id, :message => "Requires XBMC Season ID"
  validates_presence_of :episode, :message => "Requires the Episode Number"
  validates_presence_of :firstaired, :message => "Requires the first aired date"
  validates_presence_of :tvshow_id, :message => "Requires XBMC TV Show ID"
  validates_presence_of :tvshow_name, :message => "Requires TV Show Name"
  validates_presence_of :tvseason_id, :message => "Requires Season ID"
  validates_presence_of :runtime, :message => "Requires the run time"
  validates_presence_of :rating, :message => "Requires the rating"
  validates_presence_of :plot, :message => "Requires the plot"
  validates_presence_of :label, :message => "Requires label"
  validates_presence_of :title, :message => "Requires tv show title"
  validates_presence_of :thumb, :message => "Requires remote thumb"
  validates_presence_of :fanart, :message => "Requires requires remote fanart"

  set :schema_version, '1.0'

  property :xbmc_id, :float
  property :xlib_id, :integer
  property :episode, :integer
  property :firstaired, :string
  property :tvshow_id, :integer
  property :tvshow_name, :string
  property :tvseason_id, :integer
  property :runtime, :string
  property :label, :string
  property :title, :string
  property :plot, :string
  property :rating, :float
  property :thumb, :string
  property :fanart, :string

  property :l_thumb, :string
  property :l_fanart, :string
  property :url, :string

  def destroy_image
    unless self.l_thumb.blank?
      File.delete(self.l_thumb) if File.exists?(self.l_thumb)
      self.l_thumb = nil
      self.save
    end
  end

end
