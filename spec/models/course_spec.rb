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
            courseOne = FactoryGirl.create(:course)
            studentOne = FactoryGirl.create(:student)
            comp1 = FactoryGirl.create(:component,class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component,class_type: 'Tutorial')
            courseOne.components << comp1
            courseOne.components << comp2
            
            s1 = FactoryGirl.create(:session, component_code: "LE01", component: comp1)
            s2 = FactoryGirl.create(:session, component_code: "LE01", day: 'Wednesday', component: comp1)
            s3 = FactoryGirl.create(:session, component_code: "TU01", component: comp2)
            s4 = FactoryGirl.create(:session, component_code: "TU02", component: comp2)
            studentOne.courses << courseOne
            studentOne.sessions << s1 << s2 << s4
        
            expect(courseOne.alternate_sessions(studentOne,comp1)).to eq(["LE01"])
            expect(courseOne.alternate_sessions(studentOne,comp2)).to eq(["TU02","TU01"])
        end
    end
    
    describe 'alternate_sessions_clash_course' do
        it 'should return all the sessions of the course requested in the clash course. Desired enrollment first' do
            clashOne = FactoryGirl.create(:clash_request, studentId: 1)
            courseOne = FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            comp1 = FactoryGirl.create(:component,class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component,class_type: 'Practical')
            courseOne.components << comp1 << comp2
            s1 = FactoryGirl.create(:session, component_code: "LE01", component: comp1)
            s2 = FactoryGirl.create(:session, component_code: "LE01", day: 'Wednesday', component: comp1)
            s3 = FactoryGirl.create(:session, component_code: "PR01", component: comp2)
            s4 = FactoryGirl.create(:session, component_code: "PR02", component: comp2)
            clashOne.course= courseOne
            clashOne.sessions << s1 << s2 << s4
            
            expect(courseOne.alternate_sessions_clash_course(clashOne,comp1)).to eq(["LE01"])
           expect(courseOne.alternate_sessions_clash_course(clashOne,comp2)).to eq(["PR02", "PR01"])
          end
    end
end
