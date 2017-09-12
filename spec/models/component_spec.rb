require 'rails_helper'

RSpec.describe Component, type: :model do
    subject { described_class.new(class_type: 'Lecture') }
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a type' do
        subject.class_type = nil
        expect(subject).to_not be_valid
    end
    it 'should have many sessions' do
        t = described_class.reflect_on_association(:sessions)
        expect(t.macro).to eq(:has_many)
    end
    it 'should have many courses' do
        t = described_class.reflect_on_association(:courses)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end

    describe 'unique sessions mehtod' do
        it 'should return sessions with unique component codes' do
            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Tutorial')

            s1 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: 'LE01', component: comp1)
            FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Wednesday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: 'LE01', component: comp1)
            s3 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 12, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [2, 4, 6, 8, 10, 12], component_code: 'TU01', component: comp2)
            s4 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1, 3, 5, 7, 9, 11], component_code: 'TU02', component: comp2)

            lecture_expect_array = [s1]
            expect(comp1.unique_sessions).to eq(lecture_expect_array)

            tutorial_expect_array = [s3, s4]
            expect(comp2.unique_sessions).to eq(tutorial_expect_array)
        end
    end
end
