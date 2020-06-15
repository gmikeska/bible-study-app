class BiblePassageComponent < CustomizableComponent
  def initialize(**args)
    @reference = args[:reference]

    @bible = Bible.find_by(bible_id:"06125adad2d5898a-01")

    super
  end
  def self.params
    params = super()
    params.concat(reference:{dataType:"String", default:"Genesis 1:1-3"})
    return params
  end
end
