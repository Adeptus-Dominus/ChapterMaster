function space_hulk_explore_battle_aftermath() {
    if (!defeat && hulk_treasure > 0) {
        var shi = 0, loc = "";

        var shiyp = instance_nearest(battle_object.x, battle_object.y, obj_p_fleet);
        if (shiyp.x == battle_object.x && shiyp.y == battle_object.y) {
            shi = fleet_full_ship_array(shiyp)[0];
            loc = obj_ini.ship[shi];
        }

        if (hulk_treasure == 1) {
            // Requisition
            var _reqi = irandom_range(30, 60) * 10;
            obj_controller.requisition += _reqi;

            var pop = instance_create(0, 0, obj_popup);
            pop.image = "space_hulk_done";
            pop.title = "Space Hulk: Resources";
            pop.text = $"Your battle brothers have located several luxury goods and coginators within the Space Hulk.  They are salvaged and returned to the ship, granting {_reqi} Requisition.";
        } else if (hulk_treasure == 2) {
            // Artifact
            //TODO this will eeroniously put artifacts in the wrong place but will resolve crashes
            var last_artifact = scr_add_artifact("random", "random", 4, loc, shi);
            var i = 0;

            var pop = instance_create(0, 0, obj_popup);
            pop.image = "space_hulk_done";
            pop.title = "Space Hulk: Artifact";
            pop.text = $"An Artifact has been retrieved from the Space Hulk and stowed upon {loc}.  It appears to be a {fetch_artifact(last_artifact).get_type_name()} but should be brought home and identified posthaste.";
            scr_event_log("", "Artifact recovered from the Space Hulk.");
        } else if (hulk_treasure == 3) {
            // STC
            scr_add_stc_fragment(); // STC here
            var pop;
            pop = instance_create(0, 0, obj_popup);
            pop.image = "space_hulk_done";
            pop.title = "Space Hulk: STC Fragment";
            pop.text = "An STC Fragment has been retrieved from the Space Hulk and safely stowed away.  It is ready to be decrypted or gifted at your convenience.";
            scr_event_log("", "STC Fragment recovered from the Space Hulk.");
        } else if (hulk_treasure == 4) {
            // Termie Armour
            var termi = choose(2, 2, 2, 3);
            scr_add_item("Terminator Armour", termi);
            var pop;
            pop = instance_create(0, 0, obj_popup);
            pop.image = "space_hulk_done";
            pop.title = "Space Hulk: Terminator Armour";
            pop.text = "The fallen heretics wore several suits of Terminator Armour- a handful of them were found to be cleansible and worthy of use.  " + string(termi) + " Terminator Armour has been added to the Armamentarium.";
        }
    }
}
