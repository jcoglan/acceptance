Feature: Client-side acceptance validation
  
  Scenario: See default error message
    Given the Article class validates acceptance of terms
    When I visit "/"
    And I focus the check box "Terms"
    And I focus the button "Save"
    Then I should see "Terms must be accepted"
  
  Scenario: Enter required data
    Given the Article class validates acceptance of terms
    When I visit "/"
    And I check "Terms"
    And I focus the button "Save"
    Then I should not see "Terms must be accepted"
  
  Scenario: Without validation
    When I visit "/"
    And I focus the check box "Terms"
    And I focus the button "Save"
    Then I should not see "Terms must be accepted"

