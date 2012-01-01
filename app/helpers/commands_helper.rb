
module CommandsHelper
  
  def scan_video
    version = XbmcConnect.get_version
    unless version.nil?
      if version == Api::V2::VERSION
        Api::V2::VideoLibrary.scan(callback)
      elsif (version == Api::V4::VERSION)  || (version == 3)
        Api::V4::VideoLibrary.scan(callback)
      end
    end
  end
  
end