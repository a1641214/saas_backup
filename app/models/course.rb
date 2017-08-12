class Course < ActiveRecord::Base
    validates_presence_of :name, :catalogue_number
    has_and_belongs_to_many :components
    has_and_belongs_to_many :students
    has_many :clash_requests
    
    
    def alternate_sessions(current_student, comp)
        target_component = components.where(id: comp.id).first
        alt_sessions = target_component.sessions
        arr = Array.new
        arr << current_student.current_session(comp)
        alt_sessions.each do |sess|
            if !arr.include?(sess.component_code)
                arr << sess.component_code
            end
        end
        return arr
    end
    
    def alternate_sessions_clash_course(cl_request,comp)
        target_component = components.where(id: comp.id).first
        alt_sessions = target_component.sessions
        arr = Array.new
        arr << cl_request.current_clash_session(comp)
        alt_sessions.each do |sess|
            if !arr.include?(sess.component_code)
                arr << sess.component_code
            end
        end
        return arr 
    end
end
