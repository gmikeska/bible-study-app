require 'rqrcode'
class BitcoinWallet
  def self.get_address_qr_code(address)
    RQRCode::QRCode.new(address)
  end

  def self.organization
    return "Memorial United Methodist Church"
  end
  def self.get_payment_request(**args)
    request = "bitcoin:#{args[:address]}?amount=#{args[:amount]}&message=#{args[:message]}"
    return {
      request:request,
      address_qr_code:get_address_qr_code(args[:address]),
      qr_code:RQRCode::QRCode.new(request)
    }
  end

  def initialize(**args)

  end

  def get_address
    Faker::Blockchain::Bitcoin.address
  end

end
