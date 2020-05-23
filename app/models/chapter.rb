class Chapter < ApplicationRecord
  belongs_to :course
  has_many :lessons
  has_many :quizzes, through: :lessons

  after_initialize do |chapter|
    if(!chapter.slug && !chapter.name.nil?)
      chapter.slug = chapter.name.parameterize
    end
  end
  def to_param
    slug
  end
end
