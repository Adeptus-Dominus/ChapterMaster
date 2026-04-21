function scr_random_find(owner, is_planet, ship_action, feature) {
    // This returns a star or fleet instanceID

    if (is_planet && instance_exists(obj_star)) {
        var stars = [];
        with (obj_star) {
            var no_owner = owner == 0;
            var has_correct_owner = no_owner || array_contains(p_owner, owner); // && storm==0; this is from the duke code, it checks for no warp storms
            var no_feature = feature == "";
            var has_correct_feature = no_feature || array_contains(p_feature, feature);
            if (has_correct_owner && has_correct_feature) {
                array_push(stars, id);
            }
        }
        if (array_length(stars) != 0) {
            var star_index = irandom(array_length(stars) - 1);
            var star = stars[star_index];
            return star; // use that to get the obj
        } else {
            return undefined;
        }
    } else if (!is_planet && instance_exists(obj_all_fleet)) {
        var ships = [];
        with (obj_all_fleet) {
            var no_owner = owner == 0;
            var has_correct_owner = no_owner || this.owner == owner;
            var no_action = ship_action == "";
            var has_correct_action = no_action || this.action == ship_action;
            if (has_correct_owner && has_correct_action) {
                array_push(ships, id);
            }
        }
        if (array_length(ships) != 0) {
            var ship_index = irandom(array_length(ships) - 1);
            var ship = ships[ship_index];
            return ship;
        } else {
            return undefined;
        }
    } else {
        return undefined; //?? I think it would return that regardless
    }
}
