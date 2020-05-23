class Lesson < ApplicationRecord
  belongs_to :course
  belongs_to :chapter, optional:true
  has_many_attached :files
  after_save :set_filename
  has_one :quiz, required:false
  serialize :slides, Array


  def set_filename
    if(self.files.count > 0 && Rails.env != "test")
      self.files.each do |file|
        if(file.filename.extension == "mp4")
          file.blob.update(filename: "#{file.filename.base.parameterize}.#{file.filename.extension}")
        end
      end
    end
  end
  # after_commit :get_content_from_document

  def self.import(params,course)
    lesson = course.lessons.create(name:params[:name],description:params[:description])
    if(Rails.env != "test")
      lesson.slug = params[:name].parameterize
    end
    lesson.get_content_from_document(params[:import])
    lesson.save
    return lesson
  end
  after_initialize do |lesson|
    if(!lesson.slug && !lesson.name.nil?)
      lesson.slug = lesson.name.parameterize
    end
    if(!lesson.visibility)
      lesson.visibility = "Private"
    end
    if(!lesson.quiz)
      lesson.quiz = Quiz.create(questions:[])
    end
  end
  def to_param
    slug
  end
  def get_content_from_document(document)
    contents = []
    self.upload(document)
    self.save
    if(self.files.count > 0 && ["docx","doc"].include?(self.files.first.filename.to_s.split('.').last))
      self.files.first.blob.open do |file|
        doc = Docx::Document.open(file)
        # Retrieve and display paragraphs
        doc.paragraphs.each do |p|
          contents << p.to_html
        end
      end
    self.content = contents.join('')
    self.save
    end
  end
  def update(params)
    if(params[:upload])
      files.attach(params[:upload])
      params.delete(:upload)
    end
    if(params[:chapter] != "none" )
      params[:chapter] = Chapter.find_by slug:params[:chapter]
    else
      params[:chapter] = nil
    end
    super(params)
  end
  def upload(file)
    files.attach(file)
  end
  def get_file(filename)
    files.select{|f| f.filename.to_s == filename}.first
  end
  def preview(file)
    file.preview(resize_to_limit: [100, 100])
  end
  def add_slide(slide_params)
    self.slides << slide_params
  end
  def update_slide(slide_params,index)
    self.slides[index] == slide_params
  end
  def visible_to(user)
    if(visibility == "Public")
      return true
    elsif(visibility == "Enrolled")
      return(user.present? && (user.courses.include?(self.course) || user.isStaff?))
    else
      return (user.isStaff?)
    end
  end
  def self.params
    data = self.columns.collect{|c| c.name.to_sym }
    return data
  end
end
