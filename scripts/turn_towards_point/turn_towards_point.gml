function turn_towards_point(argument0, argument1, argument2, argument3, argument4, argument5) {
    // turn_towards_point(currentAngle, x1, y1, x2, y2, speed);

    var ca, x1, y1, x2, y2, sp, a;
    ca = argument0 * pi / 180;
    x1 = argument1;
    y1 = argument2;
    x2 = argument3;
    y2 = argument4;
    sp = argument5 * pi / 180;

    a = arctan2(y1 - y2, x2 - x1) - ca;
    while (a < -pi || a > pi) {
        a += (pi * 2) * -sign(a);
    }

    a = min(sp, max(-sp, a));
    a += ca;

    while (a < -pi || a > pi) {
        a += (pi * 2) * -sign(a);
    }

    return a / (pi / 180);
}
