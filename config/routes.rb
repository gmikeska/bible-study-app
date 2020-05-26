Rails.application.routes.draw do
  resources :articles, param: :slug
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    passwords: 'users/passwords',

  }
  devise_scope :user do
    get "/users/", to:"users/registrations#index"
    get "/users/:type", to:"users/registrations#index"
    get "/users/:id/edit", to:"users/registrations#edit"
    patch "/users/:id", to:"users/registrations#update"
    get "my-profile", to:"users/registrations#edit"
    get "my-courses", to:"users/registrations#my_courses"
    get "my-pets", to:"users/registrations#my_pets"
  end
  get "sign_in", to:redirect('/users/sign_in')
  #get "sign_out", to:redirect('/users/sign_out')
  resources 'pages', param: :slug, controller: 'pages'
  # resources 'lessons', param: :slug, controller: 'lessons'

  root to:"pages#home"

resources :courses, param: :slug do
    get "enroll", to:"courses#enroll_student", as:"enrollment"
    post "enroll", to:"courses#enroll"
    get '/lessons/import', to:"lessons#import"
    post '/lessons/import', to:"lessons#do_import"
    delete '/lessons/:slug/delete_file/:id', to: 'lessons#delete_file'
    resources :lessons, param: :slug do
      post '/slides/reorder', to:'lessons#reorder_slides',as:"slides_reorder"
      get '/videos/:filename', to: 'lessons#show_video'
      get '/files/:filename', to: 'lessons#show_file',as:"file"
      get '/slides/new', to:'lessons#new_slide'
      post '/slides/new', to:'lessons#create_slide'
      get '/slides/:index', to:'lessons#show_slide', as:"slide"
      get '/slides/:index/edit', to:'lessons#edit_slide'
      post '/slides/:index/edit', to:'lessons#update_slide'
      delete '/slides/:index', to:'lessons#delete_slide'
      post "/quizzes/:id", to:"quizzes#update"
      post '/upload', to: 'lessons#upload'
      patch '/upload', to: 'lessons#upload'
      resources :quizzes do
        post '/:id/response', to:'quizzes#student_response'
        post '/:id/slide_response', to:'quizzes#student_response_partial'
        get '/:student_id/review', to:'quizzes#instructor_review'
        post '/:student_id/review', to:'quizzes#submit_instructor_review'
      end
    end
    resources :chapters, param: :slug do
      get '/lessons/import', to:"lessons#import_into_chapter"
      post '/lessons/import', to:"lessons#do_import_into_chapter"
      delete '/lessons/:slug/delete_file/:id', to: 'lessons#delete_file'
      get '/lessons/:slug/videos/:filename', to: 'lessons#show_video'
      resources :lessons, param: :slug do
        get '/files/:filename', to: 'lessons#show_file',as:"file"
        get '/videos/:filename', to: 'lessons#show_video'
        patch '/upload', to: 'lessons#upload', as:"upload"
        post '/upload', to: 'lessons#upload'
        get '/slides/new', to:'lessons#new_slide'
        post '/slides/new', to:'lessons#create_slide'
        post '/slides/reorder', to:'lessons#reorder_slides',as:"slides_reorder"
        get '/slides/:index', to:'lessons#show_slide', as:"slide"
        get '/slides/:index/edit', to:'lessons#edit_slide'
        post '/slides/:index/edit', to:'lessons#update_slide'
        delete '/slides/:index', to:'lessons#delete_slide'
        post "/quizzes/:id", to:"quizzes#update"
        resources :quizzes do
          post '/:id/response', to:'quizzes#student_response'
          post '/:id/slide_response', to:'quizzes#student_response_partial'
          get '/:student_id/review', to:'quizzes#instructor_review'
          post '/:student_id/review', to:'quizzes#submit_instructor_review'
        end
      end
    end
  end
end

module CustomUrlHelper
  def lesson_path(lesson)
    if(lesson.chapter.present?)
      course_chapter_lesson_path(lesson.course, lesson.chapter,lesson)
    else
      course_lesson_path(lesson.course,lesson)
    end
  end
  def lesson_url(lesson)
    if(lesson.chapter.present?)
      course_chapter_lesson_url(lesson.course, lesson.chapter,lesson)
    else
      course_lesson_url(lesson.course,lesson)
    end
  end
  def lesson_slide_url(lesson,index)
    if(lesson.chapter.present?)
      course_chapter_lesson_slide_url(lesson.course, lesson.chapter,lesson,index)
    else
      course_lesson_slide_url(lesson.course,lesson,index)
    end
  end
  def lesson_slide_path(lesson,index)
    if(lesson.chapter.present?)
      course_chapter_lesson_slide_url(lesson.course, lesson.chapter,lesson,index)
    else
      course_lesson_slide_url(lesson.course,lesson,index)
    end
  end
  def lesson_slides_reorder_path(lesson)
    if(lesson.chapter.present?)
      course_chapter_lesson_slides_reorder_path(lesson.course,lesson.chapter,lesson)
    else
      course_lesson_slides_reorder_path(lesson.course,lesson)
    end
  end
  def edit_lesson_path(lesson)
    if(lesson.chapter.present?)
      edit_course_chapter_lesson_path(lesson.course, lesson.chapter,lesson)
    else
      edit_course_lesson_path(lesson.course,lesson)
    end
  end
  def new_lesson_path(entity)
    if(entity.class.name == "Chapter")
      new_course_chapter_lesson_path(entity.course, entity)
    elsif(entity.class.name == "Course")
      new_course_lesson_path(entity)
    end
  end
  def new_lesson_url(entity)
    if(entity.class.name == "Chapter")
      new_course_chapter_lesson_url(entity.course, entity)
    elsif(entity.class.name == "Course")
      new_course_lesson_url(entity)
    end
  end
  def edit_lesson_url(lesson)
    if(lesson.chapter.present?)
      edit_course_chapter_lesson_url(lesson.course, lesson.chapter,lesson)
    else
      edit_course_lesson_url(lesson.course,lesson)
    end
  end
  def lesson_upload_path(lesson)
    if(lesson.chapter.present?)
      course_chapter_lesson_path(lesson.course,lesson.chapter,lesson)+"/upload"
    else
      course_lesson_path(lesson.course,lesson)+"/upload"
    end
  end
  def lesson_upload_url(lesson)
    if(lesson.chapter.present?)
      course_chapter_lesson_url(lesson.course,lesson.chapter,lesson)+"/upload"
    else
      course_lesson_url(lesson.course,lesson)+"/upload"
    end
  end
  def lesson_file_path(lesson,filename)
    if(lesson.chapter.present?)
      course_chapter_lesson_file_path(lesson.course,lesson.chapter,lesson,filename)
    else
      course_lesson_file_path(lesson.course,lesson,filename)
    end
  end
  def lesson_file_url(lesson,filename)
    if(lesson.chapter.present?)
      course_chapter_lesson_file_url(lesson.course,lesson.chapter,lesson,filename)
    else
      course_lesson_file_url(lesson.course,lesson,filename)
    end
  end
  def lesson_quiz_path(lesson)
    if(lesson.chapter.present?)
      course_chapter_lesson_quiz_path(lesson.course,lesson.chapter,lesson,lesson.quiz)
    else
      course_lesson_quiz_path(lesson.course,lesson,lesson.quiz)
    end
  end
  def edit_lesson_quiz_path(lesson)
    if(lesson.chapter.present?)
      edit_course_chapter_lesson_quiz_path(lesson.course,lesson.chapter,lesson,lesson.quiz)
    else
      edit_course_lesson_quiz_path(lesson.course,lesson,lesson.quiz)
    end
  end
end

# Works at Rails 4.2.6, for older versions try http://stackoverflow.com/a/31957323/474597
Rails.application.routes.named_routes.url_helpers_module.send(:include, CustomUrlHelper)
