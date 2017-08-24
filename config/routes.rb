Rails.application.routes.draw do
    resources :clash_requests
    root to: 'clash_requests#index'

    get 'demo' => 'demo#index', :as => :demo
    # Error pages
    match '/404', to: 'errors#not_found', via: :all
    match '/422', to: 'errors#unprocessable_entity', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all
end
