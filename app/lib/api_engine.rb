require 'uri'
require 'net/http'
require 'date'

class ApiEngine

  def initialize(url, **options)
    @uri = URI.parse(url)
    @endpoints = {}
    @last_query_time = 0
    if(options[:query_interval].present?)
      @query_interval = options[:query_interval]
    else
      @query_interval = 0
    end

    if(options[:params].present?)
      @params = options[:params]
    end

    if(options[:query_method].present?)
      @query_method = options[:query_method].to_sym
    else
      @query_method = :GET
    end
  end

  def request_info(endpoint,**args)
    if(args.nil?)
      args = {}
    end
    args[:endpoint] = endpoint.to_sym
    info = build_request(args)
    query_method = info[:query_method]
    url = info[:url]
    puts "this method will #{query_method} #{url}"
  end

  def request(**args)
    info = build_request(args)
    current_elapsed = DateTime.now.strftime('%s').to_i - @last_query_time
    if(current_elapsed < @query_interval)
      cooldown = @query_interval - current_elapsed
      puts "Sleeping #{cooldown} seconds to accomodate query interval."
      sleep(cooldown)
    end
    query_method = info[:query_method]
    url = info[:url]
    puts "#{query_method} #{url}"
    # puts "this method will #{query_method} #{url}"
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    if(query_method == :GET)
      request = Net::HTTP::Get.new(url)
    end
    if(query_method == :POST)
      request = Net::HTTP::Post.new(url)
    end
    if(query_method == :PATCH)
      request = Net::HTTP::Patch.new(url)
    end
    if(query_method == :PUT)
      request = Net::HTTP::Put.new(url)
    end
    if(@params)
      @params.each_pair do |param_name,param|
        request[param_name.to_s] = param
      end
    end

    response = http.request(request)
    @last_query_time = DateTime.now.strftime('%s').to_i
    data = JSON.parse(response.read_body)
    puts data
    if(response.code == "200")
      # puts "success"
      return data
    else
      puts response.code.to_s+" "+response.message
    end
    # if(@endpoint[args[:endpoint][:block]])
      # return @endpoint[args[:endpoint]][:block](data)
    # else

    # end

  end
  def method_missing(m, **args, &block)
    if(@endpoints[m.to_sym].present?)
      request(endpoint:m.to_sym,**args)
    else
      raise NoMethodError.new "endpoint '#{m}' not defined in #{self.class.name}. Call `<#{self.class.name} instance>.endpoints` to get a list of defined endpoints."
    end

  end
  def endpoints
    @endpoints.keys
  end
  def args_for(e)
    @endpoints[e.to_sym][:args].map{|arg| arg.to_sym}
  end
  def query_params_for(e)
    @endpoints[e.to_sym][:query_params].map{|arg| arg.to_sym}
  end
  private
    def build_request(args)
      if(args[:endpoint])
        endpoint = @endpoints[args[:endpoint].to_sym]
        url = url_for(args[:endpoint],args)
      end

      if(args[:query_method])
        query_method = args[:query_method].to_sym
      elsif(endpoint[:query_method])
        query_method = endpoint[:query_method].to_sym
      else
        query_method = @query_method.to_sym
      end

      return {query_method:query_method,url:url}
    end
    def endpoint(name, **args, &block)
      if(args[:path] == nil)
        args[:path] = "/#{name.to_s}"
      end
      if(args[:args].nil?)
        args[:args] = []
      else
        args[:args] = args[:args].map do |arg_name|
          arg_name.to_sym
        end
      end
      if(args[:path].match(/\{([a-zA-Z_0-9\-]*)\}/))
        path_args = args[:path].scan(/\{([a-zA-Z_0-9\-]*)\}/).flatten
        path_args.each do |name|
          args[:args] << name.to_sym
        end
      end
      @endpoints[name.to_sym] = {path:args[:path],args:path_args,query_params:args[:query_params], block:block}
    end

    def url_for(endpoint, args)
      url = @uri.dup

      e_path = @endpoints[endpoint.to_sym][:path]

      if(@endpoints[endpoint.to_sym][:args].present? && @endpoints[endpoint.to_sym][:args].length > 0)
        args_for(endpoint.to_sym).each do |arg|
          if(args[arg].nil? && arg.to_s.split("_").length == 2 && args[arg.to_s.split("_")[0].to_sym].present?)
            value = args[arg.to_s.split("_")[0].to_sym]
          else
            value = args[arg]
          end
          e_path = e_path.gsub("{#{arg}}", value.to_s)
        end
      end

      if(e_path.include? @uri.path)
        url.path = e_path
      else
        url.path = url.path + e_path
      end

      if(@endpoints[endpoint.to_sym][:query_params])
        query_set = []

        query_params_for(endpoint.to_sym).each do |param|
          if(args[param.to_sym])
            query_set << [param.to_s,args[param.to_sym].to_s]
          end
        end

        url.query = URI.encode_www_form(query_set)
      end
      return url
    end
end
