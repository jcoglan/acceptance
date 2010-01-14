Feature: Client-side confirmation validation
  
  Scenario: Entering valid information
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "something"
    And I focus the "Save" button
    Then I should not see "Password does not match confirmation"
  
  Scenario: Failing to confirm password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "nothing"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
  
  Scenario: Entering valid information then changing the password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "something"
    And I fill in "Password" with "changed"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
  
  Scenario: Filling the confirmation but not the password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password confirmation" with "something"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
  
  Scenario: Filling confirmation before password, then filling a different password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password confirmation" with "something"
    And I fill in "Password" with "nothing"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
  
  Scenario: Filling confirmation before password, then filling a matching password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password confirmation" with "something"
    And I fill in "Password" with "something"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
  
  Scenario: Filling an invalid password and failing to confirm it
    Given the Article class validates length of password with minimum 3
    And the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "me"
    And I fill in "Password confirmation" with "too"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
  
  Scenario: Form with no confirmation field
    Given the Article class validates confirmation of title
    When I visit "/articles/new"
    And I fill in "Title" with "Funky JavaScript"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"

