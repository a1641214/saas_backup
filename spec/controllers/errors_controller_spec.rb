require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
    before do
        method = Rails.application.method(:env_config)
        expect(Rails.application).to receive(:env_config).with(no_args) do
            method.call.merge(
                'action_dispatch.show_exceptions' => true,
                'action_dispatch.show_detailed_exceptions' => false,
                'consider_all_requests_local' => false
            )
        end
    end

    describe 'Internal Server Error' do
        it 'returns http internal server error' do
            get :internal_server_error
            expect(response).to have_http_status(:internal_server_error)
        end
    end

    describe 'Unprocessable Entity' do
        it 'returns http unprocessable entity' do
            get :change_rejected
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

    describe 'Not Found' do
        it 'returns http not found' do
            get :not_found
            expect(response).to have_http_status(:not_found)
        end
    end
end
