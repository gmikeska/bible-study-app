import consumer from "./consumer"

consumer.subscriptions.create("LessonChannel", {
  connected() {
    // debugger
    if(!application.channels)
      application.channels = []

    application.channels.push(this)
    application.channelLoader(this)
    // Called when the subscription is ready for use on the server
    console.log("Connected to the room!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },
  received(data) {
    if(data["lesson_slug"] == $('meta[name=lesson-slug]').attr('id'))
    {
      application.receiveCallback(data)
    }
  }
});
