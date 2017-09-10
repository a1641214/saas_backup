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
