require 'helpers/xbmc/apis/api_2/api2'
require 'helpers/xbmc/apis/api_4/api4'

# Top level namespace for the Supported XBMCs JSONRPC APIs.
module Api
  
  # Can be referenced by: "Api::V2"
  module V2
    include ApiV2
  end
  
  # Can be referenced by: "Api::V4"
  module V4
    include ApiV4
  end

end
