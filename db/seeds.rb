# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
home = Page.create(name:"home")
about = Page.create(name:"about us")

videos = Gallery.create(name:"Videos")
images = Gallery.create(name:"Images")
# images.files.attach(io: File.open(Rails.root.join("public/dog-placeholder.png")), filename: 'dog-placeholder.png')
# videos.files.attach(io: File.open(Rails.root.join("storage/oceans.mp4")), filename: 'oceans.mp4')
videos.save
admin = User.create(name:"Admin",email:"test@test.com", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(name:"Cynthia Kepler-Karrer",email:"pastor.cynthia@earthlink.net", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(name:"Clayton Karrer",email:"	karrerct@sbcglobal.net", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(name:"Kendall Smith",email:"kendallsmith@accentfoods.com", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(name:"Mark Corry",email:"mark@corrywood.net", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")

demo_course = Course.create(name:"Demo Course", description:"Example of Course Capabilities", summary:"This is an example of the features included for course development",price:Money.new(0, 'USD')*100)
example_chapter = demo_course.chapters.create(name:"Example Chapter")
lesson = demo_course.lessons.create(name:"Test Lesson", chapter:example_chapter)
lesson.save
name = Faker::Name.name
email = name.split(" ").join('.').downcase.delete(?').split(' ').join('.')+"@"+Faker::Internet.domain_name(domain: "example")
pass = "temp1234"
student = User.create(name:name,email:email, password:pass, password_confirmation:pass, user_type:"student")

admin = User.create(name:"Admin",email:"test@test.com", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
puts student.email
demo_course.enroll(student)
demo_course.save
Article.create({title:"Test Article", content:Faker::Lorem.paragraph(sentence_count:30)})
Article.create({title:"Another Article", content:Faker::Lorem.paragraph(sentence_count:30)})
