if (drag_selecting) {
    draw_set_alpha(0.5);
    draw_set_color(CM_GREEN_COLOR);
    draw_rectangle(sel_x1, sel_y1, mouse_x, mouse_y, 1);
    draw_set_alpha(1);
}
