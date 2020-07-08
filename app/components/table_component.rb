class TableComponent < ViewComponent::Base
  with_content_areas :header, :body, :placeholder
  attr_reader :fields,:show,:edit,:delete
  include TagHelper
  include Rails.application.routes.named_routes.path_helpers_module
  include Rails.application.routes.named_routes.url_helpers_module
  include ApplicationHelper
  def initialize(records:nil, fields:nil, show:true, edit:true, delete:true)
    @records = records
    if(fields.nil? && @records.present? && @records.count > 0)
      @fields = @records.first.class.columns.collect{|c| c.name.to_sym}
    else
      @fields = fields
    end
    @show = show
    @edit = edit
    @delete = delete
  end
  def table_header(**args)
    if(!args[:fields])
      args[:fields] = @fields
    end
    if(!args[:show])
      args[:show] = @show
    end
    if(!args[:edit])
      args[:edit] = @edit
    end
    if(!args[:delete])
      args[:delete] = @delete
    end
    linkSpan = 0
    outstr = %Q(<thead>
      <tr>)
      args[:fields].each do |field|
        outstr = outstr + "<th>#{field.to_s.titleize}</th>"
      end
      if(args[:show])
        linkSpan = linkSpan+1
      end
      if(args[:edit])
        linkSpan = linkSpan+1
      end
      if(args[:delete])
        linkSpan = linkSpan+1
      end
      if(linkSpan > 0)
        outstr = outstr + %Q(<th colspan="#{linkSpan}"></th>)
      end
      outstr = outstr + %Q(</tr>
    </thead>)
    return outstr.html_safe
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
  def self.params
    return super().concat([:records, :fields, :show, :edit, :delete])
  end
end
