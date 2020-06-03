class ModalComponent < CustomizableComponent
  def initialize(**args)
    @name = args[:name]
    @title = args[:title]
    @body = args[:body]
    @submit_button = args[:submit_button]
  end
  def component_params
    return super().concat([:name,:title,:body,:submit_button])
  end
end
