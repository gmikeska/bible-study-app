class StaticPage < ApplicationRecord
  serialize :components, Array
  self.table_name = "pages"
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

  def self.page_options
    results = StaticPage.all.collect{|p| [p.name.titleize, p.pointer] }
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
  def update(params)

    params[:components].each_index do |i|
      c = params[:components][i]
      params[:components][i] = ComponentSettings.new(c[:name])
      if(c[:args].present?)
        params[:components][i].args = c[:args].symbolize_keys
      end
    end
    super(params)
  end

end
