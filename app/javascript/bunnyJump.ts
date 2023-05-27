import "phaser";
import Game from "./bunny_jump/scenes/Game";
import GameOver from "./bunny_jump/scenes/GameOver.js";
// import VirtualJoystickPlugin from "phaser3-rex-plugins/plugins/virtualjoystick-plugin.js";

// export default new Phaser.Game({
//     type: Phaser.AUTO,
//     width: 480,
//     height: 640,
//     scene: [Game, GameOver],
//     physics: {
//         default: "arcade",
//         arcade: {
//             gravity: {
//                 y: 200,
//             },
//             debug: false,
//         },
//     },
//     plugins: {
//         global: [
//             {
//                 key: "rexVirtualJoystick",
//                 plugin: VirtualJoystickPlugin,
//                 start: true,
//             },
//         ],
//     },
// });

const bunnyConfig = {
    title: "Bunny Jump",
    width: 480,
    height: 640,
    parent: "bunny-jump",
    autoCenter: true,
    scene: [Game, GameOver],
    physics: {
        default: "arcade",
        arcade: {
            gravity: {
                y: 200,
            },
            debug: false,
        },
    },
}

// const BunnyJump = new Phaser.Game(bunnyConfig);
export class BunnyJump extends Phaser.Game {
    constructor(config: Phaser.Types.Core.GameConfig) {
        super(config);
    }
}

window.onload = () => {
    let game = new BunnyJump(bunnyConfig);
}