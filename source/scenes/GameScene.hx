package scenes;

import haxepunk.*;
import entities.*;

class GameScene extends Scene
{
    private var player:Player;
    private var level:Level;

    override public function begin() {
        add(new Player());
        add(new Level());
    }

    override public function update() {
        super.update();
    }
}
