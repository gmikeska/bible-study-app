class JumbotronComponent < CustomizableComponent

  def initialize(**args)
    @title = args[:title]
    @slogan = args[:slogan]
    @body = args[:body]
    @link = args[:link]
    @link_text = args[:link_text]
    super
    add_class("jumbotron")
  end

  def self.params
    params = super()
    params.concat(title:{dataType:"String", default:"Hello, world!"},
      slogan:{dataType:"String", default:"This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information."},
      body:{dataType:"String", default:"It uses utility classes for typography and spacing to space content out within the larger container."},
      link:{dataType:"URL", default:"#"},
      link_text:{dataType:"String", default:"Learn More"})
    return params
  end
end
