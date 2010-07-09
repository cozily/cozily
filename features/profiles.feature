Feature: Profiles
  Scenario: User creates a profile
    Given I am a logged in user
    And an apartment exists with state: "listed"
    Then I can create a profile