class Donation < ApplicationRecord
  monetize :amount_cents
  monetize :amount_in_btc_cents, with_currency: :btc
  belongs_to :user
  def self.categories
    return [["General Church Budget","general_church_budget"]]
  end
  def self.payment_methods
    return [["Credit/Debit Card","credit_card"],["Bitcoin","bitcoin"]]
  end
end
