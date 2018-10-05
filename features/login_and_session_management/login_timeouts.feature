Feature: timeouts forcing re-authentication
  
  As a box office manager
  So that customers aren't confused about whether they're logged in
  I want sessions to time out unless the user selects 'Remember

Background:

  Given it is currently 1:00pm, January 1, 2017
  And customer "Tom Foolery" exists
  And I am on the login page

Scenario: no timeout when "remember me" is used

  When I check "remember_me"
  And I login with the correct credentials for customer "Tom Foolery"
  And I abandon the site for 1 day
  And I visit the home page for customer "Tom Foolery"
  Then customer "Tom Foolery" should be logged in

Scenario: timeout when "remember me" is used but >30 days elapsed

  When I check "remember_me"
  And I login with the correct credentials for customer "Tom Foolery"
  And I abandon the site for 31 days
  And I visit the home page for customer "Tom Foolery"
  Then I should see "Please log in"

Scenario: timeout when "remember me" is not used

  When I uncheck "remember_me"
  When I login with the correct credentials for customer "Tom Foolery"
  And I abandon the site for 120 minutes
  And I visit the home page for customer "Tom Foolery"
  Then I should see "Please log in"
