require 'rails_helper'

RSpec.describe ClashRequestsController, type: :controller do
    describe 'GET #new' do
        it 'returns http success' do
            get :new
            expect(response).to have_http_status(:success)
        end
    end

    describe 'GET #index' do
        it 'returns http success' do
            get :index
            expect(response).to have_http_status(:success)
        end
    end
    
    describe 'GET #edit' do
        it 'calls the edit method and finds the student' do
            studentOne = FactoryGirl.create(:student)
            clashOne = FactoryGirl.create(:clash_request)
            clashOne.student= studentOne
            clashOne.save
            studentOne.save
            expect(ClashRequest).to receive(:where)
            expect(Student).to receive(:where)
            get :edit, {:id => 1}
        end
    end
    
    describe 'PUT #update' do
        it 'finds all the courses the student is taking' do
            
            # Create courses            
            c1 = FactoryGirl.create(:course, name: 'Engineering Software as Services I', catalogue_number: 'COMP SCI 3003')
            c2 = FactoryGirl.create(:course, name: 'Engineering Software as Services II', catalogue_number: 'COMP SCI 3004')
            c4 = FactoryGirl.create(:course, name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')
            
            # Create components
            comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp2 = FactoryGirl.create(:component, class_type: 'Tutorial')
            c1.components << comp1 << comp2
            comp3 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp4 = FactoryGirl.create(:component, class_type: 'Workshop')
            c2.components << comp3 << comp4
            
            comp8 = FactoryGirl.create(:component, class_type: 'Lecture')
            comp9 = FactoryGirl.create(:component, class_type: 'Practical')
            c4.components << comp8 << comp9
    
            s1 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp1)
            s2 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Wednesday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp1)
            s3 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 12, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "TU01", component: comp2)
            s4 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1,3,5,7,9,11], component_code: "TU02", component: comp2)
            
            s5 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 9, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp3)
            s6 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 14, 0, 0, '+09:30'), length: 3, day: 'Tuesday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "WR01", component: comp4)
            
            s13 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "LE01", component: comp8)
            s14 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "PR01", component: comp9)
            s15 = FactoryGirl.create(:session, time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "PR02", component: comp9)
            
            studentOne = FactoryGirl.create(:student)
            clashOne = FactoryGirl.create(:clash_request, faculty: "Engineering", student: studentOne, course: c4)
            
            studentOne.courses << c1 << c2
            studentOne.sessions << s1 << s2 << s3 << s5 << s6
            
            clashOne.sessions << s13 << s14
            
            c1.save
            c2.save
            c4.save
            studentOne.save
            clashOne.save
            
    
            put :update, {:id => 1, "SOIL&WAT 1000WT"=>{"Lecture"=>"LE01", "Practical"=>"PR02"}, "COMP SCI 3003"=>{"Lecture"=>"LE01", "Tutorial"=>"TU02"}, "COMP SCI 3004"=>{"Lecture"=>"LE01", "Workshop"=>"WR01"}}
            updated_student = Student.find(studentOne.id)
            updated_clash = ClashRequest.find(clashOne.id)
            arr = Array.new
            updated_student.sessions.each do |sess|
                arr << sess.component_code
            end
           expect(arr).to eq(["LE01", "LE01", "TU02", "LE01", "WR01"])
            
            arr = Array.new
            expect(updated_clash.course.catalogue_number).to eq("SOIL&WAT 1000WT")
            updated_clash.sessions.each do |sess|
                arr << sess.component_code
            end
            expect(arr).to eq(["LE01","PR02"])
                
        end
    end
end


