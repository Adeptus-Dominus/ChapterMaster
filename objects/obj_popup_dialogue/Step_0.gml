/// Step Event

if (press_exclusive(vk_enter)) {
    execute = true;
}

if (press_exclusive(vk_escape)) {
    instance_destroy();
}

if (press_with_held(ord("V"), vk_control)) {
    keyboard_string += clipboard_get_text();
}

if (blink > 0) {
    blink -= delta_time/1000000;
} else if (blink <= 0) {
    blink = 2
}

if (input_type = 1) {
    inputting = keyboard_string;
    if (execute) {
        if (inputting == "") {
            instance_destroy();
        }
        scr_cheatcode(inputting);
        instance_destroy();
    }
}

if (input_type = 2) {
    if (string_length(string_letters(keyboard_string)) > 0){
        keyboard_string = string_digits(keyboard_string);
    }

    if (inputting == "") {
        inputting = 0;
    }

    if (string_length(string_digits(keyboard_string)) > 0) {
        inputting = real(string_digits(keyboard_string));
    } else {
        inputting = 0;
    }

    if (inputting > maximum) {
        inputting = maximum;
        keyboard_string = $"{maximum}";
    }

    if (execute = true) {
        if (inputting != 0) { // All checks out captain
            if (target = "t1") {
                obj_controller.trade_tnum[1] = inputting;
                obj_controller.trade_take[1] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }
            if (target = "t2") {
                obj_controller.trade_tnum[2] = inputting;
                obj_controller.trade_take[2] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }
            if (target = "t3") {
                obj_controller.trade_tnum[3] = inputting;
                obj_controller.trade_take[3] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }
            if (target = "t4") {
                obj_controller.trade_tnum[4] = inputting;
                obj_controller.trade_take[4] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }

            if (target = "m1") {
                obj_controller.trade_mnum[1] = inputting;
                obj_controller.trade_give[1] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }
            if (target = "m2") {
                obj_controller.trade_mnum[2] = inputting;
                obj_controller.trade_give[2] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }
            if (target = "m3") {
                obj_controller.trade_mnum[3] = inputting;
                obj_controller.trade_give[3] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }
            if (target = "m4") {
                obj_controller.trade_mnum[4] = inputting;
                obj_controller.trade_give[4] = target2;
                with(obj_controller) {
                    scr_trade(false);
                }
            }

            if (string_count("m", target) > 0) {
                if (target2 = "Requisition") then obj_controller.trade_req -= inputting;
                if (target2 = "Gene-Seed") then obj_controller.trade_gene -= inputting;
                if (target2 = "STC Fragment") then obj_controller.trade_chip -= inputting;
                if (target2 = "Info Chip") then obj_controller.trade_info -= inputting;
            }
        }
        instance_destroy();
    }
}