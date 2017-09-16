require 'mail'
class ClashRequestsController < ApplicationController
    def request_params
        Time.zone = 'Adelaide'
        time = Time.zone.now
        params[:clash_request] = params[:clash_request].merge(date_submitted: time.to_date)
        params.require(:clash_request).permit(
            :enrolment_request_id,
            :date_submitted,
            :faculty,
            :comments,
            :student_id,
            :email
        )
    end

    def new; end

    def create
        if Student.where(id: params[:clash_request]['student']).empty?
            flash[:notice] = 'The form was filled out incorrectly. Please try again'
            redirect_to clash_requests_path
            return
        end
        if params[:clash_request]['subject'].eql?('Select a Subject')
            flash[:notice] = 'The form was filled out incorrectly. Please try again'
            redirect_to clash_requests_path
            return
        end

        if params[:clash_request]['course'].eql?('-1')
            flash[:notice] = 'The form was filled out incorrectly. Please try again'
            redirect_to clash_requests_path
            return
        end

        # clash_degree = params[:clash_request]['degree']
        # clash_semester = params[:clash_request]['semester']
        # clash_subject = params[:clash_request]['subject']
        clash_course = Course.find(params[:clash_request]['course'])
        clash_student = Student.find(params[:clash_request]['student'])
        clash_comments = params[:clash_request]['comments']
        clash_faculty = 'ECMS'
        clash_sessions = []
        comps_to_get = clash_course.components
        invalid_course = false
        comps_to_get.each do |comp|
            type = comp.class_type
            session_form_id = params[:clash_request][type]

            if session_form_id.eql?('-1')
                flash[:notice] = 'The form was filled out incorrectly. Please try again'
                invalid_course = true
            end
            next if invalid_course
            clash_session = Session.find(session_form_id)
            session_component_code = clash_session.component_code
            same_sessions = comp.sessions.where(component_code: session_component_code)
            same_sessions.each do |sess|
                clash_sessions << sess
            end
        end

        if invalid_course
            redirect_to clash_requests_path
            return
        end

        @clash_request = ClashRequest.create!(student_id: clash_student.id, course_id: clash_course.id, sessions: clash_sessions, comments: clash_comments, faculty: clash_faculty)
        flash[:notice] = "Clash request from student #{@clash_request.student_id} was created"
        redirect_to clash_requests_path
    end

    def index
        @clash_requests = ClashRequest.all
        @clash_requests = @clash_requests.search(params[:search]) if params[:search]
        @clash_requests = @clash_requests.where('inactive = ?', false) if params[:order] == 'active'
        @clash_requests = @clash_requests.where('inactive = ?', true) if params[:order] == 'inactive'
    end

    def show
        @clash_request = ClashRequest.find params[:id]

        # Load serialised data into nicer format
        old_student_sessions = @clash_request.preserve_student_sessions.map do |session|
            Session.find(session)
        end

        old_clash_sessions = @clash_request.preserve_clash_sessions.map do |session|
            Session.find(session)
        end

        @enrol_info = { enrolment: {}, request: {} }

        # Current Enrolment (with proposed changes)
        @clash_request.student.courses.each do |course|
            @enrol_info[:enrolment][course] = {}
            course.components.each do |component|
                details = {}
                old_session = (old_student_sessions & component.sessions).first
                new_session = (@clash_request.student.sessions & component.sessions).first
                details[:type] = component.class_type
                details[:org_code] = old_session.component_code
                details[:org_nbr] = old_session.component.class_numbers[details[:org_code]]
                details[:new_code] = new_session.component_code
                details[:new_nbr] = old_session.component.class_numbers[details[:new_code]]

                @enrol_info[:enrolment][course][component] = details
            end
        end

        # Requested course
        @clash_request.course.components.each do |component|
            details = {}
            old_session = (@clash_request.sessions & component.sessions).first
            new_session = (old_clash_sessions & component.sessions).first
            details[:type] = component.class_type
            details[:org_code] = old_session.component_code
            details[:org_nbr] = old_session.component.class_numbers[details[:org_code]]
            details[:new_code] = new_session.component_code
            details[:new_nbr] = old_session.component.class_numbers[details[:new_code]]

            @enrol_info[:request][component] = details
        end
    end

    def destroy
        @clash_request = ClashRequest.find(params[:id])
        @clash_request.update!(inactive: !@clash_request.inactive)
        flash[:notice] = "Clash Request from student #{@clash_request.studentId} was made #{@clash_request.inactive ? 'inactive' : 'active'}"
        redirect_to clash_requests_path
    end

    def edit
        @clash_request = ClashRequest.find params[:id]
        @student = @clash_request.student

        @map_session_by_day = {}
        return unless @student

        # find clashes
        all_sessions = Session.all_request_student_sessions(@clash_request, @student)
        clash_hash = Session.detect_clashes(all_sessions)
        @clashes = {}
        clash_hash.each do |clash_session, clashes_with|
            next if clashes_with.nil?
            clash = { max_class: clash_session, max_length: clash_session.length, other_sessions: [] }
            clashes_with.each do |a_clash|
                next unless a_clash.length > clash[:max_length]
                clash[:other_sessions].concat [clash[:max_class]]
                clash[:max_class] = a_clash
                clash[:max_length] = a_clash.length
            end
            @clashes[clash_session] = clash
        end

        # map sessions to day
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
                requested: false,
                clashes: @clashes[session]
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
                requested: true,
                clashes: @clashes[session]
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

    def confirmation; end

    def send_email
        EnrolmentMailer.enrolment_email(1111111).deliver_now
        redirect_to clash_requests_path
    end
end
