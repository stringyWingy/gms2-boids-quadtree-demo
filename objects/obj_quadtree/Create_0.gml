/// @description Insert description here
// You can write your code in this editor

ne = false;
nw = false;
se = false;
sw = false;

w = 0;
h = 0;

divided = false;

points = [];
capacity = 0;
col = c_white;

function setup(ux,uy,uw,uh,cap){
	x = ux;
	y = uy;
	w = uw;
	h = uh;
	capacity = cap;
	
	return self;
	
}

function clear(){
	//recursively destroy all the instances that represent the quadtree
	if divided {
		nw.clear();
		ne.clear();
		sw.clear();
		se.clear();
	}
	instance_destroy(self);
}

//attempts to insert a point, returns true if success, false if not
function insert(p){    
	var len = array_length(points);
	
	 //if the point is not within bounds, quit and return false
	if !containsPoint(p) {return false;}
	
	//if we haven't hit capacity yet, add the point
	if (len < capacity){
		array_push(points,p);
		return true;
	}
	//but if we have, subdivide, and proceed attempting to inser the point into each child
	else {
		if (!divided) {divide();}
		
		//save a little bit of time by returning right away on the first successful attempt;
		if (nw.insert(p)) return true;
		if (ne.insert(p)) return true;
		if (sw.insert(p)) return true;
		if (se.insert(p)) return true;
	}
}

function divide(){
	divided =  true;
	
	nw = instance_create_layer(0,0,"lyr_quadtree",obj_quadtree).setup(x,y,w/2,h/2,capacity);
	ne = instance_create_layer(0,0,"lyr_quadtree",obj_quadtree).setup(x+w/2,y,w/2,h/2,capacity);
	sw = instance_create_layer(0,0,"lyr_quadtree",obj_quadtree).setup(x,y+h/2,w/2,h/2,capacity);
	se = instance_create_layer(0,0,"lyr_quadtree",obj_quadtree).setup(x+w/2,y+h/2,w/2,h/2,capacity);
	
	//flush all our points into their appropriate new quadrants
	for (var i = 0; i < array_length(points); i++){
		var p = points[i];
		if (nw.insert(p)) continue;
		if (ne.insert(p)) continue;
		if (sw.insert(p)) continue;
		if (se.insert(p)) continue;		
	}
	
	points = [];//since all our points have been copied over to new quadrants, flush our points out
}

function containsPoint(p,arr){
	//option to supply a range
	if is_array(arr){
		var ux = arr[0];
		var uy = arr[1];
		var uw = arr[2];
		var uh = arr[3];
		
		if (p.x >= ux &&
		p.y >= uy &&
		p.x < ux+uw &&
		p.y < uy+uh) return true;
		else return false;
	}	
	else if (p.x >= x &&
	p.y >= y &&
	p.x < x+w &&
	p.y < y+h) return true;
	
	else return false;
}

function isContainedInRect(ux,uy,uw,uh){
	if (is_array(argument[0])) {
		var rect = argument[0];
		ux = rect[0];
		uy = rect[1];
		uw = rect[2];
		uh = rect[3];
		}
	
	var contains = false;
	
	if (ux <= x &&
	ux+uw >= x+w &&
	uy <= y &&
	uy+uh >= y+h) {contains = true;}
	
	return contains;
}

function isContainedInCirc(ux,uy,ur){
	if (is_array(argument[0])) {
		var circ = argument[0];
		ux = circ[0];
		uy = circ[1];
		ur = circ[2];
		}
	
	var contains = false;
	
	if (point_distance(ux,uy,x,y) <= ur &&
	point_distance(ux,uy,x+w,y) <= ur &&
	point_distance(ux,uy,x,y+h) <= ur &&
	point_distance(ux,uy,x+w,y+h) <= ur) {contains = true;}
	
	return contains;
}

function rectIntersects(ux,uy,uw,uh){
	if (is_array(argument[0])) {
		var rect = argument[0];
		ux = rect[0];
		uy = rect[1];
		uw = rect[2];
		uh = rect[3];
		}
	
	var intersect = true;
	
	if (ux >= x+w ||
	ux+uw < x ||
	uy >= y+h ||
	uy+h < y) {intersect = false;}
	
	return intersect;
}

function circIntersects(ux,uy,ur){
	if (is_array(argument[0])) {
		var circ = argument[0];
		ux = circ[0];
		uy = circ[1];
		ur = circ[2];
		}
	
	var intersect = true;
	
	//just like the rectangle algorithm
	//with the added condition that there's a maximum distance from the center of the circle to the
	//center of the rectangle, determined by the circle's radius and the distance from the center 
	//of the rectangle to the corner
	if ((ux - ur >= x+w) ||
	(ux + ur < x) ||
	(uy - ur >= y+h) ||
	(uy + ur < y) ||
	(point_distance(x+w*.5,y+h*.5,ux,uy) > power(w*.5,2)+power(h*.5,2) + ur))
	{intersect = false;}
	
	return intersect;
}

 function queryRect(ux,uy,uw,uh){
	var found = [];
	var queryRange = [];
	
	//either accept an array as input, or collect the 4 input arguments into a new array
	if (is_array(argument[0])) {queryRange = argument[0];}
	else {queryRange = [ux,uy,uw,uh];}
	//if the query range doesn't intersect this quad tree, return blank
	if (!rectIntersects(queryRange)) return found;
	if (isContainedInRect(queryRange)) {
		return dumpAllPoints();
	}
	else {
		//
		
		//check all the points inside this quad tree, add the ones that fit inside the query zone to the output
		for (var i = 0; i < array_length(points); i++){
			var p = points[i];
			if (containsPoint(p,queryRange)) {array_push(found,p);}
		}
		
		
		//if this tree has children, query the children
		if (divided){
			array_concat(found,nw.queryRect(queryRange));
			array_concat(found,ne.queryRect(queryRange));
			array_concat(found,sw.queryRect(queryRange));
			array_concat(found,se.queryRect(queryRange));
		}
	
		return found;
	}
}

function queryCirc(ux,uy,ur){
	var found = [];
	var queryRange = [];
	
	//either accept an array as input, or collect the 4 input arguments into a new array
	if (is_array(argument[0])) {
		queryRange = argument[0];
		ux = queryRange[0];
		uy = queryRange[1];
		ur = queryRange[2];
		}
	else {queryRange = [ux,uy,ur];}
	//if the query range doesn't intersect this quad tree, return blank
	if (!circIntersects(queryRange)) return found;
	if (isContainedInCirc(queryRange)) {return dumpAllPoints();}
	else {
		//check all the points inside this quad tree, add the ones that fit inside the query zone to the output

		//if this tree has children, query the children
		if (divided){
			array_concat(found,nw.queryCirc(queryRange));
			array_concat(found,ne.queryCirc(queryRange));
			array_concat(found,sw.queryCirc(queryRange));
			array_concat(found,se.queryCirc(queryRange));
		}
		
		else { //only if we're not divided should we loop through our points
			for (var i = 0; i < array_length(points); i++){
				var	p = points[i];
				if (point_distance(ux,uy,p.x,p.y) <= ur){array_push(found,p);}
			}
		}
		
		
		return found;
	}
}

function dumpAllPoints(){
	var found = [];
	if(divided){
		array_concat(found,nw.dumpAllPoints());
		array_concat(found,ne.dumpAllPoints());
		array_concat(found,sw.dumpAllPoints());
		array_concat(found,se.dumpAllPoints());
	}
	else{array_concat(found,points);}
	return found;
}