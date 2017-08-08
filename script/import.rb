# ported to ruby by: Jacob Gonzalez
# Use this class to collect all the scattered csv file data into
# a format with can use later tht matches our database
#
# Authors:
# Jacob Gonzalez
# .

require 'csv'

# course class that fits the ruby model
# replace this with the ruby model
class Course
    attr_accessor :id
    attr_accessor :name
    attr_accessor :catalog_number
    attr_accessor :components

    def initialize(id, name, catalog_number)
        @id = id
        @name = name
        @catalog_number = catalog_number
        @components = []
    end
end

# component links courses and sessions
# e.g. LEC, TUT, etc
class Component
    attr_accessor :id
    attr_accessor :type

    def initialize(id, type)
        @id = id
        @type = type
    end
end

# import courses from the course catalog
def importCourses(filename)
    courses = {}
    # each row is a new course
    CSV.foreach(filename, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
        id = row[1]
        name = row[4]
        course = Course.new(id, name, "")
        courses[id] = course
    end
    return courses
end

# fill offering cataglog numbers from the offerings csv
def fillCourseOfferings(filename, courses)
    CSV.foreach(filename, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
        id = row[1]
        if courses.has_key? id
            # e.g. COMPSCI 3005
            courses[id].catalog_number = "#{row[4]} #{row[5]}"
        end
    end
end

# read in all the components and link them to their courses
def importComponentsAndLink(filename, courses)
    components = []
    CSV.foreach(filename, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
        id = row[1]
        type = row[-1]
        component = Component.new(id, type)
        if courses.has_key? id
            course = courses[id]
            # e.g. COMPSCI 3005
            unless course.components.include? component
                course.components.push component
                components.push component
            end
        end
    end
    return components
end

# read and import the files
directory = 'db/csv'
courses = importCourses "#{directory}/CM_CRSE_CAT_ECMS-6383074.csv"
fillCourseOfferings "#{directory}/CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv", courses
components = importComponentsAndLink("#{directory}/CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv", courses)

# print them for now
courses.each do |id, course|
    puts "#{id},#{course.name},#{course.catalog_number}"
    puts "\t#{course.components.map{|c| c.type}.join(',')}"
end
