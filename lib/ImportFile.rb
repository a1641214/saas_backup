# Use python2
# Data
# Use this class to collect all the scattered csv file data into
# a format with can use later tht matches our database
#
# Authors:
# Jacob Gonzalez
# .

require 'csv'

module ImportFile
    class Course
        def initialize(id, name, catalog_number)
            @id = id
            @name = name
            @catalog_number = catalog_number
            @components = Array.new
        end
        # print as a csv row
        def __repr__()
            return @id + "," + @name + "," + @catalog_number
        end
        # test equality against another course
        def __eq__(other)
            return @id == other.id
        end
        # get and assign value
        def id
            @id
        end
        def name
            @name
        end
        def catalog_number
            @catalog_number
        end
        def components
            @components
        end
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
        def __repr__()
            return @type
        end
        def __eq__(other)
            return @type == other.type
        end

        # get and assign value
        def id
            return @id
        end
        def type
            return @type
        end
        def assign_id(value)
            @id = value
        end
        def assign_type(value)
            @type = value
        end
    end

    class Session
        def initialize(time, day, weeks, length, component_code, course_id)
            @time = time
            @day = day
            @weeks = weeks
            @length = length
            @component_code = component_code
            @course_id = course_id
        end

        # get values
        attr_reader :time

        attr_reader :day

        attr_reader :weeks

        attr_reader :length

        attr_reader :component_code

        attr_reader :course_id
    end


    # import courses from the course catalog
    def self.importCourses(filename)
        courses = Array.new
        CSV.foreach(filename,headers: true, encoding: 'iso-8859-1:utf-8') do |row|
            id = row[1]
            name = row[4]
            course = Course.new(id,name,nil)
            courses.append(course)
        end
        return courses
    end

    # fill offering cataglog numbers from the offerings csv
    def self.fillCourseOfferings(filename, courses)
        CSV.foreach(filename,headers: true, encoding: 'iso-8859-1:utf-8') do |row|
            id = row[1]
            courses.each do |course|
                if (course.id == id)
                    # COMPSCI 3005
                    course.assign_catalog_number(row[4] + " " + row[5])
                end
            end
        end
    end

    # read in all the components and link them to their courses
    def self.importComponentsAndLink(filename, courses)
        components = nil
        CSV.foreach(filename, :headers => true) do |row|
            id = row[1]
            type = row[9]
            component = Component.new(id, type)
            # link component and course
            courses.each do |course|
                if (course.id == id)
                    components = course.components
                    has_components = false
                    components.each do |component1|
                        if( component.__eq__(component1) )
                            has_components = true
                        end
                    end
                    if(! has_components)
                        components.append(component)
                    end
                end
            end
        end
        return components
    end

    CONST_DAYS_ARRAY = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
    # Import the session activity data
    def self.importSessions(filename)
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
                if val == 1
                    sessions.push(Session.new(time, CONST_DAYS_ARRAY[index], weeks_array, length, component_code, course_id))
                end
            end
        end
        sessions
    end

end
