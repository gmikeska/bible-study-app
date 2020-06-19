class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy, :braintree_processing,:paid]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    authorized = (current_user && (current_user == @payment.user))
    return unless requester_is_authorized(authorized)

    if(@payment.payment_method == "bitcoin")
      bitcoin_payment_params
      request_data = get_payment_request(address:@bitcoin_address,amount:@payment.amount_in_btc.to_s,message:ERB::Util.url_encode(@payment.category.titleize))
      @payment_request = request_data[:request]
      @qr_code = request_data[:qr_code]
      @address_qr_code = request_data[:address_qr_code]
    else
      @client_token = Payment.gateway.client_token.generate
    end
  end

  def braintree_processing
    authorized = (current_user && (current_user == @payment.user))
    return unless requester_is_authorized(authorized)
    params = braintree_params
    result = Payment.gateway.transaction.sale(
      :amount => @payment.amount.to_s,
      :payment_method_nonce => params[:nonce],
      :options => {
        :submit_for_settlement => true
      }
    )
    if result.success?
      @payment.transaction_id = result.transaction.id


      @payment.save
      render :json => result
      return
    else
      puts(result.message)
      render :json => result
    end
  end
  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @payment.user = current_user
    respond_to do |format|
      if @payment.save
        format.html { redirect_to payment_payment_path(@payment) }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      if(params[:id])
        @payment = Payment.find(params[:id])
      elsif(params[:payment_id])
        @payment = Payment.find(params[:payment_id])
      end
      if(@payment.invoice)
        @invoice = @payment.invoice
      end
    end

    def bitcoin_payment_params
      if(@payment.payment_address.present?)
        @bitcoin_address = @payment.payment_address
      else
        @payment.payment_address = BitcoinWallet.first.use_next_multisig_address
        @bitcoin_address = @payment.payment_address
      end
      if(@payment.amount_in_btc.nil?)
        @payment.amount_in_btc = Money.new(0, 'BTC')
        @payment.amount_in_btc = @payment.amount_in_btc + @payment.amount
      end
      @payment.save()
    end

    def get_payment_request(**args)
      BitcoinWallet.get_payment_request(**args)
    end
    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:category, :amount, :payment_method)
    end
    def braintree_params
      params.permit(:nonce)
    end
end
