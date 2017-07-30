class ClashRequestsController < ApplicationController
    def request_params
        params.require(:clash_request).permit(:studentId, :comments)
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
end
