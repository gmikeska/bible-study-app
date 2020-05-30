class Course < ApplicationRecord
  has_many :lessons
  has_many :chapters
  has_one :instruction
  has_many :enrollments
  has_many :students, through: :enrollments, source: "user"
  has_many :owners, through: :students
  validates :name, presence: true
  monetize :price_cents
  after_initialize do |course|
    if(course.instruction.nil?)
    course.instruction = Instruction.new(status:"idle")
      # course.save
    end
    if(course.slug.nil? && !course.name.nil?)
      course.slug = course.name.parameterize
      # course.save
    end
    if(!course.visibility)
      course.visibility = "Private"
    end
  end
  def update(params)
    if(!params[:name].nil?)
      params[:slug] == params[:name].parameterize
    end
    if(params[:price])
      params[:price] = Money.new(params[:price], 'USD')*100
    end
    super
  end
  def to_param
    slug
  end
  def self.pending_reviews
    reviews_pending = []
    Course.all.each do |course|
      reviews_pending << course.pending_reviews
     end
     return reviews_pending.flatten
  end
  def self.count_pending_reviews
    self.pending_reviews.count
  end
  def count_pending_reviews
    pending_reviews.count
  end
  def pending_reviews
    reviews_pending = []
    enrollments.each do |enrollment|; quizzes = enrollment.quiz_responses.keys
       quizzes.each do |quiz|; assessment = enrollment.quiz_responses[quiz]
         status = enrollment.status?(quiz)
         if(status == :pending)
           reviews_pending << {enrollment:enrollment, quiz:quiz}
         end
       end
     end
     return reviews_pending
  end
  def enroll(student, chapter=nil)
    if(chapter.nil?)
      chapter = chapters.first
    end
    if(self.price.to_i > 0)
      if(student.invoices.select{|i| !i.paid?}.length == 0)
        invoice = Invoice.create(user:student.owner)
      else
        invoice = student.invoices.select{|i| !i.paid? }.last
      end
      return Enrollment.create(user:student, course:self, current_chapter:chapter, invoice:invoice)
    else
      return Enrollment.create(user:student, course:self, current_chapter:chapter)
    end

  end
  def enrolled?(student_or_parent)
    if(students.include?(student_or_parent))
      return true
    elsif(student_or_parent.isParent?)
      student_or_parent.children.each do |student|
        if(students.include?(student))
          return true
        end
      end
    end

  end
  def enrolled_students_for(user)
    result = self.students.where({parent_id:user.id})
    if(self.students.include?(user))
      result << user
    end
  end
  def online_users
    (self.students.to_ary + User.admins).select{|u| u.online == true}
  end
  def visible_to(user)
    if(visibility == "Public")
      return true
    elsif(visibility == "Enrolled")
      user_is_enrolled_and_paid = (user.present? && enrolled?(user) && Course.first.enrollments.select{|e| e.owner == user}.first.invoice.paid?)
      return((user_is_enrolled_and_paid || user.isStaff?))
    else
      return (user.present? && user.isStaff?)
    end
  end
  def self.visible_to(user)
    Course.all.select{ |c| c.visible_to(user)}
  end
end
