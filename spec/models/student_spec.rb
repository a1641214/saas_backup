require 'rails_helper'

RSpec.describe Student, type: :model do
    subject { described_class.new }
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'should have many courses' do
        t = described_class.reflect_on_association(:courses)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
    it 'should have many sessions' do
        t = described_class.reflect_on_association(:sessions)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end

    it 'should have many clash requests' do
        t = described_class.reflect_on_association(:clash_requests)
        expect(t.macro).to eq(:has_many)
    end

    describe 'current_session' do
        it 'finds the current session a student is enrolled in' do
            course_one = FactoryGirl.create(:course)
            student_one = FactoryGirl.create(:student)
            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Tutorial')
            course_one.components << comp1
            course_one.components << comp2

            s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
            s2 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1)
            FactoryGirl.create(:session, component_code: 'TU01', component: comp2)
            s4 = FactoryGirl.create(:session, component_code: 'TU02', component: comp2)
            student_one.courses << course_one
            student_one.sessions << s1 << s2 << s4

            expect(student_one.current_session(comp1)).to eq 'LE01'
            expect(student_one.current_session(comp2)).to eq 'TU02'
        end
    end

    describe 'current courses method' do
        it 'returns the catalogue numbers of the courses the student is enrolled in' do
            course_one = FactoryGirl.create(:course, catalogue_number: 'COMP SCI 3003')
            course_two = FactoryGirl.create(:course, catalogue_number: 'COMP SCI 3004')
            course_three = FactoryGirl.create(:course, catalogue_number: 'COMP SCI 1002')
            student_one = FactoryGirl.create(:student)
            student_one.courses << course_one << course_two << course_three
            expect(student_one.current_courses).to eq(['COMP SCI 3003', 'COMP SCI 3004', 'COMP SCI 1002'])
        end
    end

    describe 'add new sessions method' do
        it 'adds the correct new sessions from a course' do
            course_one = FactoryGirl.create(:course)
            student_one = FactoryGirl.create(:student)
            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Tutorial')
            course_one.components << comp1
            course_one.components << comp2

            s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
            s2 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1)
            FactoryGirl.create(:session, component_code: 'TU01', component: comp2)
            s4 = FactoryGirl.create(:session, component_code: 'TU02', component: comp2)
            code_hash = { 'Lecture' => 'LE01', 'Tutorial' => 'TU02' }
            student_one.courses << course_one
            student_one.add_new_sessions(course_one, code_hash)
            array = []
            student_one.sessions.each do |sess|
                array << sess
            end
            expect(array).to eq([s1, s2, s4])
        end
    end
end
