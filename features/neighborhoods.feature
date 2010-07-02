Feature: Neighborhoods

  Scenario: User views apartments by neighborhood
    Given I am on the homepage
    And an apartment exists with state: "listed"
    Then I can view the apartment by its neighborhood
