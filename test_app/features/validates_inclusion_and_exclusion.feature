Feature: Client-side inclusion and exclusion validation
  
  Scenario Outline: Validating value against a list
    Given the Article class validates <type> of title in <values>
    When I visit "/articles/new"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    Then I should <see success>
    And I should <see failure>
  Examples:
    | type      | values                | title | see success              | see failure                                 | 
    | inclusion | "Thom", "Jonny", "Ed" | Ed    | see "Title is valid"     | not see "Title is not included in the list" | 
    | inclusion | "Thom", "Jonny", "Ed" | Colin | not see "Title is valid" | see "Title is not included in the list"     | 
    | exclusion | "Thom", "Jonny", "Ed" | Phil  | see "Title is valid"     | not see "Title is reserved"                 | 
    | exclusion | "Thom", "Jonny", "Ed" | Thom  | not see "Title is valid" | see "Title is reserved"                     | 
    | inclusion | 4, 8, 15, 16, 23, 42  | 15    | see "Title is valid"     | not see "Title is not included in the list" | 
    | inclusion | 4, 8, 15, 16, 23, 42  | 37    | not see "Title is valid" | see "Title is not included in the list"     | 
    | exclusion | 4, 8, 15, 16, 23, 42  | 0     | see "Title is valid"     | not see "Title is reserved"                 | 
    | exclusion | 4, 8, 15, 16, 23, 42  | 23    | not see "Title is valid" | see "Title is reserved"                     | 
    | inclusion | 7..11                 | 9     | see "Title is valid"     | not see "Title is not included in the list" | 
    | inclusion | 7..11                 | 12    | not see "Title is valid" | see "Title is not included in the list"     | 
    | exclusion | 7..11                 | 4     | see "Title is valid"     | not see "Title is reserved"                 | 
    | exclusion | 7..11                 | 10    | not see "Title is valid" | see "Title is reserved"                     | 
  
  Scenario Outline: Handling blank values as titles
    Given the Article class validates <type> of title in "Thom", "Jonny", "Ed" with allow_blank <allow blank>
    When I visit "/articles/new"
    And I focus the "Title" field
    And I focus the "Save" button
    Then I should <see success>
    And I should <see failure>
  Examples:
    | type      | allow blank | see success              | see failure                                 | 
    | inclusion | true        | see "Title is valid"     | not see "Title is not included in the list" | 
    | inclusion | false       | not see "Title is valid" | see "Title is not included in the list"     | 
  
  Scenario Outline: Seeign a custom error message
    Given the Article class validates <type> of title in "Thom", "Jonny", "Ed" with message "<message>"
    When I visit "/articles/new"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    And I should <see failure>
  Examples:
    | type      | message                       | title | see failure                               | 
    | inclusion | must be a Radiohead guitarist | Colin | see "Title must be a Radiohead guitarist" | 
    | exclusion | should not be in a band       | Thom  | see "Title should not be in a band"       | 
  
  Scenario Outline: Validation depending on event
    Given there is an Article
    And the Article class validates <type> of title on <event> in "Thom", "Jonny", "Ed"
    When I visit "<path>"
    And I fill in "Title" with "<title>"
    And I focus the "Save" button
    Then I should <see failure>
  Examples:
    | type      | event  | path             | title | see failure                                 | 
    | inclusion | create | /articles/new    | Colin | see "Title is not included in the list"     | 
    | inclusion | create | /articles/1/edit | Colin | not see "Title is not included in the list" | 
    | inclusion | update | /articles/new    | Colin | not see "Title is not included in the list" | 
    | inclusion | update | /articles/1/edit | Colin | see "Title is not included in the list"     | 
    | exclusion | create | /articles/new    | Thom  | see "Title is reserved"                     | 
    | exclusion | create | /articles/1/edit | Thom  | not see "Title is reserved"                 | 
    | exclusion | update | /articles/new    | Thom  | not see "Title is reserved"                 | 
    | exclusion | update | /articles/1/edit | Thom  | see "Title is reserved"                     | 

