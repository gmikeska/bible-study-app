import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "type","preview","settings" ]

  connect() {

  }
  changeType(e) {
    this.component_name = e.currentTarget.value
    this.updatePreview(this.component_name)
    this.loadSettings(this.component_name)
  }
  settingsChanged(e) {
    // console.log(e)
    if(e.target.classList.contains("link_select"))
    {
      this.toggleLinkSelect(e)
    }
    else {
      // debugger
      this.updatePreview(this.component_name)
    }
  }
  updatePreview(component_id) {
    // console.log(this.formData())

    let params = this.formData()
    $.post({
          url: `component/${params["name"]}`,
          data:params,
          success:(data)=>{
            $(this.previewTarget).empty()
            $(this.previewTarget).append(data)
          }
      });

  }
  loadSettings(componentName) {
    $.ajax({
          url: `/component/${componentName}/settings`,
          type: "GET",
          success:(data)=>{
            $(this.settingsTarget).empty()
            let lines = $(data).html().split("\n").slice(1)
            $(this.settingsTarget).html(lines.join("\n"))
          }
      });
  }
  formData() {
    var data = {}
    data["name"] = $(".componentType",this.element).val()

    let args = {}
    if(!!$)
    {


      if($(":input",$(".settings",this.element)[0]).length > 0)
      {
        $(":input",$(".settings",this.element)[0]).each((i,el)=>{

          if (el.id.match(new RegExp('page_components\\[\\]\\[args\\]\\[(\\w+)\\]'))) {

            args[el.id.match(new RegExp('page_components\\[\\]\\[args\\]\\[(\\w+)\\]'))[1]] = $(el).val()
          }

         })

      }
    }
    else {
      console.log($)
    }
    data["args"] = args
    return data
  }
  toggleLinkSelect(e) {
    var link_select = e.currentTarget
    var link_input_wrapper = link_select.parentElement.parentElement.nextElementSibling
    var link_input = $('input',link_input_wrapper)[0]
    if(e.currentTarget.value == "external_link")
    {
      link_input.name = link_select.name
      link_select.name = 'unused'
      link_input.id = link_select.id
      link_select.id = 'unused'
      $(link_input_wrapper).show()
    }
    else {
      link_select.name = link_input.name
      link_input.name = 'unused'
      link_select.id = link_input.id
      link_input.id = 'unused'
      $(link_input_wrapper).hide()
    }
  }
  get index() {
    return parseInt(this.data.get("index"))
  }

  set index(value) {
    this.data.set("index", value)
  }
}
