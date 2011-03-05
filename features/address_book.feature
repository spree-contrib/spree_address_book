Feature: Address Book

  @selenium
  Scenario: User fill new address
    Given an order from registered user "email@person.com/password" at address step
    When I fill billing address with correct data
    And  I fill shipping address with correct data
    And press "Save and Continue"
    Then user "email@person.com" should have 1 address
    When I choose "UPS Ground" as shipping method and "Check" as payment method
    Then I should see "Your order has been processed successfully"
    
