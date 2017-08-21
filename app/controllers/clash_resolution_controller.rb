class ClashResolutionController < ApplicationController
    layout 'clash_resolution'
    def form_params
        params[:clash_request] = params[:clash_request].merge(:date_submitted => Time.new.to_date)
        params.require(:clash_request).permit(
            :enrolment_request_id,
            :faculty,
            :comments,
            :student_id,
            :date_submitted
        )
    end

    def index
        @degrees = ["Software Engineering","Finance","Electronic Electricity","Telecommunication","Accounting"]
        @semester = ["Summer semester, 2017","Semester2, 2017"]
        @subject = ["COMP","MATH","C&ENVENG"]
        @courses = Course.all
    end
    
    def create
        @session[:form_request_id] = form_params[:enrolment_request_id]
        @session[:form_student_id] = form_params[:student_id]
        @session[:form_faculty] = form_params[:faculty]
        @session[:form_comments] = form_params[:comments]
        if ( ! params[:clash_request][:agree])
            flash[:form_error] = "You have to confirm you approve and understand all condition."
            redirect_to "/clash_resolution"
            return
        end
        @clash_request = ClashRequest.create!(form_params)
        flash[:notice] = "Clash request from student #{form_params[:student_id]} was created"
        redirect_to clash_requests_path
    end
    
end
