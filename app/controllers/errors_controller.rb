class ErrorsController < ApplicationController
    def internal_server_error
        render(status: :internal_server_error)
    end

    def change_rejected
        render(status: :change_rejected)
    end

    def not_found
        render(status: :not_found)
    end
end
