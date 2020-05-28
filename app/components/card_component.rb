class CardComponent < CustomizableComponent
  def initialize(title:nil,text:nil,button_link:nil,button_text:nil, image:nil,css_class:nil, id:nil, **args)

    @image = image
    @title = title
    @text = text
    @button_link = button_link
    @button_text = button_text

    super(css_class:css_class,id:id,**args)
  end

  def component_params
    return super().concat([:title,:text,:button_link,:button_text, :image])
  end
end
