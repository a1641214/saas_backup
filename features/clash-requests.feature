Feature: Clash Requests (#16)
    Scenario: View all requests (#20)
        Given I am logged in
        Given there is a clash request in the database
        Given I am on the clash requests list page
        Then there should be 1 row

    Scenario: Create a request (#15)
        Given I am logged in
        Given I am on the new clash request page
        When I fill in "clash_request[student_id]" with "1680000"
        When I fill in "clash_request[comments]" with "Please fix"
        When I press "Create"
        Then I should be on the clash requests list page
        Then I should see "Clash request from student 1680000 was created"

    Scenario: View a request (#15)
        Given there is a student with id "1680000"
        And there is a clash request with the following:
            | id         | 5        |
            | student_id | 1680000 |
            | faculty    | ECMS     |
        Given I am on the view clash request page for id "5"
        Then I should see "1680000"
        Then I should see "ECMS"
