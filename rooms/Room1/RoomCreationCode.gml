global.SIGHT_DISTANCE = 75;
global.MAX_SPEED = 6;
global.MAX_FORCE = 7;

global.ALIGN_FORCE = 1;
global.COHESION_FORCE = 1.5;
global.SEPARATION_FORCE = 2;

global.QUADTREE_CAP = 60;
global.QUADTREE = new Quadtree(0,0,room_width,room_height,global.QUADTREE_CAP);

for (i = 0; i < 200; i++){
	var nx = random(room_width);
	var ny = random(room_height);
	
	with (instance_create_layer(nx,ny,"lyr_birbs",obj_birb)) {alarm_set(0,1)};
}

//instance_create_layer(room_width/2,room_height/2,"lyr_birbs",obj_birb);
instance_create_layer(0,0,"lyr_quadtree",obj_quadTreeManager);