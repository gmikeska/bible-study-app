import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "slides","messenger","settings" ]
  connect() {
    $(this.slidesTarget).carousel({
      pause:true
    })
    this.setChannel()
    $(this.slidesTarget).on('slide.bs.carousel', (e)=> {
        if(e.to == $(".carousel-item").length-1)
        {
          $(".chapterLesson").show()
        }
        else{ $(".chapterLesson").hide()  }
        if($("form",e.relatedTarget).length > 0 && $($("input",e.relatedTarget)[1]).attr("disabled") != "disabled")
        {
          debugger
          this.hideNext()
        }
        else
        {
          this.showNext()
        }
    })
    $('#incoming').scrollTop($('#incoming').innerHeight())
  }
  setChannel() {
    if(!!application.channels && application.channels.length > 0)
    {
      application.channels.forEach((c)=>{
        if(c.identifier == '{"channel":"LessonChannel"}')
            this.channel = c
      })
    }  

    application.receiveCallback = (data)=>{
      if(data.type == "message")
      {
        this.messageReceived(data)
      }
      if(data.type == "slide")
      {
        this.goToSlide(data.index)
      }
    }
  }
  goToSlide(index) {
    $(this.slidesTarget).carousel(index)
  }
  hideNext(){
    debugger
    $(".carousel-control-next",this.slidesTarget).hide()
  }
  showNext(){
    $(".carousel-control-next",this.slidesTarget).show()
  }
  submitAnswers(e){
    var form = e.currentTarget.parentElement.parentElement
    $.ajax({
          url: $(form)[0].action,
          data: $(form).serialize(),
          type: "POST",
          success:(response)=>{
            // debugger
             var keys = Object.keys(response)
            $(keys).each((i,key)=>{
              if(!isNaN(parseInt(key)))
              {
                var questionDiv = form.parentElement.parentElement
                key = parseInt(key)
                if(response[key].result == "correct")
                {
                  var label = $("label", questionDiv)[0]
                  var question  = label.textContent
                  var resultIndicator = `<span class='text-success' title='Correct' style='font-size:x-large'>✓</span>`
                  $(label).html(`${resultIndicator}${question}`)
                  $(".form-check-input",questionDiv).attr('disabled',true);
                  $("input",questionDiv).attr('disabled',true);
                }
                if(response[key].result == "incorrect")
                {
                  var label = $("label", questionDiv)[0]
                  var question  = label.textContent
                  var resultIndicator = `<span class='text-danger' title='Correct' style='font-size:x-large'>&times</span>`
                  $(label).html(`${resultIndicator}${question}`)
                  $(".form-check-input",questionDiv).attr('disabled',true);
                  $("input",questionDiv).attr('disabled',true);
                  var correctAnswer = `Correct Answer:${response[key].correct_answer}`
                  $(questionDiv).append(correctAnswer)
                }
              }
              if(response["score"])
              {
                var summary = `${response["correct"]} of ${response["correct"]+response["incorrect"]} correct.
                <br>Score:${response["score"]}`
                $("#quiz-results").html(summary)
              }

            })
            this.showNext()
          }
      });
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
    if(!this.channel){
      this.setChannel()
    }
    let message = $("textarea",this.messengerTarget).val()
    this.channel.send({type:"message",from:$('meta[name=current-user]').attr('id'), lesson_slug:$('meta[name=lesson-slug]').attr('id'), content:message})
    $("textarea",this.messengerTarget).val("")
  }
}
