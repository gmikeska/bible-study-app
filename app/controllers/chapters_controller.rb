class ChaptersController < ApplicationController
  before_action :set_chapter
  # GET /chapters
  # GET /chapters.json
  # def index
  #   @chapters = Chapter.all
  # end

  # GET /chapters/1
  # GET /chapters/1.json
  def show
  end

  # GET /chapters/new
  def new
    @chapter.course = @course
  end

  # GET /chapters/1/edit
  def edit
  end

  # POST /chapters
  # POST /chapters.json
  def create
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
    @chapter.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Chapter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      set_resource(model: :course, param: :slug)
    end
    def set_chapter
      set_course
      set_resource(param: :slug)
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.require(:chapter).permit(:name)
    end
end
