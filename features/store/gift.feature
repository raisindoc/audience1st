Feature: Gift checkout

  As a patron
  So that I can gift tickets
  I want to checkout with gift tickets

Background:
  Given customer "Tom Foolery" exists with email "joe3@yahoo.com"
  And I am logged in as customer "Tom Foolery"
  And my gift order contains the following tickets:
    | show    | qty | type    | price | showdate             |
    | Chicago |   2 | General |  7.00 | May 15, 2010, 8:00pm |
  And the following customers exist:
    | first_name | last_name | email           | created_by_admin | street        | password | password_confirmation | city | state |   zip | last_login          | updated_at | 
    | John       | Lennon    | john@lennon.com | false            | Imagine St.   | imagine  | imagine               | Berk | CA    | 99999 | 2009-01-01          | 2009-01-01 |       
  And I go to the store page


Scenario: unsuccessful gift order for customer gifting to themself
  Given I go to the shipping info page for customer "Tom Foolery"
  When I fill in the ".billing_info" fields with "Al Smith, 123 Fake St., Alameda, CA 94501, 510-999-9999, joe3@yahoo.com"
  And I proceed to checkout
  Then I should be on the shipping info page
  And I should see "Please enter a gift recipient email different from your own"
