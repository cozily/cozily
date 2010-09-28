class Ability
  include CanCan::Ability

  def initialize(user)
    if user.try(:admin?)
      can :manage, :all
    elsif user.present?
      can [:new, :create, :read], Apartment
      can [:edit, :order_images, :destroy, :transition, :update], Apartment, :user_id => user.id
      can [:create, :destroy], Favorite, :user_id => user.id
      can [:create, :destroy], Flag, :user_id => user.id
      can :manage, Message
      can :manage, User, :id => user.id
      can :manage, Profile, :id => user.id
    else
      can :read, Apartment
      can :create, User
    end
  end
end
