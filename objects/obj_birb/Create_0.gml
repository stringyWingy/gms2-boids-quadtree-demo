/// @description Insert description here
// You can write your code in this editor

pos = new Vec2(x,y);
vel = new Vec2(0,0);
acc = new Vec2(0,0);
neighbors = [];

drawSize = 10;
drawWeight = 2;
drawPizza = 150;

pointer = new Vec2(0,0);

colv = 0;

function applyForce(f){
	acc.add(f);
}

function updatePosition(){
	perceive();
	cohesion();
	alignment();
	separation();
	
	vel.add(acc);
	vel.limitMag(global.MAX_SPEED);
	colv = 255*(vel.mag()/global.MAX_SPEED);
	pos.add(vel);
	
	acc.setXY(0,0);
	
	if (pos.x > room_width){pos.x = 0;}
	if (pos.x < 0){pos.x = room_width;}
	if (pos.y > room_height){pos.y = 0;}
  	if (pos.y < 0){pos.y = room_height;}
	
	x=pos.x;
	y=pos.y;
	
	pointer.setXY(vel.x,vel.y);
	pointer.setMag(drawSize);
}

function perceive(){
	delete neighbors;
	neighbors = [];
	var r = global.SIGHT_DISTANCE;
	global.QUADTREE.queryCirc([x,y,r],neighbors);
}

function cohesion(){
	var avgpos = new Vec2(0,0);
	var nlen = array_length(neighbors);
	for(var i = 0; i < nlen; i++){
		if neighbors[i] != self{
			avgpos.add(neighbors[i].pos);
		}
	}
	//average out the positions
	if (nlen > 0) {avgpos.multiplyScalar(1/nlen);}
	
	//steering vector is desired-current
	avgpos.sub(pos);
	
	if (avgpos.mag() != 0) avgpos.normalize();
	//avgpos.sub(vel);
	avgpos.multiplyScalar(global.COHESION_FORCE);
	avgpos.limitMag(global.MAX_FORCE);
	
	applyForce(avgpos);
}

function alignment(){
	var steering = new Vec2(0,0);
	var nlen = array_length(neighbors);
	for(var i = 0; i < nlen; i++){
		if neighbors[i] != self{
			steering.add(neighbors[i].vel);
		}
	}
	if (nlen > 0) {steering.multiplyScalar(1/nlen);}
	
	if (steering.mag() != 0)
	steering.normalize();
	//steering.sub(vel);
	steering.multiplyScalar(global.ALIGN_FORCE);
	steering.limitMag(global.MAX_FORCE);
	
	
	applyForce(steering);
}

function separation(){
	var steering = new Vec2(0,0);
	var diff = new Vec2(x,y);
	
	var nlen = array_length(neighbors);
	for(var i = 0; i < nlen; i++){
		if neighbors[i] == self {continue;}
		
		diff.setXY(x,y);
		diff.sub(neighbors[i].pos);
		var relativeDistance = diff.mag()/global.SIGHT_DISTANCE;
		var repulsion = (1-relativeDistance)*global.SEPARATION_FORCE;
		diff.multiplyScalar(repulsion);
 		steering.add(diff);
	}
	//average out the positions
	if (nlen > 0) {steering.multiplyScalar(1/nlen);}
	
	//steering vector is desired-current
	//steering.normalize();
	//steering.sub(vel);
	steering.limitMag(global.MAX_FORCE);
	
	
	applyForce(steering);
}
//vel.setMag(6);
alarm_set(0,1);