Feature: User authentication
  In order to track my performance playing GoFish
  As a new player
  I want to register is a user

  @javascript
  Scenario: New user registration
    Given I try to login
    When I register as a new user
    Then I see my user page

  @javascript
  Scenario: Non-existing user login
    Given I am on the welcome page
    When I login
    Then I see an invalid login message

  @javascript
  Scenario: Existing user login
    Given an existing user
    And I am on the welcome page
    When I login
    Then I see my user page
