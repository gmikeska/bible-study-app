class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  serialize :breeze_data, Hash
  validates :email, presence:true
  has_many :enrollments
  has_many :donations
  has_many :courses, through: :enrollments
  has_many :invoices, through: :enrollments
  has_many :children, class_name: "User",
                          foreign_key: "parent_id"
  belongs_to :parent, class_name: "User", optional: true
  enum role: [:student, :instructor, :admin, :superAdmin]
  scope :staff, -> { where(role: 'admin').or(where(role:"superAdmin")).or(where(role:"instructor")) }
  scope :admins, -> { where(role: 'admin').or(where(role:"superAdmin")) }
  scope :instructors, -> { where(role: 'instructor') }
  scope :students, -> { where(role: 'student') }
    after_initialize do |user|
      if(user.role.nil?)
        user.role = "student"
      end
      if(user.breeze_id.present? &&  user.breeze_data.nil?)
        user.load_breeze_data
      end
    end
    def name
      f = self.first_name || ""
      l = self.last_name || ""
      return f+" "+l
    end
    def image_url(type=nil)
      if(self.breeze_id.present?)
        if(type == :thumbnail)
          return "https://files.breezechms.com/#{self.breeze_data[:thumb_path]}"
        else
          return "https://files.breezechms.com/#{self.breeze_data[:path]}"
        end
      end
    end
    def isParent?
      return children.count > 0
    end
    def load_breeze_data
      if(self.breeze_id.present?)
        breeze_api = BreezeApi.new
        data = breeze_api.person(person_id:self.breeze_id)
        data[:last_update] = Time.now
        self.breeze_data = data
        if(self.first_name.nil? && self.breeze_data[:first_name])
          self.first_name = self.breeze_data[:first_name]
        end
        if(self.last_name.nil? && self.breeze_data[:last_name])
          self.last_name = self.breeze_data[:last_name]
        end
        self.save
      end
    end
    def isChild?
      return parent.present?
    end
    def isStudent?
      return self.student? == "student"
    end
    def isInstructor?
      return self.instructor?
    end
    def staff?
      return (self.instructor? || self.admin? || self.superAdmin?)
    end
    def isStaff?
      return (self.staff?)
    end
    def isAdmin?
      return (self.admin? || self.superAdmin?)
    end
    def isDev?
      return self.superAdmin?
    end
    def self.import(params)
      params = params.to_h.symbolize_keys
      user_by_email = User.find_by(email:params[:email])
      breeze_api = BreezeApi.new
      if(params[:breeze_id] && User.find_by(breeze_id:params[:breeze_id]).nil? && user_by_email.nil?)
        data = breeze_api.person(person_id:params[:breeze_id])
        # byebug
        params[:first_name]= data[:first_name]
        params[:last_name]= data[:last_name]
        if(data[:details]["1091623166".to_sym].first[:address] == params[:email] )
          return User.new(**params)
        end
      elsif(user_by_email.present?)
        user_by_email.breeze_id = params[:breeze_id]
        user_by_email.save
        return user_by_email
      end
    end
    def self.sync
      breeze_api = BreezeApi.new
      people = breeze_api.people
      puts "API returns #{people.length} people"
      people.each do |person|
        if(User.find_by(breeze_id:person[:id]).nil?)
          data = breeze_api.person(person_id:person[:id])
          if(data[:details].present? && data[:details]["1091623166".to_sym].present? && (data[:details]["1091623166".to_sym].length > 0) && data[:details]["1091623166".to_sym].first[:address].present?)
            User.import(
              breeze_id:person[:id],
              email:data[:details]["1091623166".to_sym].first[:address],
              password:"temp1234",
              password_confirmation:"temp1234"
            )
          end
        end
      end
    end
end
