class ClashResolutionController < ApplicationController
    def form_params
        Time.zone = 'Adelaide'
        time = Time.zone.now
        params[:clash_resolution] = params[:clash_resolution].merge(date_submitted: time.to_date)
        params.require(:clash_resolution).permit(
            :enrolment_request_id,
            :faculty,
            :comments,
            :student_id,
            :date_submitted
        )
    end

    def new
        # to do: add degrees, semester, subject attribute in database.
        session[:clash_resolution] = ClashResolution.get_session_data(session[:clash_resolution])
        @degrees = ['Select a Degree', 'BE(Hons)(Petro) & BSc(Physics)', 'Scandinavian Studies ', 'BE(Honours)(Mech-Comp)', 'Engineering Enabling', 'BE(Honours)(SustEnergy-Mech)']
        @semester = ['Select a Semester', 'Summer Semester, 2017', 'Semester 1, 2017', 'Winter Semester, 2017', 'Semester 2, 2017']
        @courses = []
        @sessions = []
        @subjects = ['Select a Subject']
        @faculties = ['ECMS']
    end

    def index
        # to do: add degrees, semester, subject attribute in database.
        session[:clash_resolution] = ClashResolution.get_session_data(session[:clash_resolution])
        @degrees = ['Select a Degree', 'BE(Hons)(Petro) & BSc(Physics)', 'Scandinavian Studies ', 'BE(Honours)(Mech-Comp)', 'Engineering Enabling', 'BE(Honours)(SustEnergy-Mech)']
        @semester = ['Select a Semester', 'Summer Semester, 2017', 'Semester 1, 2017', 'Winter Semester, 2017', 'Semester 2, 2017']
        @courses = []
        @sessions = []
        @subjects = ['Select a Subject']
        @faculties = ['ECMS']
    end

    def update_classes
        @classes = Session.where('component.id = ?', params[:clash_resolution][:enrolment].component.id)
        respond_to do |format|
            format.js
        end
    end

    def show; end

    def create
        session[:clash_resolution] = params[:clash_resolution]
        error = ClashResolution.check_parameters(params)
        unless error.nil?
            flash[:form_error] = error
            redirect_to '/clash_resolution'
            return
        end
        @clash_request = ClashRequest.create!(form_params)
        flash[:notice] = "Clash request from student #{params[:clash_resolution][:student_id]} was created"
        redirect_to clash_requests_path
    end

    def find_courses_from_subject_area
        subject_area = params[:area_code]
        select_courses = Course.search_by_area(subject_area).as_json
        respond_to do |format|
            format.json do
                render json: select_courses
            end
        end
    end

    class JsonSessions
        def initialize(name)
            @component_name = name
            @component_sessions = []
        end
        attr_reader :component_name
        attr_reader :component_sessions
    end

    def find_components_and_sessions_from_course
        id = params[:selected_id]
        if id.eql?('-1')
            empty_array = []
            empty_array.as_json
            respond_to do |format|
                format.json do
                    render json: empty_array
                end
            end
            return
        end

        component_session_join = []
        select_course = Course.find(id)
        select_components = select_course.components
        select_components.each do |comp|
            js = JsonSessions.new(comp.class_type)
            indv_sessions = comp.unique_sessions
            indv_sessions.each do |sess|
                js.component_sessions << sess
            end
            component_session_join << js
        end
        component_session_join.as_json
        respond_to do |format|
            format.json do
                render json: component_session_join
            end
        end
    end

    def find_degrees_offered
        degree_array = ['BE(Hons)(Petro) & BSc(Physics)', 'Scandinavian Studies ', 'BE(Honours)(Mech-Comp)', 'Engineering Enabling', 'BE(Honours)(SustEnergy-Mech)'].as_json
        respond_to do |format|
            format.json do
                render json: degree_array
            end
        end
    end

    def find_subjects
        subject_array = Course.all_subject_areas.as_json
        respond_to do |format|
            format.json do
                render json: subject_array
            end
        end
    end
end
