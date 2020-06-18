class MessengerComponent < CustomizableComponent
  def initialize(**args)
    @users = args[:users]
    @lesson = args[:lesson]
    add_class("col")
    set_style("padding:0; margin:0; max-width:50%")
  end
  def component_params
    return super().concat([:users,:lessons])
  end
end
