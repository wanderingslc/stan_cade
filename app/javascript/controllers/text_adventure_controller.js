import { Controller } from "@hotwired/stimulus";
import consumer from "../channels/consumer";

// Connects to data-controller="text-adventure"
export default class extends Controller {
  static targets = ["output", "input", "prompt"];
  static LOCAL_COMMANDS = ["help", "exit", "play", "look"];
  static ALLOWED_COMMANDS = ["play", "resume", "list", ...this.LOCAL_COMMANDS];
  static values = {
    history: Array,
    gameSessionId: String,
    currentArea: Object,
  };

  connect() {
    this.displayWelcomeMessage();
    this.focusInput();
    // this.handleList();
    this.element.addEventListener("click", () => this.focusInput());

    this.commandChannel = consumer.subscriptions.subscriptions.find(
      (sub) => sub.identifier === JSON.stringify({ channel: "CommandChannel" })
    );
    document.addEventListener(
      "game-response",
      this.handleWebSocketResponse.bind(this)
    );
  }

  handleWebSocketResponse(event) {
    const data = event.detail;
    if (data.error) {
      console.error("Error Processing Command:", data.error);
      this.addToOutput(`Error: ${data.error}, Please try again`, "error");
      return;
    } else {
      console.log("WebSocket Response:", data);
      if (data.type === "list_soorks") {
        this.displaySoorksList(data.soorks);
      } else if (data.type === "current_state") {
        this.restoreGameState(data);
      } else if (data.type === "resume_available") {
        this.addToOutput(data.message, "system");
        this.displaySoorksList(data.soorks);
        this.displayResumeGames(data.existing_games);
      } else if (data.type === "inventory") {
        this.displayInventory(data.message);
      } else if (data.type === "error") {
        this.addToOutput(data.message, "error");
      } else {
        this.processResponse(data);
      }
    }
  }

  displayResumeGames(existingGames) {
    console.log("🎮 Resuming game session:", existingGames);
    this.addToOutput("You have existing games in progress:", "system");
    existingGames.forEach((game) => {
      this.addToOutput(
        `${game.id} - ${game.title}: ${game.description}`,
        "system"
      );
    });
  }

  restoreGameState(data) {
    console.log("🎮 Restoring game state:", data);
    this.currentAreaValue = data.current_area;
    this.addToOutput("--- Resuming your game ---", "system");
    this.displayAreaInfo();
    this.displayExits();
    this.displayItems();
    this.displayPrompt();
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
      this.addToOutput(`> ${trimmedInput}`, "command");

      if (
        this.gameSessionIdValue === "" &&
        !this.constructor.ALLOWED_COMMANDS.includes(command)
      ) {
        this.handleHelp();
        return;
      }

      if (
        this.gameSessionIdValue !== "" &&
        ["resume", "list", "play"].includes(command)
      ) {
        this.addToOutput(
          "You must exit the current game before starting a new one.",
          "error"
        );
        this.clearInput();
        return;
      }

      if (this.constructor.LOCAL_COMMANDS.includes(command)) {
        this.executeCommand(command, args);
      } else {
        this.historyValue = [...this.historyValue, command];
        this.processCommand(trimmedInput);
      }

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

  handleLook() {
    console.log("Current game session id: ", this.gameSessionIdValue);
    this.addToOutput("You look around...", "response");
    this.displayAreaInfo();
    this.displayExits();
    this.displayItems();
    this.displayPrompt();
    console.log("Current game session id: ", this.gameSessionIdValue);
  }

  handleResume() {
    console.log("Resuming game session:", this.gameSessionIdValue);
    this.handleLook();
  }

  handlePlay(args) {
    if (!args) {
      this.addToOutput("Please specify a Soork number.", "error");
      return;
    }
    this.addToOutput(`Starting Soork ${args}...`, "system");
    this.addToOutput("Loading the adventure...", "system");
    this.currentSoorkValue = args;
    this.commandChannel.perform("execute_command", {
      command: `play ${args}`,
      game_session_id: null,
    });
  }

  processResponse(data) {
    this.gameSessionIdValue = data.game_session_id;
    this.inputTarget.value = "";
    this.currentSoorkValue = data.current_soork_value;
    this.currentAreaValue = data.current_area;
    console.log("Current game session id: ", this.gameSessionIdValue);
    this.addToOutput(data.message, "response");
    this.addToOutput(
      `You are standing in the ${data.current_area.name}`,
      "response"
    );

    this.addToOutput(data.current_area.description.description, "response");
    console.log(data.current_area.exits);
    // if (data.message) {
    //   this.addToOutput(data.message, "response");
    // }

    if (data.current_area.exits) {
      Object.entries(data.current_area.exits).forEach(([direction, exit]) => {
        this.addToOutput(
          `You see an exit to the ${direction}: ${exit.description}`,
          "response"
        );
      });
    }
    if (data.current_area.items) {
      if (typeof data.current_area.items === "string") {
        this.addToOutput(data.current_area.items, "response");
      } else {
        let itemsString = "";
        for (const item of data.current_area.items) {
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
    console.log("Current Game Session ID:", this.gameSessionIdValue);
    this.commandChannel.perform("execute_command", {
      command: command,
      game_session_id: this.gameSessionIdValue,
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
    this.displaySoorksList(data.soorks);
    // fetch("/soorks.json")
    //   .then((response) => response.json())
    //   .then((data) => {
    //     this.addToOutput("Available Soorks: ", "system");
    //     data.forEach((sork) => {
    //       this.addToOutput(`${sork.id} - ${sork.title}`, "system");
    //     });
    //     this.addToOutput(
    //       "Enter the number of the Soork you want to play: play <number>",
    //       "system"
    //     );
    //   })
    //   .catch((error) => {
    //     console.error("Error fetching Soorks:", error);
    //     this.addToOutput("Error fetching Soorks. Please try again.", "error");
    //   });
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
    if (this.gameSessionIdValue === "") {
      this.addToOutput("Available commands: ", "system");
      this.addToOutput("  list - Show available Soorks", "system");
      this.addToOutput(
        "  play <number> - Start the adventure with that number",
        "system"
      );
      this.addToOutput(
        "  resume <game_id> - Resume an existing game",
        "system"
      );
      this.addToOutput("  help - Show this help message", "system");
      this.addToOutput("  quit/exit - Exit the game", "system");
      this.clearInput();
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
      this.clearInput();
    }
  }

  clearInput() {
    this.addToOutput(">", "response");
    this.inputTarget.value = "";
  }

  capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
  // Display methods, get working then move to another file
  displaySoorksList(soorks) {
    this.addToOutput("Available Soorks:", "system");
    soorks.forEach((soork) => {
      this.addToOutput(
        `${soork.id} - ${soork.title}: ${soork.description}`,
        "system"
      );
    });
  }

  displayAreaInfo() {
    this.addToOutput(
      `You are standing in the ${this.currentAreaValue.name}`,
      "response"
    );
    this.addToOutput(this.currentAreaValue.description.description, "response");
  }

  displayExits() {
    if (this.currentAreaValue.exits) {
      Object.entries(this.currentAreaValue.exits).forEach(
        ([direction, exit]) => {
          this.addToOutput(
            `You see an exit to the ${direction}: ${exit.description}`,
            "response"
          );
        }
      );
    }
  }

  displayItems() {
    if (!this.currentAreaValue.description.items) return;

    if (typeof this.currentAreaValue.description.items === "string") {
      this.addToOutput(this.currentAreaValue.description.items, "response");
    } else {
      const itemsString = this.currentAreaValue.description.items.join(" ");
      this.addToOutput(`You see items: ${itemsString}`, "response");
    }
  }

  displayInventory(items) {
    this.addToOutput("Your inventory contains:", "system");
    items.forEach((item) => {
      this.addToOutput(`- ${item.name}: ${item.description}`, "system");
    });
  }

  displaySoorksList(soorks) {
    this.addToOutput("Available Soorks:", "system");
    soorks.forEach((soork) => {
      this.addToOutput(
        `${soork.id} - ${soork.title}: ${soork.description}`,
        "system"
      );
    });
  }

  displayPrompt() {
    this.addToOutput("What do you want to do?", "response");
    this.addToOutput(">", "response");
    this.inputTarget.value = "";
  }
}
