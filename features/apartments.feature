Feature: Apartments

  Scenario: User creates an apartment
    Given I am a logged in user
    Then I can create an apartment

  Scenario: User views an apartment
    Given an apartment exists
    Then I can view the apartment

  Scenario: User edits an apartment
    Given an apartment exists
    Then I can edit the apartment

  Scenario: User deletes an apartment
    Given an apartment exists
    Then I can delete the apartment
