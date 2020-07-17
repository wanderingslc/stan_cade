import Phaser from "phaser";

import Game from "../dungeon/src/scenes/Game.ts";
import Preloader from "../dungeon/src/scenes/Preloader.ts";
import GameUI from "../dungeon/src/scenes/GameUI.ts";

// export default new Phaser.Game({
//     type: Phaser.AUTO,
//     width: 800,
//     height: 500,
//     physics: {
//         default: "arcade",
//         arcade: {
//             gravity: { y: 0 },
//         },
//     },
//     scene: [Preloader, Game, GameUI],
//     scale: {
//         zoom: 1.5,
//     },
// });

const dungeonConfig = {
    type: Phaser.AUTO,
    width: 600,
    height: 400,
    autoCenter: true,
    id: "dungeon",
    physics: {
        default: "arcade",
        arcade: {
            gravity: { y: 0 },
        },
    },
    scene: [Preloader, Game, GameUI],
    scale: {
        zoom: 1.5,
    },
}

const Dungeon = new Phaser.Game(dungeonConfig);
export default Dungeon;