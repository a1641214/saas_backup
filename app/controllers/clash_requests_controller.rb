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

        @map_session_by_day = {}
        return unless @student

        index = 0
        map_course_id_by_index = {}
        @map_session_by_day = @student.sessions.each_with_object('monday' => [], 'tuesday' => [], 'wednesday' => [], 'thursday' => [], 'friday' => []) do |session, by_day|
            id = if map_course_id_by_index[session.component_id]
                     map_course_id_by_index[session.component_id]
                 else
                     map_course_id_by_index[session.component_id] = index += 1
                 end
            by_day[session.day.downcase] << {
                session: session,
                id: id
            }
        end
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
