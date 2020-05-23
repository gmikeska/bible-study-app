class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def requester_is_authorized(condition,target=nil)
    if(current_user.present? && condition)
      if(!target.nil?)
        render target
      end
      return true
    elsif(current_user.nil?)
      store_location_for(:user, request.env['PATH_INFO'])
      redirect_to "/users/sign_in"
      return false
    else
      redirect_to "/"
      return false
    end
  end

  def requester_is_staff
    return requester_is_authorized(current_user.present? && current_user.isStaff?)
  end

  def requester_is_admin
    return requester_is_authorized(current_user.present? && current_user.isAdmin?)
  end
end
