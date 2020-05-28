class TableComponent < ViewComponent::Base
  with_content_areas :header, :body, :placeholder
  attr_reader :fields,:show,:edit,:delete
  def initialize(record:nil, fields:nil, show:true, edit:true, delete:true)
    @record = record
    if(fields.nil?)
      @fields = @record.class.columns.collect{|c| c.name.to_sym}
    else
      @fields = fields
    end
    @show = show
    @edit = edit
    @delete = delete
  end
  def colspan
    length = @fields.length
    if(@show)
      length = length+1
    end
    if(@edit)
      length = length+1
    end
    if(@delete)
      length = length+1
    end
    return length
  end
end
