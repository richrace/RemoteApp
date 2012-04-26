# Author::    Richard Race (rcr8)
# Copyright:: Copyright (c) 2012
# License::   MIT Licence

# Used for Video Models.
module ObjHelper
  
  # Strips the leading 'The/An/A' of a given string. Returns the
  # String without altering the original. This is not case 
  # sensitive.
  def make_sort_title(title)
    title.sub(/^(the|a|an)\s+/i,'')
  end

  # Calls make_sort_title and saves the object
  def make_sort_title_obj
    self.sorttitle = make_sort_title(self.title)
    self.save
  end

  # Deletes a give file from the Application File system
  def delete_image(file)
    File.delete(file) if File.exists?(file) 
  end

  # Calls delete_image method and saves the object with
  # nil pointing to the l_thumb entry.
  def destroy_thumb_image
    unless self.l_thumb.blank?
      delete_image(self.l_thumb)
      self.l_thumb = nil
      self.save
    end
  end
  
end