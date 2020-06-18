require 'bitcoin'
class BitcoinWallet < ApplicationRecord
  has_many :bitcoin_pubkeys

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
  def self.generate_keyset(key_count=1)
    output = []
    key_count.times do
      output <<  MoneyTree::Master.new
    end
    if(output.length == 1)
      return output[0]
    else
      return output
    end
  end
  def self.get_multisig_address(pubkeys,number_to_verify)
    keys = pubkeys.dup()
    return Bitcoin::Script.new(Bitcoin::Script.to_multisig_script(number_to_verify,*keys)).get_address
  end
  def address_at(index)
    if(bitcoin_pubkeys.length > 1)
      keys = []
      bitcoin_pubkeys.each do |k|
        keys << k.subkey_at(k.key_path_for_index(index))
      end
      address = BitcoinWallet.get_multisig_address(keys.collect{|sub| sub[:public_key] },self.required_keys)
      bitcoin_pubkeys.each do |key|
        key.addresses[index] = address
      end
      return address
    else
      return keys[0].to_address
    end
  end
  def next_multisig_address
    return use_multisig_address_at(next_index)
  end
  def next_index
    last_index+1
  end
  def use_multisig_address_at(index)
    keys = []
    bitcoin_pubkeys.each do |key|
      keys << key.use(index)
    end
    BitcoinWallet.get_multisig_address(keys.collect{|sub| sub[:public_key] },self.required_keys)
  end
  def subkeys(index)
    subkey = {}
    bitcoin_pubkeys.each do |key|
      subkey[name] = key.subkey_at(key.key_path_for_index(index))
    end
  end
end
