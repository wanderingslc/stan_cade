import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="text-adventure"
export default class extends Controller {
  static targets = [ "output", "input", "form" ]
  connect() {
    this.displayMessage("Welcome! Lets have a text adventure! You find yourself in a dark room. What do you do?")
  }

  submit(e) {
    e.preventDefault()
    const command = this.inputTarget.trim()
    if (command) {
      this.handleCommand(command)
      this.inputTarget.value = ' '
    }
  }

  handleCommand(command) {

  }
}
