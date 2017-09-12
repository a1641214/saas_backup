require 'mail'
class ClashRequestsController < ApplicationController
    def request_params
            Time.zone = 'Adelaide'
            time = Time.zone.now
            params[:clash_request] = params[:clash_request].merge(:date_submitted => time.to_date)
            params.require(:clash_request).permit(
            :enrolment_request_id,
            :date_submitted,
            :faculty,
            :comments,
            :student_id,
            :request_type,
            :email
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
    end

    def show
        @clash_request = ClashRequest.find params[:id]

        # Load serialised data into nicer format
        @old_student_sessions = @clash_request.preserve_student_sessions.map do |session|
            Session.find(session)
        end

        @old_clash_sessions = @clash_request.preserve_clash_sessions.map do |session|
            Session.find(session)
        end
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

        @map_session_by_day = {}
        return unless @student

        index = 0
        map_course_id_by_index = {}

        current_sessions = @student.sessions.each_with_object('monday' => [], 'tuesday' => [], 'wednesday' => [], 'thursday' => [], 'friday' => []) do |session, by_day|
            id = if map_course_id_by_index[session.component_id]
                     map_course_id_by_index[session.component_id]
                 else
                     map_course_id_by_index[session.component_id] = index += 1
                 end
            by_day[session.day.downcase] << {
                session: session,
                id: id,
                requested: false
            }
        end

        @map_session_by_day = @clash_request.sessions.each_with_object(current_sessions) do |session, by_day|
            id = if map_course_id_by_index[session.component_id]
                     map_course_id_by_index[session.component_id]
                 else
                     map_course_id_by_index[session.component_id] = index += 1
                 end
            by_day[session.day.downcase] << {
                session: session,
                id: id,
                requested: true
            }
        end

        all_sessions = Session.all_request_student_sessions(@clash_request, @student)
        @clash_hash = Session.detect_clashes(all_sessions)
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

    def confirmation; end

    def send_email
        EnrolmentMailer.enrolment_email(1111111).deliver_now
        redirect_to clash_requests_path
    end
end
