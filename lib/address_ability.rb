class AddressAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Address do |address|
      address.user == user
    end
  end
end
