class RequestFormController < ApplicationController

    def form_params
        Time.zone = 'Adelaide'
        time = Time.zone.now
        params[:request_form] = params[:request_form].merge(:date_submitted => time.to_date)
        core = "No"
        if params[:request_form]["core_yes"]
            core = "Yes"
        end
        type = RequestForm.convertType(params)
        params[:request_form] = params[:request_form].merge(:core => core)
        params[:request_form] = params[:request_form].merge(:request_type => type)
        params.require(:request_form).permit(
            :enrolment_request_id,
            :faculty,
            :comments,
            :student_id,
            :core,
            :request_type,
            :date_submitted,
        )
    end

    def index
        session[:request_form] = RequestForm.get_session_data(session[:request_form])
        @degrees = ["Software Engineering","Finance","Electronic Electricity","Telecommunication","Accounting"]
        @semester = ["Summer semester, 2017","Semester2, 2017"]
        @subject = ["COMP","MATH","C&ENVENG"]
        @courses = Course.all
        @sessions = Session.all
    end

    def create
        session[:request_form] = params[:request_form]
        error = RequestForm.check_parameters(params)
        if( error != nil )
            flash[:form_error] = error
            redirect_to "/request_form"
            return
        end
        @clash_request = ClashRequest.create(form_params)
        flash[:notice] = "Clash request from student #{params[:student_id]} was created"
        redirect_to clash_requests_path
    end
end
