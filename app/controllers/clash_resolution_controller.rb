class ClashResolutionController < ApplicationController
    def form_params
        params[:clash_resolution] = params[:clash_resolution].merge(:date_submitted => Time.new.to_date)
        params.require(:clash_resolution).permit(
            :enrolment_request_id,
            :faculty,
            :comments,
            :student_id,
            :date_submitted
        )
    end

    def index
        session[:clash_resolution] = ClashResolution.getSessionData(session[:clash_resolution])
        @degrees = ["Software Engineering","Finance","Electronic Electricity","Telecommunication","Accounting"]
        @semester = ["Summer semester, 2017","Semester2, 2017"]
        @subject = ["COMP","MATH","C&ENVENG"]
        @courses = Course.all
    end
    
    def create
        session[:clash_resolution] = params[:clash_resolution]
        error = ClashResolution.checkParameters(params)
        if( error != nil )
            flash[:form_error] = error
            redirect_to "/clash_resolution"
            return
        end
        @clash_request = ClashRequest.create!(form_params)
        flash[:notice] = "Clash request from student #{params[:student_id]} was created"
        redirect_to clash_requests_path
    end
    
end
