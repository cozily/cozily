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
    And an apartment exists with state: "published"
    Then I can view the apartment
    When an apartment exists with state: "unpublished"
    Then I should see that the apartment is unpublished

  Scenario: User edits an apartment
    Given I am a logged in user
    And I have an apartment
    Then I can edit the apartment

  Scenario: User deletes an apartment
    Given I am a logged in user
    And I have an apartment
    Then I can delete the apartment

  Scenario: User publishes an apartment
    Given I am a logged in user
    And I have an unpublished apartment
    Then I can publish the apartment
    But I cannot publish another user's apartment

  Scenario: User unpublishes an apartment
    Given I am a logged in user
    And I have an published apartment
    Then I can unpublish the apartment
    But I cannot unpublish another user's apartment

  Scenario: Owner views their apartments
    Given I am a logged in user
    And I have an apartment
    Then I can view my apartments
