
Feature: choose sticks by clicking on check boxes

As a marienbad player
So that I can remove sticks
I want to remove boxes by checking and submitting

Background: there is a game board in play and it is human's turn

    Given the following boards:
    |   turn    | row_one   | row_two   | row_three | row_four  |
    |   1       |   1       |   3       |   5       |   7       |

    And it is turn 'human'
    
Scenario: choose 1 stick from a given non-zero row
    When I check 1 stick from row_two
    And I press "remove chosen sticks"
    Then row two should have one less stick

Scenario: choose all the sticks from a given non-zero row
    When I check all the boxes in row_two
    And I press "remove chosen sticks"
    Then row 2 should have 0 sticks

Scenario: choose sticks from two different rows
    When I check 1 stick from row_one
    And I check 1 stick from row_two
    And I press "remove chosen sticks"
    Then I should see "try again"