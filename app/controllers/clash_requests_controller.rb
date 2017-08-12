class ClashRequestsController < ApplicationController
    def new; end

    def create
        @clash_request = ClashRequest.create!(request_params)
        flash[:notice] = "Clash request from student #{@request.studentId} was created"
        redirect_to clash_requests_path
    end

    def index
        @clash_requests = ClashRequest.all
        @clash_requests.each do |in_request|
            puts(in_request.student_id)
        end
    end

    def show
        @clash_request = ClashRequest.find(params[:id])
    end

    def destroy
        @clash_request = ClashRequest.find(params[:id])

        @clash_request.update!(inactive: true)

        flash[:notice] = "Clash Request from student #{@request.studentId} was made inactive"
        redirect_to clash_requests_path
    end
    
    #Rspec errors
    def edit
        @clash_request = ClashRequest.find params[:id]
        @student = @clash_request.student
    end
    
    def update
        @clash_request = ClashRequest.find params[:id]
        @student = @clash_request.student
        @student.sessions.clear
        @student.courses.each do |course|
            course_cat = course.catalogue_number
            course_param = params[course_cat]
            @student.add_new_sessions(course,course_param)
        end
        @student.update_attributes!(sessions: @student.sessions)
        
        
        request_course_cat = @clash_request.course.catalogue_number
        request_course_param = params[request_course_cat]
        @clash_request.sessions.clear
        @clash_request.add_new_request_sessions(@clash_request.course, request_course_param)
        @clash_request.update_attributes!(sessions: @clash_request.sessions)
        
        redirect_to clash_request_path
    end
end
