class ComponentInfo
  def initialize(args)
    @params = {}
    if(args.is_a? Array)
      args.each do |arg|
        @params[arg.to_sym] = {dataType:String, default:""}
      end
    else
      @params = args
    end
  end

  def concat(args)
    if(args.is_a? Array)
      args.each do |arg|
        @params[arg.to_sym] = String
      end
    else
      args.keys.each do |key|
        @params[key] = args[key]
      end
    end
  end

  def get_type(key)
    @params[key.to_sym][:dataType]
  end

  def get_default(key)
    @params[key.to_sym][:default]
  end

  def set_type(key,value)
    @params[key.to_sym][:dataType] = value
  end

  def set_default(key,value)
    @params[key.to_sym][:default] = value
  end

  def to_h
    @params.deep_dup
  end
end
