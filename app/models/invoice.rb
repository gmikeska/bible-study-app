require "braintree"
class Invoice < ApplicationRecord
  belongs_to :user
  has_many :enrollments
  has_many :payments
  has_many :courses, through: :enrollments
  after_initialize do |invoice|
    if(invoice.number.nil?)
      suffix = (Time.now.utc.strftime("%S").to_i)*(invoice.user.id)
      invoice.number = Time.now.utc.strftime("%Y%m%d%H%M")+suffix.to_s
    end
  end
  def price_total
    prices = enrollments.collect { |enrollment| enrollment.price }
    return prices.reduce(:+)
  end

  def amount_paid
    if(payments.length > 0)
      payment_list = payments.collect { |transaction| Money.new(transaction.amount.to_f*100) }
      return payment_list.reduce(:+)
    else
      return 0
    end
  end

  def apply_payment(transaction)
    self.payments << transaction
  end

  def update_payment_status
    payments.each_index do |i|;payment = payments[i]
      updated = Payment.gateway.transaction.find(payment.id)
      payments[i] = updated
    end
    save
  end

  def amount_owed
    price_total - amount_paid
  end

  def status
    if(payments.present? && payments.length > 0)
      response = self.payments.last.status
      if(self.amount_owed > 0)
        response = "partial_#{response}"
      elsif(self.refunded)
        return "refunded"
      end
    else
      response = Invoice.status_options.first
    end
    return response
  end
  def status_info(status)
    case status
    when "submitted_for_settlement"
      "The transaction has been submitted for settlement and will be included in the next settlement batch. Settlement happens nightly – the exact time depends on the processor."
    when "settling"
      "The transaction is in the process of being settled. This is a transitory state. A transaction can't be voided once it reaches Settling status, but can be refunded."
    when "settled"
      "The transaction has been settled."
    when "voided"
      "The transaction was voided prior to settlement."
    when "unpaid"
      "The user has added the course but has not yet paid."
    end
  end
  def paid?
    (self.amount_owed == 0 && ["settled", "submitted_for_settlement"].include?(self.status))
  end

  def error?
    ["SettlementDeclined","Failed", "GatewayRejected","ProcessorDeclined"].include?(self.status)
  end

  def self.status_options
     ["unpaid","pending","settled"]
  end
end
