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

when 'production'
    puts 'No seed data'
end
