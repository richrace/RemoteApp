module ObjHelper
  
  # Strips the leading 'The/An/A' of a given string. Returns the
  # String without altering the original. This is not case 
  # sensitive.
  def make_sort_title(title)
    title.sub(/^(the|a|an)\s+/i,'')
  end

  def make_sort_title_obj(obj)
    self.sorttitle = make_sort_title(self.title)
    self.save
  end

  def delete_image(file)
    File.delete(file) if File.exists?(file) 
  end

  def destroy_thumb_image(obj)
    unless obj.l_thumb.blank?
      delete_image(obj.l_thumb)
      obj.l_thumb = nil
      obj.save
    end
  end
  
end