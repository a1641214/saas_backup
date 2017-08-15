class ClashRequest < ActiveRecord::Base
    has_and_belongs_to_many :sessions
    belongs_to :course
    belongs_to :student

    after_create :preserve_initial

    # Serialize to use as integer array
    serialize :preserve_clash_sessions
    serialize :preserve_student_sessions
    serialize :preserve_student_courses

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

    def preserve_initial()
        if sessions
            update_attribute(:preserve_clash_sessions, sessions.ids)
        end

        if course
            update_attribute(:preserve_clash_course, course.id)
        end

        if student
            update_attribute(:preserve_student_sessions, student.sessions.ids)
            update_attribute(:preserve_student_courses, student.courses.ids)
        end

        self.save

    end
end
