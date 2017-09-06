Feature: Clash Requests (#16)
    Scenario: View all requests (#20)
        Given I am logged in
        Given typical usage and data
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
        Given typical usage and data
        Given I am on the view clash request page for id "5"
        Then I should see "1680000"
        Then I should see "ECMS"

    Scenario: View active clash requests (#126)
        Given I am logged in
        Given I am on the new clash request page
        Given typical usage and data
        Given I click on "Active"
        Then I should see student_id of "1111112"

    Scenario: View inactive clash requests (#126)
        Given I am logged in
        Given I am on the new clash request page
        Given typical usage and data
        Given I click on "Inactive"
        Then I should see student_id of "1111111"

    Scenario: Search for a student (#126)
        Given I am logged in
        Given I am on the new clash request page
        Given typical usage and data
        Given I search with "1680000"
        When I press search icon
        Then I should see "1 row of student"
        
