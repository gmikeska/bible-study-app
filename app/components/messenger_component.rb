class MessengerComponent < CustomizableComponent
  def initialize(users:nil, lesson:nil)
    @users = users
    @lesson = lesson
  end
end
