# Use this class to collect all the scattered csv file data into
# a format with can use later that matches our database
#
# Authors:
# Jacob Gonzalez
# Markus Andersons
# Zetong Wang
# Huey Min Gan

require 'csv'

module ImportFile
    # Temnplate classes
    class Course
        def initialize(id, name, catalog_number)
            @id = id
            @name = name
            @catalog_number = catalog_number
            @components = []
        end

        # print as a csv row
        def __repr__
            @id + ',' + @name + ',' + @catalog_number
        end

        # test equality against another course
        def __eq__(other)
            @id == other.id
        end

        # get and assign value
        attr_reader :id
        attr_reader :name
        attr_reader :catalog_number
        attr_reader :components

        def assign_id(value)
            @id = value
        end

        def assign_name(value)
            @name = value
        end

        def assign_catalog_number(value)
            @catalog_number = value
        end
    end

    class Component
        def initialize(id, type)
            @id = id
            @type = type
        end

        def __repr__
            @type
        end

        def __eq__(other)
            @type == other.type
        end

        # get and assign value
        attr_reader :id
        attr_reader :type

        def assign_id(value)
            @id = value
        end

        def assign_type(value)
            @type = value
        end
    end

    class Student
        def initialize(id, term, class_nbr, status, courses)
            @id = id
            @term = term
            @class_nbr = class_nbr
            @status = status
            @courses = courses
        end

        attr_reader :id
        attr_reader :term
        attr_reader :class_nbr
        attr_reader :status
        attr_reader :courses
    end

    class Class
        def initialize(term, course_id, class_nbr)
            @term = term
            @course_id = course_id
            @class_nbr = class_nbr
        end

        attr_reader :term
        attr_reader :course_id
        attr_reader :class_nbr
    end

    class Session
        def initialize(time, day, weeks, length, component_code, course_id, capacity)
            @time = time
            @day = day
            @weeks = weeks
            @length = length
            @component_code = component_code
            @course_id = course_id
            @capacity = capacity
        end

        # get values
        attr_reader :time
        attr_reader :day
        attr_reader :weeks
        attr_reader :length
        attr_reader :component_code
        attr_reader :course_id
        attr_reader :capacity
    end

    # import courses from the course catalog
    def self.import_courses(filename)
        courses = []
        CSV.foreach(filename, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
            id = row[1]
            name = row[4]
            course = Course.new(id, name, nil)
            courses.append(course)
        end
        courses
    end

    # fill offering cataglog numbers from the offerings csv
    def self.fill_course_offerings(filename, courses)
        CSV.foreach(filename, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
            id = row[1]
            courses.each do |course|
                if course.id == id
                    # COMPSCI 3005
                    course.assign_catalog_number(row[4] + ' ' + row[5])
                end
            end
        end
    end

    # read in all the components and link them to their courses
    def self.import_components_and_link(filename, courses)
        components = nil
        CSV.foreach(filename, headers: true) do |row|
            id = row[1]
            type = row[9]
            component = Component.new(id, type)
            # link component and course
            courses.each do |course|
                next unless course.id == id
                components = course.components
                has_components = false
                components.each do |component1|
                    has_components = true if component.__eq__(component1)
                end
                components.append(component) unless has_components
            end
        end
        components
    end

    CONST_DAYS_ARRAY = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
    # Import the session activity data
    def self.import_sessions(filename)
        sessions = []
        CSV.foreach(filename, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
            weeks_bin = row[13].to_i
            scheduled_time = row[16]
            break if scheduled_time == '' || scheduled_time.nil?
            days_bin = scheduled_time.scan(/[$]\d+[$]/)[1][1..-2].to_i
            time_bin = scheduled_time.scan(/[$]\d+[$]/)[2][1..-2].to_i
            days_array = (0...days_bin.bit_length).map { |n| days_bin[n] }
            time_array = (0...time_bin.bit_length).map { |n| time_bin[n] }
            weeks_array = (0...weeks_bin.bit_length).map { |n| weeks_bin[n] }.reverse
            course_id = row[6][2, 6]
            length = row[12] # duration of class in minutes
            component_code = row[1][-8..-1]
            component_code = component_code[0, 2] + component_code[-2, 2]
            capacity = row[5].to_i
            # determine time
            start_hours = -1
            start_minutes = -30
            time_array.each_with_index do |val, index|
                start_hours += 1 if index.even?
                start_minutes = (start_minutes + 30) % 60
                break if val == 1
            end
            time = Time.new(2017, 1, 1, start_hours, start_minutes, 0, '+09:30')

            # determine day
            days_array.each_with_index do |val, index|
                next unless val == 1
                sessions.push(Session.new(time, CONST_DAYS_ARRAY[index],
                                          weeks_array, length, component_code,
                                          course_id, capacity))
            end
        end
        sessions
    end

    # import students
    def self.import_students(filename)
        students = []
        CSV.foreach(filename, headers: true) do |row|
            id = row[0]
            term = row[1]
            class_nbr = row[2]
            status = row[3]
            courses = []
            # append to array only if the student is enrolled
            if status != 'D'
                student = Student.new(id, term, class_nbr, status, courses)
                students.append(student)
            end
        end
        students
    end

    # import classes
    def self.import_classes(filename)
        classes = []
        CSV.foreach(filename, headers: true) do |row|
            term = row[0]
            course_id = row[1]
            class_nbr = row[3]
            class1 = Class.new(term, course_id, class_nbr)
            classes.append(class1)
        end
        classes
    end

    # fill student.courses array
    def self.fill_students_with_courses(students, classes, courses)
        students.each do |student_row|
            classes.each do |class_row|
                next if student_row.class_nbr == class_row.class_nbr && student_row.term == class_row.term
                courses.each do |course_row|
                    if course_row.id == class_row.course_id
                        student_row.courses.append(course_row)
                        break
                    end
                end
            end
        end
    end
end
