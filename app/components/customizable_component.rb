class CustomizableComponent < ViewComponent::Base
  def initialize(css_class:nil, id:nil, **args)
    @style = ""
    @css_class = ""
    add_class(css_class)
    set_id(id)
  end

  def add_class(new_class)
    @css_class = "#{@css_class} #{new_class}"
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
  def self.component_params
    return [:css_class,:id]
  end
end
