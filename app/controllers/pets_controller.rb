class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  # GET /pets
  # GET /pets.json
  def index
    return unless requester_is_admin
    @pets = Pet.all
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
    return unless requester_is_authorized(true)
  end

  # GET /pets/new
  def new
    return unless requester_is_authorized(true) # consider authorized if any user is signed in.
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
    isOwner = current_user.present? && (current_user == @pet.owner || current_user.isAdmin? )
    return unless requester_is_authorized(isOwner)
  end

  # POST /pets
  # POST /pets.json
  def create
    return unless requester_is_authorized(true) # consider authorized if any user is signed in.
    params = pet_params
    params[:owner] = current_user
    @pet = Pet.new(params)

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: 'Pet was successfully created.' }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1
  # PATCH/PUT /pets/1.json
  def update
    isOwner = current_user.present? && (current_user == @pet.owner || current_user.isAdmin? )
    return unless requester_is_authorized(isOwner)
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: 'Pet was successfully updated.' }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  def destroy
    isOwner = current_user.present? && (current_user == @pet.owner || current_user.isAdmin? )
    return unless requester_is_authorized(isOwner)
    @pet.destroy
    respond_to do |format|
      format.html { redirect_to pets_url, notice: 'Pet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pet_params
      params.require(:pet).permit(:name, :species, :birthday)
    end
end
