if (hide == true) {
    exit;
}

if (battle_special > 0) {
    alarm[0] = 1;
    cooldown = 10;
    exit;
}

/* */
/*  */

// Upstream's fleet-retreat refactor (dc53f1900) deleted the type-99 release from
// this handler while obj_turn_end's flee branch still creates the popup: without
// this, fleeing a fleet battle strands an invisible modal and locks all input
// (reintroduced softlock, present verbatim in upstream main). Any click releases.
if ((type == 99) && instance_exists(obj_turn_end)) {
    player_retreat_from_fleet_combat();
    exit;
}
