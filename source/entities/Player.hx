package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.math.*;

class Player extends Entity
{
    public static inline var RUN_SPEED = 200;
    public static inline var JUMP_POWER = 300;
    public static inline var GRAVITY = 800;
    public static inline var MAX_FALL_SPEED = 300;

    private var velocity:Vector2;

    public function new() {
        super(25, 300);
        Key.define("left", [Key.LEFT, Key.LEFT_SQUARE_BRACKET]);
        Key.define("right", [Key.RIGHT, Key.RIGHT_SQUARE_BRACKET]);
        Key.define("jump", [Key.Z]);
        Key.define("grapple", [Key.X]);
        graphic = new Image("graphics/player.png");
        velocity = new Vector2(0, 0);
        setHitbox(16, 16);
    }

    override public function update() {
        if(Input.check("left")) {
            velocity.x = -RUN_SPEED;
        }
        else if(Input.check("right")) {
            velocity.x = RUN_SPEED;
        }
        else {
            velocity.x = 0;
        }

        if(isOnGround()) {
            velocity.y = 0;
            if(Input.pressed("jump")) {
                velocity.y = -JUMP_POWER;
            }
        }
        else {
            velocity.y = Math.min(
                velocity.y + GRAVITY * HXP.elapsed,
                MAX_FALL_SPEED
            );
        }

        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls");
        super.update();
    }

    private function isOnGround() {
        return collide("walls", x, y + 1) != null;
    }
}
