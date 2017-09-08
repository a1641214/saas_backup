class Component < ActiveRecord::Base
    serialize :class_numbers
    validates_presence_of :class_type
    has_many :sessions
    has_and_belongs_to_many :courses

    def search_sessions_by_component
        return self.sessions
    end

    def unique_sessions
        all_sessions = self.sessions
        session_array = []
        component_code_array = []
        all_sessions.each do |sess|
            if !component_code_array.include?(sess.component_code)
                session_array << sess
                component_code_array << sess.component_code
            end
        end
        return session_array
    end
end
