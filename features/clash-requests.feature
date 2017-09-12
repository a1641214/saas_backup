Feature: Clash Requests (#16)
    Scenario: View all requests (#20)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        Then there should be 1 row

    Scenario: View a request (#15)
        Given typical usage and data
        Given I am on the view clash request page for id "5"
        Then I should see "1680000"
        Then I should see "ECMS"

    Scenario: View active clash requests (#126)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        Given I click on "Active"
        Then I should see "1680000"

    Scenario: View inactive clash requests (#126)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        Given I click on "Inactive"
        Then I should not see any student

    Scenario: Search for a student (#126)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        Given I search with "1680000"
        Then I should see "1680000"

    Scenario: View a request using dropdown menu (#138)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        When I press "More"
        Given I click on "View request"
        Then I should see "1680000"
        Then I should see "ECMS"
    
    Scenario: Edit enrolment using dropdown menu (#138)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        When I press "More"
        Given I click on "Edit"
        Then I should see "1680000"
        Then I should see "Resolve clash request for 1680000"

    Scenario: Make a request inactive using dropdown menu (#138)
        Given I am logged in
        Given typical usage and data
        Given I am on the clash requests list page
        When I press "More"
        Given I click on "Make Inactive"
        When I press "More"
        Then I should see "Make Active"
        
