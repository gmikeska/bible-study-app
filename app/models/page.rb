class Page < ApplicationRecord
  serialize :components, Array
  after_initialize do |page|
    if(!slug)
      page.slug = page.name.parameterize
    end
  end

  def self.components
    excludes = ["customizable_component","modal_component","messenger_component"]
    results = Dir["app/components/*.rb"].collect{|path| path.split("/").last.split(".").first}.collect{|c| [c.titleize, c]}.select{|c| c[1].camelcase.constantize.respond_to? :component_params}
    results = results.select{|item| !excludes.include?(item[1])}
    return results
  end

  def self.data_sources
    Dir["app/models/*.rb"].collect{|path| [path.split("/").last.split(".").first, path.split("/").last.split(".").first.titleize]}
  end

  def add_component(name, **data)
    self.components << {name:name, args:data}
  end

  def to_param
    slug
  end

end
