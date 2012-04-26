# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Module that contains all the input commands for XBMC JSON RPC API Version 4
module Input4
  
  # Calls the command to move XBMC selector up
  def up(callback)
    XbmcConnect::Input.up(callback)
  end
  
  # Calls the command to move XBMC selector down
  def down(callback)
    XbmcConnect::Input.down(callback)
  end
  
  # Calls the command to move XBMC selector left
  def left(callback)
    XbmcConnect::Input.left(callback)
  end
  
  # Calls the command to move XBMC selector right
  def right(callback)
    XbmcConnect::Input.right(callback)
  end
  
  # Calls the command to move XBMC selector to select the current item
  def select(callback)
    XbmcConnect::Input.select(callback)
  end
  
  # Calls the command to move XBMC interface to go "Home"
  def home(callback)
    XbmcConnect::Input.home(callback)
  end
  
  # Calls the command to move XBMC interface to go "Back"
  def back(callback)
    XbmcConnect::Input.back(callback)
  end
end