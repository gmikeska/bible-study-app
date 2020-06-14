class BiblesController < ApplicationController
  before_action :set_bible, only: [:show, :edit, :update, :destroy,:load_book]
  after_action :load_chapters, only:[:load_book]
  # GET /bibles
  # GET /bibles.json
  def index
    @bibles = Bible.where({language:"English"})
  end

  # GET /bibles/1
  # GET /bibles/1.json
  def show
  end

  # GET /bibles/new
  def new
    @bible = Bible.new
  end

  def load_book
    return unless requester_is_staff
    params[:book_index] = params[:book_index].to_i
    @bible.load_book(params[:book_index])
    redirect_to @bible, notice: "#{@bible.books[params[:book_index]][:name]} was successfully loaded."

  end
  def load_chapters
    return unless requester_is_staff
    @bible.load_chapters(@book_index)
  end

  # GET /bibles/1/edit
  def edit
    return unless requester_is_staff
  end

  # POST /bibles
  # POST /bibles.json
  def create
    return unless requester_is_staff
    @bible = Bible.new(bible_params)

    respond_to do |format|
      if @bible.save
        format.html { redirect_to @bible, notice: 'Bible was successfully created.' }
        format.json { render :show, status: :created, location: @bible }
      else
        format.html { render :new }
        format.json { render json: @bible.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bibles/1
  # PATCH/PUT /bibles/1.json
  def update
    return unless requester_is_staff
    respond_to do |format|
      if @bible.update(bible_params)
        format.html { redirect_to @bible, notice: 'Bible was successfully updated.' }
        format.json { render :show, status: :ok, location: @bible }
      else
        format.html { render :edit }
        format.json { render json: @bible.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bibles/1
  # DELETE /bibles/1.json
  def destroy
    return unless requester_is_staff
    @bible.destroy
    respond_to do |format|
      format.html { redirect_to bibles_url, notice: 'Bible was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bible
      @bible = Bible.find(params[:id])
      @book_index = params[:book_index].to_i
    end

    # Only allow a list of trusted parameters through.
    def bible_params
      params.require(:bible).permit(:bibleId)
    end
end
