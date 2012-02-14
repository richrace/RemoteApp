module Input4
  
  def up(callback)
    XbmcConnect::Input.up(callback)
  end
  
  def down(callback)
    XbmcConnect::Input.down(callback)
  end
  
  def left(callback)
    XbmcConnect::Input.left(callback)
  end
  
  def right(callback)
    XbmcConnect::Input.right(callback)
  end
  
  def select(callback)
    XbmcConnect::Input.select(callback)
  end
  
  def home(callback)
    XbmcConnect::Input.home(callback)
  end
  
  def back(callback)
    XbmcConnect::Input.back(callback)
  end
end