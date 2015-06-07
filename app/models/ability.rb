class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    user ||= User.new

    can :manage, Subject if user.admin?

    can [:edit, :update], User do |another_user|
      user.admin? || user == another_user
    end

    if user.teacher? || user.admin?
      can :manage, MarkSystem
      can :manage, Question
      can :manage, Group
      can :manage, Toast do |toast|
        user.admin? || user.subject_ids.include?(toast.subject_id) || toast.new_record?
      end
      can :manage, Result
      can :manage, User do |another_user|
        another_user.student?
      end
    end

    if user.student?
      can :show, Toast do |toast|
        !(toast.group_ids & user.group_ids).empty?
      end
      can [:results, :change_locale], User
    end

    can :main, User

    can :menu, :invite if user.teacher? || user.admin?
    can :menu, :my_results if user.student?

    can :invite, Symbol do |role|
      case role
      when :admin then user.admin?
      when :teacher then user.admin? || user.teacher?
      when :student then user.admin? || user.teacher?
      end
    end
  end
end
