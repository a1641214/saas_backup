# Use this class to collect all the scattered csv file data into
# a format with can use later tht matches our database
#
# Authors:
# Jacob Gonzalez
# Zetong Wang
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
end
