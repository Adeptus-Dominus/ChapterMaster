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
// Shift + left-click orders a retreat: the formation withdraws west off the field,
// cannot fire, takes heavily reduced damage, and accepts no further orders.
if (mouse_check_button_pressed(mb_left) && keyboard_check(vk_shift) && (move_order != "") && (move_order != "retreat") && (veh_type[1] != "Defenses") && hit()) {
    if ((player_fighting_blocks_count() <= 1) && (rearguard_ticks < RETREAT_REARGUARD_HOLD) && instance_exists(obj_enunit)) {
        // The last fighting formation is the rear guard: it must delay the enemy
        // before it may follow the withdrawal (see RETREAT_REARGUARD_HOLD).
        obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} must hold as rear guard before they may withdraw!", eMSG_COLOR.YELLOW);
    } else {
        move_order = "retreat";
        order_manual = true;
        obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} are retreating from the field!", eMSG_COLOR.YELLOW);
    }
} else if (mouse_check_button_pressed(mb_left) && (move_order != "") && (move_order != "retreat") && (veh_type[1] != "Defenses") && hit()) {
    move_order = (move_order == "advance") ? "hold" : "advance";
    // Player-issued orders unlock formation merging for this block; untouched blocks
    // keep vanilla movement so formations hold shape.
    order_manual = true;
}

// Right-click cycles this formation's firing order: nearest enemies, then the first,
// second, or third enemy line, confirmed in the combat log. Retreating formations
// take no firing orders.
if (mouse_check_button_pressed(mb_right) && (move_order != "") && (move_order != "retreat") && (veh_type[1] != "Defenses") && hit()) {
    fire_target_line = (fire_target_line + 1) % 4;
    var _fire_names = ["the nearest enemies", "the first enemy line", "the second enemy line", "the third enemy line"];
    obj_ncombat.combat_log.push($"The {formation_display_name(formation_type)} are now firing on {_fire_names[fire_target_line]}!", eMSG_COLOR.AQUA);
}
