def to_menus(navigation, prefix=nil)
  Array(navigation).map { |id|
    sub_menu = nil
    if id.is_a? Hash
      sub_menu_array = id[id.keys[0]]
      id = id.keys[0]
      basename = id.chomp(File.extname id)
      sub_prefix = prefix ? "#{prefix}/#{basename}" : basename
      sub_menu = {items: to_menus(sub_menu_array, sub_prefix)}
    end
    id = "#{prefix}/#{id}" if prefix
    page = pages.new_model_view(@ruhoh.db.pages[id])
    page.sub_menu = sub_menu
    page
  }
end

module PageModelViewSubmenuAddons
  def has_active_page
    is_active_page or (sub_menu and sub_menu[:items].any? {|item| item.has_active_page})
  end
end
Ruhoh::Resources::Page::ModelView.send(:include, PageModelViewSubmenuAddons)

