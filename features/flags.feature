Feature: Flags

  @javascript
  Scenario: User flags an apartment
    Given I am a logged in user
    And an apartment exists with state: "listed"
    Then I can flag the apartment
