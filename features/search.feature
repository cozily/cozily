Feature: Search

  Background:
    Given I am a logged in user
    And there are searchable apartments

  @javascript
  Scenario: User searches for an apartment without parameters
    Then I can search for apartments without parameters

  @javascript
  Scenario: User searches for an apartment with parameters
    Then I can search for apartments with parameters