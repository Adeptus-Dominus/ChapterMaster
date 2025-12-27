/// @description (Old DnD) - draw ellipse
/// @param x1	x position of start point
/// @param y1	y position of start point
/// @param x2	x position of end point
/// @param y2	y position of end point
/// @param outline	true if outline
function action_draw_ellipse(argument0, argument1, argument2, argument3, argument4) {

	var xx1 = argument0;
	var yy1 = argument1;
	var xx2 = argument2;
	var yy2 = argument3;
	if (global.__argument_relative) {
		xx1 += x;
		yy1 += y;
		xx2 += x;
		yy2 += y;
	}  // end if

	draw_ellipse( xx1, yy1, xx2, yy2, argument4 );



}


function draw_circle_with_outline_width(xx,yy,r,w){
	for (var i=0.0;i<w;i+=0.1){
		draw_circle(xx,yy,r+i,1);
	}
}

