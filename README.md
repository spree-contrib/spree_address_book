SpreeAddressBook
================

This extension allows users select `bill_address` and `ship_address` from addresses, which was already entered by current user.


TODO
====

* Write test to ensure that `states.js` is working correctly
* The label used on the `:alternative_phone` field is different from the label used in the default spree form.
  This is because the `t('activerecord.attributes.address.alterative_phone')` is being used instead of `t(:alternative_phone)`

Installation
============

      Add `gem "spree_address_book", :git => "git://github.com/romul/spree_address_book.git"
      Run `bundle install`
      Run `rails g spree_address_book:install`


Copyright (c) 2011-2012 Roman Smirnov, released under the New BSD License
