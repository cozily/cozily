Feature: Activity Feed

  Scenario: User views activity feed
    Given I am a logged in user
    Then my activity feed should include apartments that were recently published
    And my activity feed should include apartments that I flagged
    And my activity feed should include apartments that I unflagged
    And my activity feed should include apartments that I favorited
    And my activity feed should include apartments that I unfavorited