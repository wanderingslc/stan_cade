import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="soork"
export default class extends Controller {
  static targets = ['input']

  connect() {
    console.log("Soork controller connected")
  }
}
