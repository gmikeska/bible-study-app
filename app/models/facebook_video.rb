class FacebookVideo < ApplicationRecord
  has_one_attached :video
  serialize :webhook_message, Array
  enum visibility: [:visibility_hidden,:visibility_member,:visibility_public]
  after_initialize do |video|
    if(video.slug.nil? && !video.title.nil?)
      video.slug = video.title.parameterize
      video.save
    end
  end

  def self.import
    api = FacebookGraphApi.new
    videos = api.live_videos()["data"]

    videos.each do |data|
      video_id = data["permalink_url"].split("/").last
      date =  DateTime.parse(data["creation_time"]).new_offset(DateTime.now.zone)
      video = self.find_or_create_by(video_id:video_id)
      #data.creation_time
      video.title = "Worship - #{date.strftime("%A, %B %e, %Y")}"
      video.video_id = video_id
      video.created_at = DateTime.parse(data["creation_time"])
      # require "pry"
      # binding.pry
      if(video.title.present?)
        video.slug = video.title.parameterize
        video.save
      else
        video.delete
      end
    end
  end
  def to_param
    slug
  end
  def video_url
    return "https://www.facebook.com/MemorialUnitedMethodistChurchAustin/videos/#{self.video_id}/"
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
