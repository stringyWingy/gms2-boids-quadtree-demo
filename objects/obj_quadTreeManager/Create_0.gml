/// @description Insert description here
// You can write your code in this editor
inc = font_get_size(fnt_info);
line = 0;


function printLine(str){
	draw_text(0,line*inc,str);
	line++;
}

pop = instance_number(obj_birb);
popArr = array_create(pop);

for (var i = 0; i < pop; i++){
	popArr[@ i] = instance_find(obj_birb, i);
}