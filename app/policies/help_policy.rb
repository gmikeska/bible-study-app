class HelpPolicy < ApplicationPolicy
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
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
