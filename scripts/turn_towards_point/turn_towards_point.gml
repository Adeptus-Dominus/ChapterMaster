function turn_towards_point(current_angle, x1, y1, x2, y2, turn_speed) {
	// turn_towards_point(currentAngle, x1, y1, x2, y2, speed);

	var ca = degtorad(current_angle);

	var sp = degtorad(turn_speed);

	var a = arctan2(y1-y2, x2-x1) - ca;
	while (a < -pi || a > pi)
	a += (pi*2) * -sign(a);

	a = min(sp, max(-sp, a));
	a += ca;

	while (a < -pi || a > pi)
	a += (pi*2) * -sign(a);

	return a / (pi/180);


}

function ship_turn_towards_point(target_x,target_y){
	direction = turn_towards_point(direction, x, y, target_x, target_y, turning_speed);
}
