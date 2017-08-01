class ClashRequestsController < ApplicationController
    def request_params
        params.require(:clash_request).permit(
            :enrolment_request_id,
            :studentId,
            :date_submitted,
            :faculty,
            :comments
        )
    end

    def new; end

    def create
        @request = ClashRequest.create!(request_params)
        flash[:notice] = "Clash request from student #{@request.studentId} was created"
        redirect_to clash_requests_path
    end

    def index
        @requests = ClashRequest.all
    end

    def show
        @request = ClashRequest.find(params[:id])
    end

    def destroy
        @request = ClashRequest.find(params[:id])

        @request.update!(inactive: true)

        flash[:notice] = "Clash Request from student #{@request.studentId} was made inactive"
        redirect_to clash_requests_path
    end
end
