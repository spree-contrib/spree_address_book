Deface::Override.new(
  :virtual_path => "spree/admin/shared/_address_form",
  :name => "user_id",
  :insert_bottom => "[data-hook='address_fields']",
  :text => "<%= f.hidden_field :user_id, value: @user.id if @user %>"
)
