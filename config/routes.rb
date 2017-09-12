Rails.application.routes.draw do
    get '/clash_resolution/find_courses_from_subject_area' => 'clash_resolution#find_courses_from_subject_area', :as => :find_courses_from_subject_area
    get '/clash_resolution/find_components_and_sessions_from_course' => 'clash_resolution#find_components_and_sessions_from_course', :as => :find_components_and_sessions_from_course
    get '/clash_resolution/find_session_from_components' => 'clash_resolution#find_session_from_components', :as => :find_session_from_components
    get '/clash_resolution/find_degrees_offered' => 'clash_resolution#find_degrees_offered', :as => :find_degrees_offered

    get '/clash_resolution/find_subjects' => 'clash_resolution#find_subjects', :as => :find_subjects

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
