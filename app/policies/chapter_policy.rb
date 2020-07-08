class ChapterPolicy < ApplicationPolicy
  def index?
    true
  end
  def show?
    (@user.admin? || @user.superAdmin?) || (@user.student? && @lesson.course.enrolled?(@user))
  end
  def create?
    (@user.admin? || @user.superAdmin?)
  end
  def update?
    (@user.admin? || @user.superAdmin?)
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
