require 'mail'
class ClashRequestsController < ApplicationController
    def request_params
        params.require(:clash_request).permit(
            :enrolment_request_id,
            :studentId,
            :date_submitted,
            :faculty,
            :comments,
            :student_id
        )
    end

    def new; end

    def create
        @clash_request = ClashRequest.create!(request_params)
        flash[:notice] = "Clash request from student #{@clash_request.student_id} was created"
        redirect_to clash_requests_path
    end

    def index
        @clash_requests = ClashRequest.all
        mail = Mail.first
        EnrolmentMailer.receive(mail)
    end

    def show
        @clash_request = ClashRequest.find(params[:id])
    end

    def destroy
        @clash_request = ClashRequest.find(params[:id])
        @request.update!(inactive: !@request.inactive)
        flash[:notice] = "Clash Request from student #{@request.studentId} was made #{@request.inactive ? 'inactive' : 'active'}"
        redirect_to clash_requests_path
    end

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
            @student.add_new_sessions(course, course_param)
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
