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

    Scenario: Navigate to updating page from viewing (#45)
        Given typical usage and data
        Given I am on the view clash request page for id "5"
        And student "1680000" is enrolled in courses "COMP SCI 3003" and "COMP SCI 3004"
        When I follow "Edit"
        Then I should see "Update Enrolment for 1680000"

    Scenario: Update a request (#45)
        Given typical usage and data
        And student "1680000" is enrolled in courses "COMP SCI 3003" and "COMP SCI 3004"
        Given I am on the edit clash request page for id "5"
        Then I should see "Update Enrolment for 1680000"
        Then I should see "COMP SCI 3003"
        And I should see "COMP SCI 3004"

    Scenario: Seeing already enrolled classes in updating a request (#45)
        Given typical usage and data
        And I am on the view clash request page for id "5"
        When I follow "Edit"
        Then I should see "TU02" selected for the course "COMP SCI 3003" for the "Tutorial"
        Then I should see "LE01" selected for the course "COMP SCI 3003" for the "Lecture"
        Then I should see "LE01" selected for the course "SOIL&WAT 1000WT" for the "Lecture"
        Then I should see "PR02" selected for the course "SOIL&WAT 1000WT" for the "Practical"

    Scenario: Updating a request and seeing the changes (#45)
        Given typical usage and data 
        And I am on the edit clash request page for id "5"
        When I select "PR01" for the course "SOIL&WAT 1000WT" for the "Practical"
        And  I select "TU01" for the course "COMP SCI 3003" for the "Tutorial"
        And I press "Update Enrolment"
        And I follow "Edit"
        Then I should see "TU01" selected for the course "COMP SCI 3003" for the "Tutorial"
        Then I should see "LE01" selected for the course "COMP SCI 3003" for the "Lecture"
        Then I should see "LE01" selected for the course "SOIL&WAT 1000WT" for the "Lecture"
        Then I should see "PR01" selected for the course "SOIL&WAT 1000WT" for the "Practical"

    Scenario: Seeing the current status of a clash without changes (#78)
        Given typical usage and data 
        And I am on the view clash request page for id "5"
        Then I should see "Lecture" as "LE01" and "LE01" for the course "COMP SCI 3003"
        Then I should see "Tutorial" as "TU02" and "TU02" for the course "COMP SCI 3003"
        Then I should see "Lecture" as "LE01" and "LE01" for the course "SOIL&WAT 1000WT"
        Then I should see "Practical" as "PR02" and "PR02" for the course "SOIL&WAT 1000WT"

    Scenario: Seeing the current status of a clash with changes (#78)
        Given typical usage and data 
        And I am on the edit clash request page for id "5"
        When I select "PR01" for the course "SOIL&WAT 1000WT" for the "Practical"
        And  I select "TU01" for the course "COMP SCI 3003" for the "Tutorial"
        And I press "Update Enrolment"
        Then I should see "Lecture" as "LE01" and "LE01" for the course "COMP SCI 3003"
        Then I should see "Tutorial" as "TU02" and "TU01" for the course "COMP SCI 3003"
        Then I should see "Lecture" as "LE01" and "LE01" for the course "SOIL&WAT 1000WT"
        Then I should see "Practical" as "PR02" and "PR01" for the course "SOIL&WAT 1000WT"