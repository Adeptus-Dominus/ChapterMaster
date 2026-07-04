// These arrays are the losses on any one frame.
// Instead of resetting in a bunch of places, we reset here.
array_resize(lost, 0);
array_resize(lost_num, 0);

update_block_size();
update_block_unit_count();

// Basic combat orders: left-clicking a block's bar toggles it between advancing and
// holding. hit() is the drawn bar's own hover box (fadein-guarded), the same hitbox
// the Row Composition panel keys off, so clicks land exactly where the player is
// pointing rather than on the instance's sprite mask. Orders only exist once seeded
// (move_order != ""), and the Defenses pseudo-block is not orderable.
if (mouse_check_button_pressed(mb_left) && (move_order != "") && (veh_type[1] != "Defenses") && hit()) {
    move_order = (move_order == "advance") ? "hold" : "advance";
}
