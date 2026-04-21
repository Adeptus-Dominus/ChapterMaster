function get_diag_integer(_question, _maximum, _target1, _target2) {
    with (obj_popup_dialogue) {
        instance_destroy();
    }

    var new_popup_dialogue = instance_create(650, 326, obj_popup_dialogue);
    keyboard_string = "";
    with (new_popup_dialogue) {
        question = _question;
        inputting = "";
        maximum = _maximum;
        target = _target1;
        target2 = _target2;
        input_type = 2;
    }
}
