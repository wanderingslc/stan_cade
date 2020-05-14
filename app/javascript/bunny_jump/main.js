import Phaser from "./src/lib/phaser";
import Game from "./src/scenes/Game.js";
import GameOver from "./src/scenes/GameOver.js";

export default new Phaser.Game({
  type: Phaser.AUTO,
  width: 480,
  height: 640,
  scene: [Game, GameOver],
  physics: {
    default: "arcade",
    arcade: {
      gravity: {
        y: 200,
      },
      debug: true,
    },
  },
});
