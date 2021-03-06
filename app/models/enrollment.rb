class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user
  belongs_to :invoice, optional:true
  belongs_to :current_chapter, class_name:"Chapter", optional:true
  serialize :quiz_responses, Hash
  # has_many :completed_chapters, class_name:"Chapter"
  after_initialize do |enrollment|
    if(enrollment.current_chapter.nil? && enrollment.course.chapters.length > 0)
      enrollment.current_chapter = enrollment.course.chapters.first
      enrollment.save
    end
  end
  def completed?(quiz)
    return quiz_responses[quiz].present?
  end
  def price
    return course.price
  end
  def paid?
    return self.invoice.paid?
  end
  def status?(quiz)
    if(quiz_responses[quiz].present? && quiz_responses[quiz][:answers].length < quiz.questions.length)
      return :in_progress
    elsif(quiz_responses[quiz].present? && quiz_responses[quiz][:answers].length == quiz.questions.length)
      if(quiz_responses[quiz][:results].include?(:pending))
        return :pending
      else
        return :complete
      end
    elsif(quiz_responses[quiz].nil?)
      return :in_progress
    end
  end
  def has_pending_quizzes?
    statuses = self.quiz_responses.keys.collect{|k| return status?(k) }.uniq
    if(statuses.include?(:pending))
      return true
    else
      return false
    end
  end
end
