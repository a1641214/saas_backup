Feature: Clash Requests (#16)
    Scenario: View all requests (#20)
        Given I am logged in
        Given there is a clash request in the database
        Given I am on the clash requests list page

    Scenario: Create a request (#15)
        Given I am logged in
        Given I am on the clash request create page
        When I fill in the following:
            | Student ID | a0000000   |
            | Comments   | Please fix |
        When I press "Create"
        Then I should be on the clash requests list page
        Then I should see "Clash request from student a0000000 was created"
