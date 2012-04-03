class Spree::AddressAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Spree::Address do |address|
      address.user == user
    end
  end
end
