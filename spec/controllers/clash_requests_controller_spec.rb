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
            new_student = FactoryGirl.create(:student, id: 11 )
            FactoryGirl.create(:clash_request, studentId: "11")
            expect(ClashRequest).to receive(:find)
            expect(Student).to receive(:where)
            get :edit, {:id => 1}
        end
    end
    
    describe 'PUT #update' do
        it 'finds all the courses the student is taking' do
            fake_student = double('Student')
            fake_courses = [FactoryGirl.create(:course, catalogue_number: "COMP SCI 3003"),FactoryGirl.create(:course, catalogue_number: "COMP SCI 3004")]
            FactoryGirl.create(:clash_request, studentId: "11")
            Student.stub(:find) { fake_student }
            fake_student.stub(:current_courses) { "COMP SCI 3003"}
            @student.stub(:current_courses) { "COMP SCI 3003"}
            @student.stub(:sessions) {}
            @student.stub(:clear) {}
            fake_student.stub(:sessions) {}
            fake_student.stub(:clear) {}
            fake_student.stub(:add_new_sessions){}
            @student.stub(:add_new_sessions){}
            fake_student.stub(:courses){fake_courses}
            
            expect(fake_student).to receive(:add_new_sessions)
            put :update, {:id => 1}
        end
    end
end
