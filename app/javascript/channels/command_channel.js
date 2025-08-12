import consumer from "./consumer";

consumer.subscriptions.create("CommandChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to CommandChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected from CommandChannel");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received data:", data);

    document.dispatchEvent(
      new CustomEvent("game-response", {
        detail: data,
      })
    );
  },
});
