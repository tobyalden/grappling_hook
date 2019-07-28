package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.math.*;
import haxepunk.utils.*;

class Player extends Entity
{
    public static inline var RUN_SPEED = 200;
    public static inline var JUMP_POWER = 300;
    public static inline var GRAVITY = 800;
    public static inline var MAX_FALL_SPEED = 300;
    public static inline var HOOK_SPEED = 500;

    private var hook:Hook;
    private var velocity:Vector2;
    private var sprite:Image;

    public function new() {
        super(25, 300);
        layer = -1;
        Key.define("left", [Key.LEFT, Key.LEFT_SQUARE_BRACKET]);
        Key.define("right", [Key.RIGHT, Key.RIGHT_SQUARE_BRACKET]);
        Key.define("jump", [Key.Z]);
        Key.define("grapple", [Key.X]);
        sprite = new Image("graphics/player.png");
        graphic = sprite;
        velocity = new Vector2(0, 0);
        setHitbox(16, 16);
    }

    override public function update() {
        if(Input.check("left")) {
            velocity.x = -RUN_SPEED;
            sprite.flipX = true;
        }
        else if(Input.check("right")) {
            velocity.x = RUN_SPEED;
            sprite.flipX = false;
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

        if(Input.pressed("grapple")) {
            if(hook != null) {
                scene.remove(hook);
            }
            var hookVelocity = new Vector2(
                sprite.flipX ? -HOOK_SPEED : HOOK_SPEED,
                -HOOK_SPEED
            );
            hook = new Hook(centerX - 4, centerY - 4, hookVelocity);
            scene.add(hook);
        }
        if(Input.released("grapple")) {
            if(hook != null) {
                scene.remove(hook);
                hook = null;
            }
        }

        if(hook != null && hook.isAttached) {
            // https://math.stackexchange.com/questions/814950/how-can-i-rotate-a-coordinate-around-a-circle
            var rotateAmount = 0.05;
            var xRot = (
                Math.cos(rotateAmount) * (centerX - hook.centerX)
                - Math.sin(rotateAmount) * (centerY - hook.centerY)
                + hook.centerX
            );
            var yRot = (
                Math.sin(rotateAmount) * (centerX - hook.centerX)
                + Math.cos(rotateAmount) * (centerY - hook.centerY)
                + hook.centerY
            );
            x = xRot - width / 2;
            y = yRot - height / 2;
        }
        else {
            moveBy(
                velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls"
            );
        }
        super.update();
    }

    override public function render(camera:Camera) {
        if(hook != null && hook.isAttached) {
            Draw.color = 0xFFFFFF;
            Draw.line(centerX, centerY, hook.centerX, hook.centerY);
            Draw.color = 0x00FF00;
            Draw.circle(
                hook.centerX,
                hook.centerY,
                MathUtil.distance(
                    centerX, centerY, hook.centerX, hook.centerY
                ),
                100
            );
        }
        super.render(camera);
    }

    private function isOnGround() {
        return collide("walls", x, y + 1) != null;
    }
}
