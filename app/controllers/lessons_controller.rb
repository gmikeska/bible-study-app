class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show,:show_video,:upload,:delete_file, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only:[:upload]
  before_action :authenticate_user!
  before_action :authorize_action
  # GET /lessons
  # GET /lessons.json
  def index
    return unless requester_is_staff
    @lessons = Lesson.all
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
    # enrolled =  @lesson.visible_to(current_user)
    return unless requester_is_authorized(true)
    if(@chapter)
      @index = @chapter.lessons.index(@lesson)
    end
    render :show, layout:"lesson"
  end
  def show_slide
    set_slide
    # enrolled =  @lesson.visible_to(current_user)
    return unless requester_is_authorized(true,:show)
  end
  def new_slide
    return unless requester_is_staff
    set_lesson
    @slide = {content:""}
  end
  def create_slide
    return unless requester_is_staff
    set_lesson
    @lesson.slides << slide_params
    @lesson.save
    redirect_to edit_lesson_path(@lesson)
  end

  def edit_slide
    set_slide
    # enrolled =  @lesson.visible_to(current_user)
    enrolled =  true
    return unless requester_is_authorized(enrolled,:edit_slide)
  end

  def update_slide
    set_slide
    # enrolled =  @lesson.visible_to(current_user)
    enrolled =  true
    return unless requester_is_staff
    params = slide_params
    @lesson.slides[@index][:content] = params[:content]
    @lesson.slides[@index][:title] = params[:title]
    if(params[:questions] != [""])
      params[:questions].each_index do |index|; question_number = params[:questions][index]
        params[:questions][index] = question_number.to_i
      end
    else
      params[:questions] = []
    end
    media = []
    if(params[:media] != [""])
      params[:media].each_index do |index|; filename = params[:media][index]
        if(filename.present? && filename != "")
          media << filename
        end
      end
      params[:media] = media
    else
      params[:media] = []
    end
    @lesson.slides[@index][:questions] = params[:questions]
    @lesson.slides[@index][:media] = params[:media]
    @lesson.save
    redirect_to edit_lesson_path(@lesson)
  end

  def reorder_slides
    return unless requester_is_staff()
    set_lesson
    slides = []
    slide_order_params.each do |newIndex, v|
      slides << @lesson.slides[v[:id].to_i]
    end
    @lesson.slides = slides
    @lesson.save
  end

  def delete_slide
    set_lesson
    # enrolled =  @lesson.visible_to(current_user)
    enrolled =  true
    return unless requester_is_authorized(enrolled,:show)
  end

  # GET /lessons/new
  def new
    return unless requester_is_staff
    set_course
    set_chapter
    @lesson = Lesson.new
    @lesson.chapter = @chapter
    @lesson.course = @course
  end

  # GET /lessons/1/edit
  def edit
    set_lesson
    return unless requester_is_staff
  end

  def show_file
    set_lesson
    att = @lesson.files.select{|f| f.filename.to_s == params[:filename]+"."+params[:format]}.first
    file = ActiveStorage::Blob.service.send(:download, att.key)
    data = File.open(file)
    send_data(data.read, type:att.content_type, disposition: 'inline')
  end

  def upload
    return unless requester_is_staff
    if(@lesson.chapter.present? && @chapter.nil?)
      @chapter = @lesson.chapter
    end
    if(params[:files])
      @lesson.upload(params[:files])
    elsif(params[:upload])
      filename = params[:upload].original_filename
      @lesson.upload(params[:upload])
      response = { uploaded: 1, fileName: filename, url: "#{lesson_path(@lesson)}/files/#{filename}" }
    end
    if(@chapter.present? && @lesson.chapter.nil?)
      @lesson.chapter = @chapter
      @lesson.save
    end
    render :json => response
  end
  # POST /lessons
  # POST /lessons.json
  def create
    return unless requester_is_staff
    set_course
    lp = lesson_params
    lp[:course] = @course
    if(params[:chapter_slug].present?)
      set_chapter
      lp[:chapter] = @chapter
      @lesson = Lesson.new(lp)
      respond_to do |format|
        if @lesson.save
          format.html { redirect_to [@lesson.course,@chapter,@lesson], notice: 'Lesson was successfully created.' }
          format.json { render :show, status: :created, location: @lesson }
        else
          format.html { render :new }
          format.json { render json: @lesson.errors, status: :unprocessable_entity }
        end
      end
    else
      @lesson = Lesson.new(lp)
      respond_to do |format|
        if @lesson.save
          format.html { redirect_to [@lesson.course,@lesson], notice: 'Lesson was successfully created.' }
          format.json { render :show, status: :created, location: @lesson }
        else
          format.html { render :new }
          format.json { render json: @lesson.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def do_import
    return unless requester_is_staff
    set_course
    @lesson = Lesson.import(lesson_params,@course)
    redirect_to edit_lesson_path(@lesson)
  end

  def do_import_into_chapter
    return unless requester_is_staff
    set_course
    set_chapter

    @lesson = Lesson.import(lesson_params,@course)
    @lesson.chapter = @chapter
    redirect_to edit_lesson_path(@lesson)
  end

  def delete_file
    return unless requester_is_staff
    set_lesson
    attachment = ActiveStorage::Attachment.find(lesson_params[:id])
    attachment.purge
    redirect_to edit_lesson_path(@lesson)
  end

  def show_video
    @file = @lesson.files.select{|f| f.filename.to_s.include?(lesson_params[:filename])}.first
    enrolled = current_user.present? && @lesson.visible_to(current_user)
    # byebug
    return unless requester_is_authorized(enrolled,:show_video)
  end
  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    return unless requester_is_staff
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to [@course,@lesson], notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, notice:@lesson.errors }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    return unless requester_is_admin
    course = @lesson.course
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course, notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    return unless requester_is_staff
    set_course
    @lesson = Lesson.new
    @lesson.course = @course
    render "import"
  end

  def import_into_chapter
    return unless requester_is_staff
    set_course
    set_chapter
    @lesson = Lesson.new
    @lesson.course = @course
    render "import"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      set_course
      set_chapter
      set_resource(param: :slug)
      @enrollment = @lesson.course.enrollments.select{|e| e.user == current_user}.first
      if(@lesson.quiz)
        @quiz = @lesson.quiz
      end
    end
    def set_slide
      set_lesson
      if(params[:index])
        @index = params[:index].to_i
        @slide = @lesson.slides[@index]
      end
    end

    def set_course
      if(params[:course_slug])
        set_resource(model: :course, param: :slug)
      end
    end

    def set_chapter
      if(params[:chapter_slug])
        set_resource(model: :chapter, param: :slug)
      end
    end
    # Only allow a list of trusted parameters through.

    def slide_params
      params.permit(:content,:title,questions:[],media:params[:media])
      {content:params[:content], title:params[:title], questions:params[:questions],media:params[:media]}
    end
    def slide_order_params
      params.require(:slideOrder).permit!
    end
    def lesson_params
      action = params[:action]
      forbidden_params = ["created_at","updated_at","id"]
      p = Lesson.params.reject{|c| forbidden_params.include? c.to_s}
      if(action == "update" || action == "create")

        if(params[:lesson][:chapter].present? && params[:lesson][:chapter] != "none")
          params[:chapter_slug] = params[:lesson][:chapter]
          params.permit(:chapter_slug)
          p << :chapter
        end
        if(params[:lesson][:content])
          params[:lesson][:content] = Loofah.fragment(params[:lesson][:content]).scrub!(:prune).to_s
        end
        params.permit(:slug)
        params.permit(:course_slug)
        params.require(:lesson).permit(*p)
      elsif(action == "show_video")
        params.permit(:filename)
      elsif(action == "do_import" || action == "do_import_into_chapter")
        p << :import
        params.require(:lesson).permit(p)
      elsif(action == "upload")
        params.require(:lesson).permit(:files)
        params.permit(:upload)
      elsif(action == "delete_file")
        params.permit(:id)
      end
    end
end
