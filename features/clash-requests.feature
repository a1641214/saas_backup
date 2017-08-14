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
        Given there is a student with id "1680000"
        And there is a clash request with the following:
            | id        | 5        |
            | studentId | a1680000 |
            | faculty   | ECMS     |
        Given I am on the view clash request page for id "5"
        Then I should see "a1680000"
        Then I should see "ECMS"
        
    Scenario: Nagivate to updating page from viewing (#45)
        Given there is a student with id "1680000"
        And there is a clash request with the following:
            | id        | 5        |
            | studentId | 1680000  |
            | faculty   | ECMS     |
        Given I am on the view clash request page for id "5"
        And student "1680000" is enrolled in courses "COMP SCI 3003" and "COMP SCI 3004"
        When I follow "Edit"
        Then I should see "Update Enrolment for 1680000"

    Scenario: Update a request (#45)
        Given there is a student with id "1680000"
        And there is a clash request with the following:
            | id        | 5        |
            | studentId | 1680000  |
            | faculty   | ECMS     |
        And student "1680000" is enrolled in courses "COMP SCI 3003" and "COMP SCI 3004"
        Given I am on the edit clash request page for id "5"
        Then I should see "Update Enrolment for 1680000"
        Then I should see "COMP SCI 3003"
        And I should see "COMP SCI 3004"
        
    Scenario: Seeing already enrolled classes in updating a request (#45)
        Given there is a student with id "1680000"
        And there is a clash request with the following:
            | id        | 5        |
            | studentId | 1680000  |
            | faculty   | ECMS     |
        And student "1680000" is enrolled in sessions "LE01" of type "Lecture" and "TU02" of type "Tutorial" for "COMP SCI 3003"
        And I am on the view clash request page for id "5"
        When I follow "Edit"
        Then I should see "TU02" selected for the course "COMP SCI 3003" for the "Tutorial" 
        Then I should see "LE01" selected for the course "COMP SCI 3003" for the "Lecture" 
    