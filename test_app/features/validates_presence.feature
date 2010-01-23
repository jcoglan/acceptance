Feature: Client-side presence validation
  
  Scenario: Filling in valid data
    Given the Article class validates presence of title
    When I visit "/articles/new"
    And I fill in "Title" with "75 Essential Ways to Turbocharge your So-Called Design Magazine"
    And I focus the "Save" button
    Then I should see "Title is valid"
    And I should not see "Title can't be blank"
  
  Scenario: Leaving out a required field
    Given the Article class validates presence of title
    When I visit "/articles/new"
    And I focus the "Title" field
    And I focus the "Save" button
    Then I should see "Title can't be blank"
    And I should not see "Title is valid"
  
  Scenario: Seeing a custom error message
    Given the Article class validates presence of title with message "should be filled in"
    When I visit "/articles/new"
    And I focus the "Title" field
    And I focus the "Save" button
    Then I should see "Title should be filled in"
    And I should not see "Title is valid"
  
  Scenario: Don't validate exising articles
    Given there is an Article
    And the Article class validates presence of title on create
    When I visit "/articles/1/edit"
    And I focus the "Title" field
    And I focus the "Save" button
    Then I should not see "Title can't be blank"

