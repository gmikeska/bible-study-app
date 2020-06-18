class BitcoinPubkey < ApplicationRecord
  belongs_to :user
  after_initialize do |k|
    if(k.key_path_base.nil?)
      k.key_path_base = "m/0"
      k.save
    end
  end
  def root_node
    return MoneyTree::Master.from_bip32(self.public_key)
  end

  def subkey_at(path)
    subkey = root_node.node_for_path(path).public_key
    return({public_key:subkey.key})
  end

  def use(index)
    path = key_path_for_index(index)
    return(self.subkey_at(path))
  end

  def key_path_for_index(index)
    "#{key_path_base}/#{index}"
  end
end
