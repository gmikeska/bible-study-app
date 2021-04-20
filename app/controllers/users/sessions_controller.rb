# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    store_location_for(:user, request.env['HTTP_REFERER'])
    super
  end

  # POST /resource/sign_in
  def create
    super
    # if(current_user.isAdmin? && Rails.env == "production")
    #   AdminMailer.with(user:current_user).admin_logs_in.deliver_now
    # end
    current_user.online = true
    current_user.save
  end

  # DELETE /resource/sign_out
  def destroy
    current_user.online = false
    current_user.save
    super
  end
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || "/"
  end
  def skip_naming
    true
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
