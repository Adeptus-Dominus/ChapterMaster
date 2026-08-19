target_gear = -1;
tab = 1;
badname = 0;

rows = 0;

picker = new ColourPicker(20, 550, 350);
picker.disable_textures = true;
start_colour = -1;
col_shift = false;
bulk_buttons = [];

item_name = [];
role_names_all = "";
warning = "";

type_names = {
    "1": "Primary Color",
    "2": "Secondary Color",
    "3": "Pauldron 1 Color",
    "4": "Pauldron 2 Color",
    "5": "Trim Color",
    "6": "Lens Color",
    "7": "Weapon Color",
    "sgt_helm_primary": "Sgt Helm Primary",
    "sgt_helm_secondary": "Sgt Helm Secondary",
};

type_fields = [
    "",
    "main_color",
    "secondary_color",
    "left_pauldron",
    "right_pauldron",
    "main_trim",
    "lens_color",
    "weapon_color",
];

possible_custom_roles = [
    [
        "chapter_master",
        eROLE.CHAPTERMASTER,
    ],
    [
        "honour_guard",
        eROLE.HONOURGUARD,
    ],
    [
        "veteran",
        eROLE.VETERAN,
    ],
    [
        "terminator",
        eROLE.TERMINATOR,
    ],
    [
        "captain",
        eROLE.CAPTAIN,
    ],
    [
        "dreadnought",
        eROLE.DREADNOUGHT,
    ],
    [
        "champion",
        eROLE.CHAMPION,
    ],
    [
        "tactical",
        eROLE.TACTICAL,
    ],
    [
        "devastator",
        eROLE.DEVASTATOR,
    ],
    [
        "assault",
        eROLE.ASSAULT,
    ],
    [
        "ancient",
        eROLE.ANCIENT,
    ],
    [
        "scout",
        eROLE.SCOUT,
    ],
    [
        "chaplain",
        eROLE.CHAPLAIN,
    ],
    [
        "apothecary",
        eROLE.APOTHECARY,
    ],
    [
        "techmarine",
        eROLE.TECHMARINE,
    ],
    [
        "librarian",
        eROLE.LIBRARIAN,
    ],
    [
        "sergeant",
        eROLE.SERGEANT,
    ],
    [
        "veteran_sergeant",
        eROLE.VETERANSERGEANT,
    ],
];

var _is_livery = type == ePOPUP_TYPE.LIVERYPICK;
livery_pick_type = -1;
if (_is_livery) {
    livery_pick_type = obj_creation.colour_selection_options.current_selection;
}
if (_is_livery && livery_pick_type == eLIVERY_COLOURING_OPTIONS.BULK) {
    if (target_role <= 0 || target_role >= 8) {
        instance_destroy();
        exit;
    }
    assign_picked_liveries = function() {
        draw_set_font(fnt_40k_30b);
        var _type_key = string(target_role);
        var _colour_type = struct_exists(type_names, _type_key) ? type_names[$ _type_key] : "";

        picker.title = _colour_type;

        var _action = picker.draw();
        if (_action == "destroy") {
            instance_destroy();
            exit;
        }

        var _col = picker.chosen;
        if (start_colour == -1) {
            start_colour = variable_instance_get(obj_creation, type_fields[target_role]);
        }

        if (_col == -1) {
            _col = start_colour;
        }

        variable_instance_set(obj_creation, type_fields[target_role], _col);

        with (obj_creation) {
            bulk_selection_buttons_setup();
        }
    };
} else if (_is_livery && livery_pick_type == eLIVERY_COLOURING_OPTIONS.ADVANCED) {
    start_colour = obj_creation.complex_livery_data[$ target_role][$ colour_area];
    assign_complex_picked_liveries = function() {
        var _action = picker.draw();
        if (_action == "destroy") {
            instance_destroy();
            exit;
        }
        var _col = picker.chosen;
        if (is_array(_col)) {
            obj_creation.complex_livery_data[$ target_role][$ colour_area] = _col;
        } else {
            if (_col == -1) {
                _col = start_colour;
            }

            obj_creation.complex_livery_data[$ target_role][$ colour_area] = _col;
            with (obj_creation) {
                set_complex_livery_buttons();
            }
        }
    };
} else if (type == ePOPUP_TYPE.EQUIP) {
    role_name_input = new TextBarArea(800, 170, 380, true);

    var _blocked_names = [
        "Chapter Master",
        "Master of Sanctity",
        "Master of the Apothecarion",
        "Forge Master",
    ];

    editing_role_data = obj_creation.player_role_data[target_role];

    for (var i = 0; i < array_length(obj_creation.player_role_data); i++) {
        if (i == target_role) {
            continue;
        }
        var _role_name = obj_creation.player_role_data[i].role;
        if (_role_name != "") {
            array_push(_blocked_names, string_lower(_role_name));
        }
    }

    var _dread_role = target_role == eROLE.DREADNOUGHT;

    set_new_role_data = function() {
        for (var i = 0; i < STANDARD_EQUIP_SLOT_COUNT; i++) {
            if (needed_equipment[i] == ITEM_NAME_NONE) {
                needed_equipment[i] = "";
            }
        }
        var _new_data = convert_equipment_array_into_struct(needed_equipment);
        with (editing_role_data) {
            move_data_to_current_scope(_new_data);
        }
        instance_destroy();
    };
    role_name_input.blocked_values = _blocked_names;
    unchangeable_armour = _dread_role;
    setup_UI_elements_equipment_selector(500, 200);
    unit_count = 0;
    company = -1;
    equipment_found_and_valid = array_create(5, true);
    current_equipment = variable_clone(convert_equipment_struct_into_array(editing_role_data));
    needed_equipment = variable_clone(convert_equipment_struct_into_array(editing_role_data));
    equipment_recipient_type = !_dread_role ? eEQUIP_TARGET_TYPE.MARINE : eEQUIP_TARGET_TYPE.DREADNOUGHT;
    equip_button.bind_method = set_new_role_data;
    equip_button.bind_scope = self;
    master_crafted = false;
    allow_quality_change = false;
    from_inventory = false;
    before_after_styling = false;
}
