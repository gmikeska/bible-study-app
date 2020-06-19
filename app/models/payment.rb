class Payment < ApplicationRecord
  monetize :amount_cents
  monetize :amount_in_btc_cents, with_currency: :btc
  belongs_to :user
  belongs_to :invoice, optional:true
  belongs_to :bitcoin_wallet, optional:true
  def payment_type
    if(invoice.present?)
      return "Payment"
    else
      return "Donation"
    end
  end

  def status
    if(self.payment_method == "credit_card" && self.transaction_id.present?)
      data = Payment.gateway.transaction.find(self.transaction_id)
      return data.status.to_sym
    elsif(self.payment_method == "credit_card" && self.transaction_id.nil?)
      return :pending
    elsif(self.payment_method == "bitcoin")
      if(self.payment_address.present? && self.transaction_id.nil?)
        address_data = Payment.block_explorer.address_info(address:self.payment_address)
        if(address_data["txrefs"].present? && address_data["txrefs"].length > 0)
          self.transaction_id = address_data["txrefs"].last["tx_hash"]
          self.save
        end
      end
      if(self.transaction_id.present?)
        tx_data = Payment.block_explorer.transaction(transaction_id:self.transaction_id)
        if(tx_data["confirmations"] > 0 && tx_data["confirmations"] < 6)
          return :settling
        elsif(tx_data["confirmations"] >= 6)
          return :settled
        end
      else
        return :pending
      end
    end
  end
  def self.categories
    return [["General Church Budget","general_church_budget"]]
  end
  def self.payment_methods
    return [["Credit/Debit Card","credit_card"],["Bitcoin","bitcoin"]]
  end
  def self.gateway
    return Braintree::Gateway.new(environment: :sandbox,merchant_id:ENV["BT_MERCHANT_ID"], public_key:ENV["BT_PUBLIC_KEY"], private_key:ENV["BT_PRIVATE_KEY"])
  end
  def self.status_info(status)
    case status.to_sym
    when :submitted_for_settlement
      "The transaction has been submitted for settlement and will be included in the next settlement batch. Settlement happens nightly – the exact time depends on the processor."
    when :settling
      "The transaction is in the process of being settled. This is a transitory state. A transaction can't be voided once it reaches Settling status, but can be refunded."
    when :settled
      "The transaction has been settled."
    when :voided
      "The transaction was voided prior to settlement."
    when :unpaid
      "The user has added the course but has not yet paid."
    end
  end
  def self.block_explorer
    return BlockcypherApi.new
  end
end
