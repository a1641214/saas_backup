# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

case Rails.env
when 'development', 'test'
    # Create courses
    c1 = Course.create(name: 'Engineering Software as Services I', catalogue_number: 'COMP SCI 3003')
    c2 = Course.create(name: 'Engineering Software as Services II', catalogue_number: 'COMP SCI 3004')
    c3 = Course.create(name: 'Object Oriented Programming', catalogue_number: 'COMP SCI 1102')
    c4 = Course.create(name: 'Soils and Landscapes I', catalogue_number: 'SOIL&WAT 1000WT')

    

    # Create components
    comp1 = Component.create(class_type: 'Lecture')
    comp2 = Component.create(class_type: 'Tutorial')
    c1.components.push(comp1)
    c1.components.push(comp2)
    comp3 = Component.create(class_type: 'Lecture')
    comp4 = Component.create(class_type: 'Workshop')
    c2.components.push(comp3)
    c2.components.push(comp4)
    comp5 = Component.create(class_type: 'Lecture')
    comp6 = Component.create(class_type: 'Workshop')
    comp7 = Component.create(class_type: 'Practical')
    c3.components.push(comp5)
    c3.components.push(comp6)
    c3.components.push(comp7)

    comp8 = Component.create(class_type: 'Lecture')
    comp9 = Component.create(class_type: 'Practical')
    c4.components.push(comp8)
    c4.components.push(comp9)

    # create sessions
    s1 = Session.create(time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp1)
    s2 = Session.create(time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Wednesday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp1)
    s3 = Session.create(time: Time.new(2017, 1, 1, 12, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "TU01", component: comp2)
    s4 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1,3,5,7,9,11], component_code: "TU02", component: comp2)

    s5 = Session.create(time: Time.new(2017, 1, 1, 9, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp3)
    s6 = Session.create(time: Time.new(2017, 1, 1, 14, 0, 0, '+09:30'), length: 3, day: 'Tuesday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "WR01", component: comp4)

    s7 = Session.create(time: Time.new(2017, 1, 1, 10, 0, 0, '+09:30'), length: 1, day: 'Monday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp5)
    s8 = Session.create(time: Time.new(2017, 1, 1, 15, 0, 0, '+09:30'), length: 1, day: 'Wednesday', weeks: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], component_code: "LE01", component: comp5)
    s9 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Friday', weeks: [2,4,6,8,10,12], component_code: "WR01", component: comp6)
    s10 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Thursday', weeks: [1,3,5,7,9,11], component_code: "WR02", component: comp6)
    s11 = Session.create(time: Time.new(2017, 1, 1, 9, 0, 0, '+09:30'), length: 2, day: 'Wednesday', weeks: [2,4,6,8,10,12], component_code: "PR01", component: comp7)
    s12 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Wednesday', weeks: [2,4,6,8,10,12], component_code: "PR02", component: comp7)

    s13 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "LE01", component: comp8)
    s14 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "PR01", component: comp9)
    s15 = Session.create(time: Time.new(2017, 1, 1, 11, 0, 0, '+09:30'), length: 2, day: 'Monday', weeks: [2,4,6,8,10,12], component_code: "PR02", component: comp9)

    # create students
    stud1 = Student.create(id: 1111111)
    stud1.courses.push(c1)
    stud1.courses.push(c3)
    stud1.sessions.push(s1)
    stud1.sessions.push(s2)
    stud1.sessions.push(s3)
    stud1.sessions.push(s7)
    stud1.sessions.push(s8)
    stud1.sessions.push(s10)
    stud1.sessions.push(s12)

    stud2 = Student.create(id: 1111112)
    stud2.courses.push(c2)
    stud2.sessions.push(s5)
    stud2.sessions.push(s6)
    stud1.sessions.push(s7)
    stud1.sessions.push(s8)
    stud1.sessions.push(s11)
    
    clash1 = ClashRequest.create(faculty: "Engineering", student: stud1, course: c4)
    clash2 = ClashRequest.create(faculty: "Engineering", student: stud2, course: c4)
    
    clash1.sessions.push(s13)
    clash1.sessions.push(s15)
    
    clash2.sessions.push(s13)
    clash2.sessions.push(s15)
when 'production'
    puts 'No seed data'
end
