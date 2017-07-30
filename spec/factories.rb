FactoryGirl.define do
    factory :clash_request do
        studentId "a#{Faker::Number.number(7)}"
        comments Faker::HitchhikersGuideToTheGalaxy
    end
end
