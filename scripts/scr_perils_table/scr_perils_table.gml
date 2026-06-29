/// @self Asset.GMObject.obj_pnunit
function scr_perils_table(perils_strength, unit, psy_discipline, power_name, unit_id) {
    var combat_perils = [
        [
            1,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                unit.corruption += roll_dice_chapter(1, 6, "low");
                return "He begins to gibber as psychic backlash overtakes him.";
            },
        ],
        [
            5,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                marine_casting_cooldown[unit_id] += roll_dice_chapter(1, 6, "low");
                return "His mind is burned fiercely by the warp.";
            },
        ],
        [
            15,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                var _cooldown = roll_dice_chapter(1, 6, "low");
                marine_casting_cooldown[unit_id] += _cooldown;
                var _cooldown2 = roll_dice_chapter(1, 6, "low");
                if (men > 0) {
                    repeat (6) {
                        var t = irandom(men - 1); // Random value from 0 to men-1
                        if (marine_type[t] != "") {
                            marine_casting_cooldown[t] += _cooldown2;
                        }
                    }
                }
                return $"Psychic energy outlash knocks him out for {_cooldown} hours, and stuns nearby marines for {_cooldown2}.";
            },
        ],
        [
            20,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                unit.add_or_sub_health(roll_dice_chapter(1, 50, "low") * -1);
                var flavour_text2 = "The psychic blast he had prepared runs loose, striking himself!";
                switch (psy_discipline) {
                    case "biomancy":
                        flavour_text2 = "The psychic blast he had prepared runs loose, boiling his own blood!";
                        break;
                    case "pyromancy":
                        flavour_text2 = "He lights on fire from the inside out, burning in agony!";
                        break;
                    case "telekinesis":
                        flavour_text2 = "The blast he had prepared runs loose, smashing himself into the ground!";
                        break;
                }
                return flavour_text2;
            },
        ],
        [
            30,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                marine_casting_cooldown[unit_id] += 20;
                unit.corruption += roll_dice_chapter(1, 6, "low");
                return $"His mind is seared by the warp, now unable to cast more powers for {marine_casting_cooldown[unit_id]} hours.";
            },
        ],
        [
            40,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                unit.corruption += roll_dice_chapter(1, 10, "low");
                if (men > 0) {
                    repeat (6) {
                        var t = irandom(men - 1); // Random value from 0 to men-1
                        if (marine_type[t] != "") {
                            var _ally = unit_struct[t];
                            _ally.corruption += roll_dice_chapter(1, 10, "low");
                        }
                    }
                }
                return "Capricious voices eminate from the surrounding area, whispering poisonous lies and horrible truths.";
            },
        ],
        [
            50,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                var d1 = 0, d2 = 0, d3 = 0;
                var dem = choose("Pink Horror", "Daemonette", "Bloodletter", "Plaguebearer");
                d1 = instance_nearest(x, y, obj_enunit);
                var exist;
                exist = 0;
                repeat (30) {
                    if (d3 == 0) {
                        d2 += 1;
                        if (d1.dudes[d2] == dem) {
                            exist = d2;
                            d3 = 5;
                        }
                    }
                }
                if (exist > 0) {
                    d2 = choose(3, 4, 5, 6);
                    d1.dudes_num[exist] += d2;
                    obj_ncombat.enemy_forces += d2;
                    obj_ncombat.enemy_max += d2;
                    d1.men += d2;
                }
                d2 = 0;
                if (exist == 0) {
                    repeat (30) {
                        if (d3 == 0) {
                            d2 += 1;
                            if (d1.dudes[d2] == "") {
                                d3 = d2;
                            }
                        }
                    }
                    d2 = choose(3, 4, 5, 6);
                    d1.dudes[d3] = dem;
                    d1.dudes_special[d3] = "";
                    d1.dudes_num[d3] = d2;
                    d1.dudes_ac[d3] = 15;
                    d1.dudes_hp[d3] = 150;
                    d1.dudes_dr[d3] = 0.7;
                    d1.dudes_vehicle[d3] = 0;
                    d1.dudes_damage[d3] = 0;
                    d1.men += d2;
                    obj_ncombat.enemy_forces += d2;
                    obj_ncombat.enemy_max += d2;
                }
                return "Dark, shifting lights form into several " + string(dem) + "s.";
            },
        ],
        [
            60,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                unit.add_or_sub_health(roll_dice_chapter(1, 50, "low") * -1);
                if (men > 0) {
                    repeat (6) {
                        var t = irandom(men - 1); // Random value from 0 to men-1
                        if (marine_type[t] != "") {
                            marine_hp[t] -= roll_dice_chapter(1, 50, "low");
                        }
                    }
                }
                return "There is a massive explosion of warp energy which injures him and several other marines!";
            },
        ],
        [
            70,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                obj_ncombat.global_perils += 10;
                return "Wind shrieks and blood pours from the sky!  The warp feels unstable.";
            },
        ],
        [
            80,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                unit.add_or_sub_health(roll_dice_chapter(5, 10, "low") * -1);
                if (men > 0) {
                    repeat (6) {
                        var t = irandom(men - 1); // Random value from 0 to men-1
                        if (marine_type[t] != "") {
                            marine_hp[t] -= roll_dice_chapter(1, 50, "low");
                        }
                    }
                }
                unit.add_equipment_repairs(eEQUIPMENT_SLOT.ALL);
                return "A massive shockwave eminates from the marine, who is knocked out cold!  All of his equipment is damaged!";
            },
        ],
        [
            90,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                marine_casting_cooldown[unit_id] += 999;
                unit.corruption += roll_dice_chapter(5, 10, "low");

                var dem = choose("Slaanesh", "Nurgle", "Tzeentch");
                var d1 = instance_nearest(x, y, obj_enunit);
                var d2 = 0;
                var d3 = 0;
                repeat (30) {
                    if (d3 == 0) {
                        d2 += 1;
                        if (d1.dudes[d2] == "") {
                            d3 = d2;
                        }
                    }
                }
                d1.dudes[d3] = "Greater Daemon of " + string(dem);
                d1.dudes_special[d3] = "";
                d1.dudes_num[d3] = 1;
                d1.dudes_ac[d3] = 30;
                d1.dudes_hp[d3] = 700;
                d1.dudes_dr[d3] = 0.5;
                d1.dudes_vehicle[d3] = 0;
                d1.dudes_damage[d3] = 0;
                d1.medi += 1;
                obj_ncombat.enemy_forces += 1;
                obj_ncombat.enemy_max += 1;
                d1.neww = 1;
                d1.alarm[1] = 1;

                return "The marine's flesh begins to twist and rip, seemingly turning inside out.  His form looms up, and up, and up.  Within seconds a Greater Daemon of " + string(dem) + " has taken form.";
            },
        ],
        [
            100,
            function(perils_strength, unit, psy_discipline, power_name, unit_id) {
                var flavour_text2 = choose("There is a snap, and pop, and he disappears entirely.", "He explodes into a cloud of gore, splattering guts and ceramite across the battlefield.");

                if (unit.role() == obj_ini.role[100][eROLE.CHAPTERMASTER]) {
                    flavour_text2 = "There is a snap, and pop, and he disappears entirely. Reappearing minutes later, barely alive and stunned.";
                    unit.update_health(10);
                    marine_casting_cooldown[unit_id] = 999;
                } else {
                    unit.update_health(0);
                    marine_dead[unit_id] = 2;
                }

                return flavour_text2;
            },
        ],
    ];

    for (var i = array_length(combat_perils) - 1; i >= 0; i--) {
        if (perils_strength >= combat_perils[i][0]) {
            return combat_perils[i][1](perils_strength, unit, psy_discipline, power_name, unit_id);
        }
    }
}
