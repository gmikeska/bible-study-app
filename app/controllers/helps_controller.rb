class HelpsController < ApplicationController
  before_action :set_help, only: [:show, :edit, :update, :destroy]

  # GET /helps
  # GET /helps.json
  def index
    @help = Help.find_by slug:"home"
    @contents = Help.where(category:"home")
    if(@help.restricted)
      auth = (current_user && current_user.isStaff?)
      return unless requester_is_authorized(auth)
    end
    render "show"
  end

  # GET /helps/1
  # GET /helps/1.json
  def show
    if(@help.restricted)
      auth = (current_user && current_user.isStaff?)
      return unless requester_is_authorized(auth)
    end
  end

  # GET /helps/new
  def new
    @help = Help.new
    if(params[:category].present?)
      @category = params[:category]
    end
  end

  # GET /helps/1/edit
  def edit
    auth = (current_user && current_user.isStaff?) && (!@help.system || current_user.isDev?)
    return unless requester_is_authorized(auth)
  end

  # POST /helps
  # POST /helps.json
  def create
    @help = Help.new(help_params)

    respond_to do |format|
      if @help.save
        format.html { redirect_to @help, notice: 'Help article was successfully created.' }
        format.json { render :show, status: :created, location: @help }
      else
        format.html { render :new }
        format.json { render json: @help.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /helps/1
  # PATCH/PUT /helps/1.json
  def update
    respond_to do |format|
      if @help.update(help_params)
        format.html { redirect_to @help, notice: 'Help article was successfully updated.' }
        format.json { render :show, status: :ok, location: @help }
      else
        format.html { render :edit }
        format.json { render json: @help.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /helps/1
  # DELETE /helps/1.json
  def destroy
    @help.destroy
    respond_to do |format|
      format.html { redirect_to helps_url, notice: 'Help article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_help
      @help = Help.find_by slug:params[:slug].parameterize
      @contents = Help.where(category:params[:slug].parameterize)
    end

    # Only allow a list of trusted parameters through.
    def help_params
      params.require(:help).permit(:title, :content, :system, :category)
    end
end
