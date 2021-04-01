class LessonPolicy < ApplicationPolicy
  def index?
    true
  end
  def show?
    (@user.admin? || @user.superAdmin?) || (@user.student? && @record.course.enrolled?(@user))
  end
  def create?
    (@user.admin? || @user.superAdmin?)
  end
  def update?
    (@user.admin? || @user.superAdmin?)
  end
  def upload?
    @user.staff?
  end
  def destroy?
    @user.staff?
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
