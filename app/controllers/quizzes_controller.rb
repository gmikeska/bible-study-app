class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :set_chapter, only: [:new, :create]

  # GET /quizzes
  # GET /quizzes.json
  def index
    return unless requester_is_staff
    set_course
    @quizzes = Quiz.all
  end

  def assessments
    return unless requester_is_staff
    @assessments = Course.pending_reviews
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    return unless requester_is_authorized (true)
      if(current_user.isStudent?)
        set_current_user
      end
    set_enrollment
  end

  # GET /quizzes/new
  def new
    return unless requester_is_staff
    @quiz = Quiz.new(questions:[], chapter:@chapter)
  end

  # GET /quizzes/1/edit
  def edit
    return unless requester_is_staff
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    return unless requester_is_staff
    questions = quiz_params
    questions.each do |question|
      if(question[:field_type] == "radio_button" && question[:answer].present?)
        question[:answer] == question[:answer].to_i
      end
    end
    @quiz = Quiz.new(questions:questions, chapter:@chapter)

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz.course, notice: 'Quiz was successfully created.' }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    return unless requester_is_staff
    params = {questions:quiz_params}
    respond_to do |format|
      if @quiz.update(params)
        format.html { redirect_to @quiz.course, notice: 'Quiz was successfully updated.' }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    return unless requester_is_staff
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def student_response
    set_quiz
    set_current_user
    set_enrollment
    answers = result_params

    results = @quiz.check_results(answers)
    score = @quiz.check_score(results)
    @enrollment.quiz_responses[@quiz] = {answers:answers,correct_answer:@quiz.questions.collect{|q| q[:answer] }, results:results, score:score}
    @enrollment.save
    redirect_to [@quiz.course, @quiz.chapter, @quiz]
  end
  def student_response_partial
    set_quiz
    set_current_user
    set_enrollment
    if(@enrollment.quiz_responses[@quiz].nil?)
      @enrollment.quiz_responses[@quiz] = {answers:[],correct_answer:@quiz.questions.collect{|q| q[:answer] }, results:[]}
    end
    answers = result_params
    response = { }
    answers.each do |key,value|
      @enrollment.quiz_responses[@quiz][:answers][key.to_i] = value
      @enrollment.quiz_responses[@quiz][:results][key.to_i] = @quiz.check_answer(key.to_i, value)

      if(@enrollment.quiz_responses[@quiz][:results][key.to_i] == :correct)
        response[key] = {result:@enrollment.quiz_responses[@quiz][:results][key.to_i]}
      elsif(@enrollment.quiz_responses[@quiz][:results][key.to_i] == :incorrect)
        response[key] = {result:@enrollment.quiz_responses[@quiz][:results][key.to_i],correct_answer:@enrollment.quiz_responses[@quiz][:correct_answer][key.to_i]}
        if(@quiz[:questions][key.to_i][:field_type] == "radio_button")
          response[key][:correct_answer] = @quiz[:questions][key.to_i][:choices][response[:correct_answer].to_i]
        end
      end
    end
    if(@enrollment.status?(@quiz) == :complete)
      @enrollment.quiz_responses[@quiz][:score] = @quiz.check_score(@enrollment.quiz_responses[@quiz][:results])
      response["score"] = @enrollment.quiz_responses[@quiz][:score]
      response["correct"] = @enrollment.quiz_responses[@quiz][:results].select{|e| e == :correct }.count
      response["incorrect"] = @enrollment.quiz_responses[@quiz][:results].select{|e| e == :incorrect }.count
    end
    @enrollment.save
    render :json => response
  end

  def instructor_review
    return unless requester_is_staff
    set_quiz
    set_user
    set_enrollment
    render :instructor_review
  end

  def submit_instructor_review
    return unless requester_is_staff
    set_quiz
    set_enrollment
    review = review_params
    response = @enrollment.quiz_responses[@quiz]
    review.each do |review|
      if(review[:isCorrect] == "no")
        response[:results][review[:index].to_i] = :incorrect
        response[:correct_answer][review[:index].to_i] = review[:comment]
      elsif(review[:isCorrect] == "yes")
        response[:results][review[:index].to_i] = :correct
      end
    end
    # byebug
    response[:score] = @quiz.check_score(response[:results])
    @enrollment.save
    if(Course.count_pending_reviews > @enrollment.course.count_pending_reviews)
      redirect_to action: "assessments"
    else
      redirect_to @enrollment.course
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      if(params[:course_slug])
        @course = Course.find_by slug: params[:course_slug]
      end
    end
    def set_chapter
      set_course
      if(params[:chapter_slug])
        @chapter = @course.chapters.find_by slug:params[:chapter_slug]
      end
    end
    def set_lesson
      set_chapter
      if(params[:lesson_slug])
        @lesson = @course.lessons.find_by slug:params[:lesson_slug]
      end
    end
    def set_quiz
      set_lesson
      @quiz = @lesson.quiz
    end
    def set_current_user
      @user = current_user
    end
    def set_user
      @user = User.find(params[:user_id])
    end
    def set_enrollment
      set_course
      @enrollment = Enrollment.where(course_id:@course.id).select{|e| e.user == @user}.first
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      questions = []
      byebug
      params[:quiz][:questions].each do |question|
        question = question.permit!
        if(question[:choices].present?)
          choices = []
          question[:choices].each do |key,choice|
            choices << choice
          end
          question[:choices] = choices
        end
        if(question[:field_type] == "radio_button" && question[:answer].present?)
          question[:answer] = question[:answer].to_i
        end
        questions << question
      end
      return questions
    end
    def result_params
      params.require(:answers).permit!
    end
    def review_params
      params.require(:answers).each do |answer|
        answer.permit!
      end
    end
end
