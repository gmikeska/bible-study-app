class MessengerComponent < CustomizableComponent
  def initialize(users:nil, messages:nil)
    @users = users

    if(messages.present?)
      @messages = messages
    end
  end
end
