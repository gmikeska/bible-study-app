class Page < ApplicationRecord

  after_initialize do |page|
    if(!slug)
      page.slug = page.name.parameterize
    end
  end

  def to_param
    slug
  end

end
