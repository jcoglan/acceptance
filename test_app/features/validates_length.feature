Feature: Client-side length validation
  
  Scenario Outline: Validating length of title
    Given the Article class validates length of title (<validation>)
    When I visit "/articles/new"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    Then I should <see success>
    And I should <see failure>
  Examples:
    | validation   | title   | see success              | see failure                                                    | 
    | minimum: 6   | PM      | not see "Title is valid" | see "Title is too short \(minimum is 6 characters\)"           | 
    | minimum: 6   | Social  | see "Title is valid"     | not see "Title is too short \(minimum is 6 characters\)"       | 
    | maximum: 6   | Malcolm | not see "Title is valid" | see "Title is too long \(maximum is 6 characters\)"            | 
    | maximum: 6   | Tucker  | see "Title is valid"     | not see "Title is too long \(maximum is 6 characters\)"        | 
    | is: 5        | Hugh    | not see "Title is valid" | see "Title is the wrong length \(should be 5 characters\)"     | 
    | is: 5        | Ollie   | see "Title is valid"     | not see "Title is the wrong length \(should be 5 characters\)" | 
    | within: 2..5 | Hugh    | see "Title is valid"     | not see "Title is too short"                                   | 
    | within: 2..5 | F       | not see "Title is valid" | see "Title is too short \(minimum is 2 characters\)"           | 
    | within: 2..5 | Affairs | not see "Title is valid" | see "Title is too long \(maximum is 5 characters\)"            | 

