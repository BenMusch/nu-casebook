module Helpers
  # Returns an array of the names of the passed relation
  def names_array(names)
    names.map(&:name)
  end

  # Returns a string of the names of the passed relation, joined by commas
  def names_string(names)
    names_array(names).join(', ')
  end
end
