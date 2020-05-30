import consumer from "./consumer"

consumer.subscriptions.create("LessonChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the room!");
    $("body").ready(()=>{
      $("#chatButton").click(()=>{

        if($("#chatMessage").length > 0)
        {
          // debugger
          if($("#chatMessage").val() != "")
          {
            // console.log($("#chatMessage").val())
            this.send({from:$('meta[name=current-user]').attr('id'), lesson_slug:$('meta[name=lesson-slug]').attr('id'), content:$("#chatMessage").val()})
            $("#chatMessage").val("")
          }
        }
      })
    })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if(data["lesson_slug"] == $('meta[name=lesson-slug]').attr('id'))
    {
      $("pre","#incoming").append(`${data.from}:${data.content}\n`)
      console.log(data)
    }
  }
});
