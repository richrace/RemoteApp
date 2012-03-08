module SortHelper
  
  # Strips the leading 'The/An/A' of a given string. Returns the
  # String without altering the original. This is not case 
  # sensitive.
  def make_sort_title(title)
    title.sub(/^(the|a|an)\s+/i,'')
  end
  
end