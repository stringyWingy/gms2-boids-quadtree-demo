/// @description clear and update quadtree
// You can write your code in this editor

//clear the quadtree first
delete global.QUADTREE;
global.QUADTREE = new Quadtree(0,0,room_width,room_height,global.QUADTREE_CAP);


for (var i = 0; i < pop; i++){
	//loop through the entire population, insert them into the grid
	global.QUADTREE.insert(popArr[i]);
}

//show_debug_message(global.QUADTREE);
