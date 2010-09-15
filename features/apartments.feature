Feature: Apartments

  @javascript
  Scenario: User creates an apartment
    Given I am a logged in lister
    Then I can create an apartment

  @javascript
  Scenario: User creates a sublet
    Given I am a logged in lister
    Then I can create a sublet

  Scenario: User views an apartment
    Given I am a logged in user
    And an apartment exists with state: "listed"
    Then I can view the apartment
    When an apartment exists with state: "unlisted"
    Then I should see that the apartment is unlisted

  Scenario: User edits an apartment
    Given I am a logged in user
    And I have an apartment
    Then I can edit the apartment

  Scenario: User deletes an apartment
    Given I am a logged in user
    And I have an apartment
    Then I can delete the apartment

  Scenario: User lists an apartment
    Given I am a logged in user
    And I have an unlisted apartment
    Then I can list the apartment
    But I cannot list another user's apartment

  Scenario: User unlists an apartment
    Given I am a logged in user
    And I have an listed apartment
    Then I can unlist the apartment
    But I cannot unlist another user's apartment

  Scenario: Owner views their apartments
    Given I am a logged in user
    And I have an apartment
    Then I can view my apartments
