Feature: Businesses

  @javascript
  Scenario: User sees nearby restaurants
    Given an apartment exists with state: "published"
    Then I can view restaurants that are near the apartment