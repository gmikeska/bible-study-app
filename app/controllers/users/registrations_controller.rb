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
  def import
    @user = User.new
    render "import"
  end

  def show
    return unless requester_is_staff
    @user = User.find(params[:id])
    breeze_data = @user.breeze_data
    if(breeze_data.present?)
      @breeze_data = breeze_data
    end
    render "show"
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.first_name = params[:user][:first_name]
    resource.last_name = params[:user][:last_name]
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def do_import
    p = params.require(:user).permit(:email,:breeze_id)
    p[:password] = "temp1234"
    p[:password_confirmation]  = "temp1234"
    if(p[:breeze_id].present? && p[:email].present?)
      resource = User.import(p)
      resource.save
      yield resource if block_given?
      if resource.persisted?
        set_flash_message! :notice, "User has been imported from Breeze."
        if requester_is_admin
          redirect_to "/users/"
        else
          redirect_to "/"
        end
      end
    elsif(p[:breeze_id].nil?)
      redirect_to "/users/import", notice:"A Breeze ID is required for User Import."
    elsif(p[:email].nil?)
      redirect_to "/users/import", notice:"An email address is Required for User Import."
    end
  end

  def index
    return unless requester_is_staff
    if(params[:usertype] == "admins")
      @users = User.admins.order("created_at desc")
    elsif(params[:usertype] == "instructors")
      @users = User.instructors.order("created_at desc")
    elsif(params[:usertype] == "students")
      @users = User.students.order("created_at desc")
    else
      @users = User.all.order("created_at desc")
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
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
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
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name,:last_name, :user_type, :id, :breeze_id])
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
