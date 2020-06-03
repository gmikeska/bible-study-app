class MessengerComponent < CustomizableComponent
  def initialize(**args)
    @users = args[:users]
    @lesson = args[:lesson]
  end
  def component_params
    return super().concat([:users,:lessons])
  end
end
