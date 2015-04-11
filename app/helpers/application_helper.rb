module ApplicationHelper

  def currently_in_section?(section)
    content_for(:current_navigation_section) == section.to_s
  end

  def currently_in_sub_section?(sub_section)
    content_for(:current_navigation_sub_section) == sub_section.to_s
  end

  def menu_link(*args, &block)
    options = block_given? ? args[1] : args[2]
    section = options.delete(:section)
    sub_section = options.delete(:sub_section)
    if section.present? && currently_in_section?(section) || sub_section.present? && currently_in_sub_section?(sub_section)
      tag_options = {class: 'active'}
    end
    content_tag :li, link_to(*args, &block), tag_options
  end

end
