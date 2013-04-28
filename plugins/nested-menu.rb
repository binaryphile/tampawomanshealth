def to_menu(navigation, prefix=nil)
  Array(navigation).map do |id|
    submenu = nil
    if id.is_a? Hash
      submenu_array = id[id.keys[0]]
      id = id.keys[0]
      basename = id.chomp(File.extname id)
      subprefix = prefix ? "#{prefix}/#{basename}" : basename
      submenu = {items: to_menu(submenu_array, subprefix)}
    end
    id = "#{prefix}/#{id}" if prefix
    page = pages.new_model_view(@ruhoh.db.pages[id])
    page.submenu = submenu
    page
  end
end

def to_submenu(navigation)
  subnav, prefix = find_in_tree(navigation, page.id.split('/')[-1])
  to_menu(subnav, prefix)
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
      if result.length > 0
        break
      end
    end
  end
  [result, prefix]
end

module PageModelViewSubmenuAddons
  def has_active_page
    is_active_page or (submenu and submenu[:items].any? {|item| item.has_active_page})
  end
end
Ruhoh::Resources::Page::ModelView.send(:include, PageModelViewSubmenuAddons)

