import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "message", "secret"];

  connect() {
    this.encrypted = [
      27, 29, 22, 21, 1, 83, 78, 92, 14, 11, 17, 26, 28, 3, 93, 10, 13, 8, 93,
      30, 0, 29, 13, 7, 23, 27, 7, 6, 0, 5, 1, 74, 1, 29, 0, 29, 54, 1, 4, 22,
      12, 78, 7, 27, 7, 0, 93, 4, 0, 26, 7, 77, 4, 2, 25, 78, 18, 26, 17, 0, 6,
      26, 78, 26, 4, 3, 2, 23, 26, 78, 27, 6, 15, 0, 45, 25, 0, 20, 12,
    ];
  }

  submit(event) {
    event.preventDefault();

    const guess = this.inputTarget.value.trim().toLowerCase();

    if (!guess) {
      this.showMessage("Please enter a word!", "error");
      return;
    }
    try {
      const decrypted = this.decrypt(this.encrypted, guess);
      // Check if it matches our expected secret
      if (
        decrypted ===
        "https://github.com/wanderingslc/stan_cade/tree/main/app/assets/images/home_page"
      ) {
        this.showMessage("🎉 Correct!", "success");
        this.revealSecret(decrypted);
        this.inputTarget.disabled = true;
      } else {
        this.showMessage("❌ Try again!", "error");
        this.inputTarget.value = "";
      }
    } catch {
      this.showMessage("❌ Try again!", "error");
      this.inputTarget.value = "";
    }
  }

  // XOR cipher - the guess is the key
  decrypt(encrypted, key) {
    let result = "";
    for (let i = 0; i < encrypted.length; i++) {
      const keyChar = key.charCodeAt(i % key.length);
      result += String.fromCharCode(encrypted[i] ^ keyChar);
    }
    return result;
  }

  showMessage(text, type) {
    this.messageTarget.textContent = text;
    this.messageTarget.className = `message-area ${type}`;
  }

  revealSecret(secretText) {
    // Find the span inside the alert and set the text
    this.secretTarget.querySelector(".secret-text").textContent = secretText;
    this.secretTarget.classList.remove("d-none");
  }
}
