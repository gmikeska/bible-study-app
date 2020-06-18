class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :checkout,:payment, :paid, :refund]
  # self.TRANSACTION_SUCCESS_STATUSES = [
  #   Braintree::Transaction::Status::Authorizing,
  #   Braintree::Transaction::Status::Authorized,
  #   Braintree::Transaction::Status::Settled,
  #   Braintree::Transaction::Status::SettlementConfirmed,
  #   Braintree::Transaction::Status::SettlementPending,
  #   Braintree::Transaction::Status::Settling,
  #   Braintree::Transaction::Status::SubmittedForSettlement,
  # ]

  # GET /invoices
  # GET /invoices.json
  def index
    return unless requester_is_staff
    @invoices = Invoice.all
    @invoices.each do |invoice|
      if(invoice.status == "submitted_for_settlement" || invoice.status == "settling")
        invoice.update_payment_status
      end
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    authorized = (current_user && (current_user == @invoice.user || current_user.isStaff?))
    return unless requester_is_authorized(authorized)
  end

  def checkout
    authorized = (current_user && (current_user == @invoice.user || current_user.isStaff?))
    return unless requester_is_authorized(authorized)
    @payment = Payment.new(invoice:@invoice, user:current_user, amount:@invoice.amount_owed)
    @payment.save
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def refund
    return unless requester_is_staff
    @invoice.payments.each do |transaction|
      if(transaction.status == "settled")
        result = Payment.gateway.transaction.refund(transaction.id)
      else
        result = Payment.gateway.transaction.void(transaction.id)
      end
      byebug
    end
    @invoice.refunded = true
    redirect_to "/invoices/"
  end

  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      if(params[:invoice_id])
        @invoice = Invoice.find(params[:invoice_id])
      else
        @invoice = Invoice.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.fetch(:invoice, {})
    end
end
