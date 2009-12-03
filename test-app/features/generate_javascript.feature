Feature: Generate JavaScript from Active Record validations
  
  Background:
    Given there is an Article class
    And I have specified a code generator
  
  Scenario: Generate validation for presence
    Given the Article class requires "title" to be present
    When I go to the home page
    Then I should see a form called "new_article"
    And I should see a script called "new_article_validation" containing
    """
    form('new_article').requires('article[title]');
    """
  
  Scenario: Generate validation for length
    Given the Article class requires "title" to have length 12
    When I go to the home page
    Then I should see a form called "new_article"
    And I should see a script called "new_article_validation" containing
    """
    form('new_article').requires('article[title]').toHaveLength(12);
    """
  
  Scenario: Generate validation for uniqueness
    Given the Article class requires "title" to be unique
    When I go to the home page
    Then I should see a form called "new_article"
    And I should see a script called "new_article_validation" containing
    """
    form('new_article').requires('article[title]').toBeUnique();
    """
  
  Scenario: Don't generate 'on update' validation for new objects
    Given the Article class requires "title" to have length 3 on "update"
    When I go to the home page
    Then I should see a form called "new_article"
    And I should see a script called "new_article_validation" not containing
    """
    form('new_article').requires('article[title]').toHaveLength(3);
    """
  
  Scenario: Don't generate any code if disabled
    Given the Article class requires "title" to be present
    And the Acceptance generator is disabled
    When I go to the home page
    Then I should see a form called "new_article"
    And I should not see a script called "new_article_validation"

