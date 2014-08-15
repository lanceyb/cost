class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      can :index_materials
    else
      can :manage, :home
      can :index, Material
    end
  end
end
