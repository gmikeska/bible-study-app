class Email < ApplicationRecord
  serialize :recipients, Array

  def message_variables
    content.scan(/\{(\S*)\}/).flatten
  end

  def input_variables
    message_variables.select{|var| !var.include?(".")}
  end

  def compile_message(data, recipient)
    message = content
    message_variables.each do |key|
      if(key.include? "recipient.")
        attribute = key.split(".")[1]
        puts "parsing #{key} to #{recipient[attribute.to_sym]}"
        message = message.gsub("{#{key}}",recipient[attribute.to_sym])
      else
        message = message.gsub("{#{key}}",data[key])
      end
      puts "after parsing #{key} - #{message}"
    end
    return message
  end

  def recipient_list
    arr = []
    if(recipients.length > 0)
      recipients.each do |r|
        if(is_pointer?(r))
          result = Email.resolve_pointer(r)
          if(result.is_a? ActiveRecord::Relation)
            arr << result.to_a
          else
            arr << result
          end
        end
      end
    else
      arr = User.all.to_a
    end
    return arr.flatten
  end

  def deliver_now(sending_params)
    recipient_list.each do |user|
      CustomMailer.with(user:user,body:self.compile_message(sending_params,user),subject:self.subject).dynamic.deliver_now
    end
  end
  def deliver_later(sending_params)
    recipient_list.each do |user|
      CustomMailer.with(user:user,body:self.compile_message(sending_params,user),subject:self.subject).dynamic.deliver_later
    end
  end

end
