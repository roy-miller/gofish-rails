Feature: User rankings
  In order to see how my peformance compares to other users
  As a GoFish player
  I want to see my wins and losses and my relative rank

  @javascript
  Scenario: I view my performance and ranking
    Given a set of completed matches
    When I view my performance
    Then I see my wins and losses
    And I see my ranking
