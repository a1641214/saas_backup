#xvfb-run cucumber
Feature: Clash Resolution
#     Scenario: View clash resolution page #77
#         Given I am on the clash resolution page
#         Then I should see "Enrolment Request ID Number"
#         Then I should see "Name"
#         Then I should see "Student ID"
#         Then I should see "Email"
#         Then I should see "Degree Program"
#         Then I should see "Semester"
#         Then I should see "Subject Area"
#         Then I should see "Course"
#         Then I should see "Course Name"
#         Then I should see "Additional Comments"


#     # General case
#     Scenario: Create a request and submit
#         Given there is a student with id "1681256"
#         Given I am logged in
#         Given there is a course with name "Engineering Software as Services I"
#         Given I am on the clash resolution page
#         When I fill in "clash_resolution[enrolment_request_id]" with "12345"
#         When I fill in "clash_resolution[name]" with "Tester"
#         When I fill in "clash_resolution[student_id]" with "1681256"
#         When I fill in "clash_resolution[email]" with "xyz123@gmail.com"
#         When I select "Software Engineering" from "clash_resolution[degree]"
#         When I select "Semester2, 2017" from "clash_resolution[semester]"
#         When I select "COMP" from "clash_resolution[faculty]"
#         When I select "Engineering Software as Services I" from "clash_resolution[course]"
#         When I fill in "clash_resolution[comments]" with "This is a test"
#         When I choose "agree"
#         When I press "Submit"
#         # Go to "clash request list", and see if there is a clash request there.
#         Given I am on the clash requests list page
#         And there is a clash request with the following:
#             | id         | 12345        |
#             | student_id | 1681256 |
#             | faculty    | COMP     |

#     Scenario: User click submit without filling in anything
#         Given I am on the clash resolution page
#         When I press "Submit"
#         Then I should see "You have to confirm you approve and understand all conditions."


#     Scenario: User only agree with conditions, but do not fill in form
#         Given I am on the clash resolution page
#         When I choose "agree"
#         When I press "Submit"
#         Then I should see "Please fill in all required information."


#     Scenario: User input a wrong student id, which does not exist in database
#         Given there is a course with name "Engineering Software as Services I"
#         Given I am on the clash resolution page
#         When I fill in "clash_resolution[enrolment_request_id]" with "12345"
#         When I fill in "clash_resolution[name]" with "Does not exist"
#         When I fill in "clash_resolution[student_id]" with "123456"
#         When I fill in "clash_resolution[email]" with "haha@gmail.com"
#         When I select "Software Engineering" from "clash_resolution[degree]"
#         When I select "Semester2, 2017" from "clash_resolution[semester]"
#         When I select "COMP" from "clash_resolution[faculty]"
#         When I select "Engineering Software as Services I" from "clash_resolution[course]"
#         When I fill in "clash_resolution[comments]" with "This is a test"
#         When I choose "agree"
#         When I press "Submit"
#         Then I should see "Student id does not exist in database."


#     Scenario: Enrolment_request_id contain nonnumeric
#         Given there is a course with name "Engineering Software as Services I"
#         Given I am on the clash resolution page
#         When I fill in "clash_resolution[enrolment_request_id]" with "uyrd^&*"
#         When I fill in "clash_resolution[name]" with "Does not exist"
#         When I fill in "clash_resolution[student_id]" with "12345"
#         When I fill in "clash_resolution[email]" with "haha@gmail.com"
#         When I select "Software Engineering" from "clash_resolution[degree]"
#         When I select "Semester2, 2017" from "clash_resolution[semester]"
#         When I select "COMP" from "clash_resolution[faculty]"
#         When I select "Engineering Software as Services I" from "clash_resolution[course]"
#         When I fill in "clash_resolution[comments]" with "This is a test"
#         When I choose "agree"
#         When I press "Submit"
#         Then I should see "Invalid enrolment request id"

#     Scenario: student_id contain nonnumeric
#         Given there is a course with name "Engineering Software as Services I"
#         Given I am on the clash resolution page
#         When I fill in "clash_resolution[enrolment_request_id]" with "1234"
#         When I fill in "clash_resolution[name]" with "Does not exist"
#         When I fill in "clash_resolution[student_id]" with "*&%&*%"
#         When I fill in "clash_resolution[email]" with "haha@gmail.com"
#         When I select "Software Engineering" from "clash_resolution[degree]"
#         When I select "Semester2, 2017" from "clash_resolution[semester]"
#         When I select "COMP" from "clash_resolution[faculty]"
#         When I select "Engineering Software as Services I" from "clash_resolution[course]"
#         When I fill in "clash_resolution[comments]" with "This is a test"
#         When I choose "agree"
#         When I press "Submit"
#         Then I should see "Invalid student id."

#     Scenario: Remember all user input
#         Given there is a course with name "Engineering Software as Services I"
#         Given I am on the clash resolution page
#         When I fill in "clash_resolution[enrolment_request_id]" with "12345"
#         When I fill in "clash_resolution[name]" with "Tester"
#         When I fill in "clash_resolution[student_id]" with "123456"
#         When I fill in "clash_resolution[email]" with "xyz123@gmail.com"
#         When I select "Software Engineering" from "clash_resolution[degree]"
#         When I select "Semester2, 2017" from "clash_resolution[semester]"
#         When I select "COMP" from "clash_resolution[faculty]"
#         When I select "Engineering Software as Services I" from "clash_resolution[course]"
#         When I fill in "clash_resolution[comments]" with "This is a test"
#         When I choose "agree"
#         When I press "Submit"
#         # request will fail, because student id does not exist in database.
#         # user will stay on the same page, and see if their input is still in there.
#         Then I can find "12345" on "clash_resolution[enrolment_request_id]"
#         Then I can find "Tester" on "clash_resolution[name]"
#         Then I can find "123456" on "clash_resolution[student_id]"
#         Then I can find "xyz123@gmail.com" on "clash_resolution[email]"
#         Then "Software Engineering" should be selected for "clash_resolution[degree]"
#         Then "Semester2, 2017" should be selected for "clash_resolution[semester]"
#         Then "COMP" should be selected for "clash_resolution[faculty]"
#         Then "Engineering Software as Services I" should be selected for "clash_resolution[course]"
#         Then I can find "This is a test" on "clash_resolution[comments]"

    @javascript
    Scenario: Filling out a form
        Given two comp sci and one soil and water course exsist
        And "1705" is a student wanting to make a clash request
        And I am on the clash resolution page
        When I fill in "clash_resolution[enrolment_request_id]" with "1814"
        And I fill in "clash_resolution[name]" with "Mary"
        And I fill in "clash_resolution[student]" with "1705"
        And I fill in "clash_resolution[email]" with "xyz123@gmail.com"
        And I select "Scandinavian Studies" from "clash_resolution[degree]"
        And I select "Summer Semester, 2017" from "clash_resolution[semester]"
        And I select "COMP SCI" from "clash_resolution[subject]"
        And I select "COMP SCI 3003" from "clash_resolution[course]"
        And I select "LE01:1" from "clash_resolution[Lecture]"
        And I select "TU02:4" from "clash_resolution[Tutorial]"
        And I choose "agree"
        And I press "Submit"
        Then I should see "Clash request from student 1705 was created
        
    @javascript
    Scenario: Form persisting in clash request page
        Given two comp sci and one soil and water course exsist
        And "1705" is a student wanting to make a clash request
        And I am on the clash resolution page
        And I have filled out the clash request form and pressed submit
        Then I should see "ECMS"
        When I press "More"
        Given I click on "View request"
        Then I should see "Requested Class"
        And I should see "Lecture"
        And I should see "LE01"
        And I should see "Tutorial"
        And I should see "TU02"
