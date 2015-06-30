module ApplicationHelper

  def page_title(title = '')
    if title.empty?
      "NU Casebook"
    else
      title + " | NU Casebook"
    end
  end
end
