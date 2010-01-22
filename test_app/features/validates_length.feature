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
  
  Scenario Outline: Seeing a custom error message
    Given the Article class validates length of title (<validation>) with message "must be the right length"
    When I visit "/articles/new"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    Then I should not see "Title is valid"
    And I should see "Title must be the right length"
  Examples:
    | validation   | title   | 
    | minimum: 6   | PM      | 
    | maximum: 6   | Malcolm | 
    | is: 5        | Hugh    | 
    | within: 2..5 | F       | 
    | within: 2..5 | Affairs | 
  
  Scenario Outline: Seeing a custom message depending on error type
    Given the Article class validates length of title (<validation>) with <message type> "<message template>"
    When I visit "/articles/new"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    Then I should not see "Title is valid"
    And I should see "Title <message>"
  Examples:
    | validation   | title   | message type | message template                    | message                     | 
    | minimum: 6   | PM      | too_short    | needs at least {{count}} characters | needs at least 6 characters | 
    | maximum: 6   | Malcolm | too_long     | admits no more than {{count}}       | admits no more than 6       | 
    | is: 5        | Hugh    | wrong_length | should be exactly {{count}}         | should be exactly 5         | 
    | within: 2..5 | F       | too_short    | would like {{count}} or more        | would like 2 or more        | 
    | within: 2..5 | Affairs | too_long     | can't accept more than {{count}}    | can't accept more than 5    | 

