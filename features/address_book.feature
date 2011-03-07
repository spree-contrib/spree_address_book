Feature: Address Book

  @selenium @wip @stop
  Scenario: User fill new address
    Given an order from registered user "email@person.com/password", who has 0 addresses, at address step
    When I fill billing address with correct data
    And check "order_use_billing"
    And press "Save and Continue"
    Then user "email@person.com" should have 1 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"
    
  @selenium @wip @stop
  Scenario: User select address
    Given an order from registered user "email@person.com/password", who has 1 addresses, at address step
    When I choose "order_bill_address_id_1"
    And I choose "order_ship_address_id_1"
    And press "Save and Continue"
    Then user "email@person.com" should have 1 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"

  @selenium @wip @stop
  Scenario: User select address
    Given an order from registered user "email@person.com/password", who has 1 addresses, at address step
    When I choose "order_bill_address_id_1"
    And check "order_use_billing"
    And press "Save and Continue"
    Then user "email@person.com" should have 1 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"

  @selenium @wip @stop
  Scenario: User select address
    Given an order from registered user "email@person.com/password", who has 1 addresses, at address step
    When I choose "order_bill_address_id_0"
    And I fill billing address with correct data
    And I choose "order_ship_address_id_0"
    And I fill shipping address with correct data
    And press "Save and Continue"
    Then user "email@person.com" should have 2 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"    

  @selenium @wip @stop
  Scenario: User select address
    Given an order from registered user "email@person.com/password", who has 1 addresses, at address step
    When I choose "order_bill_address_id_0"
    And I fill billing address with correct data
    And I check "order_use_billing"
    And press "Save and Continue"
    Then user "email@person.com" should have 2 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"
    
  @selenium @wip @stop
  Scenario: User can edit address, if it was not used by another order
    Given an order from registered user "email@person.com/password", who has 1 addresses, at address step
    When I choose "order_bill_address_id_1"
    And I choose "order_ship_address_id_1"
    And press "Save and Continue"
    Then user "email@person.com" should have 1 address
    When I follow "Address"
    Then I should see "10 Lovely Street Northwest"
    When I choose "order_bill_address_id_0"
    And fill in "order_bill_address_attributes_zipcode" with "125000"
    And press "Save and Continue"
    Then user "email@person.com" should have 2 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"
