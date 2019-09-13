## ⚠️ Deprecation notice ⚠️

Since Spree 4.0 this extension is deprecated and not needed. Address Book was [merged into Spree core in Spree 4.0](https://guides.spreecommerce.org/release_notes/4_0_0.html#address-book-support). 

# Spree Address Book

[![Build Status](https://travis-ci.org/spree-contrib/spree_address_book.svg?branch=master)](https://travis-ci.org/spree-contrib/spree_address_book) [![Code Climate](https://codeclimate.com/github/spree-contrib/spree_address_book/badges/gpa.svg)](https://codeclimate.com/github/spree-contrib/spree_address_book)

This extension allows registered users to have multiple shipping & billing addresses and select each of them on checkout.

## Installation

1. Add this extension to your Gemfile with this line:

  #### Spree >= 3.1

  ```ruby
  gem 'spree_address_book', github: 'spree-contrib/spree_address_book'
  ```

  #### Spree 3.0 and Spree 2.x

  ```ruby
  gem 'spree_address_book', github: 'spree-contrib/spree_address_book', branch: 'X-X-stable'
  ```

  The `branch` option is important: it must match the version of Spree you're using.
  For example, use `3-0-stable` if you're using Spree `3-0-stable` or any `3.0.x` version.

2. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

3. Copy & run migrations
  ```ruby
  bundle exec rails g spree_address_book:install
  ```

4. Restart your server

  If your server was running, restart it so that it can find the assets properly.


## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

## License

Copyright (c) 2011-2016 Roman Smirnov & [contributors](https://github.com/spree-contrib/spree_address_book/graphs/contributors), released under the New BSD License
