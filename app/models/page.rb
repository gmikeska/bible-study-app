class Page < ApplicationRecord
  serialize :components, Array
  after_initialize do |page|
    if(page.slug != page.name.parameterize)
      page.slug = page.name.parameterize
    end
  end

  def self.component_options
    excludes = ["customizable_component","modal_component","messenger_component"]
    results = Dir["app/components/*.rb"].collect{|path| path.split("/").last.split(".").first}.collect{|c| [c.titleize, c]}.select{|c| c[1].camelcase.constantize.respond_to? :params}
    results = results.select{|item| !excludes.include?(item[1])}
    return results
  end

  def self.data_sources
    Dir["app/models/*.rb"].collect{|path| [path.split("/").last.split(".").first, path.split("/").last.split(".").first.titleize]}
  end

  def add_component(name, component)
    self.components << component
  end

  def to_param
    slug
  end

end
