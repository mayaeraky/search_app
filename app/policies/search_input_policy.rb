class SearchInputPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
   true
  end

  def show?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: @current_user.id)
    end
  end
end