class JumbotronComponent < CustomizableComponent
  def initialize(**args)
    @title = args[:title]
    @slogan = args[:slogan]
    @body = args[:body]
    @link = args[:link]
    @link_text = args[:link_text]
    super
  end
  def self.component_params
    return super().concat([:title,:slogan,:body,:link, :link_text])
  end
end
