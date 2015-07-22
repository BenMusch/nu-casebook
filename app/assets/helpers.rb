module Helpers
  # Returns an array of the names of the passed relation
  def names_array(names)
    names.map(&:name)
  end

  # Returns a string of the names of the passed relation, joined by commas
  def names_string(names)
    names_array(names).join(', ')
  end

  # Properly formats a users name before saving
  def format_name(name)
    properly_formatted_name = name.split(" ").map { |n| n.capitalize }
    properly_formatted_name.join(' ')
  end
end
