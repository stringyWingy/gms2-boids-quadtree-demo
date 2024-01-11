///@function Vec3(x,y,z)
///@param Real x
///@param Real y
///@param Real z
function Vec3(_x,_y,_z) constructor{
	x = _x;
	y = _y;
	z = _z;

	static clone = function(){
		return new Vec3(x,y,z);
	};
	
	static copy = function(_obj){
		x = _obj.x;
		y = _obj.y;
		z = _obj.z;
	};
	
	static mag = function(){
		return point_distance_3d(0,0,0,x,y,z);
	};
	
	static dir = function(){
		return point_direction(0,0,x,y);
	};
	
	static pitch = function(){
		if (mag() != 0)	return darcsin(z/_mag());
		else return 0;
	};

	 static setMag = function(_m){
		normalize();	
		multiplyScalar(_m);
	};

	static setDir = function(_d){
		var _m = mag();//save the current _mag so we can restore it
		var _p = pitch();

		setDirPitchMag(_d,_p,_m);
	};

	static setPitch = function(_p){
		var _m = mag();	
		var _d = dir();
		
		setDirPitchMag(_d,_p,_m);
	};
	
	static setDirPitchMag = function(_d,_p,_m){
		x = dcos(_d)*dcos(_p)*_m;
		y = -dsin(_d)*dcos(_p)*_m;
		z = dsin(_p)*_m;
		
	};
	
	static setXYZ = function(_x,_y,_z){
		x = _x;
		y = _y;
		z = _z;
	};

	static add = function(_obj){
		x += _obj.x;
		y += _obj.y;
		z += _obj.z;
	};

	static sub = function(_obj){
		x -= _obj.x;
		y -= _obj.y;
		z -= _obj.z;
	};

	static multiply3D = function(_m){
		x *= _m;
		y *= _m;
		z *= _m;
	};
	
	static dot = function(_obj){
		return x*_obj.x + y*_obj.y + z*_obj.z;
	};

	static normalize = function(){
		var d = dir();
		var p = pitch();
		var m = 1;
		
		setDPM(d,p,m);
	};

	static random3D = function(){
		var m = 1;
		var d = random(360);
		var p = random_range(-90,90);
		
		setDPM(d,p,m);
		return self
	};

	static limit = function(m){
		if (mag() > m){
			setMag(m);	
		}
	};
	
	static fromArray = function(_arr, _offset = 0){
		x = _arr[_offset];
		y = _arr[_offset + 1];
		z = _arr[_offset + 2];
	};
	
	static toArray = function(_arr, _offset = 0){
		_arr[_offset] = x;
		_arr[_offset + 1] = y;
		_arr[_offset + 2] = z;
	};
}

function Vec3_DirPitchMag(_d,_p,_m) : Vec3(_d,_p,_m) constructor {
	x = 0;
	y = 0;
	z = 0;
	setDPM(_d,_p,_m);
}