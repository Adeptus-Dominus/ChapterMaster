function scr_bolt(argument0, argument1, argument2, argument3, argument4) {
    //creator: Schalken. 081102
    //this script draws a lightning bolt in the brush color.
    //format: scr_bolt(from_x,from_y,to_x,to_y,crazy);

    var xx, yy, tx, ty, dir, wild, wild2;
    xx = argument0;
    yy = argument1;
    tx = round(argument2);
    ty = round(argument3);

    if (argument4 == 0) {
        wild = 90;
        wild2 = 181;
    } else {
        wild = 135;
        wild2 = 271;
    }

    do {
        dir = point_direction(xx, yy, tx, ty) - wild + floor(random(wild2));
        xx += lengthdir_x(1, dir);
        yy += lengthdir_y(1, dir);
        draw_point(xx, yy);
    } until (round(xx) == tx && round(yy) == ty)
}
