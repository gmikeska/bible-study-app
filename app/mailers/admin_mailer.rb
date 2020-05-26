class AdminMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Welcome, #{@user.name}! You're an Admin!", from: 'noreply@church-sunday-school.herokuapp.com')
  end
  def admin_logs_in
    @user = params[:user]
    mail(to: "gmikeska07@gmail.com", subject: "An admin just logged in.", from: 'noreply@church-sunday-school.herokuapp.com')
  end
end
