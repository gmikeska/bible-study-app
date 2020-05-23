class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence:true
  has_many :courses
  has_many :enrollments
  has_many :invoices, through: :enrollments
  has_many :children, class_name: "User",
                          foreign_key: "parent_id"
  belongs_to :parent, class_name: "User", optional: true
  scope :admins, -> { where(user_type: 'admin') }
  scope :instructors, -> { where(user_type: 'instructor') }
  scope :students, -> { where(user_type: 'student') }
    after_initialize do |user|
      if(user.user_type.nil?)
        user.user_type = "student"
      end
    end
    def type
      user_type
    end

    def type=(typestr)
      if(typestr == "admin" || typestr == "instructor" || typestr == "student")
        user_type = typestr
      end
    end
    def isStudent?
      return user_type == "student"
    end
    def isInstructor?
      return (user_type == "instructor")
    end
    def isStaff?
      return (user_type == "instructor" || user_type == "admin")
    end
    def isAdmin?
      return user_type == "admin"
    end
end
