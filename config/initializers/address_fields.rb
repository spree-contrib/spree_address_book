ADDRESS_FIELDS = [
  "firstname",
  "lastname",
  "company",
  "address1",
  "address2",
  "city",
  "state",
  "zipcode",
  "country",
  "phone"
]

Spree::PermittedAttributes.address_attributes << [
  :user_id,
  :deleted_at
]
