Feature: Activity Feed

  Scenario: User views activity feed
    Given I am a logged in user
    Then my activity feed should include apartments that were recently listed