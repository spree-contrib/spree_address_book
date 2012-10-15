class Spree::AddressAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Spree::Address do |address|
      address.user == user
    end

    can :create, Spree::Address do |address|
      user.id.present?
    end
  end
end
