class CardComponent < CustomizableComponent
  def initialize(**args)

    @image = args[:image]
    @title = args[:title]
    @text = args[:text]
    @button_link = args[:button_link]
    @button_text = args[:button_text]

    super(css_class:css_class,id:id,**args)
  end

  def component_params
    return super().concat([:title,:text,:button_link,:button_text, :image])
  end
end
