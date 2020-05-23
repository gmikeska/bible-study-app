class InstructionsController < ApplicationController
  before_action :set_instruction, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :relay
  layout "live"
  # GET /instructions
  # GET /instructions.json
  def index
    @instructions = Instruction.all
  end

  # GET /instructions/1
  # GET /instructions/1.json
  def show
    @course = @instruction.course
    @url = instruction_url(@instruction)
  end

  # GET /instructions/new
  def new
    @instruction = Instruction.new
  end

  # GET /instructions/1/edit
  def edit
  end

  # POST /instructions
  # POST /instructions.json
  def create
    @instruction = Instruction.new(instruction_params)

    respond_to do |format|
      if @instruction.save
        format.html { redirect_to @instruction, notice: 'Instruction was successfully created.' }
        format.json { render :show, status: :created, location: @instruction }
      else
        format.html { render :new }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructions/1
  # PATCH/PUT /instructions/1.json
  def update
    respond_to do |format|
      if @instruction.update(instruction_params)
        format.html { redirect_to @instruction, notice: 'Instruction was successfully updated.' }
        format.json { render :show, status: :ok, location: @instruction }
      else
        format.html { render :edit }
        format.json { render json: @instruction.errors, status: :unprocessable_entity }
      end
    end
  end

  def relay

    if(params["type"] == "JOIN_ROOM")
      arriving_user = User.find(params["from"]["id"].to_i)
      au = {name:arriving_user.name, id:arriving_user.id}
      current_classroom = Instruction.find(params["classroom"].to_i)
      if(!current_classroom.attending.include? au)
        current_classroom.attending << au
        current_classroom.save
        puts arriving_user.name+" arrives to "+current_classroom.course.name+" classroom."
      else
        puts arriving_user.name+" reconnects to "+current_classroom.course.name+" classroom."
      end
    end

    if(params["type"] == "REMOVE_USER")
      departing_user = User.find(params["from"]["id"].to_i)
      du = {name:departing_user.name, id:departing_user.id}
      current_classroom = Instruction.find(params["classroom"].to_i)
      if(!current_classroom.attending.include? du)
        current_classroom.attending.delete(du)
        current_classroom.save
        puts departing_user.name+" departs "+current_classroom.course.name+" classroom."
      else
        puts departing_user.name+" sends duplicate disconnect from "+current_classroom.course.name+" classroom."
      end
    end

    if(params["type"] == "MESSAGE")
      puts params["from"]
      sender = User.find(params["from"]["id"].to_i)
      current_classroom = Instruction.find(params["id"].to_i)
      current_classroom.messages << {message:params["message"],from:params["from"]}
      current_classroom.save()
    end
    ActionCable.server.broadcast "instruction_channel", params
  end

  # DELETE /instructions/1
  # DELETE /instructions/1.json
  def destroy
    @instruction.destroy
    respond_to do |format|
      format.html { redirect_to instructions_url, notice: 'Instruction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instruction
      @instruction = Instruction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def instruction_params
      params.fetch(:instruction, {})
    end
end
