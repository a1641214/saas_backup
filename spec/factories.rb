FactoryGirl.define do
    factory :clash_request do
        studentId "a#{Faker::Number.number(7)}"
        comments Faker::HitchhikersGuideToTheGalaxy
        enrolment_request_id Faker::Number.number(5)
        date_submitted Faker::Date.backward
        faculty Faker::Company.name
    end
end
