class CarouselComponent < CustomizableComponent

  def initialize(**args)
    @slides = args[:slides]
    @starting_slide_index = args[:starting_slide_index]

    if(args[:starting_slide_index])
      @starting_slide_index = args[:starting_slide_index]
    else
      @starting_slide_index = 0
    end

    if(args[:slides])
      @slides = args[:slides]
    else
      @slides = []
    end

    if(args[:controls])
      @controls = args[:controls]
    else
      @controls = false
    end
    if(args[:indicators])
      @indicators = args[:indicators]
    else
      @indicators = false
    end
    super
    if(@id.nil? || @id == "")
      set_id("carousel")
    end
    add_class("carousel")
    add_class("slide")
    add_data("ride","carousel")
  end

  def slide(index)
    if(index == @starting_slide_index)
  return %Q(<div class="carousel-item active">
    #{@slides[index]}
  </div>).html_safe
    else
  return %Q(<div class="carousel-item">
    #{@slides[index]}
  </div>).html_safe
    end
  end

  def self.params
    params = super()
    params.concat(slides:{dataType:"Array", default:[%Q(<svg width="800" height="400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400" preserveAspectRatio="none"><defs><style type="text/css">#holder_172bdfeb8cf text { fill:#444;font-weight:normal;font-family:Helvetica, monospace;font-size:40pt } </style></defs><g id="holder_172bdfeb8cf"><rect width="800" height="400" fill="#666"></rect><g><text x="247.3125" y="217.7609375">First slide</text></g></g></svg>),
      %Q(<svg width="800" height="400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400" preserveAspectRatio="none"><defs><style type="text/css">#holder_172bdfeb8cf text { fill:#444;font-weight:normal;font-family:Helvetica, monospace;font-size:40pt } </style></defs><g id="holder_172bdfeb8cf"><rect width="800" height="400" fill="#666"></rect><g><text x="247.3125" y="217.7609375">Second slide</text></g></g></svg>),
      %Q(<svg width="800" height="400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400" preserveAspectRatio="none"><defs><style type="text/css">#holder_172bdfeb8cf text { fill:#444;font-weight:normal;font-family:Helvetica, monospace;font-size:40pt } </style></defs><g id="holder_172bdfeb8cf"><rect width="800" height="400" fill="#666"></rect><g><text x="247.3125" y="217.7609375">Third slide</text></g></g></svg>)
    ]},starting_slide_index:0,controls:false,indicators:false)
    return params
  end
end
