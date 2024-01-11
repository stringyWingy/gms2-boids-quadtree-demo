/// @description Insert description here
// You can write your code in this editor

alarm_set(0,60+random(240));

var push = new Vec2(0,0).random2D();
push.setMag(random(global.MAX_SPEED));
push.sub(vel);
applyForce(push);
