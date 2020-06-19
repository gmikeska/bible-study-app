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

  def field_for(key, form)
    if(get_type(key) == "String")
      return %Q(<div class="field">
        #{form.text_field "components[][args][#{key}]".to_sym, value:@args[key], label:key.to_s.titleize, placeholder:get_default(key), data:{action:"component-editor#updatePreview"}}
      </div>).html_safe
    end
    if(get_type(key) == "URL")
      if(Page.page_options.collect{|p| p[1] }.include?(@args[key]))
        selectName = "components[][args][#{key}]"
        inputName = "unused"
        selected = @args[key]
        input_style = "display:none;"
        value = ""
      else
        selectName = "unused"
        inputName = "components[][args][#{key}]"
        input_style = ""
        selected = "external_link"
        value = @args[key]
      end

      return %Q(<div class="row"><div class="field col">
        #{form.select selectName.to_sym, Page.page_options.concat([["External Link...","external_link"]]), {selected:selected, label:key.to_s.titleize, include_blank:"Select a destination"},class:"link_select",data:{action:"component-editor#updatePreview"}}
      </div>
      <div class="field col" style="#{input_style}">
        #{form.text_field inputName.to_sym, value:value, label:"External Link", placeholder:'http://www.google.com',data:{action:"component-editor#updatePreview"}}
      </div></div>).html_safe
    end
    #   return %Q(<div class="field">
    #     #{form.select "components[][args][#{key}]".to_sym, Page.page_options.concat([["External Link","external_link"]]), selected:@args[key], label:key.to_s.titleize, include_blank:"Select a destination...", style:select_style}
    #     #{form.text_field "components[][args][#{key}]".to_sym, label:"<p style='#{input_style}'>&nbsp</p>".html_safe, placeholder:"http://www.google.com", style:input_style}
    #   </div>).html_safe
    # end
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
