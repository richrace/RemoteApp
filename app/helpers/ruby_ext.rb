# Used with XbmcConnect
class Object
  def metaclass
    class << self
      self
    end
  end
end