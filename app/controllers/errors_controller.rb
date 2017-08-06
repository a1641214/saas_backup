class ErrorsController < ApplicationController
    def internal_server_error
        render(status: :internal_server_error)
    end

    def unprocessable_entity
        render(status: :unprocessable_entity)
    end

    def not_found
        render(status: :not_found)
    end
end
