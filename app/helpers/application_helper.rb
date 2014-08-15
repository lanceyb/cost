module ApplicationHelper
  include Devise::TestHelpers

  def nav_li name, url, options = {}
    if can? :manager, name
      cls = current_session == name ? "active" : ""
      content_tag :li, class: cls do
        link_to I18n.translate("nav.li.#{name}"), url, options
      end
    else
      ""
    end
  end
end
