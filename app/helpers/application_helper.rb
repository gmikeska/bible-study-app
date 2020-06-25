module ApplicationHelper
  def current_user_is?(type)
    return (current_user && current_user.type == type)
  end
  def preview_video(file,url)
      return %Q(<div style="background-image:url('#{url_for(file.preview(resize_to_limit: [200, 200]).processed)}'); min-height:200px; min-width:200px;">#{link_to "<div class='w-100' style='font-size: xx-large;padding-left: 45%;padding-top: 30%;color: white;'>►</div>".html_safe, url, style:'text-decoration:none;'} </div> )
  end
  def video_path(lesson,file)
      return "/videos/#{file.filename.base.to_s}"
  end
  def player_video(file,url)
    if(file.previewable? && !file.preview(resize_to_limit: [100, 100]).processed.nil?)
      return %Q(<div data-video='#{url}' class="video" style="cursor: pointer;background-image:url('#{url_for(file.preview(resize_to_limit: [200, 200]).processed)}'); background-color: black;background-repeat: no-repeat;background-position: center; min-height:200px; min-width:200px;"><div style="color: white; font-size: xx-large;padding-left: 41%; padding-top: 26%;">►</div> </div> )
    else
      return %Q(<a data-video='#{url}' class="video" style="cursor: pointer;">#{file.name}</a> )
    end
  end
  def text_icon(size=2)
%Q(<svg class="bi bi-file-earmark-text" width="#{size}em" height="#{size}em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
    <path d="M4 1h5v1H4a1 1 0 00-1 1v10a1 1 0 001 1h8a1 1 0 001-1V6h1v7a2 2 0 01-2 2H4a2 2 0 01-2-2V3a2 2 0 012-2z"/>
    <path d="M9 4.5V1l5 5h-3.5A1.5 1.5 0 019 4.5z"/>
    <path fill-rule="evenodd" d="M5 11.5a.5.5 0 01.5-.5h2a.5.5 0 010 1h-2a.5.5 0 01-.5-.5zm0-2a.5.5 0 01.5-.5h5a.5.5 0 010 1h-5a.5.5 0 01-.5-.5zm0-2a.5.5 0 01.5-.5h5a.5.5 0 010 1h-5a.5.5 0 01-.5-.5z" clip-rule="evenodd"/>
  </svg>).html_safe
  end
  def back_button(link, **args)
    if(args[:class].nil?)
      args[:class] = 'btn btn-sm btn-secondary'
    end
    link_to '⮜ Back',link, **args
  end
  def is_dev(user)
    return ["test@test.com","gmikeska07@gmail.com"].include?(user.email)
  end
  def view_button(link, **args)
    if(args[:class].nil?)
      args[:class] = 'btn btn-sm btn-default'
    end
    if(args[:content].present?)
      content = args[:content]
      args.delete(:content)
    else
      content = "View"
    end
    link_to content, link, **args
  end
  def edit_button(link, **args)
    if(args[:class].nil?)
      args[:class] = 'btn btn-sm btn-default'
    end
    if(args[:content].present?)
      content = args[:content]
      args.delete(:content)
    else
      content = "Edit"
    end
    link_to content, link, **args
  end
  def delete_button(link, **args)
    if(args[:class].nil?)
      args[:class] = 'btn btn-sm btn-danger'
    end
    if(args[:content].present?)
      content = args[:content]
      args.delete(:content)
    else
      content = "Delete"
    end
    link_to content, link, method: :delete, data: { confirm: 'Are you sure?' }, **args
  end
  def toolbar(buttons,**args)
    if(args[:class].nil?)
      args[:class] = "border row toolbar"
    else
      args[:class] = "#{args[:class]} toolbar"
    end
    
    %Q(<div class="#{args[:class]}" style="#{args[:style]}">
      #{buttons.join('')}
    </div>).html_safe
  end
  def attachment_info(preview,heading,summary)
%Q(<div class="media">
    #{preview}
    <div class="media-body">
      <h5 class="mt-0">#{heading}</h5>
      #{summary}
    </div>
  </div>)
  end
end
