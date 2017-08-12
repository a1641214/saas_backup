class ClashRequest < ActiveRecord::Base
    has_and_belongs_to_many :sessions
    belongs_to :course
    belongs_to :student 
    
    def current_clash_session(taking_component)
        offered_session = sessions.where(component: taking_component).first
        return offered_session.component_code
    end
   
    def add_new_request_sessions(specific_course, code_hash)
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
