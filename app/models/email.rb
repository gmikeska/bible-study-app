class Email < ApplicationRecord

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

  def service_variables

  end

end
