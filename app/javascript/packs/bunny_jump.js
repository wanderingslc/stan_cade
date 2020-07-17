import Phaser from "../bunny_jump/src/lib/phaser";
import Game from "../bunny_jump/src/scenes/Game.js";
import GameOver from "../bunny_jump/src/scenes/GameOver.js";
import VirtualJoystickPlugin from "phaser3-rex-plugins/plugins/virtualjoystick-plugin.js";

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
    type: Phaser.AUTO,
    width: 480,
    height: 640,
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
    plugins: {
        global: [
            {
                key: "rexVirtualJoystick",
                plugin: VirtualJoystickPlugin,
                start: true,
            },
        ],
    },
}

const BunnyJump = new Phaser.Game(bunnyConfig);
export default BunnyJump;