Deface::Override.new(
  :virtual_path => "spree/admin/users/orders",
  :original => 'b1f8812150361580d503b9a3c3ace4e43572f010',
  :name => "link_to_order_page",
  :replace => "erb[loud]:contains('spree.new_admin_order_path')",
  :text => '<%= link_to Spree.t(:add_one), spree.new_admin_order_path(user_id: params[:id]) %>'
)
