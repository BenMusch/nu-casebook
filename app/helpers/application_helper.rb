module ApplicationHelper
  def page_title(title = '')
    if title.empty?
      "NU Casebook"
    else
      title + " | NU Casebook"
    end
  end

  def map_with_id(object, attribute)
    object.all.collect { |o| [o.send(attribute), o.id] }
  end
end
