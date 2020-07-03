class FacebookVideo < ApplicationRecord
  has_one_attached :video
  serialize :webhook_message, Hash
  after_initialize do |video|
    if(video.slug.nil? && !video.title.nil?)
      video.slug = video.title.parameterize
      video.save
    end
  end

  def to_param
    slug
  end
  def video_id
    return self.video_url.match('https:\/\/www.facebook.com\/MemorialUnitedMethodistChurchAustin\/videos\/(\w*)\/')[1]
  end
  def citation
    "<blockquote cite='https://developers.facebook.com/MemorialUnitedMethodistChurchAustin/videos/#{self.video_id}/' class='fb-xfbml-parse-ignore'><a href='https://developers.facebook.com/MemorialUnitedMethodistChurchAustin/videos/#{self.video_id}/'></a><p></p>Posted by <a href='https://www.facebook.com/MemorialUnitedMethodistChurchAustin/'>Memorial United Methodist Church-Austin</a> on #{self.recording_date}</blockquote>"
  end
  def recording_date
    self.created_at.strftime("%A, %B %e, %Y")
  end
  def is_live?
    return  DateTime.now.between?(DateTime.parse(self.created_at.strftime("%B %e, %Y")+" 11:45 AM #{DateTime.now.zone}"), DateTime.parse(self.created_at.strftime("%B %e, %Y")+" 11:50 AM #{DateTime.now.zone}"))
  end

end
