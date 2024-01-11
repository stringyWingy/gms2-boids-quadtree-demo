global.SIGHT_DISTANCE = 30;
global.MAX_SPEED = 5;
global.MAX_FORCE = 7;

global.ALIGN_FORCE = 1;
global.COHESION_FORCE = 2;
global.SEPARATION_FORCE = 1.1;

global.QUADTREE_CAP = 32;
global.QUADTREE = new Quadtree(0,0,room_width,room_height,global.QUADTREE_CAP);

var _starting_population = 200;

for (i = 0; i < _starting_population; i++){
	var nx = random(room_width);
	var ny = random(room_height);
	
	with (instance_create_layer(nx,ny,"lyr_birbs",obj_birb)) {alarm_set(0,1)};
}

//instance_create_layer(room_width/2,room_height/2,"lyr_birbs",obj_birb);
instance_create_layer(0,0,"lyr_quadtree",obj_quadTreeManager);