class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    user ||= User.new

    can :manage, Subject if user.admin?

    can :manage, User do |another_user|
      user.admin? || (user.teacher? && another_user.student?) || user == another_user
    end

    if user.teacher?
      can :manage, MarkSystem
      can :manage, Question
      can :manage, Group
      can :manage, Toast
      can :manage, Result
    end

    can :menu, [:toasts, :groups, :users, :mark_systems, :results, :invite] if user.teacher? || user.admin?
    can :menu, :my_results if user.student?
    can :menu, :subjects if user.admin?

    can :invite, Symbol do |role|
      case role
      when :admin then user.admin?
      when :teacher then user.admin? || user.teacher?
      when :student then user.admin? || user.teacher?
      end
    end
  end
end
