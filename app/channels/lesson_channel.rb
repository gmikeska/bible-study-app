class LessonChannel < ApplicationCable::Channel
  def subscribed
    # transmit(params)
    stream_from "lesson_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    data["from"] = data["from"].titleize
    message_str = data["from"]+":"+data["message"]
    lesson = Lesson.find_by slug:data["lesson_slug"]
    puts lesson.messages
    lesson.messages << message_str
    lesson.save
    puts lesson.messages
    # puts data
    transmit(data)
    # ActionCable.server.broadcast("InstructionChannel", data)
  end
end
