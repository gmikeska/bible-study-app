class BiblePassageComponent < CustomizableComponent
  def initialize(**args)
    @reference = args[:reference]

    if(args[:bible_id])
      @bible = Bible.find_by(bible_id:args[:bible_id])
    else
      @bible = Bible.find_by(bible_id:"06125adad2d5898a-01")
    end
    
    super
    add_class("container")
  end
  def self.params
    params = super()
    params.concat(reference:{dataType:"String", default:"Genesis 1:1-3"})
    return params
  end
end
