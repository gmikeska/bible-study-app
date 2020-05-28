class ModalComponent < CustomizableComponent
  def initialize(name:nil,title:nil,body:nil,submit_button:nil)
    @name = name
    @title = title
    @body = body
    @submit_button = submit_button
  end
end
