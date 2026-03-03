if (cooldown > 0) {
    cooldown--;
}

if (fade_alpha > 0) {
    fade_alpha = approach(fade_alpha, 0, 0.01);
}

if (fade_alpha <= 0.5) {
    title_alpha = approach(title_alpha, 1.0, 0.02);

    if (instance_exists(obj_cursor)) {
        obj_cursor.image_alpha = title_alpha;
    }
}
