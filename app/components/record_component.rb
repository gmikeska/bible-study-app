class RecordComponent < ViewComponent::Base
  def initialize(record:nil, fields:nil, show:true, edit:true, delete:true,**args)
    @record = record
    if(fields.nil? && @records.present? && @records.count > 0)
      @fields = @record.class.columns.collect{|c| c.name.to_sym}
    else
      @fields = fields
    end
    @show = show
    @edit = edit
    @delete = delete
  end

  def header
    linkSpan = 0
    outstr = %Q(<thead>
      <tr>)
      @fields.each do |field|
        outstr = outstr + "<th>#{field.to_s.titleize}</th>"
      end
      if(@show)
        linkSpan = linkSpan+1
      end
      if(@edit)
        linkSpan = linkSpan+1
      end
      if(@delete)
        linkSpan = linkSpan+1
      end
      if(linkSpan > 0)
        outstr = outstr + %Q(<th colspan="#{linkSpan}"></th>)
      end
      outstr = outstr + %Q(</tr>
    </thead>)
    return outstr.html_safe
  end
end
