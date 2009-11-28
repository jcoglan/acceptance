Feature: Generate JavaScript from Active Record validations
  
  Background:
    Given there is an Article class
    And I have specified a code generator
  
  Scenario: Generate validation
    Given the Article class requires "title" to be present
    When I go to the home page
    Then I should see a form
    And I should see a script containing
    """
    form('new_article').requires('title');
    """

