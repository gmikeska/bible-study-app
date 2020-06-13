class DonationsController < ApplicationController
  before_action :set_donation, only: [:show, :edit, :update, :destroy, :payment]

  # GET /donations
  # GET /donations.json
  def index
    @donations = Donation.all
  end

  # GET /donations/1
  # GET /donations/1.json
  def show
  end

  def payment
    if(@donation.payment_method == "bitcoin")
      set_bitcoin_payment_params
      request_data = get_payment_request(address:@bitcoin_address,amount:@donation.amount_in_btc.to_s,message:ERB::Util.url_encode(@donation.category.titleize))
      @payment_request = request_data[:request]
      @qr_code = request_data[:qr_code]
      @address_qr_code = request_data[:address_qr_code]
    end
  end

  # GET /donations/new
  def new
    @donation = Donation.new
  end

  # GET /donations/1/edit
  def edit
  end

  # POST /donations
  # POST /donations.json
  def create
    @donation = Donation.new(donation_params)
    @donation.user = current_user
    respond_to do |format|
      if @donation.save
        format.html { redirect_to donation_payment_path(@donation) }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donations/1
  # PATCH/PUT /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to @donation, notice: 'Donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to donations_url, notice: 'Donation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      if(params[:id])
        @donation = Donation.find(params[:id])
      elsif(params[:donation_id])
        @donation = Donation.find(params[:donation_id])
      end
    end

    def set_bitcoin_payment_params
      if(@donation.payment_address.present?)
        @bitcoin_address = @donation.payment_address
      else
        @bitcoin_address = BitcoinWallet.new().get_address
        @donation.payment_address = @bitcoin_address
      end
      if(@donation.amount_in_btc.nil?)
        @donation.amount_in_btc = Money.new(0, 'BTC')
        @donation.amount_in_btc = @donation.amount_in_btc + @donation.amount
      end
      @donation.save()
    end

    def get_payment_request(**args)
      BitcoinWallet.get_payment_request(**args)
    end

    # Only allow a list of trusted parameters through.
    def donation_params
      params.require(:donation).permit(:category, :amount, :payment_method)
    end
end
