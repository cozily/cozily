Feature: Favorites

  Scenario: User favorites an apartment
    Given I am logged in user
    And an apartment exists
    Then I can favorite the apartment