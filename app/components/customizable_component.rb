class CustomizableComponent < ViewComponent::Base
  include Rails.application.routes.named_routes.path_helpers_module
  include Rails.application.routes.named_routes.url_helpers_module
  include ApplicationHelper
  def initialize(**args)
    if(args[:css_class])
      @css_class = args[:css_class]
    else
      @css_class = ""
    end

    if(args[:id])
      @id = args[:id]
    else
      @id = ""
    end

    if(args[:style])
      @style = args[:style]
    else
      @style = ""
    end

    if(args[:tag_name])
      @tag_name = args[:tag_name]
    else
      @tag_name = :div
    end
    if(args[:data])
      @data = args[:data]
    else
      @data = {}
    end
  end

  def add_class(new_class)
    @css_class = "#{@css_class} #{new_class}"
  end
  def set_data(key,value)
    @data[key] = value
  end

  def set_id(id)
    @id = id
  end

  def set_style(**args)
    args.each_pair do |key, value|
      @style = @style+"#{key}:#{value};"
    end
    @style = "style=#{@style}"
  end
  def tag_args
    args = {}
    if(@css_class != "")
      args[:class] = @css_class
    end
    if(@style != "")
      args[:style] = @style
    end
    if(@id != "")
      args[:id] = @id
    end
    if(@data.keys.length > 0)
      args[:data] = @data
    end

    return args
  end
  def wrap(*args)
    value = nil
    buffer = with_output_buffer { value = yield(*args).html_safe }
    content = buffer.to_s
    return content_tag(@tag_name.to_sym,"\n#{content.to_s.html_safe}\n".html_safe,**tag_args).html_safe
  end
  def create_link_url(link_reference)
    if(Page.first.is_pointer?(link_reference))
      return Page.first.resolve_pointer(link_reference).url
    else
      return link_reference
    end
  end

  def self.params
    return ComponentInfo.new([:css_class,:id])
  end
end
