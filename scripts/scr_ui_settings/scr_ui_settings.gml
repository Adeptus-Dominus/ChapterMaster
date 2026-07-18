/// @self Asset.GMObject.obj_controller
/// @mixin
function setup_ui_chapter_settings() {
    settings_buttons_ui_components = {};
    settings_buttons_ui_components.back_arrow = new SpriteButton({
        sprite: spr_arrow,
        x1: 25,
        y1: 70,
        scale_x: 2,
        scale_y: 2,
    });

    settings_buttons_ui_components.formation_name_input = new TextBarArea(800, 66);

    settings_buttons_ui_components.formation_radio = new RadioSet([
        {
            str1: "Raid",
            font: fnt_40k_30b,
            tooltip: "Can only be used in Raids. Prevents the use of all vehicles aside from Dreadnoughts and Land Speeders. Starts in melee.",
            value: "raid",
            style: "box",
        },
        {
            str1: "Attack",
            font: fnt_40k_30b,
            tooltip: "Can't be used in Raids. Can use any vehicles.",
            value: "attack",
            style: "box",
        },
    ], "Formation", {
        x1: 757,
        y1: 120,
    });

    settings_buttons_ui_components.attack_box = new Box({
        x1: 35,
        y1: 211,
        x2: 1206,
        y2: 703,
        colour: c_gray,
    });

    settings_buttons_ui_components.raid_box = new Box({
        x1: 35,
        y1: 211,
        x2: 841,
        y2: 703,
        colour: c_gray,
    });

    role_settings_selection_buttons = [];
    var _role_order = [
        eROLE.APOTHECARY,
        eROLE.CHAPLAIN,
        eROLE.LIBRARIAN,
        eROLE.TECHMARINE,
        eROLE.CAPTAIN,
        eROLE.CHAMPION,
        eROLE.HONOURGUARD,
        eROLE.TERMINATOR,
        eROLE.VETERAN,
        eROLE.TACTICAL,
        eROLE.DEVASTATOR,
        eROLE.ASSAULT,
        eROLE.SCOUT,
        eROLE.SERGEANT,
        eROLE.VETERANSERGEANT,
    ];

    var _but_x = 1277;
    var _but_y = 230;
    var _base_tool = "Click to open the settings for this unit.";

    for (var i = 0; i < array_length(_role_order); i++) {
        var _role_id = _role_order[i];

        var _active = obj_ini.race[100][_role_id] != 0;
        var _button = new UnitButtonObject({
            style: "pixel",
            x1: _but_x,
            y1: _but_y,
            label: obj_ini.role[100][_role_id],
            set_width: true,
            w: 289,
            active: _active,
            role_id: _role_id,
            tooltip: string(obj_ini.role[100][_role_id]) + " Settings\n" + _base_tool,
        });

        _but_y += 30;
        array_push(role_settings_selection_buttons, _button);
    }

    settings_buttons_ui_components.role_settings_selection_buttons = role_settings_selection_buttons;

    company_settings_selection_buttons = [];
    _but_x = 936;
    _but_y = 230;
    var romanNumerals = scr_roman_numerals();
    _base_tool = "Click to open the settings for this company.";

    // i<= to include the scount company
    for (var i = 0; i <= obj_ini.companies; i++) {
        var _string = i == 0 ? "Headquarters" : romanNumerals[i - 1] + " Company";
        var _button = new UnitButtonObject({
            style: "pixel",
            x1: _but_x,
            y1: _but_y,
            label: _string,
            set_width: true,
            w: 289,
            tooltip: _string + " Settings\n" + _base_tool,
        });

        _but_y += 30;
        array_push(company_settings_selection_buttons, _button);
    }

    settings_buttons_ui_components.company_settings_selection_buttons = company_settings_selection_buttons;

    settings_buttons_ui_components.boarding_objectives = new ReactiveString("Boarding Objective", 110, 570, {
        tooltip: "Boarding Objective\nThe objective of your Astartes once they board an enemy ship.",
        font: fnt_40k_14,
    });

    var _toggle_dam_sys = new ToggleButton({
        style: "box",
        tooltip: "Your Astartes will attempt to disable the ship by attacking the ship bridge and systems.",
        str1: "Damage Systems",
        x1: 50,
        y1: 604,
        active: command_set[20],
        clicked_check_default: true,
    });

    settings_buttons_ui_components.boarding_damage_systems = _toggle_dam_sys;

    var _toggle_use_plasma = new ToggleButton({
        style: "box",
        tooltip: "Your Astartes will use equipped Plasma Bombs to massively damage the boarded ship.",
        str1: "Use Plasma Bombs",
        x1: _toggle_dam_sys.x2 + 10,
        y1: 604,
        active: command_set[21],
        clicked_check_default: true,
    });

    settings_buttons_ui_components.boarding_plasma_bombs = _toggle_use_plasma;

    var _toggle_commandeer = new ToggleButton({
        style: "box",
        tooltip: "Your Astartes will attempt to commandeer the vessel, to be permenantely used or salvaged.",
        str1: "Commandeer Ship",
        x1: _toggle_use_plasma.x2 + 10,
        y1: 604,
        active: command_set[22],
        clicked_check_default: true,
    });

    settings_buttons_ui_components.boarding_commandeer = _toggle_commandeer;

    var _sets = settings_buttons_ui_components;

    _sets.progenitor_livery = new ToggleButton({
        x1: 50,
        y1: 140,
        str1: "Progenitor Livery",
        tooltip: "Turned off by default. \nWhen turned on, various unit visuals may change depending on your progenitor chapter.",
        active: progenitor_visuals,
        style: "box",
        clicked_check_default: true,
    });

    _sets.astartes_transfer_toggle = new ToggleButton({
        x1: _sets.progenitor_livery.x2 + 10,
        y1: 140,
        str1: "Allow Astartes Transfer",
        tooltip: "Turned off by default. Allows you to transfer Astartes in the same way as vehicles.",
        active: command_set[1],
        style: "box",
        clicked_check_default: true,
    });

    _sets.codex_compliant = new ToggleButton({
        x1: _sets.astartes_transfer_toggle.x2 + 10,
        y1: 140,
        str1: "Codex Compliant Organization",
        tooltip: "When enabled, marine promotions are limited based on their current company and EXP, overall following the Codex Astartes promotion sequence.",
        active: command_set[2],
        style: "box",
        clicked_check_default: true,
    });

    var _y = _sets.progenitor_livery.y2 + 10;
    _sets.modest_livery = new ToggleButton({
        x1: 50,
        y1: _y,
        str1: "Modest Livery",
        tooltip: "Turned off by default.  Prevents Advantages and Disadvantages from changing the appearances of your marines, effectively disabling any special ornamentation or possible battle wear.",
        active: modest_livery,
        style: "box",
        clicked_check_default: true,
    });

    _sets.tagged_training = new ToggleButton({
        x1: _sets.astartes_transfer_toggle.x1,
        y1: _y,
        str1: "Tagged Training Livery",
        tooltip: "Turned off by default, makes specialist training select only tagged marines, click on their potential indicators to tag.",
        active: tagged_training,
        style: "box",
        clicked_check_default: true,
    });

    var _roles = active_roles();

    _role_order = [
        eROLE.CAPTAIN,
        eROLE.ANCIENT,
        eROLE.CHAMPION,
        eROLE.CHAPLAIN,
        eROLE.APOTHECARY,
        eROLE.LIBRARIAN,
        eROLE.TECHMARINE,
    ];

    var _tog_buttons = [];

    for (var i = 0; i < array_length(_role_order); i++) {
        var _role_name = _roles[_role_order[i]];
        array_push(_tog_buttons, {str1: _role_name, font: fnt_40k_14, tooltip: $"activate to make {_role_name}s a default member of your company command."});
    }

    var _command_mult = new MultiSelect(_tog_buttons, "Company Command Structure", {
        is_horizontal: false,
        x1: 75,
        y1: 300,
    });

    for (var i = 0; i < array_length(_command_mult.toggles); i++) {
        var _tog = _command_mult.toggles[i];
        _tog.active = bool(command_set[3 + i]);
    }

    _sets.comany_command_structure = _command_mult;

    var _post_boarding = new RadioSet([
        {
            str1: "Board Next Nearest",
            font: fnt_40k_14,
            style: "box",
            tooltip: "After disabling an enemy vessel your Astartes will launch a new boarding mission at the nearest enemy.",
        },
        {
            str1: "Return and Recuperate",
            font: fnt_40k_14,
            style: "box",
        },
    ], "Post-Boarding", {
        x1: 80,
        y1: 710,
    });

    _sets.post_boarding_action = _post_boarding;

    _sets.auto_board_multi = new MultiSelect([
        {
            str1: "Battleships",
            font: fnt_40k_14,
            style: "box",
            tooltip: "If checked your Battleships will launch Boarding teams automatically when an eligible target is in range.",
        },
        {
            str1: "Cruisers",
            font: fnt_40k_14,
            style: "box",
            tooltip: "If checked your Cruisers will launch Boarding teams automatically when an eligible target is in range.",
        },
    ], "Automatic Boarding", {
        x1: 420,
        y1: 710,
    });
}

function scr_ui_settings() {
    var romanNumerals = scr_roman_numerals();
    // Var declaration
    var tool1 = "", tool2 = "";
    var _che = false;
    var cx, cy;
    var x5 = 0, y5 = 0, x6 = 0;
    var too_img = 0;

    if (menu == eMENU.FORMATIONS_SETTINGS && formating > 0) {
        scr_draw_formation_settings();
    } else if (menu == eMENU.ROLE_SETTINGS) {
        scr_draw_role_settings_ui();
    } else if (menu == eMENU.COMPANY_SETTINGS) {
        scr_draw_company_settings_ui();
    }

    if (menu != eMENU.SETTINGS) {
        var _back_button = settings_buttons_ui_components.back_arrow;
        _back_button.draw(true);
        if (_back_button.is_clicked) {
            with (obj_formation_bar) {
                instance_destroy();
            }
            if (bat_formation[formating] == "") {
                bat_formation_type[formating] = 0;
            }
            pop_draw_return_values();
            with (obj_mass_equip) {
                instance_destroy();
            }
            settings = 0;
            menu = eMENU.SETTINGS;
            exit;
        }
    } else if (menu == eMENU.SETTINGS) {
        add_draw_return_values();
        var _ui_feats = settings_buttons_ui_components;
        // Reset vars
        tool1 = "";
        tool2 = "";
        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(800, 66, string(global.chapter_name) + " Chapter Settings", 1, 1, 0);
        draw_text_transformed(800, 110, "(Codex Compliant)", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);

        _ui_feats.progenitor_livery.draw();
        progenitor_visuals = _ui_feats.progenitor_livery.active;

        _ui_feats.astartes_transfer_toggle.draw();
        command_set[1] = _ui_feats.astartes_transfer_toggle.active;

        _ui_feats.codex_compliant.draw();
        command_set[2] = _ui_feats.codex_compliant.active;

        _ui_feats.modest_livery.draw();
        modest_livery = _ui_feats.modest_livery.active;

        _ui_feats.tagged_training.draw();
        tagged_training = _ui_feats.tagged_training.active;

        var _com_multi = _ui_feats.comany_command_structure;

        _com_multi.draw();

        for (var i = 0; i < array_length(_com_multi.toggles); i++) {
            command_set[3 + i] = _com_multi.toggles[i].active;
        }

        _ui_feats.boarding_objectives.draw();

        var _toggl_dam_sys = _ui_feats.boarding_damage_systems;
        if (_toggl_dam_sys.draw()) {
            command_set[20] = _toggl_dam_sys.active;
            if (_toggl_dam_sys.active) {
                command_set[22] = false;
                command_set[21] = false;
            }
        }

        var _toggle_use_plasma = _ui_feats.boarding_plasma_bombs;

        if (_toggle_use_plasma.draw()) {
            command_set[21] = _toggle_use_plasma.active;
            if (_toggle_use_plasma.active) {
                command_set[22] = false;
                command_set[20] = false;
            }
        }

        var _toggle_commandeer = settings_buttons_ui_components.boarding_commandeer;

        if (_toggle_commandeer.draw()) {
            if (_toggle_commandeer.active) {
                command_set[22] = 1;
                command_set[20] = 0;
                command_set[21] = 0;
            } else {
                command_set[22] = 0;
            }
        }

        var _post_board = settings_buttons_ui_components.post_boarding_action;

        if (command_set[22] == 1) {
            _post_board.allow_changes = false;
            _post_board.current_selection = -1;
            command_set[23] = false;
            command_set[24] = false;
        } else {
            _post_board.allow_changes = true;
        }

        _post_board.draw();

        command_set[23] = _post_board.toggles[0].active;
        command_set[24] = _post_board.toggles[1].active;

        var _auto_board = settings_buttons_ui_components.auto_board_multi;

        _auto_board.toggles[0].active = command_set[25];

        _auto_board.toggles[1].active = command_set[26];

        _auto_board.draw();

        command_set[25] = _auto_board.toggles[0].active;

        command_set[26] = _auto_board.toggles[1].active;

        draw_text(937 - 341, 207, "Battle Formations");
        draw_text(937, 207, "Company Settings");
        draw_text(1278, 207, "Astartes Role Settings");

        scr_select_role_settings_ui();

        scr_select_company_settings_ui();

        xxx = 936 - 341;
        yyy = 250 - 31;

        for (var i = 1; i <= 11; i++) {
            draw_set_alpha(1);
            // if (custom!=eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.5);
            yyy += 31;
            draw_set_color(c_gray);
            var _formation = bat_formation[i];

            if (_formation != "") {
                draw_rectangle(xxx, yyy, xxx + 289, yyy + 20, 0);
            }
            if (i > 2) {
                if ((_formation == "") && (bat_formation[i - 1] != "")) {
                    draw_rectangle(xxx, yyy, xxx + 289, yyy + 20, 0);
                }
            }

            draw_set_color(0);

            var shw = "", isnew = false;
            shw = string(bat_formation[i]);

            if (i > 3) {
                if (bat_formation_type[i] == 1) {
                    shw = $"A] {string(shw)}";
                } else if (bat_formation_type[i] == 2) {
                    shw = $"R] {string(shw)}";
                }
            }
            if (i > 2) {
                if ((shw == "") && (bat_formation[i - 1] != "")) {
                    isnew = true;
                    shw = "(New Formation)";
                }
            }

            if (shw != "" || isnew == true) {
                draw_text(xxx, yyy, string(shw));
                if (scr_hit(xxx, yyy, xxx + 289, yyy + 20)) {
                    /*if (custom==eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.2);if (custom!=eCHAPTER_TYPE.CUSTOM) then */
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(xxx, yyy, xxx + 289, yyy + 20, 0);
                    draw_set_alpha(1);

                    if (i <= 3) {
                        tool1 = $"{shw} Settings";
                    }
                    tool2 = "Click to open the settings for this formation.";
                    if (i > 3) {
                        if (_formation != "") {
                            tool1 = $"{_formation} Settings";
                            tool2 = "Click to open the settings for this formation.";
                        }
                        if (bat_formation[i] == "") {
                            tool1 = "New Custom Formation";
                            tool2 = "Click to open and create a new Battle Formation for Ground combat or Raiding.";
                        }
                    }

                    if (mouse_button_clicked()) {
                        formating = i;
                        menu = 24;

                        scr_ui_formation_bars();
                        if (bat_formation[formating] == "") {
                            bat_formation[formating] = "Custom" + string(formating - 3);
                            bat_formation_type[formating] = 1;
                            bat_deva_for[formating] = 3;
                            bat_assa_for[formating] = 5;
                            bat_tact_for[formating] = 4;
                            bat_vete_for[formating] = 3;
                            bat_hire_for[formating] = 3;
                            bat_libr_for[formating] = 2;
                            bat_comm_for[formating] = 2;
                            bat_tech_for[formating] = 2;
                            bat_term_for[formating] = 5;
                            bat_hono_for[formating] = 2;
                            bat_drea_for[formating] = 6;
                            bat_rhin_for[formating] = 6;
                            bat_pred_for[formating] = 6;
                            bat_landraid_for[formating] = 6;
                            bat_landspee_for[formating] = 5;
                            bat_whirl_for[formating] = 1;
                            bat_scou_for[formating] = 3;
                        }
                    }
                }
            }
        }

        if (tool1 != "") {
            tooltip_draw(tool2,,,,, tool1);
        }
        pop_draw_return_values();
    }
}

function scr_select_company_settings_ui() {
    // Company Settings
    var _comp_buttons = settings_buttons_ui_components.company_settings_selection_buttons;

    // start at 1 to exclude HQ
    for (var i = 1; i < array_length(_comp_buttons); i++) {
        var _button = _comp_buttons[i];
        if (!_button.draw()) {
            continue;
        }

        /*if (custom==eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.2);if (custom!=eCHAPTER_TYPE.CUSTOM) then */
        menu = eMENU.COMPANY_SETTINGS;
        settings = i;
        squad_arrangement = new SquadArrangementEditor(settings);
    }
}

function scr_draw_company_settings_ui() {
    if (settings != 0 && is_struct(squad_arrangement)) {
        squad_arrangement.draw();
    }
}

function scr_select_role_settings_ui() {
    // Role Settings
    var _role_buttons = settings_buttons_ui_components.role_settings_selection_buttons;
    for (var i = 0; i < array_length(_role_buttons); i++) {
        var _button = _role_buttons[i];
        if (!_button.draw()) {
            continue;
        }
        settings = _button.role_id;
        menu = eMENU.ROLE_SETTINGS;
        setup_role_settings_buttons();
        with (obj_mass_equip) {
            instance_destroy();
        }
        instance_create(0, 0, obj_mass_equip);
    }
}

function setup_role_settings_buttons() {
    role_settings_ui = {};
    var _button_x = 830;
    var _settings = obj_controller.settings;
    role_settings_ui.main_weapon_button = new UnitButtonObject({
        style: "pixel",
        x1: _button_x,
        y1: 185,
        label: $"Main Weapon: {obj_ini.wep1[100][_settings]}",
        set_width: true,
        w: 250,
        active: true,
        tooltip: "click to change main weapon",
        slot_index: eEQUIPMENT_SLOT.WEAPON_ONE,
    });
    role_settings_ui.secondary_weapon_button = new UnitButtonObject({
        style: "pixel",
        x1: _button_x,
        y1: role_settings_ui.main_weapon_button.y2,
        label: $"Secondary Weapon: {obj_ini.wep2[100][_settings]}",
        set_width: true,
        w: 250,
        active: true,
        tooltip: "click to change secondary weapon",
        slot_index: eEQUIPMENT_SLOT.WEAPON_TWO,
    });
    role_settings_ui.armour_button = new UnitButtonObject({
        style: "pixel",
        x1: _button_x,
        y1: role_settings_ui.secondary_weapon_button.y2,
        label: $"Armour: {obj_ini.armour[100][_settings]}",
        set_width: true,
        w: 250,
        active: true,
        tooltip: "click to change armour",
        slot_index: eEQUIPMENT_SLOT.ARMOUR,
    });
    role_settings_ui.gear_button = new UnitButtonObject({
        style: "pixel",
        x1: _button_x,
        y1: role_settings_ui.armour_button.y2,
        label: $"Special Item: {obj_ini.gear[100][_settings]}",
        set_width: true,
        w: 250,
        active: true,
        tooltip: "click to Special Item",
        slot_index: eEQUIPMENT_SLOT.GEAR,
    });
    role_settings_ui.mobi_button = new UnitButtonObject({
        style: "pixel",
        x1: _button_x,
        y1: role_settings_ui.gear_button.y2,
        label: $"Mobility Item: {obj_ini.mobi[100][_settings]}",
        set_width: true,
        w: 250,
        active: true,
        tooltip: "click to change Mobility Item",
        slot_index: eEQUIPMENT_SLOT.MOBILITY,
    });
}

function scr_draw_mass_equip_gui() {
    if (total_role_number > 0) {
        draw_set_color(c_gray);
        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_30b);
        draw_set_alpha(1);

        draw_text_ext_transformed(107, 160, string_hash_to_newline(string(total_roles)), -1, 471 * 1.66, 0.6, 0.6, 0);

        draw_text_ext_transformed(107, 190 + (string_height_ext(string_hash_to_newline(total_roles), -1, 471 * 1.66) * 0.6), string_hash_to_newline(string(all_equip)), -1, 471 * 1.66, 0.6, 0.6, 0);

        draw_set_alpha(1);
        if (good1 + good2 + good3 + good4 + good5 != 5) {
            draw_set_alpha(0.5);
        }
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_rectangle(114, 626, 560, 665, 0);
        draw_set_color(0);
        draw_text(333, 636, $"Requip All {obj_ini.role[100][role]} With Default Items");
        if (scr_hit(114, 626, 560, 665) == true) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            if (good1 + good2 + good3 + good4 + good5 != 5) {
                draw_set_alpha(0.1);
            }
            draw_rectangle(114, 626, 560, 665, 0);
            draw_set_alpha(1);
            if (mouse_button_clicked() && (good1 + good2 + good3 + good4 + good5 == 5)) {
                engage = true;
                refresh = true;
                effect_create_depth(depth - 1, ef_firework, 800, 400, 5, c_yellow);
            }
        }
        draw_set_alpha(1);

        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_left);

        if (req_wep1 != "") {
            draw_set_color(c_gray);
            if (req_wep1_num > have_wep1_num) {
                draw_set_color(c_red);
            }
            if (req_wep1_num > have_wep1_num) {
                draw_text_transformed(154, 670, string_hash_to_newline("-Not enough " + string(req_wep1) + " (Have " + string(have_wep1_num) + ", Need " + string(req_wep1_num) + ")"), 0.6, 0.6, 0);
            }
            if (req_wep1_num <= have_wep1_num) {
                draw_text_transformed(154, 670, string_hash_to_newline("-" + string(req_wep1) + " (Have " + string(have_wep1_num) + ", Need " + string(req_wep1_num) + ")"), 0.6, 0.6, 0);
            }
        }
        if (req_wep2 != "") {
            draw_set_color(c_gray);
            if (req_wep2_num > have_wep2_num) {
                draw_set_color(c_red);
            }
            if (req_wep2_num > have_wep2_num) {
                draw_text_transformed(154, 698, string_hash_to_newline("-Not enough " + string(req_wep2) + " (Have " + string(have_wep2_num) + ", Need " + string(req_wep2_num) + ")"), 0.6, 0.6, 0);
            }
            if (req_wep2_num <= have_wep2_num) {
                draw_text_transformed(154, 698, string_hash_to_newline("-" + string(req_wep2) + " (Have " + string(have_wep2_num) + ", Need " + string(req_wep2_num) + ")"), 0.6, 0.6, 0);
            }
        }
        if (req_armour != "") {
            draw_set_color(c_gray);
            if (req_armour_num > have_armour_num) {
                draw_set_color(c_red);
            }
            if (req_armour_num > have_armour_num) {
                draw_text_transformed(154, 726, string_hash_to_newline("-Not enough " + string(req_armour) + " (Have " + string(have_armour_num) + ", Need " + string(req_armour_num) + ")"), 0.6, 0.6, 0);
            }
            if (req_armour_num <= have_armour_num) {
                draw_text_transformed(154, 726, string_hash_to_newline("-" + string(req_armour) + " (Have " + string(have_armour_num) + ", Need " + string(req_armour_num) + ")"), 0.6, 0.6, 0);
            }
        }
        if (req_gear != "") {
            draw_set_color(c_gray);
            if (req_gear_num > have_gear_num) {
                draw_set_color(c_red);
            }
            if (req_gear_num > have_gear_num) {
                draw_text_transformed(154, 754, string_hash_to_newline("-Not enough " + string(req_gear) + " (Have " + string(have_gear_num) + ", Need " + string(req_gear_num) + ")"), 0.6, 0.6, 0);
            }
            if (req_gear_num <= have_gear_num) {
                draw_text_transformed(154, 754, string_hash_to_newline("-" + string(req_gear) + " (Have " + string(have_gear_num) + ", Need " + string(req_gear_num) + ")"), 0.6, 0.6, 0);
            }
        }
        if (req_mobi != "") {
            draw_set_color(c_gray);
            if (req_mobi_num > have_mobi_num) {
                draw_set_color(c_red);
            }
            if (req_mobi_num > have_mobi_num) {
                draw_text_transformed(154, 782, string_hash_to_newline("-Not enough " + string(req_mobi) + " (Have " + string(have_mobi_num) + ", Need " + string(req_mobi_num) + ")"), 0.6, 0.6, 0);
            }
            if (req_mobi_num <= have_mobi_num) {
                draw_text_transformed(154, 782, string_hash_to_newline("-" + string(req_mobi) + " (Have " + string(have_mobi_num) + ", Need " + string(req_mobi_num) + ")"), 0.6, 0.6, 0);
            }
        }
    }

    if (total_role_number > 0 && tab > -1) {
        item_name = [];
        var infanty_roles = [
            eROLE.CHAPTERMASTER,
            eROLE.HONOURGUARD,
            eROLE.VETERAN,
            eROLE.TERMINATOR,
            eROLE.CAPTAIN,
            eROLE.CHAMPION,
            eROLE.TACTICAL,
            eROLE.DEVASTATOR,
            eROLE.ASSAULT,
            eROLE.ANCIENT,
            eROLE.SCOUT,
            eROLE.CHAPLAIN,
            eROLE.APOTHECARY,
            eROLE.TECHMARINE,
            eROLE.LIBRARIAN,
            eROLE.SERGEANT,
            eROLE.VETERANSERGEANT,
            eROLE.DREADNOUGHT,
        ];
        // hand slots
        if ((tab == 0 || tab == 1) && array_get_index(infanty_roles, obj_controller.settings) >= 0) {
            // Get all available hand weapons
            scr_get_item_names(
                item_name,
                obj_controller.settings, // eROLE
                0, // slot
                eENGAGEMENT.ANY,
                true, // include the company standard
                false, // do not limit to available items
            );
            scr_get_item_names(
                item_name,
                obj_controller.settings, // eROLE
                1, // slot
                eENGAGEMENT.ANY,
                false, // include the company standard
                false, // do not limit to available items
                false, // not only mastercrafted
                true, // put none in the list only once
            );
            array_resize(item_name, array_unique_ext(item_name));
        } else {
            scr_get_item_names(
                item_name,
                obj_controller.settings, // eROLE
                tab, // slot
                eENGAGEMENT.NONE, // doesn't matter to non infantry/non hand slots
                true, // include the company standard
                false, // do not limit to available items
            );
        }

        draw_set_color(0);
        draw_rectangle(1183, 160, 1506, 747, 0);

        draw_set_color(c_gray);
        draw_rectangle(1184, 161, 1505, 746, 1);
        draw_rectangle(1185, 162, 1504, 745, 1);
        draw_rectangle(1186, 163, 1503, 744, 1);

        draw_set_font(fnt_40k_30b);
        var slot_name = get_slot_name(obj_controller.settings, tab);
        draw_text_transformed(1203, 174, $"Select {slot_name}", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14b);

        var x3 = 1205; // Starting x position for the first column
        var y3 = 205; // Starting y position
        var space = 18; // Amount to move down for each item
        var items_per_column = 24;
        var column_width = 146;
        var column_gap = 3;

        for (var h = 0; h < array_length(item_name); h++) {
            if (h > 0 && h % items_per_column == 0) {
                x3 += column_width;
                y3 = 205;
            }

            draw_set_color(c_gray);
            var scale = string_width(item_name[h]) >= 140 ? 0.75 : 1;
            draw_text_transformed(x3, y3, item_name[h], scale, 1, 0);

            // keep track of the item's bottom right corner
            var item_x2 = x3 + (column_width - column_gap);
            var item_y2 = y3 + space - 1;

            if (scr_hit(x3, y3, item_x2, item_y2)) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                draw_text_transformed(x3, y3, item_name[h], scale, 1, 0);
                draw_set_alpha(1);

                if (mouse_button_clicked()) {
                    var buh = item_name[h] == ITEM_NAME_NONE ? "" : item_name[h];

                    switch (tab) {
                        // slots
                        case 0:
                            obj_ini.wep1[100][role] = buh;
                            break;
                        case 1:
                            obj_ini.wep2[100][role] = buh;
                            break;
                        case 2:
                            obj_ini.armour[100][role] = buh;
                            // No bikes or jump packs for Terminators
                            if (array_contains(global.list_terminator_armour, buh) || buh == STR_ANY_TERMINATOR_ARMOUR) {
                                obj_ini.mobi[100][role] = "";
                            }
                            break;
                        case 3:
                            obj_ini.gear[100][role] = buh;
                            break;
                        case 4:
                            obj_ini.mobi[100][role] = buh;
                            break;
                    }
                    tab = -1;
                    refresh = true;
                    with (obj_controller) {
                        setup_role_settings_buttons();
                    }
                }
            }
            y3 += space;
        }

        if (cancel_button.draw()) {
            tab = -1;
        }
    }

    /* */
    /*  */
}

function scr_draw_role_settings_ui() {
    if (menu != eMENU.ROLE_SETTINGS) {
        return;
    }

    if (settings > 0) {
        with (obj_mass_equip) {
            scr_draw_mass_equip_gui();
        }
        var _index = settings;

        var _roles = active_roles();

        var _buttons = [
            role_settings_ui.main_weapon_button,
            role_settings_ui.secondary_weapon_button,
            role_settings_ui.armour_button,
            role_settings_ui.gear_button,
            role_settings_ui.mobi_button,
        ];

        var _button_clicked = false;
        var _slot_clicked = -1;
        for (var i = 0; i < array_length(_buttons); i++) {
            var _but = _buttons[i];
            var _allow_click = true;
            if (i == eEQUIPMENT_SLOT.GEAR) {
                var _armour = obj_ini.armour[100][_index];
                var _armour_tags = gear_weapon_data("armour", _armour, "tags");
                if (_armour_tags != 0) {
                    if (array_contains(_armour_tags, "terminator") || array_contains(_armour_tags, "dreadnought")) {
                        _allow_click = false;
                    }
                }
            } else if (i == eEQUIPMENT_SLOT.ARMOUR || i == eEQUIPMENT_SLOT.MOBILITY) {
                _allow_click = _index != eROLE.DREADNOUGHT;
            }
            if (_but.draw(_allow_click)) {
                _button_clicked = true;
                _slot_clicked = _but.slot_index;
            }
        }

        if (!_button_clicked) {
            return;
        }

        if (obj_mass_equip.tab != -1) {
            obj_mass_equip.refresh = true;
        } else if (obj_mass_equip.tab == -1) {
            obj_mass_equip.tab = _slot_clicked;
            obj_mass_equip.item_name = [];
            var is_hand_slot = _slot_clicked == eEQUIPMENT_SLOT.WEAPON_ONE || _slot_clicked == eEQUIPMENT_SLOT.WEAPON_TWO;
            scr_get_item_names(
                obj_mass_equip.item_name,
                obj_controller.settings, // eROLE
                _slot_clicked, // slot
                is_hand_slot ? (obj_mass_equip.tab == 0 ? eENGAGEMENT.RANGED : eENGAGEMENT.MELEE) : eENGAGEMENT.NONE,
                true, // include company standard
                false, // show all regardless of inventory
            );
        }
    }
}
