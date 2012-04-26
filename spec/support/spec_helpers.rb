require 'spec_helper'

module SpecHelpers
  def javascript(driver, &block)
    Capybara.current_driver = driver
    yield
    ensure
      Capybara.use_default_driver
  end
end
