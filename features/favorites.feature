Feature: Favorites

  @javascript
  Scenario: User favorites an apartment
    Given I am a logged in user
    And an apartment exists with state: "published"
    Then I can favorite the apartment

  @allow-rescue
  Scenario: User views their favorites
    Given I am a logged in user
    And I have favorites
    Then I can view my favorites
    But I cannot view another user's favorites
