/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_info);
draw_set_color($000000);
draw_rectangle(0,0,inc*10,inc*10,false);
draw_set_color(c_gray);


printLine("QTCAP: " + string(global.QUADTREE_CAP));
printLine("FPS: " + string(fps));
printLine("SIGHT: " + string(global.SIGHT_DISTANCE));

var o = instance_find(obj_birb,0);
printLine("VEL.DIR: " + string(o.vel.dir()));
printLine("VEL.MAG: " + string(o.vel.mag()));
printLine("");
printLine("ACC.DIR: " + string(o.acc.dir()));
printLine("ACC.MAG: " + string(o.acc.mag()));

printLine("QUADS: " + string(global.QUADTREE.totalMembers()));
line = 0;