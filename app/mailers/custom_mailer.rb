class CustomMailer < ApplicationMailer
  default from:"Memorial United Methodist Church <website@memorialumcaustin.com>"
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
