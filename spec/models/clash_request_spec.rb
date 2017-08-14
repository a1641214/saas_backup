require 'rails_helper'

RSpec.describe ClashRequest, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"

    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'should have many sessions' do
        t = described_class.reflect_on_association(:sessions)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
    it 'should belong to a courses' do
        t = described_class.reflect_on_association(:course)
        expect(t.macro).to eq(:belongs_to)
    end
    it 'should belong to a student' do
        t = described_class.reflect_on_association(:student)
        expect(t.macro).to eq(:belongs_to)
    end

    describe 'current clash session method' do
        it 'finds the current session of the clash request course component' do
            clash_one = FactoryGirl.create(:clash_request)
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

            expect(clash_one.current_clash_session(comp1)).to eq 'LE01'
            expect(clash_one.current_clash_session(comp2)).to eq 'PR02'
        end
    end

    describe 'add new request sessions' do
        it 'should add the new sessions into the clash request' do
            clash_one = FactoryGirl.create(:clash_request)
            course_one = FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Practical')
            course_one.components << comp1 << comp2
            s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
            FactoryGirl.create(:session, component_code: 'PR01', component: comp2)
            s4 = FactoryGirl.create(:session, component_code: 'PR02', component: comp2)
            clash_one.course = course_one
            code_hash = { 'Lecture' => 'LE01', 'Practical' => 'PR02' }
            clash_one.course = course_one
            clash_one.add_new_request_sessions(course_one, code_hash)
            array = []
            clash_one.sessions.each do |sess|
                array << sess
            end
            expect(array).to eq([s1, s4])
        end
    end
end
