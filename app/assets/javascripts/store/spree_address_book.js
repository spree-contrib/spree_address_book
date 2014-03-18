(function ($) {
    $(document).ready(function () {
        var order_use_billing_ = $('input#order_use_billing');
        var select_addresses_ = $("#shipping .select_address");
        if ($(".select_address").length) {
            order_use_billing_.unbind("click");
            $(".inner").hide();
            $(".inner input").prop("disabled", true);
            $(".inner select").prop("disabled", true);
            if (order_use_billing_.is(':checked')) {
                select_addresses_.hide();
            }

            order_use_billing_.click(function () {
                if ($(this).is(':checked')) {
                    select_addresses_.hide();
                    hide_address_form('shipping');
                } else {
                    select_addresses_.show();
                    if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
                        show_address_form('shipping');
                    }
                }
            });

            $("input[name='order[bill_address_id]']:radio").change(function () {
                if ($("input[name='order[bill_address_id]']:checked").val() == '0') {
                    show_address_form('billing');
                } else {
                    hide_address_form('billing');
                }
            });

            $("input[name='order[ship_address_id]']:radio").change(function () {
                if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
                    show_address_form('shipping');
                } else {
                    hide_address_form('shipping');
                }
            });
        }
        else {
            order_use_billing_.click(function () {
                order_use_billing($(this));
            });
            order_use_billing(order_use_billing_);
        }
    });

    function order_use_billing(el) {
        if (el.is(':checked')) {
            hide_address_form('shipping');
        } else {
            show_address_form('shipping');
        }
    }


    function hide_address_form(address_type) {
        $("#" + address_type + " .inner").hide();
        $("#" + address_type + " .inner input").prop("disabled", true);
        $("#" + address_type + " .inner select").prop("disabled", true);
    }

    function show_address_form(address_type) {
        $("#" + address_type + " .inner").show();
        $("#" + address_type + " .inner input").prop("disabled", false);
        $("#" + address_type + " .inner select").prop("disabled", false);
    }
})(jQuery);
