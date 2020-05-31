# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :remove_password_params_if_blank, only: [:update]
  before_action :configure_account_update_params
  layout "application"
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new
    render "new"
  end

  # POST /resource
  # def create
  #   super
  # end
  def index
    return unless requester_is_staff
    if(params[:type].present?)
      @users = User.where({user_type:params[:type].singularize.downcase})
      render "index"
    else
      @users = User.all.order(:id)
      render "index"
    end
  end

  def my_courses
    return unless requester_is_authorized(true)
    @user = current_user
    if(@user.isStaff?)
      @courses = Course.all()
    else
      @enrollments = @user.enrollments
    end
    render "my_courses"
  end
  def my_pets
    return unless requester_is_authorized(true)
    @user = current_user
    render "my_pets"
  end

  # GET /resource/edit
  def edit
    return unless requester_is_authorized(true)
    set_resource
    super
  end

  # PUT /resource
  def update
    return unless requester_is_authorized(true)
    set_resource
    @user.name = params["user"]["name"]
    @user.email = params["user"]["email"]
    @user.user_type = params["user"]["user_type"]
    success = @user.save
    if (success && @user != current_user)
      @users = User.all
      redirect_to "/users/"
      # format.json { render :show, status: :created, location: @lesson }
    elsif
       render :edit
      # format.json { render json: @lesson.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /resource
  def destroy
    return unless requester_is_authorized(true)
    set_resource
    if(current_user != @user)
      @user.delete
      redirect_to "/users/", notice:"User account was successfully deleted."
    else
      super
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_type, :id])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
  def set_resource
    if(params[:id] && params[:id].to_i != 0)
      user_id = params[:id].to_i
    elsif(params["user"]["id"] && params["user"]["id"].to_i != 0)
      user_id = params["user"]["id"].to_i
    end
    if(current_user.type == "admin" || current_user.id != user_id)
      @user = User.find(user_id)
    end
  end

  def remove_password_params_if_blank
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
