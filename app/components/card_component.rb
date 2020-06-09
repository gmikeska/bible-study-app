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
    return super().concat(title:{dataType:String, default:"Example Card"},
      text:{dataType:String, default:"Card Element"},
      button_link:{dataType:String, default:"#"},
      button_text:{dataType:String, default:"More Info"},
      image:{dataType:String, default:""})
  end
end
