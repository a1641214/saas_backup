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

    describe 'week binary conversion method' do
        it 'should take a 52 length array and turn it to a decimal number' do
            new_array = [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0]
            conversion = Session.week_conversion(new_array)
            expect(conversion).to eq(1125899906847304)
        end
    end

    describe 'day binary conversion method' do
        it 'should take a string of the day and turn it to a decimal number' do
            day_one = 'Monday'
            day_two = 'Tuesday'
            day_three = 'Wednesday'
            day_four = 'Thursday'
            day_five = 'Friday'
            day_six = 'Saturday'
            day_seven = 'Sunday'

            conversion = Session.day_conversion(day_one)
            expect(conversion).to eq(1)

            conversion = Session.day_conversion(day_two)
            expect(conversion).to eq(2)

            conversion = Session.day_conversion(day_three)
            expect(conversion).to eq(4)

            conversion = Session.day_conversion(day_four)
            expect(conversion).to eq(8)

            conversion = Session.day_conversion(day_five)
            expect(conversion).to eq(16)

            conversion = Session.day_conversion(day_six)
            expect(conversion).to eq(32)

            conversion = Session.day_conversion(day_seven)
            expect(conversion).to eq(64)
        end
    end

    describe 'detect clashes method' do
        it 'will return a map of a course, pointing to an array of all the weeks there are clashes in' do
            course_one = FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            course_two = FactoryGirl.create(:course, name: 'Engineering Software as Services I', catalogue_number: 'COMP SCI 3003')

            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Practical')

            comp3 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp4 = FactoryGirl.create(:component, class_type: 'Workshop')

            comp5 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp6 = FactoryGirl.create(:component, class_type: 'Workshop')

            course_one.components << comp1 << comp2
            course_two.components << comp3 << comp4
            course_two.components << comp5 << comp6
            uni_weeks = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            s1 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, component: comp1, weeks: uni_weeks)
            s2 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, component: comp1, weeks: uni_weeks)
            FactoryGirl.create(:session, component_code: 'PR01', day: 'Friday', time: Time.new(2017, 1, 1, 2, 0, 0, '+09:30'), length: 2, component: comp2, weeks: uni_weeks)
            s4 = FactoryGirl.create(:session, component_code: 'PR02', day: 'Thursday', time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, component: comp2, weeks: uni_weeks)

            s5 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Monday', time: Time.new(2017, 1, 1, 12, 0, 0, '+09:30'), length: 1, component: comp3, weeks: uni_weeks)
            s6 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Monday', time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, component: comp3, weeks: uni_weeks)
            FactoryGirl.create(:session, component_code: 'WR01', day: 'Wednesday', time: Time.new(2017, 1, 1, 16, 0, 0, '+09:30'), length: 2, component: comp4, weeks: uni_weeks)
            s8 = FactoryGirl.create(:session, component_code: 'WR02', day: 'Friday', time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, component: comp4, weeks: uni_weeks)

            s9 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', time: Time.new(2017, 1, 1, 9, 0, 0, '+09:30'), length: 3, component: comp5, weeks: uni_weeks)
            s10 = FactoryGirl.create(:session, component_code: 'WR01', day: 'Friday', time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, component: comp6, weeks: uni_weeks)

            every_session_array = []
            every_session_array << s1 << s2 << s4 << s5 << s6 << s8 << s9 << s10

            clash_hash = Session.detect_clashes(every_session_array)
            expect(clash_hash[s9]).to eq([1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s10]).to eq([1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s1]).to eq([1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s2]).to eq([1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s4]).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s5]).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s6]).to eq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
            expect(clash_hash[s8]).to eq([1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        end
    end
end
