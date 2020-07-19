class CoursesController < ApplicationController
  before_action :set_course
  before_action :authenticate_user!, except:[:index, :show]
  before_action :authorize_action

  # GET /courses
  # GET /courses.json
  def index

  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @lessons = @course.lessons
  end

  # GET /courses/new
  def new

  end

  # GET /courses/1/edit
  def edit
  end

  def enroll_student
    if(!current_user.isParent?)
      enrollment = @course.enroll(current_user)
      # byebug
      if(@course.price.to_i == 0)
        redirect_to @course
        return
      else
        redirect_to enrollment.invoice
      end
    else
      render "enroll_student"
    end
  end

  def enroll
    if(params[:student_id].present?)
      @enrollee = User.find(params[:student_id].to_i)
    else
      @enrollee = current_user
    end
    enrollment = @course.enroll(@enrollee)
    # byebug
    if(@course.price.to_i == 0)
      redirect_to @course
      return
    else
      redirect_to enrollment.invoice
    end
  end
  # POST /courses
  # POST /courses.json
  def create
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    course_params[:summary] = Loofah.fragment(course_params[:summary]).scrub!(:prune).to_s
    # byebug
    respond_to do |format|
      if @course.update(course_params)
        @course.save
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def redirect_target(action=nil)
    if(action.nil?)
      action = params[:action]
    end
    if(action == "edit" || action == "update")
      return @course
    else
      return "/"
    end
  end

  def redirect_message(action=nil)
    if(action.nil?)
      action = params[:action]
    end
    if(action == "create" || action == "new")
      return nil
    elsif(action == "edit" || action == "update")
      return "You are not authorized to edit that course."
    elsif(action == "show" || action == "index")
      return "You are not authorized to view that course."
    else
      return "You are not authorized to edit that course."
    end
  end
  def set_course
    # params["slug"] = params["slug"].parameterize
    set_resource(param: :slug)
  end

  def course_params
    filter_params(exclude:["price_cents", "price_currency"], include:["price"])
  end
end
