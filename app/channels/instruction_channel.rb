class InstructionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "instruction_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # if(data["type"] == "JOIN_ROOM")
    #
    # end
    # ActionCable.server.broadcast("InstructionChannel", data)
  end
end
