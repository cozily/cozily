Feature: Unauthenticated

  Scenario: User can sign in on the homepage
    Given I am an unauthenticated user
    Then I can sign in on the homepage