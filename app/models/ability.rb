class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :manage, Apartment
      can :manage, Favorite, :user_id => user.id
    else
      can :read, Apartment
    end
  end
end
