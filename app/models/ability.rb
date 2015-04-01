class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.is_admin?
      can :manage, :all
    else
      can [:create, :destroy], [Favorite, Like, Request], user_id: user.id
      can :manage, Relationship, follower_id: user.id
      can :manage, [BookState, Comment, Review], user_id: user.id
      can :manage, User, id: user.id
    end
  end
end