require 'rho/rhoapplication'
require "validatable"   
require "json"

class AppApplication < Rho::RhoApplication
    
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
=begin    [
      {:label => "Controller", :action => '/app/Controls'},
      {:label => "Movies", :action => '/app', :icon => '/public/images/icons/clapboard.png'},
      {:label => "TV Shows", :action => '/app', :icon => '/public/images/icons/tv-1.png'},
      {:label => "Playlist", :action => '/app', :icon => '/public/images/icons/movie-1.png'},
      {:label => "Music", :action => '/app', :icon => '/public/images/icons/note-2.png'},
      {:label => "Files", :action => '/app', :icon => '/public/images/icons/cabinet.png'}
    ]
=end
    #To remove default toolbar uncomment next line:
    @@toolbar = nil
    super

    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    # SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')
  end
end
