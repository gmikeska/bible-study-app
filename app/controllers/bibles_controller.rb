class BiblesController < ApplicationController
  before_action :set_bible, only: [:show, :edit, :update, :destroy]

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

  # GET /bibles/1/edit
  def edit
  end

  # POST /bibles
  # POST /bibles.json
  def create
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
    end

    # Only allow a list of trusted parameters through.
    def bible_params
      params.require(:bible).permit(:bibleId)
    end
end
