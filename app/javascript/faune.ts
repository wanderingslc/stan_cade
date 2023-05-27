import "phaser";

import Game from "./faune/scenes/Game";
import Preloader from "./faune/scenes/Preloader";
import GameUI from "./faune/scenes/GameUI";


const config = {
    title: "Faune",
    width: 800,
    height: 500,
    parent: "faune",
    scene: [Preloader, Game, GameUI],
    physics: {
        default: "arcade",
        arcade: {
            gravity: { y: 0 },
        },
    },
    scale: {
        zoom: 1.5,
    }
}
export class Faune extends Phaser.Game {
    constructor(config: Phaser.Types.Core.GameConfig) {
        super(config);
    }
}

window.onload = () => {
    let game = new Faune(config);
}
