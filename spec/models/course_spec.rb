require 'rails_helper'

RSpec.describe Course, type: :model do
    subject do
        described_class.new(name: 'A Comp Sci Course',
                            catalogue_number: 'COMP SCI 1000')
    end
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a name' do
        subject.name = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a catalogue number' do
        subject.catalogue_number = nil
        expect(subject).to_not be_valid
    end
    it 'should have many courses' do
        t = described_class.reflect_on_association(:components)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
    it 'should have many students' do
        t = described_class.reflect_on_association(:students)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
    it 'should have many clash requests' do
        t = described_class.reflect_on_association(:clash_requests)
        expect(t.macro).to eq(:has_many)
    end

    describe 'alternateSessions method' do
        it 'should return all the sessions for a course component as an array. Current enrollment first' do
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

            expect(course_one.alternate_sessions(student_one, comp1)).to eq(['LE01'])
            expect(course_one.alternate_sessions(student_one, comp2)).to eq(%w[TU02 TU01])
        end
    end

    describe 'alternate_sessions_clash_course' do
        it 'should return all the sessions of the course requested in the clash course. Desired enrollment first' do
            clash_one = FactoryGirl.create(:clash_request, studentId: 1)
            course_one = FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Practical')
            course_one.components << comp1 << comp2
            s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
            s2 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1)
            FactoryGirl.create(:session, component_code: 'PR01', component: comp2)
            s4 = FactoryGirl.create(:session, component_code: 'PR02', component: comp2)
            clash_one.course = course_one
            clash_one.sessions << s1 << s2 << s4

            expect(course_one.alternate_sessions_clash_course(clash_one, comp1)).to eq(['LE01'])
            expect(course_one.alternate_sessions_clash_course(clash_one, comp2)).to eq(%w[PR02 PR01])
        end
    end

    describe 'all subject areas method' do
        it 'should return the list of all the subject areas offered' do
            FactoryGirl.create(:course, name: 'Engineering Software as Services I', catalogue_number: 'COMP SCI 3003')
            FactoryGirl.create(:course, name: 'Engineering Software as Services II', catalogue_number: 'COMP SCI 3004')
            FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            FactoryGirl.create(:course, name: 'Applied Areodynamics', catalogue_number: 'MECH ENG 3101')
            FactoryGirl.create(:course, name: 'Introduction to Petroleum Engineering', catalogue_number: 'PETROENG 1006')
            desired_array = ['COMP SCI', 'MECH ENG', 'PETROENG', 'SOIL&WAT']
            output_array = Course.all_subject_areas
            expect(output_array).to eq(desired_array)
        end
    end

    describe 'all subject areas method' do
        it 'should return the list of all the subject areas offered' do
            c1 = FactoryGirl.create(:course, name: 'Engineering Software as Services I', catalogue_number: 'COMP SCI 3003')
            c2 = FactoryGirl.create(:course, name: 'Engineering Software as Services II', catalogue_number: 'COMP SCI 3004')
            FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            FactoryGirl.create(:course, name: 'Applied Areodynamics', catalogue_number: 'MECH ENG 3101')
            c5 = FactoryGirl.create(:course, name: 'Introduction to Petroleum Engineering', catalogue_number: 'PETROENG 1006')
            desired_array = [c1, c2]
            output_array = Course.search_by_area('COMP SCI')
            expect(output_array).to eq(desired_array)

            desired_array = [c5]
            output_array = Course.search_by_area('PETROENG')
            expect(output_array).to eq(desired_array)
        end
    end
end
