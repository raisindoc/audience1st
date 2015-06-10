@stubs_successful_credit_card_payment
Feature: refund an order

  As a boxoffice manager
  Because customers sometimes can't make the show and I want them to be happy
  I want to cancel and refund an order placed with a credit card

Background: customer has placed a credit card order

  Given an order for customer "Tom Foolery" paid with "credit card" containing:
  | show    | qty | type    | price | showdate             |
  | Chicago |   3 | General |  7.00 | May 15, 2010, 8:00pm |
  And I am logged in as boxoffice
  And I am on the orders page for customer "Tom Foolery"

@stubs_successful_refund
Scenario: refund credit card order

  When I refund that order
  Then I should be on the home page for customer "Tom Foolery"
  And I should see "Credit card refund of $21.00 successfully processed."

@stubs_failed_refund
Scenario: cannot refund credit card order

  When I refund that order
  Then I should see "Could not process credit card refund"

  
