 // Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

///@function Vec2(x,y)
///@param Real x
///@param Real y
function Vec2(_x,_y) constructor{
	x = _x;
	y = _y;

	static clone = function(){
		return new _Vector(x,y);
	};

	static copy = function(_obj){
		x = _obj.x;
		y = _obj.y;
	}

	static mag = function(){
		return point_distance(0,0,x,y);
	};
	
	static dir = function(){
		return point_direction(0,0,x,y);	
	};
	
	 static setMag = function(_m){
		normalize();	
		multiplyScalar(_m);
	};

	static setDir = function(_d){
		var _m = mag();//save the current _mag so we can restore it

		x = dcos(_d)*_m;
		y = -dsin(_d)*_m;
	};

	static setDirMag = function(_d,_m){
		x = dcos(_d)*_m;
		y = -dsin(_d)*_m;
	};

	static setRad = function(r){
		var _d = radtodeg(r);

		x = dcos(_d)*_mag();
		y = -dsin(_d)*_mag();
	};

	static setXY = function(_x,_y){
		x = _x;
		y = _y;
	};

	static add = function(_obj){
		x += _obj.x;
		y += _obj.y;
	};

	static sub = function(_obj){
		x -= _obj.x;
		y -= _obj.y;
	};

	static multiplyScalar = function(_s){
		x *= _s;
		y *= _s;
	};
	
	static multiply2D = function(_obj){
		x *= _obj.x;
		y *= _obj.y;
	}

	static normalize = function(){
		var _d = dir();
		
		x = dcos(_d);
		y = -dsin(_d);
	};

	static random2D = function(){
		normalize();
		setDir(random(360));
		
		return self
	};

	static limitMag = function(_m){
		if (mag() > _m){
			setMag(_m);	
		}
	};
	
	static mirrorY = function(){
		y = -y;
	};
	
	static mirrorX = function(){
		x = -x;
	};
	
	static dot = function(_obj){
		return x*_obj.x + y*_obj.y
	}
	
	static snap = function(_vecOffset,_gridSize){
		var _ox = x + _vecOffset.x;
		var _oy = y + _vecOffset.y;
		
		x = floor(x/_gridSize)*_gridSize;
		y = floor(y/_gridSize)*_gridSize;
	}
	
	static fromArray = function(_arr, _offset = 0){
		x = _arr[_offset];
		y = _arr[_offset + 1];
	}
	
	static toArray = function(_arr, _offset = 0){
		_arr[_offset] = x;
		_arr[_offset + 1] = y;
	}
}

///@function Vec2_DirMag(_direction,_magnitude)
///@param Real direction
///@param Real magnitude
function Vec2_DirMag(_d,_m) : Vec2(_d,_m) constructor {
	x = dcos(_d)*_m;
	y = -dsin(_d)*_m;
}

///@function complexPower(_vec,_degree)
function complexPower(_vec, _degree){
	if (_degree == 0){
		return new _Vector(1,0);
	}
	else if (_degree == 1){
		return _vec;	
	}
	
	var _output = _vec.clone();
	for (var _i = 1; _i < _degree; _i++){
		_output = _complexMultiply(_output,_vec);
	}
	return _output;
}

//using a vector to represent real and i_maginary coefficients
///@function complexMultiply(_vec1,_vec2)
function complexMultiply(_vec1,_vec2){
	var _x = _vec1.x;
	var _y = _vec1.y;
	var _X = _vec2.x;
	var _Y = _vec2.y;
	
	return new Vec2((_X * _x) - (_Y * _y), (_x * _Y) + (_X * _y));
};
