class ClashRequest < ActiveRecord::Base
    has_and_belongs_to_many :sessions
    belongs_to :course
    belongs_to :student
    validates_uniqueness_of :studentId
    after_create :preserve_initial

    # Serialize to use as integer array
    serialize :preserve_clash_sessions
    serialize :preserve_student_sessions

    def current_clash_session(taking_component)
        offered_session = sessions.where(component: taking_component).first
        offered_session.component_code
    end

    def add_new_request_sessions(specific_course, code_hash)
        component_codes = []
        code_hash.each do |_key, value|
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

    def preserve_initial
        ClashRequest.rebuild_preserve(id)
    end

    def self.rebuild_preserve(r_id)
        # For each preserved state, only update if there is something to update
        # There should almost always be something, but mainly useful in development
        clash_request = ClashRequest.find(r_id)

        clash_request.update(preserve_clash_sessions: clash_request.sessions.ids) if clash_request.sessions.ids
        clash_request.update(preserve_student_sessions: clash_request.student.sessions.ids) if clash_request.student

        # Commit changes
        clash_request.save
    end
    
    def self.search(query)
        where("enrolment_request_id LIKE ?", "%#{query}%") 
        where("student_id LIKE ?", "%#{query}%")
        where("date_submitted LIKE ?", "%#{query}%")
        where("faculty LIKE ?", "%#{query}%")
        where("date_submitted LIKE ?", "%#{query}%")
      end
end
