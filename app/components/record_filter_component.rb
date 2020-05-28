class RecordFilterComponent < ViewComponent::Base
  def initialize(filters)
    @filters = filters
  end

  def filter_element(name, index, title=nil)
    if(index == 0)
      return %Q(<li class="nav-item">
      <a class="nav-link active" title="#{title}" id="pills-#{name}-tab" data-toggle="pill" href="#pills-#{name}" role="tab" aria-controls="pills-#{name}" aria-selected="true">#{name.titleize}</a>
      </li>)
    else
      return %Q(<li class="nav-item">
      <a class="nav-link" title="#{title}" id="pills-#{name}-tab" data-toggle="pill" href="#pills-#{name}" role="tab" aria-controls="pills-#{name}" aria-selected="false">#{name.titleize}</a>
      </li>)
    end
  end
  def filter_bar
    outstr = %Q(<ul class="nav nav-pills mb-3 border-top" id="pills-tab" role="tablist" style="padding-top:10px;">\n)
      @filters.each_index do |index|; filter= @filters[index]
        el = filter_element(filter[:name],index,filter[:tooltip])+"\n"
        outstr = outstr + el
      end
    outstr = outstr+"</ul>\n"
    return outstr
  end
  def pane(name, content, index)
    if(index == 0)
      return %Q(<div class="tab-pane fade show active" id="pills-#{name}" role="tabpanel" aria-labelledby="#{name}-tab">#{content}</div>)
    else
      return %Q(<div class="tab-pane fade" id="pills-#{name}" role="tabpanel" aria-labelledby="#{name}-tab">#{content}</div>)
    end
  end
end
