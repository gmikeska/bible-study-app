import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "slides","messenger","settings" ]
  connect() {
    $(this.slidesTarget).carousel({
      pause:true
    })
    application.channels.forEach((c)=>{
      if(c.identifier == '{"channel":"LessonChannel"}')
          this.channel = c
    })
    application.receiveCallback = (data)=>{
      this.messageReceived(data)
    }
    $(this.slidesTarget).on('slid.bs.carousel', function (e) {
        if(e.to == $(".carousel-item").length-1)
        {
          $(".chapterLesson").show()
        }
        else{ $(".chapterLesson").hide()  }
    })
    $('#incoming').scrollTop($('#incoming').innerHeight())
  }
  setChannel(channel) {
    this.channel = channel
  }
  messageReceived(data){
    $("#incoming").attr({ scrollTop: $("#incoming").attr("scrollHeight") });
    let currentScroll = $('#incoming').scrollTop();
    let scrollDelta = parseInt($("#incoming").css("line-height"))
    $("#incoming",this.messengerTarget).append(`${data.from}:${data.content}<br>`)
    $('#incoming').scrollTop(currentScroll+scrollDelta);
    console.log(data)
  }
  sendMessage(e) {
    let message = $("textarea",this.messengerTarget).val()
    this.channel.send({from:$('meta[name=current-user]').attr('id'), lesson_slug:$('meta[name=lesson-slug]').attr('id'), content:message})
    $("textarea",this.messengerTarget).val("")
  }
}
