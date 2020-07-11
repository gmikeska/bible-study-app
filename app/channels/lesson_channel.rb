class LessonChannel < ApplicationCable::Channel
  def subscribed
    # transmit(params)
    stream_from "lesson_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    if(data["type"] == "message")
      data["from"] = data["from"].titleize
      # message_str = data["from"]+":"+data["message"]
      lesson = Lesson.find_by slug:data["lesson_slug"]
      lesson.messages << data
      lesson.save
      # puts data
      transmit(data)
    elsif(data["type"] == "slide")

    end
    # ActionCable.server.broadcast("InstructionChannel", data)
  end
end
