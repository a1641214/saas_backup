require 'import_file'
require 'activerecord-import'

ActiveRecord::Import.require_adapter('mysql2')

class DemoController < ApplicationController
    def index
        @path = 'db/csv/'
        @courses = ImportFile.import_courses(@path + 'CM_CRSE_CAT_ECMS-6383074.csv')
        ImportFile.fill_course_offerings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', @courses)
        ImportFile.import_components_and_link(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv', @courses)
        sessions = ImportFile.import_sessions(@path + 'SPActivity_2017.csv')

        return unless Course.count.zero?

        # using activerecord-import to batch create objects to avoid N+1 problem
        batch_courses = []
        batch_components = []
        batch_sessions = []

        # push courses into database objects
        @courses.each do |_, course|
            # create a course entry
            c = Course.new(id: course.id,
                           name: course.name,
                           catalogue_number: course.catalog_number)

            # create components and link to the courses
            course.components.each do |component|
                comp = Component.new(class_type: component.type)
                c.components << comp
                batch_components << comp
            end

            batch_courses << c
        end

        # push sessions into database objects
        sessions.each do |session|
            begin
                course = Course.find(session.course_id)
                course.components.each do |component|
                    next unless component.class_type[0, 2] == session.component_code[0, 2]
                    s = Session.new(component: component,
                                    time: session.time,
                                    day: session.day,
                                    weeks: session.weeks,
                                    length: session.length,
                                    capacity: session.capacity,
                                    component_code: session.component_code)
                    batch_sessions << s
                end
            rescue ActiveRecord::RecordNotFound
                puts 'Course with id ' + session.course_id.to_s + ' does not exist!'
            end
        end

        # batch create all the courses from the arrays
        Course.import batch_courses
        Component.import batch_components
        Session.import batch_sessions
    end

    def display_student
        @path = 'db/csv/'
        @courses = ImportFile.import_courses(@path + 'CM_CRSE_CAT_ECMS-6383074.csv')
        ImportFile.fill_course_offerings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', @courses)
        ImportFile.import_components_and_link(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv', @courses)
        @students = ImportFile.import_students(@path + 'EN_BY_CLASS_ECMS-6384857.csv')
        @classes = ImportFile.import_classes(@path + 'CLS_CMBND_SECT_FULL-6385825.csv')
        ImportFile.fill_students_with_courses(@students, @classes, @courses)
    end

    def student_object
        @students.each do |student|
            Student.create(student.id)
        end
    end
end
