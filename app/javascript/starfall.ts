import "phaser";
import {WelcomeScene} from "./starfall/welcomeScene";
import {GameScene} from "./starfall/gameScene";
import {ScoreScene} from "./starfall/scoreScene";

const config = {
    title: "Starfall",
    width: 800,
    height: 600,
    parent: "starfall-game",
    scene: [WelcomeScene, GameScene, ScoreScene],
    physics: {
        default: "arcade",
        arcade: {
            debug: false
        }
    },
    backgroundColor: "#18216D"
};

export class StarfallGame extends Phaser.Game {
    constructor(config: Phaser.Types.Core.GameConfig) {
        super(config);
    }
}

window.onload = () => {
    let game = new StarfallGame(config);
}
// $(document).on("turbolinks:load", () => {
//     let game = new StarfallGame(config);
// });
