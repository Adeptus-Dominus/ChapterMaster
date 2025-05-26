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
    }
	
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

    list_slate.inside_method = function(){

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

        var _column_x = list_slate.XX + 40
        var yy = list_slate.YY;
        var xx = list_slate.XX;
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
            draw_rectangle(xx + 25, _row_y, xx + list_slate.width-50, _row_y + _row_height, 1);

            var _goto_button = {
                x1: _columns.location.x1 - 20,
                y1: _row_y + 4,
                sprite: spr_view_small,
                click: function() {
                    return point_and_click([x1, y1, x2, y2]);
                }
            };
            with(_goto_button) {
                w = sprite_get_width(sprite);
                h = sprite_get_height(sprite);
                x2 = x1 + w;
                y2 = y1 + h;
                draw_sprite(sprite, 0, x1, y1);
            }
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

            if scr_hit(xx + 25, _row_y, xx + 1546, _row_y + _row_height) {
                var _struct = obj_ini.ship_data[i];
                if (fleet_temps.view_ship != i){
                    fleet_temps.view_ship = i;
                    fleet_temps.view_ship_struct = _struct;
                    fleet_temps.view_ship_occupants = scr_ship_occupants(i);
                }
                tooltip_draw($"Carrying ({_struct.carrying}/{_struct.capacity}");
                if (_goto_button.click()) {
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

            draw_set_color(c_gray);
            draw_rectangle(xx + 146, yy + 492, xx + 411, yy + 634, 1);
            var ships = ["Battle Barge", "Strike Cruiser","Gladius","Hunter"];
            var ship_im = 0;
            for (var i=0;i<array_length(ships);i++){
                if (_ship.class==ships[i]){
                    ship_im=i;
                    break;
                }
            }
            draw_set_color(c_white);
            draw_sprite(spr_ship_back_white, ship_im, _center_x-(sprite_get_width(spr_ship_back_white)/2), yy + 492);

            draw_set_color(c_gray);
            draw_set_font(fnt_40k_14);
            draw_set_halign(fa_left);



            draw_text(xx + 42, yy + 450, $"Health: {_ship.ship_hp_percentage()}");
            draw_text(xx + 42, yy + 500, $"Shields: {_ship.shields}" );
            draw_text(xx + 42, yy + 550, $"Armour: {_ship.front_armour},{_ship.side_armour}, {_ship.rear_armour}");
            draw_text(xx + 42, yy + 600, $"Turrets: {array_length(_ship.turrets)}");

            draw_text(xx + 426, yy + 450, $"Max Speed: {convert_to_kilometers(_ship.max_speed)}km/s");
            draw_text(xx + 426, yy + 500, $"Acceleration: {_ship.acceleration * 60}km/s/s");
            draw_text(xx + 426, yy + 550, $"Turn Speed: {_ship.turning_speed * 60}degrees/s");
            

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