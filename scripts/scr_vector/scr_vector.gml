// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function                 Vector(x,y);
/// @param {string}  x  The x coordinate of the vector
/// @param {string}  y  The y coordinate of the vector
/// @description              Create a new vector at x, y

function Vector(ux,uy) constructor{
	x = ux;
	y = uy;

	static mag = function(){
		return point_distance(0,0,x,y);
	};
	
	static dir = function(){
		return point_direction(0,0,x,y);	
	};

	 static setMag = function(m){
		normalize();	
		mult(m);
	};

	static setDir = function(d){
		var m = mag();//save the current mag so we can restore it

		x = dcos(d)*m;
		y = -dsin(d)*m;
	};

	static setRad = function(r){
		var d = radtodeg(r);

		x = dcos(d)*mag();
		y = -dsin(d)*mag();
	};

	static setPos = function(ux,uy){
		x = ux;
		y = uy;
	};

	static add = function(obj){
		x += obj.x;
		y += obj.y;
	};

	static sub = function(obj){
		x -= obj.x;
		y -= obj.y;
	};

	static mult = function(m){
		x *= m;
		y *= m;
	};

	static normalize = function(){
		var d = dir();
		
		x = dcos(d);
		y = -dsin(d);
	};

	static random2D = function(){
		normalize();
		setDir(random(360));
		
		return self
	};

	static limit = function(m){
		if (mag() > m){
			setMag(m);	
		}
	};
}