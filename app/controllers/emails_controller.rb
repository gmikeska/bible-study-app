class EmailsController < ApplicationController
  before_action :set_email, only: [:show,:send_email,:submit_email_send, :edit, :update, :destroy]

  # GET /emails
  # GET /emails.json
  def index
    return unless requester_is_staff
    @emails = Email.all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    return unless requester_is_staff
  end

  def send_email
    return unless requester_is_staff
  end

  def submit_email_send
    return unless requester_is_staff
    @recipients.each do |user|
      body = @email.compile_message(sending_params,user)
      CustomMailer.with(user:user,body:body,subject:@email.subject).dynamic.deliver_now
    end
    redirect_to @email, notice: 'Email was successfully created.'
  end

  # GET /emails/new
  def new
    return unless requester_is_staff
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
    return unless requester_is_staff
  end

  # POST /emails
  # POST /emails.json
  def create
    return unless requester_is_staff
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    return unless requester_is_staff
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    return unless requester_is_staff
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
      @recipients = @email.recipient_list
    end

    # Only allow a list of trusted parameters through.
    def email_params
      params.require(:email).permit(:name, :subject, :content)
    end
    def sending_params
      params[:email].permit!.to_h
    end
end
