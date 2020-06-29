class FacebookVideo < ApplicationRecord
  after_initialize do |video|
    if(video.slug.nil? && !video.title.nil?)
      video.slug = video.title.parameterize
      video.save
    end
  end

  def to_param
    slug
  end

end
