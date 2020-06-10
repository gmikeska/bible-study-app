class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def resource_scope
    self.class.name.downcase
  end
  def resource_identifier
    to_param
  end
  def resource_type
    return "model"
  end
  def pointer
    return "#{resource_type}:#{resource_scope}:#{resource_identifier}"
  end
  def url
    Rails.application.routes.url_helpers.polymorphic_url(self, only_path: true)
  end
  def get_url(pointer)

    puts pointer

    if(pointer.include? "file")
      target = parse_pointer(pointer)
      return target[:scope].capitalize.constantize.where({slug:target[:param]}).first.get_url(target[:resource])
    else
      return retrieve_pointer(pointer).url
    end
  end

  def retrieve_pointer(pointer)
    pointer = parse_pointer(pointer)
    searchScope = pointer[:scope].capitalize.constantize

    if(searchScope.columns.to_a.select {|c| c.name == "slug"}.count == 0)
      record = searchScope.find(pointer[:param])
    else
      record = searchScope.find_by slug:pointer[:param]
    end

    if(pointer[:attribute].present?)
      return(record[pointer[:attribute].to_sym])
    else
      return record
    end
  end

  def parse_pointer(pointer)
    parts = pointer.split(":")
    if(parts[0] == "file")
      data = {type:parts[0], scope:"Gallery", param:parts[1], resource:parts[2]}
    else
      data = {type:parts[0], scope:parts[1].capitalize, param:parts[2]}
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
