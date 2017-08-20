require 'rails_helper'

RSpec.describe Session, type: :model do
    subject do
        described_class.new(time: Time.new(2017, 7, 30, 10, 0, 0, '+09:30'), length: 1,
                            day: 'Monday', weeks: [1, 3, 5, 7, 9, 11], component_code: 'LE01',
                            capacity: 50)
    end
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a time' do
        subject.time = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a day' do
        subject.day = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a week' do
        subject.weeks = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a component code' do
        subject.component_code = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a length' do
        subject.length = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a capacity' do
        subject.capacity = nil
        expect(subject).to_not be_valid
    end
    it 'should have one component' do
        t = described_class.reflect_on_association(:component)
        expect(t.macro).to eq(:belongs_to)
    end
    it 'should have many students' do
        t = described_class.reflect_on_association(:students)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
    it 'should have many clash requests' do
        t = described_class.reflect_on_association(:clash_requests)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end

    describe 'all_sessions method' do
        it 'should return an array of all the sessions enrolled by the student and the clash request sessions' do
            student_one = FactoryGirl.create(:student)
            clash_one = FactoryGirl.create(:clash_request, studentId: 1)
            course_one = FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            course_two = FactoryGirl.create(:course, name: 'Engineering Software as Services I', catalogue_number: 'COMP SCI 3003')
            course_three = FactoryGirl.create(:course, name: 'Engineering Software as Services II', catalogue_number: 'COMP SCI 3004')

            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Practical')

            comp3 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp4 = FactoryGirl.create(:component, class_type: 'Workshop')

            comp5 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp6 = FactoryGirl.create(:component, class_type: 'Workshop')

            course_one.components << comp1 << comp2
            course_two.components << comp3 << comp4
            course_two.components << comp5 << comp6
            s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
            s2 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1)
            FactoryGirl.create(:session, component_code: 'PR01', component: comp2)
            s4 = FactoryGirl.create(:session, component_code: 'PR02', component: comp2)

            s5 = FactoryGirl.create(:session, component_code: 'LE01', component: comp3)
            s6 = FactoryGirl.create(:session, component_code: 'LE01', component: comp3)
            FactoryGirl.create(:session, component_code: 'WR01', day: 'Wednesday', component: comp4)
            s8 = FactoryGirl.create(:session, component_code: 'WR02', day: 'Wednesday', component: comp4)

            s9 = FactoryGirl.create(:session, component_code: 'LE01', component: comp5)
            s10 = FactoryGirl.create(:session, component_code: 'WR01', day: 'Wednesday', component: comp6)

            clash_one.course = course_one
            clash_one.sessions << s1 << s2 << s4
            student_one.courses << course_two << course_three
            student_one.sessions << s5 << s6 << s8 << s9 << s10

            every_session_array = []
            every_session_array << s1 << s2 << s4 << s5 << s6 << s8 << s9 << s10

            all_sessions_call = Session.all_request_student_sessions(clash_one, student_one)
            expect(all_sessions_call).to eq(every_session_array)
        end
    end
end
