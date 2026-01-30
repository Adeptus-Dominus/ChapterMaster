function draw_animated_scanline(x1, y1, width, height, time = 10, color = 5998382) {
    static line_move = 0;
    draw_set_color(color);
    var step_millisecond = current_time / 1000;
    var anim = (step_millisecond % time) / time * 20; // anim will cycle from 0 to 20 over the duration specified by anim_length
    if (anim <= 10) {
        draw_set_alpha(anim / 10);
    } else {
        draw_set_alpha(2 - (anim / 10));
    }
    line_move = y1 + (height * ((anim % 20) / 20));
    if (irandom(100) <= 5) {
        line_move -= 4;
    }
    draw_line(x1, line_move, x1 + width, line_move);
    draw_set_alpha(1);
}
