import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="text-adventure"
export default class extends Controller {
  static targets = ["output", "input", "prompt"];
  connect() {
    this.displayWelcomeMessage();
    this.focusInput();
    this.listSoorks();
    this.element.addEventListener("click", () => this.focusInput());

    this.history = [];
    this.currentSoorkValue = null;
  }

  displayWelcomeMessage() {
    this.addToOutput(
      "Welcome to the Soork (SOrt Of Zork), based on Zork!",
      "system"
    );
    this.addToOutput("Loading a list of adventures: ...", "system");
  }

  focusInput() {
    this.inputTarget.focus();
  }

  handleCommand(e) {
    if (e.key === "Enter") {
      e.preventDefault();
      const command = this.inputTarget.value.trim();
      this.addToOutput(`> ${command}`, "command");

      this.processCommand(command);
      this.inputTarget.value = "";
    }
  }

  submit(e) {
    e.preventDefault();

    const command = this.inputTarget.textContent.trim();
    if (command) {
      this.handleCommand(command);
      this.inputTarget.value = " ";
    }
  }

  displayMessage(message) {
    console.log("Message:", message);
  }

  handleCommand(command) {
    console.log("Command received:", command);
  }

  addToOutput(text, type) {
    const entry = document.createElement("div");
    entry.classList.add("terminal-type", type);
    entry.textContent = text;
    this.outputTarget.appendChild(entry);
    this.outputTarget.scrollTop = this.outputTarget.scrollHeight;
  }

  listSoorks() {
    fetch("/soorks.json")
      .then((response) => response.json())
      .then((data) => {
        this.addToOutput("Available Soorks: ", "system");
        data.forEach((sork) => {
          this.addToOutput(`${sork.id} - ${sork.title}`, "system");
        });
        this.addToOutput(
          "Enter the number of the Soork you want to play:",
          "system"
        );
      })
      .catch((error) => {
        console.error("Error fetching Soorks:", error);
        this.addToOutput("Error fetching Soorks. Please try again.", "error");
      });
  }
}
