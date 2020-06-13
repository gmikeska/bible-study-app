# Preview all emails at http://localhost:3000/rails/mailers/custom
class CustomPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/custom/dynamic
  def dynamic
    CustomMailer.with(user:User.second,body:Email.first.compile_message({"dynamic_message"=>"Look at this dynamic text!"},User.second),subject:Email.first.subject).dynamic
  end

end
