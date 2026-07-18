try {
    if (obj_ncombat.started == 0) {
        if (men + dreads + veh <= 0) {
            instance_destroy();
        }
        obj_ncombat.player_forces += self.men + self.veh + self.dreads;
        obj_ncombat.player_max += self.men + self.veh + self.dreads;

        //TODO centralise a method for moving units between columns
        /*if (men<=4) and (veh=0) and (dreads=0){// Squish leftt
            var leftt=instance_nearest(x-12,y,obj_pnunit);
            
        
        }*/
    }

    if ((obj_ncombat.red_thirst >= 2) && (obj_ncombat.battle_over == 0)) {
        if (men > 0) {
            var miss = "";
            var r_lost = 0;

            for (var raar = 0; raar < (men + dreads); raar++) {
                var _r_roll = floor(random(1000)) + 1;
                if (obj_ncombat.player_forces < (obj_ncombat.player_max * 0.75)) {
                    _r_roll -= 8;
                }
                if (obj_ncombat.player_forces < (obj_ncombat.player_max / 2)) {
                    _r_roll -= 10;
                }
                if (obj_ncombat.player_forces < (obj_ncombat.player_max / 4)) {
                    _r_roll -= 24;
                }
                if (obj_ncombat.player_forces < (obj_ncombat.player_max / 7)) {
                    _r_roll -= 104;
                }
                if (obj_ncombat.player_forces < (obj_ncombat.player_max / 10)) {
                    _r_roll -= 350;
                }

                if ((marine_dead[raar] == 0) && (marine_type[raar] != "Death Company") && (marine_type[raar] != obj_ini.role[100][eROLE.CHAPTERMASTER]) && (_r_roll <= 4)) {
                    r_lost += 1;
                    marine_type[raar] = "Death Company";
                    obj_ncombat.red_thirst += 1;
                    if (r_lost == 1) {
                        miss += "Battle Brother " + string(unit_struct[raar].name()) + ", ";
                    }
                    if (r_lost > 1) {
                        miss += string(unit_struct[raar].name()) + ", ";
                    }
                }
            }
            if (r_lost > 1) {
                miss = string_replace(miss, "Battle Brother", "Battle Brothers");
            }

            var woo = string_length(miss);
            miss = string_delete(miss, woo - 1, 2); // remove last

            if (string_count(", ", miss) == 1) {
                miss = string_replace(miss, ", ", " and ");
            }
            if (string_count(", ", miss) > 1) {
                woo = string_rpos(", ", miss);

                miss = string_delete(miss, woo - 1, 3);
                if (r_lost >= 3) {
                    miss = string_insert(", and ", miss, woo - 1);
                }
                if (r_lost == 2) {
                    miss = string_insert(" and ", miss, woo - 1);
                }
            }

            if (r_lost == 1) {
                miss += " has been lost to the Red Thirst!";
            }
            if (r_lost > 1) {
                miss += " have been lost to the Red Thirst!";
            }

            if (r_lost > 0) {
                obj_ncombat.combat_log.push(miss, eMSG_COLOR.RED);
                obj_ncombat.timer_pause = 2;
            }
        }
    }

    if (obj_ncombat.started >= 1) {
        // Should probably have the option under deployment to say 'Should Assault Marines enter the fray with vehicles?'   [ ]
    }

    // Right here execute some sort of check- if left is open, and engaged, and enemy is only vehicles, and no weapons to hurt them...

    if (instance_exists(obj_enunit)) {
        if (collision_point(x + 10, y, obj_enunit, 0, 1) != noone && collision_point(x - 10, y, obj_pnunit, 0, 1) == noone) {
            var neares = instance_nearest(x + 10, y, obj_enunit);

            if ((neares.men == 0) && (neares.veh > 0)) {
                var norun = 0;

                for (var i = 1; i <= 20; i++) {
                    if (apa[i] > 2) {
                        norun = 1;
                        break;
                    }
                }

                if (norun == 0 && x > 10) {
                    x -= 10;
                    engaged = false;
                }
            }
        }
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
}
