class CoursePolicy < ApplicationPolicy
  def index?
    true
  end
  def show?
    true
  end
  def create?
    (@user.admin? || @user.superAdmin?)
  end
  def update?
    (@user.admin? || @user.superAdmin?)
  end
  def enroll_student?
    true
  end
  def enroll?
    true
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
