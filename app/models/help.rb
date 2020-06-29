# require 'commonmarker'
class Help < ApplicationRecord
  serialize :missing_sections, Array
  after_initialize do |help|
    if(help.title.present? && help.slug != help.title.parameterize)
      help.slug = help.title.parameterize
    end
    help.missing_sections.each do |name|
      if(help.headers.include?(name))
        help.missing_sections.delete(name)
        help.save
      end
    end
  end
  def to_param
    slug
  end
  def categories
    result = [self.title]
    if(self.category.present?)
      result = (Help.find_by slug:category).categories.concat(result)
    end
    return result
  end
  def doc
    Kramdown::Document.new(self.content, input:"GFM")
  end
  def html_content
    doc.to_html
  end
  def nodes
    doc.root.children
  end
  def header_objects
    nodes.select{|n| n.type == :header}
  end
  def headers
    header_objects.to_a.map{|h| h.options[:raw_text] }
  end
  def section(name, type=:html)
    name = name.titleize
    docNodes = self.nodes
    header_objects = docNodes.select{|n| n.type == :header}
    if(headers.include? name)
      # byebug
      sectionHeader = header_objects.select{|n| (n.options[:raw_text] == name)}.first
      index = docNodes.index(sectionHeader)
      if(sectionHeader == header_objects.last)
        output =  docNodes[index,docNodes.length]
      else
        nextIndex = docNodes.index(header_objects[header_objects.index(sectionHeader)+1])
        output = docNodes[index,nextIndex]
      end
      fragment = Kramdown::Document.new("", input:"GFM")
      # byebug
      if(type == :html)
        fragment.root.children = output
        return fragment.to_html
      elsif(type == :text)
      end
    else
      if(!missing_sections.include?(name))
        missing_sections << name
        self.save
      end
      return nil
    end

  end
end
