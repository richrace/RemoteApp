module SortHelper
  
  def create_sort_title(title)
    title.sub(/^(the|a|an)\s+/i,'')
  end
  
end