class ComponentSettings
  # Used for `serialize` method in ActiveRecord
  class << self
    def load(data)
      self.new(data[:name],data[:args])
    end
    def dump(obj)
      unless obj.is_a?(self)
        raise ::ActiveRecord::SerializationTypeMismatch,
          "Attribute was supposed to be a #{self}, but was a #{obj.class}. -- #{obj.inspect}"
      end
      return obj.to_h
    end
  end


  attr_accessor :name, :args

  def initialize(name,args=nil)
    @name = name
    if(args.present?)
      @args = args.symbolize_keys
    else
      @args = instance.params.defaults
    end
  end
  def keys
    return instance.params.keys
  end
  def get_type(key)
    return instance.params.get_type(key)
  end
  def get_default(key)
    return instance.params.get_default(key)
  end
  def instance
    @name.camelcase.constantize
  end
  def view(args=nil)
    if(args.nil?)
      args = @args
    end
    return self.instance.new(**args)
  end

  def to_h
    return {name:@name, args:@args}
  end
end
