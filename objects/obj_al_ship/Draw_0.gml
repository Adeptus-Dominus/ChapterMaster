if (name != "") {
    draw_self();

    draw_set_font(fnt_info);
    draw_set_halign(fa_center);

    draw_ship_status_overlay(self, CM_GREEN_COLOR, COL_REQUISITION);
}
