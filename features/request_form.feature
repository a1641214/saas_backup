Feature: Clash Resolution
    Scenario: View request form page #77
        Given I am visiting request_form
        Then I should see "Enrolment Request ID Number"
        Then I should see "Name"
        Then I should see "Student ID"
        Then I should see "Email"
        Then I should see "Degree Program"
        Then I should see "Semester"
        Then I should see "Subject Area"
        Then I should see "Course"
        Then I should see "Course Name"
        Then I should see "Comments or Justification"


    # General case
    Scenario: Create a request and submit
        Given there is a student with id "1681256"
        Given I am logged in
        Given there is a course with name "Engineering Software as Services I"
        Given I am visiting request_form
        When I fill in "request_form[enrolment_request_id]" with "12345"
        When I fill in "request_form[name]" with "Tester"
        When I fill in "request_form[student_id]" with "1681256"
        When I fill in "request_form[email]" with "xyz123@gmail.com"
        When I select "Software Engineering" from "request_form[faculty]"
        When I select "Semester2, 2017" from "request_form[semester]"
        When I select "COMP" from "request_form[subject]"
        When I select "Engineering Software as Services I" from "request_form[course]"
        When I fill in "request_form[comments]" with "This is a test"
        When I choose "agree"
        When I press "Submit"
        # Go to "clash request list", and see if there is a clash request there.
        Given I am on the home page
        And there is a clash request with the following:
            | id         | 12345        |
            | student_id | 1681256 |

    Scenario: User click submit without filling in anything
        Given I am visiting request_form
        When I press "Submit"
        Then I should see "You have to confirm you approve and understand all conditions."


    Scenario: User only agree with conditions, but do not fill in form
        Given I am visiting request_form
        When I choose "agree"
        When I press "Submit"
        Then I should see "Please fill in all required information."


    Scenario: User input a wrong student id, which does not exist in database
        Given there is a course with name "Engineering Software as Services I"
        Given I am visiting request_form
        When I fill in "request_form[enrolment_request_id]" with "12345"
        When I fill in "request_form[name]" with "Does not exist"
        When I fill in "request_form[student_id]" with "123456"
        When I fill in "request_form[email]" with "haha@gmail.com"
        When I select "Software Engineering" from "request_form[faculty]"
        When I select "Semester2, 2017" from "request_form[semester]"
        When I select "COMP" from "request_form[subject]"
        When I select "Engineering Software as Services I" from "request_form[course]"
        When I fill in "request_form[comments]" with "This is a test"
        When I choose "agree"
        When I press "Submit"
        Then I should see "Student id does not exist in database."


    Scenario: Enrolment_request_id contain nonnumeric
        Given there is a course with name "Engineering Software as Services I"
        Given I am visiting request_form
        When I fill in "request_form[enrolment_request_id]" with "uyrd^&*"
        When I fill in "request_form[name]" with "Does not exist"
        When I fill in "request_form[student_id]" with "12345"
        When I fill in "request_form[email]" with "haha@gmail.com"
        When I select "Software Engineering" from "request_form[faculty]"
        When I select "Semester2, 2017" from "request_form[semester]"
        When I select "COMP" from "request_form[subject]"
        When I select "Engineering Software as Services I" from "request_form[course]"
        When I fill in "request_form[comments]" with "This is a test"
        When I choose "agree"
        When I press "Submit"
        Then I should see "Invalid enrolment request id"

    Scenario: student_id contain nonnumeric
        Given there is a course with name "Engineering Software as Services I"
        Given I am visiting request_form
        When I fill in "request_form[enrolment_request_id]" with "1234"
        When I fill in "request_form[name]" with "Does not exist"
        When I fill in "request_form[student_id]" with "*&%&*%"
        When I fill in "request_form[email]" with "haha@gmail.com"
        When I select "Software Engineering" from "request_form[faculty]"
        When I select "Semester2, 2017" from "request_form[semester]"
        When I select "COMP" from "request_form[subject]"
        When I select "Engineering Software as Services I" from "request_form[course]"
        When I fill in "request_form[comments]" with "This is a test"
        When I choose "agree"
        When I press "Submit"
        Then I should see "Invalid student id."

    Scenario: Remember all user input
        Given there is a course with name "Engineering Software as Services I"
        Given I am visiting request_form
        When I fill in "request_form[enrolment_request_id]" with "12345"
        When I fill in "request_form[name]" with "Tester"
        When I fill in "request_form[student_id]" with "123456"
        When I fill in "request_form[email]" with "xyz123@gmail.com"
        When I select "Software Engineering" from "request_form[faculty]"
        When I select "Semester2, 2017" from "request_form[semester]"
        When I select "COMP" from "request_form[subject]"
        When I select "Engineering Software as Services I" from "request_form[course]"
        When I fill in "request_form[comments]" with "This is a test"
        When I choose "agree"
        When I press "Submit"
        # request will fail, because student id does not exist in database.
        # user will stay on the same page, and see if their input is still in there.
        Then I can find "12345" on "request_form[enrolment_request_id]"
        Then I can find "Tester" on "request_form[name]"
        Then I can find "123456" on "request_form[student_id]"
        Then I can find "xyz123@gmail.com" on "request_form[email]"
        Then I can find "This is a test" on "request_form[comments]"
