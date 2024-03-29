import "phaser";
import { sceneEvents } from "../events/EventCenter";

export default class GameUI extends Phaser.Scene {
    private hearts: Phaser.GameObjects.Group;
    constructor() {
        super({ key: "game-ui" });
    }

    create() {
        this.add.image(5, 26, 'treasure', 'coin_anim_f0.png');
        const coinsLabel = this.add.text(10, 20, '0');
        sceneEvents.on('player-coins-changed', coins => {
            coinsLabel.text = coins.toString();
        })

        this.hearts = this.add.group({
            classType: Phaser.GameObjects.Image,
        });

        this.hearts.createMultiple({
            key: "ui-heart-full",
            setXY: {
                x: 10,
                y: 10,
                stepX: 16,
            },
            quantity: 3,
        });
        sceneEvents.on(
            "player-health-changed",
            this.handlePlayerHealthChanged,
            this
        );
        this.events.on(Phaser.Scenes.Events.SHUTDOWN, () => {
            sceneEvents.off("player-health-changed", this.handlePlayerHealthChanged);
            sceneEvents.off('player-coins-changed');
        });
    }
    private handlePlayerHealthChanged(health: number) {
        // @ts-ignore
        this.hearts.children.each((go, idx) => {
            const heart = go as Phaser.GameObjects.Image;
            if (idx < health) {
                heart.setTexture("ui-heart-full");
            } else {
                heart.setTexture("ui-heart-empty");
            }
        });
    }
}
