Feature: Client-side format validation
  
  Scenario Outline: Validating value against a regex
    Given the Article class validates format of title using <pattern>
    When I visit "/articles/new"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    Then I should <see success>
    And I should <see failure>
  Examples:
    | pattern | title | see success              | see failure                | 
    | /foo/   | food  | see "Title is valid"     | not see "Title is invalid" | 
    | /foo/   | Food  | not see "Title is valid" | see "Title is invalid"     | 
    | /foo/i  | Food  | see "Title is valid"     | not see "Title is invalid" | 
    | /foo/i  | bar   | not see "Title is valid" | see "Title is invalid"     | 
  
  Scenario: Seeing a custom error message
    Given the Article class validates format of title using /foo/ with message "should contain foo!"
    When I visit "/articles/new"
    And I fill in "Title" with "Food"
    And I focus the "Save" button
    Then I should see "Title should contain foo!"
  
  Scenario: Don't see error message when creating a new article
    Given the Article class validates format of title on update using /foo/
    When I visit "/articles/new"
    And I fill in "Title" with "Food"
    And I focus the "Save" button
    Then I should not see "Title is invalid"
  
  Scenario Outline: Handling blank values as titles
    Given the Article class validates format of title using /foo/ with allow_blank <allow blank>
    When I visit "/articles/new"
    And I focus the "Title" field
    And I focus the "Save" button
    Then I should <see success>
    And I should <see failure>
  Examples:
 | allow blank | see success              | see failure                | 
 | true        | see "Title is valid"     | not see "Title is invalid" | 
 | false       | not see "Title is valid" | see "Title is invalid"     | 

