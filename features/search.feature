Feature: Search

  Scenario: User searches for an apartment by number of bedrooms
    Given there are searchable apartments
    Then searching for apartments yields the correct results