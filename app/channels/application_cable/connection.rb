module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = set_user
      # byebug
      logger.add_tags 'ActionCable', "User #{current_user.id}"
    end

    # protected

    def set_user
      env['warden'].user || reject_unauthorized_connection
    end

  end
end
