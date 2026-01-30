if ((x < -1000) || (x > room_width + 1000) || (y < -1000) || (y > room_height + 1000)) {
    instance_destroy();
}
if ((point_distance(x, y, target_x, target_y) <= 10) && (yra == 0)) {
    pulsing = 1;
    yra = 1;
    speed = 0;
    image_speed = 1;
}

if (yra == 1) {
    pulsing += 1;
    if ((image_xscale < 1) && (pulsing <= 50)) {
        image_xscale += 0.05;
        image_yscale += 0.05;
    }
    if (pulsing >= 80) {
        image_alpha -= 0.05;
    }
    if ((pulsing >= 80) && (image_alpha <= 0)) {
        instance_destroy();
    }
}
