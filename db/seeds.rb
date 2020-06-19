# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
home = Page.create(name:"home")
events = Page.create(name:"events")

videos = Gallery.create(name:"Videos")
images = Gallery.create(name:"Images")
# images.files.attach(io: File.open(Rails.root.join("public/dog-placeholder.png")), filename: 'dog-placeholder.png')
# videos.files.attach(io: File.open(Rails.root.join("storage/oceans.mp4")), filename: 'oceans.mp4')
videos.save
# admin = User.create(first_name:"Cynthia",last_name:"Kepler-Karrer",email:"pastor.cynthia@earthlink.net", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(first_name:"Clayton",last_name:"Karrer",email:"	karrerct@sbcglobal.net", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(first_name:"Kendall",last_name:"Smith",email:"kendallsmith@accentfoods.com", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")
# admin = User.create(first_name:"Mark",last_name:"Corry",email:"mark@corrywood.net", password:"temp1234", password_confirmation:"temp1234", user_type:"admin")

demo_course = Course.create(name:"Demo Course", description:"Example of Course Capabilities", summary:"This is an example of the features included for course development",price:Money.new(1, 'USD')*100)
example_chapter = demo_course.chapters.create(name:"Example Chapter")
lesson = demo_course.lessons.create(name:"Test Lesson", chapter:example_chapter)
lesson.save
first_name = Faker::Name.first_name
last_name = Faker::Name.last_name
email = [first_name,last_name].join('.').downcase.delete(?').split(' ').join('.')+"@"+Faker::Internet.domain_name(domain: "example")
pass = "temp1234"
admin = User.create(
  first_name:"Admin",
  last_name:"Admin",
  email:"test@test.com",
  password:"temp1234",
  password_confirmation:"temp1234",
  user_type:"admin"
)
student = User.create(first_name:first_name,last_name:last_name,email:email, password:pass, password_confirmation:pass, user_type:"student")

demo_course.enroll(student)
demo_course.save
Article.create({title:"Test Article", content:Faker::Lorem.paragraph(sentence_count:30)})
Article.create({title:"Another Article", content:Faker::Lorem.paragraph(sentence_count:30)})
3.times do
  BitcoinPubkey.create(public_key:MoneyTree::Master.new.to_bip32,user:User.first)
end
BitcoinWallet.create(bitcoin_pubkeys:BitcoinPubkey.all,required_keys:(BitcoinPubkey.all.count-1))
Bible.list_bibles
b = Bible.find_by(bible_id:"06125adad2d5898a-01")
b.load_book(45)
puts student.email
