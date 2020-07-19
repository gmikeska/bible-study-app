import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    window.modal = {}
    window.modal[this.element.id] = this
    this.init_callbacks = []
    this.submit_callbacks = []
    this.resetAfterSubmit = true
    this.initial_html = this.element.innerHTML
  }
  onInit(cb)
  {
    this.init_callbacks.push(cb)
    cb(this)
  }
  onSubmit(cb)
  {
    this.submit_callbacks.push(cb)
  }
  submit(e)
  {
    this.submit_callbacks.forEach((item, i) => {
        item(e)
    });
    $(this.element).modal('hide')
    if(this.resetAfterSubmit)
    {
      this.reset()
    }
  }
  reset()
  {
    this.element.innerHTML = this.initial_html
    this.init_callbacks.forEach((item, i) => {
        item(this)
    });
  }

}
