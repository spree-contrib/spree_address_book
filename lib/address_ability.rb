class AddressAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Spree::Address do |address|
      address.user == user || address.id.nil?
    end
  end
end
