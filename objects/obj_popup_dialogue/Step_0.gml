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
    blink -= delta_time / 1000000;
} else if (blink <= 0) {
    blink = 2;
}

if (input_type == 1) {
    inputting = keyboard_string;
    if (execute) {
        if (inputting == "") {
            instance_destroy();
        }
        scr_cheatcode(inputting);
        instance_destroy();
    }
}

if (input_type == 2) {
    if (string_length(string_letters(keyboard_string)) > 0) {
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

    if (execute == true) {}
}
