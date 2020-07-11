class FoldingComponent < CustomizableComponent
  with_content_areas :body, :toggle
  def initialize(**args)
    @name = args[:name]
    @title = args[:title]
    @starts_expanded = args[:starts_expanded]
  end
  def component_params
    return super().concat({name:{dataType:"String", default:"folding"},
      title:{dataType:"String", default:"Hello, world!"},
      starts_expanded:{dataType:"Boolean", default:false}
      })
  end
end
