Feature: Apartments

  @allow-rescue
  Scenario: User creates an apartment
    Given I am a logged in user
    Then I can create an apartment
    When I am not a logged in user
    Then I cannot create an apartment

  Scenario: User views an apartment
    Given an apartment exists
    Then I can view the apartment

  @allow-rescue
  Scenario: User edits an apartment
    Given I am a logged in user
    And I have an apartment
    Then I can edit the apartment
    But I cannot edit another user's apartment

  Scenario: User deletes an apartment
    Given I am a logged in user
    And I have an apartment
    Then I can delete the apartment

  Scenario: User publishes an apartment
    Given I am a logged in user
    And I have an unpublished apartment
    Then I can publish the apartment

  Scenario: User unpublishes an apartment
    Given I am a logged in user
    And I have an published apartment
    Then I can unpublish the apartment
