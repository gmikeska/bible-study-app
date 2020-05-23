class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :enroll, :enroll_pet]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @lessons = @course.lessons
  end

  # GET /courses/new
  def new
    return unless requester_is_staff
    @course = Course.new()
  end

  # GET /courses/1/edit
  def edit
    return unless requester_is_staff
  end

  def enroll_pet
    return unless requester_is_authorized(current_user.present?)
    render "enroll_pet"
  end

  def enroll
    return unless requester_is_authorized(current_user.present?)
    @pet = Pet.find(params[:pet_id].to_i)
    enrollment = @course.enroll(@pet)
    # byebug
    redirect_to enrollment.invoice
  end
  # POST /courses
  # POST /courses.json
  def create
    return unless requester_is_staff
    @course = Course.new(course_params)

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
    return unless requester_is_staff
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
    return unless requester_is_admin
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private


    # Use callbacks to share common setup or constraints between actions.
    def set_course
      if(params[:slug].present?)
        @course = Course.find_by slug: params[:slug]
      elsif(params[:course_slug].present?)
        @course = Course.find_by slug: params[:course_slug]
      end
    end

    # Only allow a list of trusted parameters through.
    def course_params
      p = Course.column_names.reject{|c| (c.include?( "_at") || c.include?( "price")) }.map{|c| c = c.to_sym}
      p << :price
      params.require(:course).permit(*p)
    end
end
