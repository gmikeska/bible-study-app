// class Message extends HTMLElement {
//   styles() {
//     return `
//       :host {
//         display: block;
//       }
//       ::slotted(time) {
//         float: right;
//         font-size: 0.75em;
//       }
//       .sender { font-weight: bold; }
//       .body { … }
//     `
//   }
//
//   constructor() {
//     super()
//     const shadow = this.attachShadow({mode: 'open'});
//     shadow.innerHTML = `
//       <style>
//         ${this.styles()}
//       </style>
//       <slot name="posted"></slot>
//       <div class="commenter">
//         <slot name="avatar"></slot> <slot name="author"></slot>
//       </div>
//       <div class="body">
//         <slot name="body"></slot>
//       </div>
//     `
//   }
// }
customElements.define('message', Comment)
