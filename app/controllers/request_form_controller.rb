class RequestFormController < ApplicationController
    layout "request_form"
    def form_params
        Time.zone = 'Adelaide'
        time = Time.zone.now
        params[:request_form] = params[:request_form].merge(:date_submitted => time.to_date)
        params.require(:request_form).permit(
            :enrolment_request_id,
            :faculty,
            :comments,
            :student_id,
            :date_submitted
        )
    end


    def update_classes
        @classes = Session.where('component.id = ?', params[:clash_resolution][:enrolment].component.id)
        respond_to do |format|
            format.js
        end
    end

    def clash_resolution
        session[:request_form] = RequestForm.get_session_data(session[:request_form])
        @degrees = ["Software Engineering","Finance","Electronic Electricity","Telecommunication","Accounting"]
        @semester = ["Summer semester, 2017","Semester2, 2017"]
        @subject = ["COMP","MATH","C&ENVENG"]
        @courses = Course.all
        @sessions = Session.all
    end

    def unit_overload
        session[:request_form] = RequestForm.get_session_data(session[:request_form])
        session[:request_form] = RequestForm.get_session_data(session[:request_form])
        @degrees = ["Software Engineering","Finance","Electronic Electricity","Telecommunication","Accounting"]
        @semester = ["Summer semester, 2017","Semester2, 2017"]
        @subject = ["COMP","MATH","C&ENVENG"]
        @courses = Course.all
    end

    def course_full_resolution
        session[:request_form] = RequestForm.get_session_data(session[:request_form])
        @degrees = ["Software Engineering","Finance","Electronic Electricity","Telecommunication","Accounting"]
        @semester = ["Summer semester, 2017","Semester2, 2017"]
        @subject = ["COMP","MATH","C&ENVENG"]
        @courses = Course.all
    end

    def create_clash_resolution
        session[:request_form] = params[:request_form]
        error = RequestForm.check_parameters(params)
        if( error != nil )
            flash[:form_error] = error
            redirect_to "/clash_resolution"
            return
        end
        @clash_request = RequestForm.create!(form_params)
        flash[:notice] = "Clash request from student #{params[:student_id]} was created"
        redirect_to clash_requests_path
    end
end
