require 'find'
require 'fileutils'
require 'nokogiri'

input_dir = '../www.tampawomanshealthcenter.com'
output_dir = '../output'

FileUtils.mkdir_p(output_dir) unless File.exists?(output_dir)
Find.find(input_dir) do |name|
  out_name = String.new(name)
  out_name[input_dir] = output_dir
  items = out_name.split('/')
  if items[-1] == 'Default.html'
    items.pop(3)
    if items.length > 0
      file_name = items.pop
      dir_name = items.join('/')
      items << file_name + '.md'
      file_name = items.join('/')
      FileUtils.mkdir_p(dir_name) unless File.exists?(dir_name)
      doc = Nokogiri::HTML(open(name))
      node = doc.css('.ContentPane tbody td')
      file = open(file_name, 'w')
      file.write(node.text)
      file.close
    end
  end
end

