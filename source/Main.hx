import haxepunk.*;
import scenes.*;

class Main extends Engine
{
    static function main() {
        new Main();
    }

    override public function init() {
        HXP.scene = new GameScene();
    }

	override public function update() {
        super.update();
    }
}
