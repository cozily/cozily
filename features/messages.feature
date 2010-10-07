@javascript
Feature: Messages
  Scenario: Non-owner messages an owner
    Given I am a logged in user
    And an apartment exists with state: "published"
    Then I can message the owner

  Scenario: User views their inbox
    Given I am a logged in user
    Then I can view my inbox

  Scenario: User views replies to a message
    Given I am a logged in user
    Then I can view replies to a message

  Scenario: User replies to a message
    Given I am a logged in user
    Then I can reply to a message

  Scenario: User can delete a conversation
    Given I am a logged in user
    Then I can delete a conversation

  Scenario: User replies to a deleted conversation
    Given I am a logged in user
    Then I can reply to a deleted conversation

  Scenario: User messages from the dashboard
    Given I am a logged in user
    Then I can message from the dashboard
