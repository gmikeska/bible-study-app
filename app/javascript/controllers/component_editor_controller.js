import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "type","preview","settings" ]

  connect() {

  }
  changeType(e) {
    // setInputHandlers(wrapper)
    this.updatePreview(e.currentTarget.value)
    this.loadSettings(e.currentTarget.value)
  }
  updatePreview(e) {
    // console.log(this.formData())
    if(e.currentTarget.classList.contains("link_select") && (e.currentTarget.value == "external_link"))
    {
      var link_select = e.currentTarget
      var link_input_wrapper = link_select.parentElement.parentElement.nextElementSibling
      var link_input = $('input',link_input_wrapper)[0]
      link_input.name = link_select.name
      link_select.name = 'unused'
      link_input.id = link_select.id
      link_select.id = 'unused'
      $(link_input_wrapper).show()
    }else if(e.currentTarget.classList.contains("link_select") && (e.currentTarget.value != "external_link"))
    {
      var link_select = e.currentTarget
      var link_input_wrapper = link_select.parentElement.parentElement.nextElementSibling
      var link_input = $('input',link_input_wrapper)[0]
      link_select.name = link_input.name
      link_input.name = 'unused'
      link_select.id = link_input.id
      link_input.id = 'unused'
      $(link_input_wrapper).hide()
    }
    else
    {
      $.post({
            url: `component/${this.data.get("index")}`,
            data:this.formData(),
            success:(data)=>{
              $(this.previewTarget).empty()
              $(this.previewTarget).append(data)
            }
        });
    }


  }
  loadSettings(componentName) {
    $.ajax({
          url: `/component/${componentName}/settings`,
          type: "GET",
          success:(data)=>{
            $(this.settingsTarget).empty()
            lines = $(data).html().split("\n").slice(1)
            $(this.settingsTarget).html(lines.join("\n"))
          }
      });
  }
  formData() {
    var data = {}
    data["args"] = {}
    $(":input",this.element).each((i,el)=>{
      if(el.id.match(new RegExp('page_components\\[\\]\\[name\\]')))
      {
        data["name"] =  $(el).val()
      }
      else if (el.id.match(new RegExp('page_components\\[\\]\\[args\\]\\[(\\w+)\\]'))) {
        data["args"][el.id.match(new RegExp('page_components\\[\\]\\[args\\]\\[(\\w+)\\]'))[1]] = $(el).val()
      }
     })
     return data
  }
}
