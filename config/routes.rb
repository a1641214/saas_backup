Rails.application.routes.draw do
    resources :clash_requests
    resources :clash_resolution
    root to: 'clash_requests#index'

    get 'clash_resolution/update_classes', as: 'update_classes'

    get 'send_email', to: 'clash_requests#send_email', as: :send_email
    get 'confirmation' => 'clash_requests#confirmation', :as => :confirmation
    get 'demo' => 'demo#index', :as => :demo
    # Error pages
    match '/404', to: 'errors#not_found', via: :all
    match '/422', to: 'errors#unprocessable_entity', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all
end
