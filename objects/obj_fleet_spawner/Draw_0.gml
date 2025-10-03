

exit;

var y1,y2;
y1=y-(height/2);
y2=y+(height/2);

draw_set_color(CM_GREEN_COLOR);draw_set_alpha(1);

if (x<800) then draw_rectangle(-300,y1,300,y2,0);
if (x>800) then draw_rectangle((room_width)-300,y1,room_width+300,y2,0);

