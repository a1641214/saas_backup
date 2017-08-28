FactoryGirl.define do
    factory :clash_request do
        id 5
        studentId 1680000
        comments 'test'
        enrolment_request_id 1
        date_submitted Time.new(2017, 1, 1, 9, 0, 0, '+09:30')
        faculty 'ECMS'
    end

    factory :student do
    end

    factory :component do
        class_type 'Lecture'
    end

    factory :course do
        name 'Engineering Software as Services I'
        catalogue_number 'COMP SCI 3003'
    end

    factory :session do
        time Time.new(2017, 1, 1, 10, 0, 0, '+09:30')
        length 1
        day 'Monday'
        weeks [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        component_code 'LE01'
        component
        capacity 10
    end
end
