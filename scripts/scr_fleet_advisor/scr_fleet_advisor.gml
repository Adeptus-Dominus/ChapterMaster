function fleet_advisor_data_setup(){
    fleet_temps = {
        capitals : 0,
        frigates : 0,
        escorts : 0,
        ships_with_damage : false,
        heavy_damaged_ships : 0,
        most_damaged_ship : -1,
        view_ship : -1,
        view_ship_struct : false,
        view_ship_occupants : "",
        weapon_equip:false
    }
    var _goto_button = new icon_button();

    _goto_button.set_sprite_data(1,1,spr_view_small, 0);
    with (_goto_button){
        click_method = function(){
            var _temps = obj_controller.fleet_temps;
            var _ship = _temps.view_ship_struct;
            var _select_data = {
                purpose : $"{_ship.name} technical suppliers",
                purpose_code : "ship_tech_suppliers",
                number : 0,
                ship : _temps.view_ship,
            }
            group_selection(_ship.tech_suppliers,_select_data);
        }

        hover_method = function(){
            tooltip_draw("Click to viewmarines currently contributing to fullfilling technical requirements");
        }
    }  
    
    fleet_temps.tech_fulfilment_view = _goto_button;
	
    ship_slate = new DataSlate();
    list_slate = new DataSlate();
    weapon_slate = new DataSlate();
    weapon_slate.weapon = false;
    weapon_slate.slot = false;
    for (var i = 0; i < array_length(obj_ini.ship_data); i++) {
         var _ship = obj_ini.ship_data[i];

        switch(_ship.size){
            case 3:
                fleet_temps.capitals++;
                break;
            case 2:
                fleet_temps.frigates++;
                break;
            case 1:
                fleet_temps.escorts++;
                break;                                                                
        }

    } 

    var _most_damage = 100;
    for (var i = 0; i < array_length(obj_ini.ship_data); i++) {
        var _ship = fetch_ship(i);
        _ship.update_ship_combat_data();
        var _percent = _ship.ship_hp_percentage();
        if (_percent<100 && !fleet_temps.ships_with_damage){
            fleet_temps.ships_with_damage = true;
        }
        if (_percent<25){
            fleet_temps.heavy_damaged_ships++;
        }
        if (_percent<_most_damage){
            fleet_temps.most_damaged_ship = i;
            _most_damage = _percent;
        }
    }
    man_max = i;
    man_current = 0; 
    var _text = "Greetings, Chapter Master.\n\nYou requested a report?  Our fleet contains ";
    _text += $"Your fleet contains {fleet_temps.capitals} Capital Ships, {fleet_temps.frigates} Frigates, and {fleet_temps.escorts} Escorts";
    if (fleet_temps.ships_with_damage == 0){
        _text += ", none of which are damaged.";
    }
    if (_most_damage < 100){
        _text += $".  Our most damaged vessel is the {fetch_ship(fleet_temps.most_damaged_ship).name} - it has {_most_damage}% Hull Integrity.";
    }

    if (fleet_temps.heavy_damaged_ships == 2){
        _text += "  Two of our ships are highly damaged.  You may wish to purchase a Repair License from the Sector Governerner.";
    }
    if (fleet_temps.heavy_damaged_ships > 2){
        _text += "  Several of our ships are highly damaged.  It is advisable that you purchase a Repair License from the Sector Governer.";
    } 

    _text += "\n\nHere are the current positions of our ships and their contents:"; 
    if (menu_adept = 1) {
        _text = string_replace(_text, "Our", "Your");
        _text = string_replace(_text, " our", " your");
        _text = string_replace(_text, "We", "You");
    }
    fleet_temps.advisor_text = _text;

    var _feet_surface = surface_create(685, 752);
    surface_set_target(_feet_surface);
    fleet_temps.goto_buttons = [];
    fleet_temps.hitboxes = [];
    fleet_select_surface();
    surface_reset_target();
    fleet_temps.fleet_list_surface = _feet_surface;
}

function fleet_select_surface(){
    draw_set_font(fnt_40k_14b);
    draw_set_color(c_white);
    var _columns = {
        name: {
            w: 176,
            text: "Name",
            h_align: fa_left,
            y1 : 0,
        },
        class: {
            w: 154,
            text: "Class",
            h_align: fa_left,
            y1 : 0,
        },
        location: {
            w: 130,
            text: "Location",
            h_align: fa_left,
            y1 : 0,
        },
        hp: {
            w: 44,
            text: "HP",
            h_align: fa_right,
            y1 : 0,
        },
        carrying: {
            w: 84,
            text: "Carrying",
            h_align: fa_right,
            y1 : 0,
        },
    };

    var _column_x = 0 + 40
    var yy = 0;
    var xx = 0;
    var _header_offset = 80;
    var _columns_array = ["name", "class", "location", "hp", "carrying"];

    for (var i = 0; i < array_length(_columns_array); i++) {
        with(_columns[$ _columns_array[i]]) {
            x1 = _column_x;
            _column_x += w;
            x2 = x1 + w;
            y1 = yy + _header_offset;
            header_y = (y1 - 2);
            switch (h_align) {
                case fa_right:
                    header_x = x2;
                    break;
                case fa_center:
                    header_x = (x1 + x2) / 2;
                    break;
                case fa_left:
                default:
                    header_x = x1;
                    break;
            }
            draw_set_halign(h_align);
            draw_text(header_x, header_y, text);
        }
    }
    draw_set_halign(fa_left);

    var _row_height = 20;
    var _row_gap = 2;
    for (var i = ship_current; i < ship_current + 34; i++) {
        if (i >= array_length(obj_ini.ship_data)){
            continue;
        }

        var _row_y = _columns.name.y1 + _row_height + (i * (_row_height + _row_gap));

        var _goto_button = new icon_button();

        _goto_button.x1 = _columns.location.x1 - 20;
        _goto_button.y1 = _row_y + 4;

        _goto_button.set_sprite_data(1,1,spr_view_small, 0);
        _goto_button.id = i;
        with (_goto_button){
            click_method = function(){
                var i = id;
                with(obj_p_fleet) {
                    var _fleet_ships = fleet_full_ship_array();
                    if (array_contains(_fleet_ships, i)){
                        obj_controller.x = x;
                        obj_controller.y = y;
                        obj_controller.menu = 0;
                        with(obj_fleet_show) {
                            instance_destroy();
                        }
                        instance_create(x, y, obj_fleet_show);                              
                    }
                }
            }
        }

        array_push(fleet_temps.goto_buttons, _goto_button)

        var _ship = obj_ini.ship_data[i];

        with(_columns) {
            name.contents = string_truncate(_ship.name, _columns.name.w - 6);
            class.contents = _ship.class;
            location.contents = _ship.location;
            hp.contents = $"{round(_ship.hp / _ship.max_hp * 100)}%";
            carrying.contents = $"{_ship.carrying}/{_ship.capacity}";
        }

        for (var g = 0; g < array_length(_columns_array); g++) {
            with(_columns[$ _columns_array[g]]) {
                draw_set_halign(h_align);
                switch (h_align) {
                    case fa_right:
                        draw_text(x2, _row_y, contents);
                        break;
                    case fa_center:
                        draw_text((x1 + x2) / 2, _row_y, contents);
                        break;
                    case fa_left:
                    default:
                        draw_text(x1, _row_y, contents);
                        break;
                    }
            }
        }
        var _hit_box = {
            x1 : xx + 25,
            x2 : xx + 1546,
            y1 : _row_y,
            y2 : _row_y + _row_height,
            ship : obj_ini.ship_data[i],
            id : i,
            relative_x : 0,
            relative_y : 0,
        }
        with (_hit_box){
            enter = function(){
                if (scr_hit(relative_x + x1, relative_y + y1, relative_x+ x2, relative_y + y2)) {
                    if (obj_controller.fleet_temps.view_ship != id){
                        obj_controller.fleet_temps.view_ship = id;
                        obj_controller.fleet_temps.view_ship_struct = ship;
                        obj_controller.fleet_temps.view_ship_occupants = scr_ship_occupants(id);
                    }
                    tooltip_draw($"Carrying ({ship.carrying}/{ship.capacity}");
                }                
            }            
        }
        array_push(fleet_temps.hitboxes, _hit_box);
    }
}

function setup_weapon_selection_equip(){
    var _weps = obj_ini.ship_weapons;
    var _slot = obj_controller.fleet_temps.wep_change_slot;
    for (var i=0;i<array_length(_weps);i++){
        var _wep = _weps[i];
        if (_slot.size < _wep.size){
            continue;
        }
        
    }

}

// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @mixin
function scr_fleet_advisor(){
	//TODO swap this xx yy stuff out for a surface
	var xx = __view_get(e__VW.XView, 0) + 0;
    var yy = __view_get(e__VW.YView, 0) + 0;
	draw_sprite(spr_rock_bg, 0, xx, yy);

    if (menu_adept = 0) {
        if(struct_exists(obj_ini.custom_advisors, "admiral")){
            scr_image("advisor/splash", obj_ini.custom_advisors.admiral, xx + 16, yy + 43, 310, 828);
        } else {
            scr_image("advisor/splash", 7, xx + 16, yy + 43, 310, 828);
        }        // draw_sprite(spr_advisors,6,xx+16,yy+43);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, "Flagship Bridge", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, $"Master of the Fleet {obj_ini.lord_admiral_name}", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }
    if (menu_adept = 1) {
        scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 40, "Flagship Bridge", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, $"Adept {obj_controller.adept_name}" , 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
    }

    draw_text_ext(xx + 336 + 16, yy + 130, fleet_temps.advisor_text, -1, 536);

    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_text_transformed(xx + 1262, yy + 40, "Fleet", 0.6, 0.6, 0);

    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);

    var cn = obj_controller;

    // TODO: Probably a good idea to turn this whole interactive list/sheet generating logic into a constructor, that can be reused on many screens.
    // I have no passion for this atm.

    if (obj_controller.fleet_temps.weapon_equip == false){
        list_slate.inside_method = function(){
            draw_surface(fleet_temps.fleet_list_surface, list_slate.XX, list_slate.YY);
            var _loop = max(array_length(fleet_temps.goto_buttons), array_length(fleet_temps.hitboxes));
            for (var i=0;i<_loop;i++){
                if (i<array_length(fleet_temps.goto_buttons)){
                    var _button = fleet_temps.goto_buttons[i];
                    _button.relative_x = list_slate.XX;
                    _button.relative_y = list_slate.YY;
                    _button.draw();
                }
                if (i<array_length(fleet_temps.hitboxes)){
                    var _hit = fleet_temps.hitboxes[i];
                    _hit.relative_x = list_slate.XX;
                    _hit.relative_y = list_slate.YY;                
                    _hit.enter();
                }            
            }
        }
    }


    list_slate.draw_with_dimensions(xx + 900, yy + 66, 685, 752);

    ship_slate.inside_method = function(){
        var xx = ship_slate.XX;
        var _center_x = (ship_slate.width/2) + xx
        var yy = ship_slate.YY;
        if (fleet_temps.view_ship>-1) {
            var _ship = fleet_temps.view_ship_struct;
            draw_set_font(fnt_40k_30b);
            draw_set_halign(fa_center);
            draw_text_transformed(xx + 280, yy + 60, _ship.name, 0.75, 0.75, 0);
            draw_text_transformed(xx + 280, yy + 90, _ship.class, 0.5, 0.5, 0);
            if (_ship.captain != ""){
                draw_text_transformed(xx + 280, yy + 120, $"Current Captain : {_ship.captain_data.name_role()}", 0.5, 0.5, 0);
            } else {
                var _new_cap = draw_unit_buttons([xx + 240, yy + 120], "Choose Captain", [1, 1], 38144, , fnt_40k_14b);
                if (point_and_click(_new_cap)){
                    var _candidates = collect_role_group("all", ["",0,fleet_temps.view_ship]);
                    var _select_data = {
                        purpose:"Ship Management",
                        purpose_code : "ship_captain",
                        number:1,
                        system:0,
                        feature:"none",
                        planet : 0,
                        ship : fleet_temps.view_ship,
                        selections : [],
                    }
                    group_selection(_candidates,_select_data);
                }
                
            }

            draw_set_color(c_gray);
            draw_rectangle(xx + 146, yy + 492, xx + 411, yy + 634, 1);
            var ships = ["Battle Barge", "Strike Cruiser","Gladius","Hunter"];
            var ship_im = 0;
            for (var i=0;i<array_length(ships);i++){
                if (_ship.class == ships[i]){
                    ship_im = i;
                    break;
                }
            }
            draw_set_color(c_white);
            draw_sprite(spr_ship_back_white, ship_im, _center_x-(sprite_get_width(spr_ship_back_white)/2), yy + 492);

            draw_set_color(c_gray);
            draw_set_font(fnt_40k_14);
            draw_set_halign(fa_left);


            if (_ship.tech_fulfilment < _ship.minimum_tech_requirements){
                draw_set_color(CM_RED_COLOR);
            }
            draw_text_ext(xx + 200, yy + 450, $"Tech Fulfillment\n{_ship.tech_fulfilment}/{_ship.minimum_tech_requirements}",-1, 130);
            if (scr_hit(xx + 200, yy + 440, xx + 330, yy + 490)){
                tooltip_draw("Ships without a minimum amount of technical capabilities onboard suffer greatly in combat situations and are prone to malfunctions, weapons jams, slower reload times and a range of other issues. Make sure ships have a contingent of techmarines or marines with high enough technical knowledge to fulfil a ships needs and calm their machine spirits");
            }
            var _view_button = fleet_temps.tech_fulfilment_view;
            _view_button.x1 = 335;
            _view_button.y1 = 465;
            _view_button.relative_x = xx;
            _view_button.relative_y = yy;
            _view_button.update();
            _view_button.draw();
           
            draw_set_color(c_gray);
            draw_text_ext(xx + 42, yy + 450, $"Health: {_ship.ship_hp_percentage()}",-1, 130);
            draw_text_ext(xx + 42, yy + 500, $"Shields: {_ship.shields}" ,-1, 130);
            draw_text_ext(xx + 42, yy + 550, $"Armour: {_ship.front_armour},{_ship.side_armour}, {_ship.rear_armour}",-1, 130);
            draw_text_ext(xx + 42, yy + 600, $"Turrets: {array_length(_ship.turrets)}",-1, 130);

            draw_text_ext(xx + 426, yy + 450, $"Max Speed: {convert_to_kilometers(_ship.max_speed)}km/s",-1, 130);
            draw_text_ext(xx + 426, yy + 500, $"Acceleration: {_ship.acceleration * 60}km/s/s",-1, 130);
            draw_text_ext(xx + 426, yy + 550, $"Turn Speed: {_ship.turning_speed * 60}degrees/s",-1, 130);
            

            draw_set_font(fnt_40k_12);
            // draw_text_ext(xx + 352, 775, $"Carrying ({temp[118]}): {temp[119]}", -1, 542);
            draw_set_font(fnt_40k_14);
            

            _ship.draw_ui_manage(xx, yy);
        }
    }
    ship_slate.draw_with_dimensions(xx + 342, yy + 66, 561, 752);
    if (weapon_slate.weapon != false){
        weapon_slate.inside_method = function(){
            var _wep = weapon_slate.weapon;
            var xx = weapon_slate.XX;
            var yy = weapon_slate.YY;
            draw_set_halign(fa_middle);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_30b);
            draw_text(xx + 280 - (string_width(_wep.name)/2), yy + 30, _wep.name)
            draw_set_font(fnt_40k_14b);
            draw_set_halign(fa_left);
            draw_text(xx+50, yy+60, $"Range : {convert_to_kilometers(_wep.range)}km");
            draw_text(xx+50, yy+90, $"minrange : {convert_to_kilometers(_wep.minrange)}km");
            draw_text(xx+50, yy+120, $"Rate of fire : {1/fps_to_secs(_wep.cooldown)}/s");
            draw_text(xx+50, yy+150, $"Damage : {_wep.dam}");
            draw_text(xx+50, yy+180, $"Firing Arc : {_wep.firing_arc*2} degrees");
            draw_text(xx+50, yy+210, $"Bullet Speed : {convert_to_kilometers(_wep.bullet_speed)}km/s");
            draw_text(xx+50, yy+240, $"Base Accuracy : {_wep.accuracy}%");
            draw_text(xx+50, yy+270, $"Size : {_wep.size}");
            draw_text(xx+50, yy+300, $"bombard_value : {_wep.bombard_value}");
        }
            
            
        weapon_slate.draw_with_dimensions(xx, yy+66, 340, 400);
    }
    // 31 wide
    scr_scrollbar(1550, 100, 1577, 818, 34, ship_max, ship_current);
}