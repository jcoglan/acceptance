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

