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
      const command = this.inputTarget.value.trim().toLowerCase();
      if (command === "help") {
        this.showHelp();
      } else if (command === "list") {
        this.listSoorks();
      } else if (command === "exit") {
        this.addToOutput("Exiting the game. Goodbye!", "system");
        this.inputTarget.disabled = true;
      } else if (command.includes("play")) {
        const soorkNumber = command.split(" ")[1];

        if (soorkNumber) {
          this.currentSoorkValue = soorkNumber;
          this.addToOutput(`Starting Soork ${soorkNumber}...`, "system");
          this.addToOutput("Loading the adventure...", "system");
          this.startSoork(soorkNumber);
          return;
        } else {
          this.addToOutput("Please specify a Soork number.", "error");
          return;
        }
      } else if (command) {
        this.history.push(command);
      }
      this.addToOutput(`> ${command}`, "command");

      this.processCommand(command);
      this.inputTarget.value = "";
    }
  }

  startSoork(soorkNumber) {
    fetch(`/soorks/${soorkNumber}/start`)
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

    if (data.result.exits) {
      this.addToOutput(`You see exits: ${data.result.exits}`, "response");
    }
    if (data.result.items) {
      let itemsString = "";
      for (const item of data.result.items) {
        itemsString += `${item.name} (${item.description}) `;
      }
      this.addToOutput(`You see items: ${itemsString}`, "response");
    }
    this.addToOutput("What do you want to do?", "response");
    this.addToOutput(">", "response");
  }

  processCommand(command) {
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
        this.displayMessage(data.message);
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

  listSoorks() {
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

  showHelp() {
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
}
