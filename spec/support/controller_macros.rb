FactoryBot.define do
  module ControllerMacros
    def login_student
      # Before each test, create and login the user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = FactoryBot.create(:user)
        sign_in @user
      end
    end

    def login_admin
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in FactoryBot.create(:admin) # Using factory bot as an example
      end
    end
    def file_import
      before do
        @file = fixture_file_upload('Dogs 101 Lesson 4.docx', 'application/docx')
      end
    end
    def file_upload
      before(:each) do
        @upload = fixture_file_upload('oceans.mp4', 'video/mp4')
      end
    end
    def create_course
      before(:each) do
        @course = FactoryBot.create(:course)
      end
    end
    def create_lesson
      before(:each) do
        @course = FactoryBot.create(:course)
        @lesson = FactoryBot.create(:lesson)
        @course.lessons << @lesson
      end
    end
    def create_video_lesson
      before do
        if(@course.nil?)
          @course = FactoryBot.create(:course)
        end
        if(@lesson.nil?)
          @lesson = FactoryBot.create(:lesson)
          @course.lessons << @lesson
        end
        @lesson.files.attach(fixture_file_upload('oceans.mp4', 'video/mp4'))
      end
    end
    def create_chapter_with_lesson
      before(:each) do
        @course = FactoryBot.create(:course)
        @chapter = FactoryBot.create(:chapter)
        @chapter.course = @course
        @chapter.save
        if(@pet)
          @course.enroll(@pet,@chapter)
          @course.save
        end
        @lesson = FactoryBot.create(:lesson)
        @course.lessons << @lesson
        @lesson.chapter = @chapter
      end
    end
    def create_pet_and_login_owner
      before(:each) do
        @pet = FactoryBot.build(:pet)
        @user = FactoryBot.create(:user)
        @pet.owner = @user
        @pet.save
        sign_in @user
      end
    end
    def create_pet_and_owner
      before(:each) do
        @pet = FactoryBot.build(:pet)
        @user = FactoryBot.create(:user)
        @pet.owner = @user
        @pet.save
      end
    end
    def create_pet_and_login_admin
      before(:each) do
        @pet = FactoryBot.build(:pet)
        @user = FactoryBot.create(:user)
        @pet.owner = @user
        @pet.save
        @admin = FactoryBot.create(:admin)
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in @admin # Using factory bot as an example
      end
    end
  end
end
