class Student < ActiveRecord::Base
    has_and_belongs_to_many :courses
    has_and_belongs_to_many :sessions
    
    def current_session(taking_component)
        offered_session = sessions.where(component: taking_component).first
        return offered_session.component_code
    end
    
    def current_courses()
        array = Array.new
        courses.each do |course|
            array << (course.catalogue_number)
        end
        return array
    end
    
    def add_new_sessions(specific_course, code_hash)
        component_codes = Array.new
        class_type = Array.new
        code_hash.each do |key, value|
            component_codes << value
        end
        specific_course.components.each do |comp|
            comp.sessions.each do |sess|
                if component_codes.include?(sess.component_code)
                    sessions << sess
                end
            end
        end
    end
end
