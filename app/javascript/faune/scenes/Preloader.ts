import  'phaser';
// @ts-ignore
// import tiles from "../../../assets/tiles/dungeon_tiles_extruded.png";

// @ts-ignore
import dungeon from "../public/tiles/dungeon-2.json";
// @ts-ignore

// @ts-ignore
import fauneAtlas from "../public/character/fauna.json";
// @ts-ignore

// @ts-ignore
import lizardAtlas from "../public/enemies/lizard.json";
// @ts-ignore

//@ts-ignore
import treasureAtlas from "../public/items/treasure.json";
//@ts-ignore
export default class Preloader extends Phaser.Scene {
    constructor() {
        super("preloader");
    }

    preload() {
        this.load.setBaseURL("../../assets/faune");
        this.load.image("tiles", "tiles/dungeon_tiles_extruded.png");
        this.load.tilemapTiledJSON("dungeon", dungeon);
        this.load.atlas("faune", "character/fauna.png", fauneAtlas);
        this.load.atlas("lizard", "enemies/lizard.png", lizardAtlas);
        this.load.atlas("treasure", "items/treasure.png", treasureAtlas);
        this.load.image("ui-heart-empty", 'ui/ui-heart-empty.png');
        this.load.image("ui-heart-full",  "ui/ui-heart-full.png");
        this.load.image("knife", "weapons/weapon_knife.png");
    }
    create() {
        this.scene.start("game");
    }
}
