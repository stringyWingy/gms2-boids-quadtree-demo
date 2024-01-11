/// @description Insert description here
// You can write your code in this editor

function mag(){
	return point_distance(0,0,x,y);
}

function setMag(m){
	normalize();	
	mult(m);
}

function setDir(d){
	var m = mag();//save the current mag so we can restore it

	x = dcos(d);
	y = -dsin(d);
	
	mult(m);
}

function setRad(r){
	direction = radtodeg(r);

	x = dcos(d)*mag();
	y = -dsin(d)*mag();
}

function setPos(nx,ny){
	x = nx;
	y = ny;
	
	updateDirection();
}

function add(obj){
	setPos(x+obj.x,y+obj.y);
}

function sub(obj){
	setPos(x-obj.x,y-obj.y);
}

function updateDirection(){
	if (x != 0 && y != 0){
		direction = point_direction(0,0,x,y);
	}
}

function mult(m){
	setPos(x*m,y*m);
}

function normalize(){
	x = dcos(direction);
	y = -dsin(direction);
}

function random2D(){
	setDir(random(360));
	normalize();
}

function limit(m){
	if (mag() > m){
		setMag(m);	
	}
}

updateDirection();