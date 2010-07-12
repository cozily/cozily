class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :create, Apartment
      can :read, Apartment
      can [:edit, :order_images, :destroy, :transition, :update], Apartment, :user_id => user.id

      can :manage, Favorite, :user_id => user.id
      can :manage, Message
      can :manage, User, :id => user.id
    else
      can :read, Apartment
    end
  end
end
