class Gallery < ApplicationRecord
  has_many_attached :files

  def upload(params)
    if(params[:files])
      files.attach(params[:files])
    end
  end

  def get_url(file)
    # files = self.files.select {|f| f.filename == filename }
    return Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end
  def url_for(file)
    if(is_video(file))
      return "/galleries/#{self.id}/videos/#{file.id}"
    elsif(is_image(file))
      return "/galleries/#{self.id}/#{file.filename}"
    else
      # files = self.files.select {|f| f.filename == filename }
      return Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end
  end

  def video_extensions
    return ["mp4"]
  end

  def image_extensions
    return ["jpg","jpeg","png"]
  end

  def is_video(file)
    return video_extensions.include?(file.filename.to_s.split('.')[1])
  end

  def is_image(file)
    return image_extensions.include?(file.filename.to_s.split('.')[1])
  end

  def include?(filename)
    files = self.files.select {|f| f.filename == filename }
    return (files.length > 0)
  end

  def filenames
    data = []
    files = self.files.each {|file| data << file.filename }
    return data
  end

  def get_document(attachment)
    contents = []
    attachment.blob.open do |file|
      doc = Docx::Document.open(file)
      # Retrieve and display paragraphs
      doc.paragraphs.each do |p|
        contents << p.to_html
      end
    end
    return contents
  end
end
