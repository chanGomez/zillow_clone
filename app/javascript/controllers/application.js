import { Application } from "@hotwired/stimulus"

const application = Application.start()
console.log("stimulus is working")

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
