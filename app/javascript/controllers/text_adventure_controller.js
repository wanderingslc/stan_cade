import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="text-adventure"
export default class extends Controller {
  static targets = ["output", "input", "prompt"];
  static LOCAL_COMMANDS = ["help", "list", "exit", "play"];

  connect() {
    this.displayWelcomeMessage();
    this.focusInput();
    this.handleList();
    this.element.addEventListener("click", () => this.focusInput());

    this.history = [];
    this.currentSoorkValue = null;
    this.gameSessionId = null;
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
      const trimmedInput = this.inputTarget.value.trim();

      if (!trimmedInput) {
        this.addToOutput("Please enter a command.", "error");
        return;
      }

      const [command, ...args] = trimmedInput.split(" ");

      if (this.constructor.LOCAL_COMMANDS.includes(command)) {
        this.executeCommand(command, args);
      } else {
        this.history.push(command);
        this.processCommand(trimmedInput);
      }

      this.addToOutput(`> ${trimmedInput}`, "command");

      this.inputTarget.value = "";
    }
  }

  executeCommand(command, args) {
    console.log("Executing local command:", command, args);
    const methodName = `handle${this.capitalize(command)}`;
    if (typeof this[methodName] === "function") {
      this[methodName](args);
    } else {
      this.addToOutput(`Unknown command: ${command}`, "error");
    }
  }

  handlePlay(args) {
    if (!args) {
      this.addToOutput("Please specify a Soork number.", "error");
      return;
    }
    this.addToOutput(`Starting Soork ${args}...`, "system");
    this.addToOutput("Loading the adventure...", "system");
    this.currentSoorkValue = args;
    fetch(`/soorks/${args}/start`)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        this.processResponse(data);
      });
  }

  processResponse(data) {
    this.gameSessionId = data.game_session_id;
    this.inputTarget.value = "";
    this.addToOutput(data.message, "response");
    this.addToOutput(
      `You are standing in the ${data.current_room.name}`,
      "response"
    );
    this.addToOutput(data.current_room.description, "response");

    if (data.result.message) {
      this.addToOutput(data.result.message, "response");
    }
    if (data.result.exits) {
      this.addToOutput(`You see exits: ${data.result.exits}`, "response");
    }
    if (data.result.items) {
      if (typeof data.result.items === "string") {
        this.addToOutput(data.result.items, "response");
      } else {
        let itemsString = "";
        for (const item of data.result.items) {
          itemsString += `${item.name} (${item.description}) `;
        }
        this.addToOutput(`You see items: ${itemsString}`, "response");
      }
    }
    this.addToOutput("What do you want to do?", "response");
    this.addToOutput(">", "response");
  }

  processCommand(command) {
    console.log("Processing command to server:", command);
    console.log("Current Soork Value:", this.currentSoorkValue);
    fetch(`/soorks/${this.currentSoorkValue}/process_command`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getMetaTag(),
      },
      body: JSON.stringify({
        command: command,
        game_session_id: this.gameSessionId,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        this.addToOutput(data.description, "response");
        this.processResponse(data);
        this.displayMessage(data.result);
      })
      .catch((error) => {
        console.error("Error processing command:", error);
        this.addToOutput(
          "Error processing command. Please try again.",
          "error"
        );
      });
  }

  getMetaTag() {
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    return metaTag ? metaTag.getAttribute("content") : null;
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

  // handleCommand(command) {
  //   console.log("Command received:", command);
  // }

  addToOutput(text, type) {
    const entry = document.createElement("div");
    entry.classList.add("terminal-type", type);
    entry.textContent = text;
    this.outputTarget.appendChild(entry);
    this.outputTarget.scrollTop = this.outputTarget.scrollHeight;
  }

  handleList() {
    fetch("/soorks.json")
      .then((response) => response.json())
      .then((data) => {
        this.addToOutput("Available Soorks: ", "system");
        data.forEach((sork) => {
          this.addToOutput(`${sork.id} - ${sork.title}`, "system");
        });
        this.addToOutput(
          "Enter the number of the Soork you want to play: play <number>",
          "system"
        );
      })
      .catch((error) => {
        console.error("Error fetching Soorks:", error);
        this.addToOutput("Error fetching Soorks. Please try again.", "error");
      });
  }

  handleQuit() {
    this.addToOutput("Quitting the game...", "system");
    this.handleExit();
  }

  handleExit() {
    this.addToOutput("Exiting the game...", "system");
    // Perform any necessary cleanup or state saving

    this.inputTarget.value = "";
    this.outputTarget.innerHTML = ""; // Clear the output
    this.currentSoorkValue = null; // Reset the current Soork value
    this.addToOutput("Thank you for playing!", "system");
    this.processCommand("exit");
  }

  handleHelp() {
    if (this.currentSoorkValue === null) {
      this.addToOutput("Available commands: ", "system");
      this.addToOutput("  list - Show available Soorks", "system");
      this.addToOutput(
        "  play <number> - Start the adventure with that number",
        "system"
      );
      this.addToOutput("  help - Show this help message", "system");
      this.addToOutput("  quit/exit - Exit the game", "system");
    } else {
      this.addToOutput("Try commands like:", "system");
      this.addToOutput("  look - Look around", "system");
      this.addToOutput("  open mailbox - Open the mailbox", "system");
      this.addToOutput("  take <item> - Take an item", "system");
      this.addToOutput("  use - Use an item", "system");
      this.addToOutput("  inventory - Check your inventory", "system");
      this.addToOutput("  go - Move in a direction", "system");
      this.addToOutput("  help - Show this help message", "system");
      this.addToOutput("  quit/exit - Exit the game", "system");
    }
  }

  capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
}
