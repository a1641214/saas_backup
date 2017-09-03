Rails.application.routes.draw do
    resources :clash_requests
    root to: 'clash_requests#index'

    get 'clash_resolution/update_classes', as: 'update_classes'

    get 'send_email', to: 'clash_requests#send_email', as: :send_email
    get 'confirmation' => 'clash_requests#confirmation', :as => :confirmation
    get 'demo' => 'demo#index', :as => :demo

    # clash_form
    get 'clash_resolution' => 'request_form#clash_resolution'
    get 'unit_overload' => 'request_form#unit_overload'
    get 'course_full_resolution' => 'request_form#course_full_resolution'
    post 'clash_resolution' => 'request_form#create_clash_resolution'

    # Error pages
    match '/404', to: 'errors#not_found', via: :all
    match '/422', to: 'errors#unprocessable_entity', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all
end
