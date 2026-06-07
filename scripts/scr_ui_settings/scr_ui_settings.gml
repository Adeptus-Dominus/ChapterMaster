/// @self Asset.GMObject.obj_controller
/// @mixin
function setup_ui_chapter_settings(){
    settings_buttons_ui_components = {};
    settings_buttons_ui_components.back_arrow = new SpriteButton({
        sprite : spr_arrow,
        x1: 25,
        y1 : 70,
        scale_x : 2,
        scale_y : 2
    });

    settings_buttons_ui_components.formation_name_input = new TextBarArea(600,66);

    settings_buttons_ui_components.formation_radio = new RadioSet([
            {
                str1: "Raid", 
                font: fnt_40k_30b, 
                tooltip: "Can only be used in Raids. Prevents the use of all vehicles aside from Dreadnoughts and Land Speeders. Starts in melee.",
                value : "raid",
                style : "box"
            },
            {
                str1: "Attack", 
                font: fnt_40k_30b, 
                tooltip: "Can't be used in Raids. Can use any vehicles.",
                value : "attack",
                style : "box"
            },
        ],
        "Formation",
        {
            x1 : 757,
            y1 : 120
        }
    );

    settings_buttons_ui_components.attack_box = new Box({
        x1 : 35, 
        y1 : 211, 
        x2 : 1206, 
        y2 : 703,
        colour : c_gray
    });

    settings_buttons_ui_components.raid_box = new Box({
        x1 : 35, 
        y1 : 211, 
        x2 : 841, 
        y2 : 703,
        colour : c_gray
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
    var _but_y = 220;
    var _base_tool = "Click to open the settings for this unit.";

    for (var i = 0; i<array_length(_role_order); i++){
        var _role_id = _role_order[i];

        var _active = obj_ini.race[100][_role_id] != 0;
        var _button = new UnitButtonObject({
            style : "pixel",
            x1 : _but_x,
            y1 : _but_y,
            label : obj_ini.role[100][_role_id],
            set_width : true,
            w : 289,
            active : _active,
            role_id : _role_id,
            tooltip : string(obj_ini.role[100][_role_id]) + " Settings\n" + _base_tool
        });

        _but_y += 30;
        array_push(role_settings_selection_buttons, _button);

    }

    settings_buttons_ui_components.role_settings_selection_buttons = role_settings_selection_buttons;

    company_settings_selection_buttons = [];
    _but_x = 936;
    _but_y = 220;
    var romanNumerals = scr_roman_numerals();
    _base_tool = "Click to open the settings for this company.";

    for (var i = 0; i<obj_ini.companies; i++){

        var _string = i == 0 ? "Headquarters" : romanNumerals[i - 1] + " Company"
        var _button = new UnitButtonObject({
            style : "pixel",
            x1 : _but_x,
            y1 : _but_y,
            label : _string,
            set_width : true,
            w : 289,
            tooltip : _string + " Settings\n" + _base_tool
        });

        _but_y += 30;
        array_push(company_settings_selection_buttons, _button);

    }

    settings_buttons_ui_components.company_settings_selection_buttons = company_settings_selection_buttons;

    settings_buttons_ui_components.boarding_objectives = new ReactiveString(
        "Boarding Objective",
        100,
        600, 
        {
            tooltip : "Boarding Objective\nThe objective of your Astartes once they board an enemy ship."
        }
    );


    var _toggle_dam_sys = new ToggleButton({
        style : "box",
        tooltip : "Your Astartes will attempt to disable the ship by attacking the ship bridge and systems.",
        str1 : "Damage Systems",
        x1 : 50,
        y1 : 634,
        active : command_set[20],
        clicked_check_default : true
    });

    settings_buttons_ui_components.boarding_damage_systems = _toggle_dam_sys;

    var _toggle_use_plasma = new ToggleButton({
        style : "box",
        tooltip : "Your Astartes will use equipped Plasma Bombs to massively damage the boarded ship.",
        str1 : "Use Plasma Bombs",
        x1 : 150,
        y1 : 634,
        active : command_set[21],
        clicked_check_default : true
    });

    settings_buttons_ui_components.boarding_plasma_bombs = _toggle_use_plasma;

    var _toggle_commandeer = new ToggleButton({
        style : "box",
        tooltip : "Your Astartes will attempt to commandeer the vessel, to be permenantely used or salvaged.",
        str1 : "Commandeer Ship",
        x1 : 75,
        y1 : 688,
        active : command_set[22],
        clicked_check_default : true
    });

    settings_buttons_ui_components.boarding_commandeer = _toggle_commandeer;

    var _sets = settings_buttons_ui_components;

    _sets.progenitor_livery = new ToggleButton({
        x1 : 50,
        y1 : 140,
        str1 : "Progenitor Livery",
        tooltip : "Turned off by default. \nWhen turned on, various unit visuals may change depending on your progenitor chapter.",
        active : progenitor_visuals,
        style : "box",
        clicked_check_default : true
    });

    _sets.astartes_transfer_toggle = new ToggleButton({
        x1 : _sets.progenitor_livery.x2 + 10,
        y1 : 140,
        str1 : "Allow Astartes Transfer",
        tooltip : "Turned off by default. Allows you to transfer Astartes in the same way as vehicles.",
        active : command_set[1],
        style : "box",
        clicked_check_default : true
    });

    _sets.codex_compliant = new ToggleButton({
        x1 : _sets.astartes_transfer_toggle.x2 + 10,
        y1 : 140,
        str1 : "Codex Compliant Organization",
        tooltip : "When enabled, marine promotions are limited based on their current company and EXP, overall following the Codex Astartes promotion sequence.",
        active : command_set[2],
        style : "box",
        clicked_check_default : true
    });

    var _y = _sets.progenitor_livery.y2 + 10;
    _sets.modest_livery = new ToggleButton({
        x1 : 50,
        y1 : _y,
        str1 : "Modest Livery",
        tooltip : "Turned off by default.  Prevents Advantages and Disadvantages from changing the appearances of your marines, effectively disabling any special ornamentation or possible battle wear.",
        active : modest_livery,
        style : "box",
        clicked_check_default : true
    });

    _sets.tagged_training = new ToggleButton({
        x1 : _sets.astartes_transfer_toggle.x1,
        y1 : _y,
        str1 : "Tagged Training Livery",
        tooltip : "Turned off by default, makes specialist training select only tagged marines, click on their potential indicators to tag.",
        active : tagged_training,
        style : "box",
        clicked_check_default : true
    });

    var _roles = active_roles();


    _role_order = [
        eROLE.CAPTAIN,
        eROLE.ANCIENT,
        eROLE.CHAMPION,
        eROLE.CHAPLAIN,
        eROLE.APOTHECARY,
        eROLE.LIBRARIAN,
        eROLE.TECHMARINE
    ]

    var _tog_buttons = [];

    for (var i=0;i<array_length(_role_order);i++){
        var _role_name = _roles[_role_order[i]];
        array_push(_tog_buttons, 
            {
                str1 : _role_name,
                font : fnt_40k_14,
                active : command_set[3 + i],
                tooltip : $"activate to make {_role_name}s a default member of your company command."
            }           
        )
    }

    var _command_mult = new MultiSelect(
        _tog_buttons, 
        "Company Command Structure", 
        {
            draw_alighn : "vertical",
            x1 : 75,
            y1 : 300,
        }
    );

    _sets.comany_command_structure = _command_mult;

    var _post_boarding = new RadioSet(
        [
            {
                str1 : "Board Next Nearest",
                font : fnt_40k_14,
                style : "box",
                tooltip : "After disabling an enemy vessel your Astartes will launch a new boarding mission at the nearest enemy."
            },
            {
                str1 : "Return and Recuperate",
                font : fnt_40k_14,
                style : "box",
            }
        ], 
        "Post-Boarding", 
        {
            draw_alighn : "vertical",
            x1 : 40,
            y1 : 730,
        }
    );

    _sets.post_boarding_action = _post_boarding;

    _sets.auto_board_multi = new MultiSelect(
        [
            {
                str1 : "Battleships",
                font : fnt_40k_14,
                style : "box",
                tooltip : "If checked your ships will launch Boarding teams automatically when an eligible target is in range."
            },
            {
                str1 : "Cruisers",
                font : fnt_40k_14,
                style : "box",
                tooltip : "If checked your ships will launch Boarding teams automatically when an eligible target is in range."
            }
        ], 
        "Automatic Boarding", 
        {
            x1 : 325,
            y1 : 730,
        }
    );
}

function scr_ui_settings() {

    var romanNumerals = scr_roman_numerals();
    // Var declaration
    var tool1 = "", tool2 = "";
    var _che = false;
    var cx, cy;
    var x5 = 0, y5 = 0, x6 = 0;
    var too_img = 0;

    if ((menu == eMENU.FORMATIONS_SETTINGS) && (formating > 0)) {
        scr_draw_formation_settings();
    }else if (menu == eMENU.ROLE_SETTINGS) {
        scr_draw_role_settings_ui();
    }else if (menu == eMENU.COMPANY_SETTINGS){
        scr_draw_company_settings_ui();
    }

    if (menu == eMENU.SETTINGS) {
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

        yy -= 64;

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

        for (var i=0;i<array_length(_com_multi.toggles);i++){
            command_set[3 + i] = _com_multi.toggles[i].active;
        }

        _ui_feats.boarding_objectives.draw();

        var _toggl_dam_sys = _ui_feats.boarding_damage_systems;
        if (_toggl_dam_sys.draw()){
            command_set[20] = _toggl_dam_sys.active;
            if (_toggl_dam_sys.active){
                command_set[22] = false;
                command_set[21] = false;
            }
        }

        var _toggle_use_plasma = _ui_feats.boarding_plasma_bombs;

        if (_toggle_use_plasma.draw()){
            command_set[21] = _toggle_use_plasma.active;
            if (_toggle_use_plasma.active){
                command_set[22] = false;
                command_set[20] = false;
            }
        }

        var _toggle_commandeer = settings_buttons_ui_components.boarding_commandeer;

        if (_toggle_commandeer.draw()){
            if (_toggle_commandeer.active){
                command_set[22] = 1;
                command_set[20] = 0;
                command_set[21] = 0;  
            }  else {
                command_set[22] = 0;
            }        
        }

        var _post_board = settings_buttons_ui_components.post_boarding_action;

        if (command_set[22] == 1){
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

        _auto_board.draw();

        command_set[25] = _auto_board.toggles[0].active;

        command_set[26] = _auto_board.toggles[1].active;

        yy += 64;

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
                }
                else if (bat_formation_type[i] == 2) {
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
                if (scr_hit(xxx, yyy, xxx + 289, yyy + 20) == true) {
                    /*if (custom==eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.2);if (custom!=eCHAPTER_TYPE.CUSTOM) then */
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(xxx, yyy, xxx + 289, yyy + 20, 0);
                    draw_set_alpha(1);

                    if (i <= 3) {
                        tool1 = string(shw) + " Settings";
                    }
                    tool2 = "Click to open the settings for this formation.";
                    if (i > 3) {
                        if (bat_formation[i] != "") {
                            tool1 = $"{string(bat_formation[i])} Settings";
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
                            bat_deva_for[formating] = 1;
                            bat_assa_for[formating] = 4;
                            bat_tact_for[formating] = 2;
                            bat_vete_for[formating] = 2;
                            bat_hire_for[formating] = 3;
                            bat_libr_for[formating] = 3;
                            bat_comm_for[formating] = 3;
                            bat_tech_for[formating] = 3;
                            bat_term_for[formating] = 3;
                            bat_hono_for[formating] = 3;
                            bat_drea_for[formating] = 5;
                            bat_rhin_for[formating] = 6;
                            bat_pred_for[formating] = 7;
                            bat_landraid_for[formating] = 7;
                            bat_landspee_for[formating] = 4;
                            bat_whirl_for[formating] = 1;
                            bat_scou_for[formating] = 1;
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


function scr_select_company_settings_ui(){
// Company Settings
    var _comp_buttons = settings_buttons_ui_components.company_settings_selection_buttons;
    for (var i = 0; i<array_length(_comp_buttons); i++){
        var _button = _comp_buttons[i];
        if (!_button.draw()){
            continue;
        }


        /*if (custom==eCHAPTER_TYPE.CUSTOM) then draw_set_alpha(0.2);if (custom!=eCHAPTER_TYPE.CUSTOM) then */
        menu = eMENU.COMPANY_SETTINGS;
        settings = i;
        if (settings != 0){
            squad_arrangement = new SquadArrangementEditor(settings);
        }
    }
}

function scr_draw_company_settings_ui(){
    var _back_button = settings_buttons_ui_components.back_arrow;
    _back_button.draw();
    squad_arrangement.draw();
}

function scr_select_role_settings_ui(){
// Role Settings
    var _role_buttons = settings_buttons_ui_components.role_settings_selection_buttons;
    for (var i = 0; i<array_length(_role_buttons); i++){
        var _button = _role_buttons[i];
        if (!_button.draw()){
            continue;
        }
        settings = _button.role_id;
        menu = eMENU.ROLE_SETTINGS;
        with (obj_mass_equip) {
            instance_destroy();
        }
        instance_create(0, 0, obj_mass_equip);      
    }
}

function scr_draw_role_settings_ui(){
    if (menu == eMENU.ROLE_SETTINGS) {
        if (settings > 0) {
            var co = 100;
            var ide;
            ide = settings;

            var _back_button = settings_buttons_ui_components.back_arrow;
            _back_button.draw();
            if (_back_button.is_clicked) {
                with (obj_mass_equip) {
                    instance_destroy();
                }
                menu = 21;
                exit;
            }

            draw_set_halign(fa_center);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(800, 66, string(obj_ini.role[100][settings]) + " Settings", 1, 1, 0);

            // New: 678,160
            // Old: 444,550
            // Dif: 234,-390

            draw_set_font(fnt_40k_30b);
            draw_set_color(c_gray);
            draw_set_halign(fa_left);
            draw_text_transformed(678, 160, obj_ini.role[co][ide], 0.6, 0.6, 0);
            var wid, hei;
            wid = 0;
            hei = string_height_ext(string(obj_ini.role[co][ide]) + "Q", -1, 580) * 0.6;
            draw_rectangle(678 - 1, 160 - 1, 1056, 160 + hei, 1);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_14b);
            draw_set_halign(fa_right);

            var title = "";
            var geh = "";
            spacing = 22;
            x5 = 830;
            y5 = 207 - spacing;

            for (var gg = 0; gg <= 4; gg++) {
                y5 += spacing;
                if (gg == 0) {
                    title = "Main Weapon: ";
                    geh = obj_ini.wep1[co][ide];
                }
                if (gg == 1) {
                    title = "Secondary Weapon: ";
                    geh = obj_ini.wep2[co][ide];
                }
                if (gg == 2) {
                    title = "Armour: ";
                    geh = obj_ini.armour[co][ide];
                }
                if (gg == 3) {
                    title = "Special Item: ";
                    geh = obj_ini.gear[co][ide];
                }
                if (gg == 4) {
                    title = "Mobility Item: ";
                    geh = obj_ini.mobi[co][ide];
                }

                draw_set_halign(fa_right);
                draw_set_color(c_gray);
                draw_rectangle(x5, y5, x5 - string_width(title), y5 + string_height(title) - 2, 0);
                draw_set_color(0);
                draw_text(x5, y5, string(title));

                if (scr_hit(x5 - string_width(title), y5, x5, y5 + string_height(title) - 2) == true) {
                    draw_set_color(c_white);
                    draw_set_alpha(0.2);
                    draw_rectangle(x5, y5, x5 - string_width(title), y5 + string_height(title) - 2, 0);

                    var nep = false;

                    if (((obj_ini.armour[co][ide] == "Terminator Armour") || (obj_ini.armour[co][ide] == "Dreadnought")) && (gg == 3)) {
                        nep = true;
                    }
                    if ((ide == 6) && ((gg == 2) || (gg == 4))) {
                        nep = true;
                    }

                    if (mouse_button_clicked() && !nep) {
                        if (obj_mass_equip.tab != -1) {
                            obj_mass_equip.refresh = true;
                        } else if (obj_mass_equip.tab == -1) {
                            obj_mass_equip.tab = gg;
                            obj_mass_equip.item_name = [];
                            var is_hand_slot = gg == 0 || gg == 1;
                            scr_get_item_names(
                                obj_mass_equip.item_name,
                                obj_controller.settings, // eROLE
                                gg, // slot
                                is_hand_slot ? (obj_mass_equip.tab == 0 ? eENGAGEMENT.RANGED : eENGAGEMENT.MELEE) : eENGAGEMENT.NONE,
                                true, // include company standard
                                false, // show all regardless of inventory

                            );
                        }
                    }
                }
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_set_halign(fa_left);
                draw_text(x5 + 5, y5, string(geh));
            }
        }
    }
}


function scr_draw_formation_settings(){
    add_draw_return_values();
    // Reset vars
    tool1 = "";
    tool2 = "";
    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_30b);

    draw_set_alpha(1);
    // Back arrow
    var _back_button = settings_buttons_ui_components.back_arrow;
    _back_button.draw();
    if (_back_button.is_clicked){
        with (obj_formation_bar) {
            instance_destroy();
        }

        menu = 21;
        if (bat_formation[formating] == "") {
            bat_formation_type[formating] = 0;
        }
        pop_draw_return_values();
        exit;            
    }

    draw_sprite(spr_formation_arrow, 0, 550, 385);

    var _name_input = settings_buttons_ui_components.formation_name_input;

    bat_formation[formating] = _name_input.draw(bat_formation[formating]);

    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);

    var _formation_type = bat_formation_type[formating] == 1;

    var _formation_radio = settings_buttons_ui_components.formation_radio

    if (formating <= 3){
        _formation_radio.allow_changes = false;
    }
    _formation_radio.draw();

    if (_formation_radio.changed){
        var _new_val =  _formation_radio.selection_val("value");
        if (_new_val == "attack"){
            bat_formation_type[formating] = 1;
            scr_ui_formation_bars();            
        } else if (_new_val == "raid"){
            bat_formation_type[formating] = 2;
            scr_ui_formation_bars();            
        }
    }


    var _attack_box = settings_buttons_ui_components.attack_box;

    var _raid_box = settings_buttons_ui_components.raid_box;
   
    draw_set_color(c_gray);
    draw_set_alpha(0.25);

    var _player_deploys_x = 49;
    var  _player_deploys_y = 224;

    for (var i = 0; i < 10; i++) {
        draw_rectangle(_player_deploys_x, _player_deploys_y, _player_deploys_x + 38, _player_deploys_y + 464, 0);
        _player_deploys_x += 50;
    }
    draw_set_alpha(1);
	
	var _enemy_deploy_boxes_x;
    // Attack Box
    if (bat_formation_type[formating] == 1) {
        _attack_box.draw(1);
        _enemy_deploy_boxes_x = 1054;
    } else {
        _raid_box.draw(1);
        _enemy_deploy_boxes_x = 684;
    }

    draw_set_alpha(0.25);
    // Draw Enemy boxes
    draw_set_color(c_red);
    var _enemy_deploy_boxes_y = 224;
    for (var i = 0; i < 3; i++) {
        draw_rectangle(_enemy_deploy_boxes_x, _enemy_deploy_boxes_y, _enemy_deploy_boxes_x + 38, _enemy_deploy_boxes_y + 464, 0);
        _enemy_deploy_boxes_x += 50;
    }

    // Draw Secondary info box
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle( 1221,  211,  1561,  703, 1);
    draw_rectangle( 1220,  212,  1560,  702, 1);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);

    // This is where the cursor is changed- needs to be smart and also pass the instance type
    tooltip = "";
    tooltip_other = "";

    if (collision_point(mouse_x, mouse_y, obj_formation_bar, 1, 1) && (obj_cursor.image_index == 0)) {
        obj_cursor.image_index = 3;
    }
    if ((!collision_point(mouse_x, mouse_y, obj_formation_bar, 1, 1)) && (obj_cursor.image_index == 3)) {
        obj_cursor.image_index = 0;
    }

    if (obj_cursor.image_index == 3) {
        var theh = instance_position(mouse_x, mouse_y, obj_formation_bar);
        if (instance_exists(theh)) {
            if (theh.unit_id == 1) {
                tooltip = "Headquarters";
                tooltip2 = "You and your advisors will be placed within this section.  It is strongly advisable you give them backup in this same column.";
            }
            if (theh.unit_id == 2) {
                tooltip = "Honour Guard";
                tooltip2 = "Any Honour Guard within your Headquarters will be placed here.  The best place for them within the formation depends on loadout.";
            }
            if (theh.unit_id == 3) {
                tooltip = "Librarians";
                tooltip2 = "Epistolary, Lexicanum, and Codiciery make up this section.  They tend to deal decent damage and offer useful buffs for other units.";
            }
            if (theh.unit_id == 4) {
                tooltip = "Techmarines";
                tooltip2 = "Techmarines and their servitors are placed within this block.  It is advisable that they are placed near your vehicles and armour.";
            }
            if (theh.unit_id == 5) {
                tooltip = "Terminators";
                tooltip2 = "Any Terminators that you may have will be placed here.  They can very easily soak lots of damage and dish it back in return.";
            }
            if (theh.unit_id == 6) {
                tooltip = "Veterans";
                tooltip2 = "Veterans, the most experienced tacticals of your Chapter, are placed here.  Their best position in the formation depends on loadout.";
            }
            if (theh.unit_id == 7) {
                tooltip = "Tacticals";
                tooltip2 = "The greater bulk of your Chapter, the tactical marines, go here.  Tactical marines may be situated nearly anywhere.  Note that Apothecaries and Chaplains without jump-packs will also be placed here.";
            }
            if (theh.unit_id == 8) {
                tooltip = "Devastators";
                tooltip2 = "Devastators offer much long ranged firepower.  As a result they are best placed in the rear of your formation.";
            }
            if (theh.unit_id == 9) {
                tooltip = "Assaults";
                tooltip2 = "Assault marines are damage powerhouses, but tend to be squisher.  You may or may not wish for them to be on the front lines.  Note that Apothecaries and Chaplains with jump-packs will be placed here.";
            }
            if (theh.unit_id == 10) {
                tooltip = "Scouts";
                tooltip2 = "Scouts are not-yet full fledged Astartes.  Striking a balance between exposure to the enemy, for experience, and safety is key.";
            }
            if (theh.unit_id == 11) {
                tooltip = "Dreadnoughts";
                tooltip2 = "Dreadnoughts are the most durable and tough marines within your chapter.  They are best suited for the front lines.";
            }
            if (theh.unit_id == 12) {
                tooltip = "Hirelings";
                tooltip2 = "Any and all units that you recieve from other factions are placed within this block.";
            }
            if (theh.unit_id == 13) {
                tooltip = "Rhinos";
                tooltip2 = "Rhinos offer protection for units behind them but are not well armoured and lacking in firepower.";
            }
            if (theh.unit_id == 14) {
                tooltip = "Predators";
                tooltip2 = "Predators offer protection for units behind them and have a decent amount of long ranged firepower.";
            }
            if (theh.unit_id == 15) {
                tooltip = "Land Raiders";
                tooltip2 = "Land Raiders are incredibly tanky war machines that protect rear columns and offer tremendous amounts of firepower.  Other super-heavy vehicles will also be placed here.";
            }
            if (theh.unit_id == 16) {
                tooltip = "Land Speeders";
                tooltip2 = "Land Speeders are incredibly agile attack vehicles that offer a light highly mobile heavy weapon platform.";
            }
            if (theh.unit_id == 17) {
                tooltip = "Whirlwinds";
                tooltip2 = "Whirlwinds are armoured fire-support capable of supporting assaults from a long range safe from enemy retaliation.";
            }
            too_img = theh.unit_id - 1;
        }
    }

    if (tooltip != "") {
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(1398, 213, string(tooltip), 0.75, 0.75, 0);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_text_ext(1227, 565, string(tooltip2), -1, 323);

        // draw_sprite(spr_formation_splash,too_img,xx+1271,yy+252);
        scr_image("formation", too_img, 1271, 252, 239, 297);
    }

    if (tool1 != "") {
        tooltip_draw(tooltip2,350, , CM_GREEN_COLOR, fnt_40k_14, tooltip);
    }
    pop_draw_return_values();
}
