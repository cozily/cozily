Feature: Businesses

  @javascript
  Scenario: User sees nearby restaurants
    Given I am a logged in user
    And an apartment exists with state: "published"
    Then I can view restaurants that are near the apartment
