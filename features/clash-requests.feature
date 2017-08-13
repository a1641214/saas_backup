Feature: Clash Requests (#16)
    Scenario: View all requests (#20)
        Given I am logged in
        Given there is a clash request in the database
        Given I am on the clash requests list page
        Then there should be 1 row

    Scenario: Create a request (#15)
        Given I am logged in
        Given I am on the new clash request page
        When I fill in "clash_request[studentId]" with "a0000000"
        When I fill in "clash_request[comments]" with "Please fix"
        When I press "Create"
        Then I should be on the clash requests list page
        Then I should see "Clash request from student a0000000 was created"

    Scenario: View a request (#15)
        Given there is a clash request with the following:
            | id        | 5        |
            | studentId | a1680000 |
            | faculty   | ECMS     |
        Given I am on the view clash request page for id "5"
        Then I should see "a1680000"
        Then I should see "ECMS"

    Scenario: Make a request inactive (#64)
        Given there is a clash request with the following:
            | id        | 1        |
            | studentId | a1680000 |
            | faculty   | ECMS     |
            | inactive  | false    |
        Given I am on the view clash request page for id "1"
        Then I follow "Make inactive"
        Then I should see "Clash Request from student a1680000 was made inactive"

    Scenario: Make a request active (#64)
        Given there is a clash request with the following:
            | id        | 1        |
            | studentId | a1680000 |
            | faculty   | ECMS     |
            | inactive  | true    |
        Given I am on the view clash request page for id "1"
        Then I follow "Make active"
        Then I should see "Clash Request from student a1680000 was made active"
