class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :edit, :update, :destroy]
  # GET /chapters
  # GET /chapters.json
  # def index
  #   @chapters = Chapter.all
  # end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
    return unless requester_is_staff
  end

  # GET /chapters/new
  def new
    return unless requester_is_staff
    set_course
    @chapter = Chapter.new
    @chapter.course = @course
  end

  # GET /chapters/1/edit
  def edit
    return unless requester_is_staff
  end

  # POST /chapters
  # POST /chapters.json
  def create
    return unless requester_is_staff
    @chapter = Chapter.new(chapter_params)
    set_course
    @course.chapters << @chapter
    respond_to do |format|
      if @chapter.save
        format.html { redirect_to @course, notice: 'Chapter was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chapters/1
  # PATCH/PUT /chapters/1.json
  def update
    return unless requester_is_staff
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.html { redirect_to @chapter.course, notice: 'Chapter was successfully updated.' }
        format.json { render :show, status: :ok, location: @chapter }
      else
        format.html { render :edit }
        format.json { render json: @chapter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chapters/1
  # DELETE /chapters/1.json
  def destroy
    return unless requester_is_staff
    set_course
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find_by slug: params[:course_slug]
    end
    def set_chapter
      set_course
      @chapter = Chapter.find_by slug: params[:slug]
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.require(:chapter).permit(:name)
    end
end
