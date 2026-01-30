function scr_target(battle_block, man_or_vehicle) {
    // battle_block : instance
    // man_or_vehicle : "veh" or "men"

    // This naughty, sexy code is used to return a target for a battle block's any particular weapon

    // wih(ob_ennit){showmeage("targ#"+string(dudes[1])+"|"+string(dudes_num[1])+"|"+string(men+medi)+"|"+string(dudes_hp[1]));}

    var final_target = 0;

    repeat (1) {
        if (final_target == 0) {
            var target_num, target_id, target_min, target_max;
            var targets = 0, roll = 0, dice = 0;
            var valid = false;

            var f = -1;
            repeat (31) {
                f += 1;
                target_num[f] = 0;
                target_id[f] = 0;
                target_min[f] = 0;
                target_max[f] = 0;
            }

            f = 0;

            for (f = 1; f <= 30; f++) {
                valid = false;
                if (battle_block.dudes[f] == "") {
                    continue;
                }
                if (man_or_vehicle == "veh") {
                    if (battle_block.dudes_vehicle[f] == 1) {
                        valid = true;
                    }
                } else if (man_or_vehicle == "men") {
                    if (battle_block.dudes_vehicle[f] == 0) {
                        valid = true;
                    }
                } else if ((man_or_vehicle == "medi") && (battle_block.dudes_vehicle[f] == 1 || battle_block.dudes_vehicle[f] == 0)) {
                    valid = true;
                }
                if (valid) {
                    targets += 1;
                    target_id[targets] = f;
                    target_num[targets] = battle_block.dudes_num[f];
                    dice += target_num[targets];
                    target_max[targets] = dice;
                    if (targets == 1) {
                        target_min[targets] = 0;
                    }
                    if (targets > 1) {
                        target_min[targets] = target_max[targets - 1] + 1;
                    }
                }
            }

            roll = floor(random(dice)) + 1;
            f = 0;
            repeat (targets) {
                f += 1;
                if ((roll >= target_min[f]) && (roll <= target_max[f]) && (final_target == 0)) {
                    final_target = f;
                    break;
                }
            }
        }
    }

    if (final_target != 0) {
        return final_target;
    }
    if (final_target == 0) {
        return 1;
    }
}
