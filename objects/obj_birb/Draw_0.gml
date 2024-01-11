/// @description Insert description here
// You can write your code in this editor

var colh = (vel.dir()/360)*255;
var col = make_color_hsv(colh,255,255);

//var x1 = pos.x;
//var y1 = pos.y;
//var x2 = x1 + pointer.x;
//var y2 = y1 + pointer.y;

//pointer.setDir(pointer.dir()+drawPizza);
//var x3 = x1 + pointer.x;
//var y3 = y1 + pointer.y;

//pointer.setDir(pointer.dir()-drawPizza*2);
//var x4 = x1 + pointer.x;
//var y4 = y1 + pointer.y;

//draw_set_color(c_black);
//draw_line_width(x2,y2,x3,y3,drawWeight);
//draw_line_width(x2,y2,x4,y4,drawWeight);
//draw_line_width(x1,y1,x3,y3,drawWeight);
//draw_line_width(x1,y1,x4,y4,drawWeight);
//draw_set_color(col);
//for (var i = 0; i < array_length(neighbors); i++){
//	var n = neighbors[i];
//	if (n == self ||
//	(point_distance(x,y,n.x,n.y) > global.SIGHT_DISTANCE))
//	{continue;}
//	draw_line_width(x,y,n.x,n.y,1);
//}

draw_sprite_ext(spr_arrow,0,x,y,1,1,vel.dir(),col,1);
////draw_circle(pos.x,pos.y,global.SIGHT_DISTANCE,true);
//draw_set_color(col2);
//draw_circle(x,y,drawSize/3,false);

//var drawstring = "pos: " + string_format(pos.x,0,1) + ", " + string_format(pos.y,0,1) + ". ";
//drawstring += "vel: " + string_format(vel.direction,0,1) + ", " + string_format(vel.mag(),0,1) + ". ";

//draw_set_font(fnt_info);
//draw_text(0,0,drawstring);