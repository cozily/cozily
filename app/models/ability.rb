class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :create, Apartment
      can :read, Apartment
      can [:edit, :update, :destroy], Apartment, :user_id => user.id

      can :manage, Favorite, :user_id => user.id
    else
      can :read, Apartment
    end
  end
end
