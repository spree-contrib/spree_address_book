module Spree::AddressesHelper
  def address_field(form, method, id_prefix = "b", &handler)
    id_prefix = id_prefix == 'bill_address' ? 'b' : 's'
    content_tag :p, :id => [id_prefix, method].join, :class => "field" do
      if handler
        handler.call
      else
        is_required = Spree::Address.required_fields.include?(method)
        separator = is_required ? '<span class="req">*</span><br />' : '<br />'
        form.label(method) + separator.html_safe +
        form.text_field(method, :class => is_required ? 'required' : nil)
      end
    end
  end
end
