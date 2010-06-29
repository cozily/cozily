Feature: Messages

  @javascript
  Scenario: Non-owner messages an owner
    Given I am a logged in user
    And an apartment exists with state: "published"
    Then I can message the owner

  Scenario: User views their inbox
    Given I am a logged in user
    Then I can view my inbox