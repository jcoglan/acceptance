Feature: Client-side acceptance validation
  
  Scenario: Enter required data
    Given the Article class validates acceptance of terms
    When I visit "/articles/new"
    And I check "Terms"
    And I focus the button "Save"
    Then I should not see "Terms must be accepted"
  
  Scenario: See default error message
    Given the Article class validates acceptance of terms
    When I visit "/articles/new"
    And I focus the check box "Terms"
    And I focus the button "Save"
    Then I should see "Terms must be accepted"
  
  Scenario: Skip the required field
    Given the Article class validates acceptance of terms
    When I visit "/articles/new"
    And I focus the button "Save"
    Then I should not see "Terms must be accepted"
  
  Scenario: Don't see error message for new objects
    Given the Article class validates acceptance of terms on update
    When I visit "/articles/new"
    And I focus the check box "Terms"
    And I focus the button "Save"
    Then I should not see "Terms must be accepted"
  
  Scenario: See a custom error message
    Given the Article class validates acceptance of terms with message "must be checked, please"
    When I visit "/articles/new"
    And I focus the check box "Terms"
    And I focus the button "Save"
    Then I should see "Terms must be checked, please"
  
  Scenario: Without validation
    When I visit "/articles/new"
    And I focus the check box "Terms"
    And I focus the button "Save"
    Then I should not see "Terms must be accepted"

