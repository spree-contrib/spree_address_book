class UspsAddressValidator < ActiveModel::Validator
  def validate(record)
    begin
      return if record.country.iso != 'US'
      state = record.state ? record.state.abbr : record.state_name
      USPSStandardizer.lookup_for(:address => record.address1, :state => state, :city => record.city, :zipcode => record.zipcode)
    rescue USPSStandardizer::Error => ex
      record.errors.add(:base, ex.message)
    rescue Exception # ex. USPS isn't available
    end
  end
end
