class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, :all #for now - it should be [Closet, Cloth, Comment]
    can :update, :all, user: user #for now - it should be [Closet, Cloth, Comment]
  end

  def admin_abilities
    can :manage, :all
  end
end
