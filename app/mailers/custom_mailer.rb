class CustomMailer < ApplicationMailer
  default from:"noreply@church-sunday-school.herokuapp.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.custom_mailer.dynamic.subject
  #
  def dynamic
    @body = params[:body]
    @user = params[:user]
    mail(to: @user.email, subject: params[:subject])
  end
end
