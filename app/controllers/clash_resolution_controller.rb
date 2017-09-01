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

    def index
        # to do: add degrees, semester, subject attribute in database.
        session[:clash_resolution] = ClashResolution.get_session_data(session[:clash_resolution])
        @degrees = ['Software Engineering', 'Finance', 'Electronic Electricity', 'Telecommunication', 'Accounting']
        @semester = ['Summer Semester, 2017', 'Semester 1, 2017', 'Winter Semester, 2017', 'Semester 2, 2017']
        @subjects = ['COMP', 'MATH', 'C&ENVENG']
        @courses = Course.all
        @sessions = Session.all
    end

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
end
