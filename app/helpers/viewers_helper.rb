module ViewersHelper

  # Capitalizes names properly
  def format_name(name)
    properly_formatted_name = name.split(" ").map { |n| n.capitalize }
    properly_formatted_name.join(' ')
  end
end
