// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//some array utilities real quick
function array_push(arr, val){
	var i = array_length(arr);
	array_set(arr,i,val);
}

function array_concat(arr1, arr2){
	for (var i = 0; i < array_length(arr2); i++){
		array_push(arr1, arr2[@ i]);
	}
}


function Quadtree(ux,uy,uw,uh,cap) constructor{
	ne = false;
	nw = false;
	se = false;
	sw = false;

	x = ux;
	y = uy;
	w = uw;
	h = uh;
	
	capacity = cap;
	divided = false;
	points = [];

	//attempts to insert a point, returns true if success, false if not
	//p is any object or struct with variables named x and y
	static  insert = function(p){    
		 //if the point is not within bounds, quit and return false
		if !containsPoint(p) {return false;}
	
		//if we haven't hit capacity yet, add the point
		var len = array_length(points);
		if (len < capacity){
			array_push(points,p);
			return true;
		}
		//but if we have, subdivide, and proceed attempting to inser the point into each child
		else {
			if !divided divide();
		
			//save a little bit of time by returning right away on the first successful attempt;
			if nw.insert(p) return true;
			if ne.insert(p) return true;
			if sw.insert(p) return true;
			if se.insert(p) return true;
		}
	};

	static divide = function(){
		divided =  true;
	
		nw = new Quadtree(x,y,w/2,h/2,capacity);
		ne = new Quadtree(x+w/2,y,w/2,h/2,capacity);
		sw = new Quadtree(x,y+h/2,w/2,h/2,capacity);
		se = new Quadtree(x+w/2,y+h/2,w/2,h/2,capacity);
	
		//flush all our points into their appropriate new quadrants
		for (var i = 0; i < array_length(points); i++){
			var p = points[i];
			if (nw.insert(p)) continue;
			if (ne.insert(p)) continue;
			if (sw.insert(p)) continue;
			if (se.insert(p)) continue;		
		}
	};

	static containsPoint = function(p,arr){
		//option to supply a range array [ux, uy, uh, uw]
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
	};

	static isContainedInRect = function(ux,uy,uw,uh){
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
	};

	static isContainedInCirc = function(ux,uy,ur){
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
	};

	static rectIntersects = function(ux,uy,uw,uh){
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
	};

	static circIntersects = function(ux,uy,ur){
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
	};

	 static queryRect = function(queryRange, found){
		//if no array is supplied to operate on, assume this call is the original call 
		//that will return a new array
		var originalCall = false;
		if !is_array(found) {found = []; originalCall = true;}
	
		//queryRange will be supplied as an array [ux,uy,uw,uh]
		//if the query range doesn't intersect this quad tree, return blank
		if !rectIntersects(queryRange) return;
		if isContainedInRect(queryRange) {
			dumpAllPoints(found);
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
				nw.queryRect(queryRange,found);
				ne.queryRect(queryRange,found);
				sw.queryRect(queryRange,found);
				se.queryRect(queryRange,found);
			}
	
			if originalCall return found;
		}
	};

	static queryCirc = function(queryRange,found){
		//if no array is supplied to operate on, assume this call is the original call 
		//that will return a new array
		var originalCall = false;
		if !is_array(found) {found = []; originalCall = true;}
		
		//queryRange will be an array supplied as [ux,uy,ur]


		//if the query range doesn't intersect this quad tree, return blank
		if !circIntersects(queryRange) return;
		if isContainedInCirc(queryRange) {dumpAllPoints(found); return;}
		else {
			//check all the points inside this quad tree, add the ones that fit inside the query zone to the output

			//if this tree has children, query the children
			if (divided){
				nw.queryCirc(queryRange,found);
				ne.queryCirc(queryRange,found);
				sw.queryCirc(queryRange,found);
				se.queryCirc(queryRange,found);
			}
		
			else { //only if we're not divided should we loop through our points
				for (var i = 0; i < array_length(points); i++){
					var	p = points[i];
					//only now do we need to know queryRanges actual values
					ux = queryRange[0];
					uy = queryRange[1];
					ur = queryRange[2];
					if (point_distance(ux,uy,p.x,p.y) <= ur){array_push(found,p);}
				}
			}
		
		
			if originalCall return found;
		}
	};

	static dumpAllPoints = function(found){
		var originalCall = false;
		if !is_array(found) {found = []; originalCall = true;}
		
		if (divided){
			nw.dumpAllPoints(found);
			ne.dumpAllPoints(found);
			sw.dumpAllPoints(found);
			se.dumpAllPoints(found);
		}
		else {array_concat(found,points);}
		if originalCall return found;
	};
	
	static draw = function(){
		if divided {
			nw.draw();
			ne.draw();
			sw.draw();
			se.draw();
		}
		
		else draw_rectangle(x,y,x+w,y+h,true);	
	};
	
	static toString = function(){
		var str = "QUADTREE " + string(x) + "," + string(y) + " " + string(w) + " " + string(h) + " "
		+ "DIVIDED " + (!divided ? "FALSE " : "TRUE ")
		+ "POINTS " + string(array_length(points));
		return str;
	}
	
	static totalMembers = function(){
			if divided return (nw.totalMembers() + ne.totalMembers() + sw.totalMembers() + se.totalMembers());
			else return 1;
	}
}