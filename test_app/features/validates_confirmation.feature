Feature: Client-side confirmation validation
  
  Scenario: Entering valid information
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "something"
    And I focus the "Save" button
    Then I should not see "Password does not match confirmation"
    And I should see "Password confirmation is valid"
  
  Scenario: Failing to confirm password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "nothing"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Seeing a custom error message
    Given the Article class validates confirmation of password with message "must be confirmed"
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "nothing"
    And I focus the "Save" button
    Then I should see "Password must be confirmed"
  
  Scenario: Don't see error message when editing an article
    Given there is an Article
    And the Article class validates confirmation of password on create
    When I visit "/articles/1/edit"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "nothing"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Entering valid information then changing the password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "something"
    And I fill in "Password" with "changed"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Entering the confirmation but not the password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password confirmation" with "something"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Entering confirmation before password, then entering a different password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password confirmation" with "something"
    And I fill in "Password" with "nothing"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Entering confirmation before password, then entering a matching password
    Given the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password confirmation" with "something"
    And I fill in "Password" with "something"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
    And I should see "Password confirmation is valid"
  
  Scenario: Entering an invalid password and failing to confirm it
    Given the Article class validates length of password with minimum 3
    And the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "me"
    And I fill in "Password confirmation" with "too"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Failing to confirm a valid password then entering an invalid password
    Given the Article class validates length of password with minimum 3
    And the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "something"
    And I fill in "Password confirmation" with "nothing"
    And I fill in "Password" with "Hi"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Confirming an invalid password then entering a valid password
    Given the Article class validates length of password with minimum 3
    And the Article class validates confirmation of password
    When I visit "/articles/new"
    And I fill in "Password" with "oh"
    And I fill in "Password confirmation" with "oh"
    And I fill in "Password" with "this-is-valid"
    And I focus the "Save" button
    Then I should see "Password doesn't match confirmation"
    And I should not see "Password confirmation is valid"
  
  Scenario: Form with no confirmation field
    Given the Article class validates confirmation of title
    When I visit "/articles/new"
    And I fill in "Title" with "Funky JavaScript"
    And I focus the "Save" button
    Then I should not see "Password doesn't match confirmation"

