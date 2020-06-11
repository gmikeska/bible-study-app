class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def resource_name
    self.class.name.downcase
  end
  def resource_identifier
    to_param
  end
  def resource_type
    return "model"
  end
  def pointer
    return "#{resource_type}:#{resource_name}:#{resource_identifier}"
  end
  def self.pointer(scope)
    return "collection:#{resource_name}:#{scope}"
  end
  def url
    Rails.application.routes.url_helpers.polymorphic_url(self, only_path: true)
  end
  def get_url(pointer)

    puts pointer

    if(pointer.include? "file")
      target = parse_pointer(pointer)
      return target[:class].capitalize.constantize.where({slug:target[:param]}).first.get_url(target[:resource])
    else
      return retrieve_pointer(pointer).url
    end
  end

  def retrieve_pointer(pointer)
    pointer = parse_pointer(pointer)
    searchClass = pointer[:class].capitalize.constantize
    if(pointer[:type]=="model")
      if(searchClass.columns.to_a.select {|c| c.name == "slug"}.count == 0)
        record = searchClass.find(pointer[:param])
      else
        record = searchClass.find_by slug:pointer[:param]
      end
      if(pointer[:attribute].present?)
        return(record[pointer[:attribute].to_sym])
      else
        return record
      end
    elsif(pointer[:type]=="collection")
      return searchClass.send(pointer[:param])
    end
  end

  def parse_pointer(pointer)
    parts = pointer.split(":")
    if(parts[0] == "file")
      data = {type:parts[0], class:"Gallery", param:parts[1], resource:parts[2]}
    else
      data = {type:parts[0], class:parts[1].capitalize, param:parts[2]}
    end
    if(parts[3].present?)
      data[:attribute] = parts[3]
    end
    return data
  end

  def is_pointer(pointer)
    return !!pointer.match(/(\S+):(\S+):(\S+)/)
  end
end
