Feature: Messages

  Scenario: Non-owner messages an owner
    Given I am a logged in user
    And an apartment exists with state: "published"
    Then I can message the owner
