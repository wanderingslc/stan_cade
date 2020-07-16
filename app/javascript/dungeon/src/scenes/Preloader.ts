import Phaser from 'phaser';
// @ts-ignore
import tiles from "../../public/tiles/dungeon_tiles_extruded.png";
// @ts-ignore
import dungeon from "../../public/tiles/dungeon-2.json";
// @ts-ignore
import faune from "../../public/character/fauna.png";
// @ts-ignore
import fauneAtlas from "../../public/character/fauna.json";
// @ts-ignore
import lizard from "../../public/enemies/lizard.png";
// @ts-ignore
import lizardAtlas from "../../public/enemies/lizard.json";
// @ts-ignore
import treasure from "../../public/items/treasure.png";
//@ts-ignore
import treasureAtlas from "../../public/items/treasure.json";
//@ts-ignore
import heartEmpty from "../../public/ui/ui_heart_empty.png";
//@ts-ignore
import heartFull from "../../public/ui/ui_heart_full.png";
//@ts-ignore
import knife from "../../public/weapons/weapon_knife.png";


export default class Preloader extends Phaser.Scene {
  constructor() {
    super("preloader");
  }

  preload() {
    this.load.image("tiles", tiles);
    this.load.tilemapTiledJSON("dungeon", dungeon);
    this.load.atlas("faune", faune, fauneAtlas);
    this.load.atlas("lizard", lizard, lizardAtlas);
    this.load.atlas("treasure", treasure, treasureAtlas);
    this.load.image("ui-heart-empty", heartEmpty);
    this.load.image("ui-heart-full", heartFull);
    this.load.image("knife", knife);
  }
  create() {
    this.scene.start("game");
  }
}
