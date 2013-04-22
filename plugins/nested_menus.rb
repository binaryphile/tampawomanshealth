def to_menus(navigation, prefix=nil)
  Array(navigation).map do |id|
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
  end
end

def to_submenus(navigation)
  subnav, prefix = find_in_tree(navigation, page.id)
  to_menus(subnav, prefix)
end

def find_in_tree(tree, name)
  result = []
  prefix = nil
  tree.each do |item|
    if item == name
      break
    end
    if item.is_a?(Hash)
      key = item.keys[0]
      prefix = key
      prefix = key.chomp(File.extname(key))
      if key == name
        result = item[key]
        break
      end
      result, subprefix = find_in_tree(item[key], name)
      prefix = subprefix ? "#{prefix}/#{subprefix}" : prefix
    end
  end
  [result, prefix]
end

module PageModelViewSubmenuAddons
  def has_active_page
    is_active_page or (sub_menu and sub_menu[:items].any? {|item| item.has_active_page})
  end
end
Ruhoh::Resources::Page::ModelView.send(:include, PageModelViewSubmenuAddons)

