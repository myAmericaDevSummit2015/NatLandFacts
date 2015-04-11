module ApplicationHelper

  def currently_in_section?(section)
    content_for(:current_navigation_section) == section.to_s
  end

  def currently_in_sub_section?(sub_section)
    content_for(:current_navigation_sub_section) == sub_section.to_s
  end

end
