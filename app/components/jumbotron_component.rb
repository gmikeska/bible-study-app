class JumbotronComponent < CustomizableComponent
  def initialize(title:nil,slogan:nil,body:nil,link:nil,link_text:nil)
    @title = title
    @slogan = slogan
    @body = body
    @link = link
    @link_text = link_text
  end
  def component_params
    return super().concat([:title,:slogan,:body,:link, :link_text])
  end
end
