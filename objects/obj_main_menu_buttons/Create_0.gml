fade_val = 0;
fade_target = 0;
target_room = -1;
is_quitting = false;

buttons = [];

if (room_get_name(room) == "Creation") {
    array_push(buttons, {
        label: "BACK",
        sprite: spr_mm_butts_small,
        subimg: 1,
        x: x,
        y: y + 25,
        w: sprite_get_width(spr_mm_butts_small) * 2,
        h: sprite_get_height(spr_mm_butts_small) * 2,
        hover: 0,
        action: function() {
            start_room_transition(Main_Menu);
        },
    });
} else {
    var _labels = [
        "NEW GAME",
        "LOAD",
        "SETTINGS",
        "EXIT"
    ];
    for (var i = 0; i < 4; i++) {
        array_push(buttons, {
            label: _labels[i],
            sprite: spr_mm_butts,
            subimg: i,
            x: 580,
            y: 500 + (i * 44),
            w: 198 * 2.2,
            h: 20 * 2.2,
            hover: 0,
            action: undefined,
        });
    }

    buttons[0].action = function() {
        start_room_transition(Creation);
    };
    buttons[1].action = function() {
        var _pop = instance_create_depth(0, 0, -100, obj_saveload);
        _pop.menu = 2;

        var _vx = camera_get_view_x(view_camera[0]);
        var _vy = camera_get_view_y(view_camera[0]);

        var _b = instance_create_depth(_vx + 707, _vy + 830, -20010, obj_new_button);
        _b.button_text = "Back";
        _b.target = 30;
        _b.scaling = 1.5;
        _b.button_id = 1;
    };
    buttons[2].action = function() {
        instance_create_depth(0, 0, -100, obj_ingame_menu);
    };
    buttons[3].action = function() {
        is_quitting = true;
        fade_target = 1;
    };
}
