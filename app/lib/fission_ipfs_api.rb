require "api_gears"
class FissionIpfsApi < ApiGears
  def initialize(**options)
    if(options[:params].nil?)
      options[:params] = {}
    end
    if(options[:currency].nil?)
      options[:currency] = "btc"
    end
    if(options[:chain_id].nil?)
      options[:chain_id] = "main"
    end
    options[:content_type] = "json"
    url = "https://runfission.com/#{options[:currency]}/#{options[:chain_id]}"
    super(url,options)
    endpoint "upload_data", path:"/ipfs", query_params:[:file_content]

    endpoint "address_balance", path:"/addrs/{address}/balance"
    endpoint "transaction", path:"/txs/{transaction_id}"
    endpoint "generate_multisig_address", path:"/addrs",query_method: :post, query_params:[:pubkeys], set_query_params:{script_type:"multisig-2-of-3"}
  end

  def upload(path_to_file)
    file_to_upload = File.open(File.expand_path(path_to_file))
    ipfs_address = self.upload_data(file_content:file_to_upload.read())
    return [File.filename(path_to_file), ipfs_address]
  end
end
