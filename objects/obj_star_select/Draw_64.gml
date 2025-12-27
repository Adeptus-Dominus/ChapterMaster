


if (instances_exist_any([obj_bomb_select, obj_drop_select, obj_popup])){
    exit;
}

if (obj_controller.zoomed=1) then exit;
if (!instance_exists(target)) then exit;
if (obj_controller.menu=60) then exit;

add_draw_return_values();
draw_set_font(fnt_40k_14b);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(0);

var temp1=0;
var xx=__view_get( e__VW.XView, 0 )+0;
var yy=__view_get( e__VW.YView, 0 )+0;
if (loading=1){
    xx=xx;
    yy=yy;
} else if (loading==1){
    var  temp1, dist;
    dist=999;
    
    obj_controller.selecting_planet=0;
    button1="";
    button2="";
    button3="";
    button4="";

    if (instance_exists(target)){
        if (target.space_hulk==1){
            pop_draw_return_values();
            exit;
        }
    }
}
if (obj_controller.selecting_planet>target.planets){
    obj_controller.selecting_planet = 0;
}
var click_accepted = (!obj_controller.menu) and (!obj_controller.zoomed) and (!instance_exists(obj_bomb_select)) and (!instance_exists(obj_drop_select));
if (click_accepted && (!debug || !debug_slate.entered())) {
    if (scr_click_left(0)) {
        var closes=0,sta1=0,sta2=0;
        var mouse_consts = return_mouse_consts();
        sta1=instance_nearest(mouse_consts[0],mouse_consts[1],obj_star);
        sta2=point_distance(mouse_consts[0],mouse_consts[1],sta1.x,sta1.y);
        closes=true;
        if (sta2>15){
            if (scr_hit(
                27,
                165,
                300,
                165+294)
            ){
                closes=false
            } else if (obj_controller.selecting_planet>0){
                closes = !main_data_slate.entered();
                if (closes){
                    if (is_struct(garrison) || population){
                        closes =  !garrison_data_slate.entered();
                    }
                }
               
                if (!is_string(feature)){
                    if (feature.main_slate.entered()){
                        closes=false;
                    }
                }
            }
            var shutter_button;
            var shutters = [shutter_1, shutter_2, shutter_3, shutter_4];
            for (var i=0; i<4;i++){
                shutter_button = shutters[i];
                if (shutter_button.hit()){
                    closes=false;
                    break;
                }
            }
            if (closes){
                cooldown=0;
                obj_controller.sel_system_x=0;
                obj_controller.sel_system_y=0;
                obj_controller.selecting_planet=0;
                obj_controller.popup=0;
                instance_destroy();
            }
        }
    }
}

if (target.craftworld=0) and (target.space_hulk=0) then draw_sprite(spr_star_screen,target.planets,27,165);
if (target.craftworld=1) then draw_sprite(spr_star_screen,5,27,165);
if (target.space_hulk=1) then draw_sprite(spr_star_screen,6,27,165);
if (target.craftworld=0) and (target.space_hulk=0) then draw_sprite_ext(target.sprite_index,target.image_index,77,287,1.25,1.25,0,c_white,1);

var _screen_height = sprite_get_height(spr_star_screen);
var _screen_width = sprite_get_width(spr_star_screen);

draw_sprite_ext(spr_servo_left_arm, 0,27+_screen_width,165+_screen_height/3, 2, 2, 0, c_white, 1);
draw_sprite_ext(spr_servo_right_arm, 0,27,165+_screen_height/3, 2, 2, 0, c_white, 1);
draw_sprite_ext(spr_servo_skull_head, 0,27+_screen_width/2,165, 2, 2, 0, c_white, 1);

var system_string = target.name+" System";
if (target.owner!=1) then draw_set_color(0);
if (target.owner  = eFACTION.Player) then draw_set_color(c_blue);
if (target.craftworld=0) and (target.space_hulk=0){
    draw_text_transformed(184,180,system_string,1,1,0);
}

if (target.craftworld=0) and (target.space_hulk=0){
    draw_set_color(global.star_name_colors[target.owner]);
    draw_text_transformed(184,180,system_string,1,1,0);
}


if (global.cheat_debug && obj_controller.selecting_planet && !loading){
    draw_planet_debug_options();
}


if (obj_controller.menu == 0 && !debug){
    if (manage_units_button.draw(has_player_forces)){
        var _viewer = obj_controller.location_viewer
        _viewer.update_garrison_log();
        var _unit_dispersement = _viewer.garrison_log;
        var _sys_name = target.name;
        if (struct_exists(_unit_dispersement, target.name)){
            group_selection(_unit_dispersement[$ _sys_name].units,{
                purpose:$"{target.name} Management",
                purpose_code : "manage",
                number:0,
                system:target.id,
                feature:"none",
                planet : 0,
                selections : []
            });
            instance_destroy();
            pop_draw_return_values();
            exit;
        }
    }
}


if (loading!=0){
    draw_set_font(fnt_40k_14);
    draw_set_color(CM_GREEN_COLOR);
    draw_text(184,202,
    string_hash_to_newline("Select Destination"));
}


//the draw and click on planets logic
if (!debug){
    planet_selection_action();
}

draw_set_font(fnt_40k_14b);

if (obj_controller.selecting_planet!=0){
    if (p_data.planet != obj_controller.selecting_planet){
        delete p_data;
        p_data = new PlanetData(obj_controller.selecting_planet, target);
    }
// Buttons that are available
    if (!buttons_selected){
        if (obj_controller.faction_status[eFACTION.Imperium] != "War" && p_data.current_owner > 5) || (obj_controller.faction_status[eFACTION.Imperium] == "War" && p_data.at_war(0, 1, 1) && p_data.player_disposition <= 50) {
            var is_enemy=true;
        } else {
            var is_enemy=false;
        }

        if (p_data.planet>0){
            if (target.present_fleet[1]=0)/* and (target.p_type[obj_controller.selecting_planet]!="Dead")*/{
                if (p_data.player_forces>0){
                    if (is_enemy){
                        button1="Attack";
                        button2="Purge";
                    }
                }
            }
            if (target.present_fleet[1]>0)/* and (target.p_type[obj_controller.selecting_planet]!="Dead")*/{
                if (is_enemy) {
                    button1="Attack";
                    button2="Raid";
                    button3="Bombard";
                }
                else {
                    button1="Attack";
                    button2="Raid";
                    button3="Purge";
                }
                
                if (torpedo>0){
                    var pfleet=instance_nearest(x,y,obj_p_fleet);
                    if (instance_exists(pfleet)) and (point_distance(pfleet.x,pfleet.y,target.x,target.y)<=40) and (pfleet.action=""){
                        if (pfleet.capital_number+pfleet.frigate_number>0) and (button4="") then button4="Cyclonic Torpedo";
                    }
                }
                
            }
        }
        var planet_upgrades = target.p_upgrades[obj_controller.selecting_planet];
        if (((p_data.planet_type=="Dead") or (array_length(p_data.upgrades)>0)) and ((target.present_fleet[1]>0) or (target.p_player[obj_controller.selecting_planet]>0))){
            if (array_length(p_data.features)==0) or (array_length(planet_upgrades)>0){

                chock = !p_data.xenos_and_heretics();
                if (chock==1){
                    if (p_data.has_upgrade(P_features.Secret_Base)){
                        button1="Base";
                    }else if (p_data.has_upgrade(P_features.Arsenal)){
                        button1="Arsenal"; 
                    }else if (p_data.has_upgrade(P_features.Gene_Vault)){
                        button1="Gene-Vault";
                    }else if (array_length(p_data.upgrades)==0){
                        button1="Build";
                    }
                    if (array_contains(["Build","Gene-Vault","Arsenal","Base"],button1)){
                        button2="";
                        button3="";
                        button4="";
                        button5="";
                    }
                }
            }
        }
        
        if (obj_controller.recruiting_worlds_bought>0 && !p_data.at_war()){
            if (!p_data.has_feature(P_features.Recruiting_World) && p_data.planet_type != "Dead" && !target.space_hulk){
                button4="+Recruiting";
            }
        }
        if (target.space_hulk){
            if (target.present_fleet[1]>0){
                button1="Raid";
                button2="Bombard";
                button3="";
                button4="";
            }
        }
        buttons_selected=true;  
    }

    main_data_slate.inside_method = function(){
        p_data.planet_info_screen();
    }
    var slate_draw_scale = 420/850;
    if (feature!=""){
        if (is_struct(feature)){
            feature.draw_planet_features(344+main_data_slate.width-4,165)
            if (feature.remove){
                feature="";
            }else if (feature.destroy){
                feature = "";
                instance_destroy();
                pop_draw_return_values();
                exit;
            }
        }
   } else if (population){
    garrison_data_slate.title = "Population Report";
    garrison_data_slate.inside_method = function(){
        draw_set_color(c_gray);
        var xx = garrison_data_slate.XX;
        var yy = garrison_data_slate.YY;                
        var cur_planet = obj_controller.selecting_planet;
        var half_way =  garrison_data_slate.height/2;
        var spacing_x = 100;
        var spacing_y = 65;
        draw_set_halign(fa_left);

        if (!target.space_hulk) {
            if (obj_controller.faction_status[eFACTION.Imperium] != "War" && p_data.current_owner <= 5) || (obj_controller.faction_status[eFACTION.Imperium] == "War") {
                colonist_button.update({
                    x1:xx+35,
                    y1:half_way,
                    allow_click : array_length(potential_doners),
                });
                colonist_button.draw();

                recruiting_button.update({
                    x1:xx+(spacing_x*2)+15,
                    y1:half_way,
                    allow_click : true,
                });
                recruiting_button.draw();

                if (p_data.has_feature(P_features.Recruiting_World)) {
                    var _recruit_world = p_data.get_features(P_features.Recruiting_World)[0];
                    if (_recruit_world.recruit_type == 0) && (obj_controller.faction_status[p_data.current_owner] != "War" && obj_controller.faction_status[p_data.current_owner] != "Antagonism" || p_data.player_disposition >= 50) {
                        draw_text(xx+(spacing_x*3)+35, half_way-20, "Open: Voluntery");
                    } else if (_recruit_world.recruit_type == 0 && p_data.player_disposition <= 50) {
                        draw_text(xx+(spacing_x*3)+35, half_way-20, "Covert: Voluntery");
                    } else {
                        draw_text(xx+(spacing_x*3)+35, half_way-20, "Abduct");
                    }
                    recruitment_type_button.update({
                        x1:xx+(spacing_x*3)+35,
                        y1:half_way,
                        allow_click : true,
                    });
                    recruitment_type_button.draw();

                    draw_text(xx+(spacing_x*3)-15, half_way+(spacing_y)-20, $"Req:{_recruit_world.recruit_cost * 2}");
                    if (_recruit_world.recruit_cost > 0) {
                        recruitment_costdown_button.update({
                            x1:xx+(spacing_x*2)+35,
                            y1:half_way+(spacing_y),
                            allow_click : true,
                        });
                        recruitment_costdown_button.draw();
                    }
                    if (_recruit_world.recruit_cost < 5) {
                        recruitment_costup_button.update({
                            x1:xx+(spacing_x*3)+35,
                            y1:half_way+(spacing_y),
                            allow_click : true,
                        });
                        recruitment_costup_button.draw();
                    }
                }
            }
        }
		
var p = cur_planet;

function fmt_compact(_n){
    _n = abs(_n);
    if (_n >= 1000000000) return string_format(_n / 1000000000, 0, 2) + "B";
    if (_n >= 1000000)    return string_format(_n / 1000000,    0, 2) + "M";
    if (_n >= 1000)       return string_format(_n / 1000,       0, 1) + "K";
    return string(floor(_n));
}

var LARGE_POP_CONVERSION = 1000000000;

var _supported_pop_stored = target.p_max_population[p];
var _cur_pop_stored       = target.p_population[p];
var _max_pop_stored       = target.p_max_population[p];

var _is_large = (target.p_large[p] == 1);

var _supported_pop_abs = _is_large ? (_supported_pop_stored * LARGE_POP_CONVERSION) : _supported_pop_stored;
var _cur_pop_abs       = _is_large ? (_cur_pop_stored       * LARGE_POP_CONVERSION) : _cur_pop_stored;
var _max_pop_abs       = _is_large ? (_max_pop_stored       * LARGE_POP_CONVERSION) : _max_pop_stored;

draw_set_color(c_white);
draw_set_halign(fa_left);

var _base_x = xx + 35;
var _base_y = half_way + spacing_y + 60;
var _line_h = 18;

draw_text(
    _base_x,
    _base_y,
    "Max supported population: " + fmt_compact(_supported_pop_abs)
);

var POP_GROWTH_RATE = 0.00025;
var _pop_growth_abs = 0;

if (_cur_pop_abs > 0 && _supported_pop_abs > 0 && _cur_pop_abs < _supported_pop_abs){
    _pop_growth_abs = ceil(_cur_pop_abs * POP_GROWTH_RATE);
    _pop_growth_abs = min(_pop_growth_abs, _supported_pop_abs - _cur_pop_abs);
} else if (_cur_pop_abs > 0 && _supported_pop_abs <= 0) {
    _pop_growth_abs = ceil(_cur_pop_abs * POP_GROWTH_RATE);
}

draw_text(
    _base_x,
    _base_y + _line_h,
    "Pop growth/turn (0.025%): +" + fmt_compact(_pop_growth_abs)
);

var _has_target_pdf = variable_instance_exists(target.id, "p_target_pdf");
var _target_pdf     = _has_target_pdf ? target.p_target_pdf[p] : 0;

draw_text(
    _base_x,
    _base_y + (_line_h * 2),
    "Target PDF: " + fmt_compact(_target_pdf)
);

var _pdf_cap = 0;
var _support_pct = 0;

if (_has_target_pdf && _target_pdf > 0 && _max_pop_abs > 0){
    var _pop_ratio = clamp(_cur_pop_abs / _max_pop_abs, 0, 1);
    _pdf_cap = floor(_target_pdf * _pop_ratio);

    if (_pdf_cap > 0){
        _support_pct = (target.p_pdf[p] / _pdf_cap) * 100;
    } else if (target.p_pdf[p] > 0){
        _support_pct = 999;
    }
}

draw_text(
    _base_x,
    _base_y + (_line_h * 3),
    "Supported PDF (current pop): " + fmt_compact(_pdf_cap)
);

var PDF_GROWTH_RATE = 0.01;
var _pdf_growth = 0;

if (_has_target_pdf && _target_pdf > 0 && _pdf_cap > 0){
    if (target.p_pdf[p] < _pdf_cap){
        _pdf_growth = ceil(_target_pdf * PDF_GROWTH_RATE);
        _pdf_growth = min(_pdf_growth, _pdf_cap - target.p_pdf[p]);
    }
}

draw_text(
    _base_x,
    _base_y + (_line_h * 4),
    "PDF growth per turn: +" + fmt_compact(_pdf_growth)
);

draw_text(
    _base_x,
    _base_y + (_line_h * 5),
    "PDF capacity usage: " +
    string_format(_support_pct, 0, 1) + "% (" +
    fmt_compact(target.p_pdf[p]) + " of " + fmt_compact(_pdf_cap) + ")"
);

    }
    garrison_data_slate.draw(344+main_data_slate.width-4, 160, 0.6, 0.6);          
}
    if (obj_controller.selecting_planet>0){
        main_data_slate.draw(344,160, slate_draw_scale, slate_draw_scale+0.1);
    }
    var current_button="";
    var shutter_x = main_data_slate.XX-165;
    var shutter_y = 296+165;
    if (!debug){
        if (shutter_1.draw_shutter(shutter_x, shutter_y, button1, 0.5, true)) then current_button=button1;
        if (shutter_2.draw_shutter(shutter_x, shutter_y+47, button2,0.5, true))then current_button=button2;
        if (shutter_3.draw_shutter(shutter_x, shutter_y+(47*2), button3,0.5, true))then current_button=button3;
        if (shutter_4.draw_shutter(shutter_x, shutter_y+(47*3), button4,0.5, true))then current_button=button4;
    }
    if (current_button!=""){
        if (array_contains(["Build","Base","Arsenal","Gene-Vault"],current_button)){
            var building=instance_create(x,y,obj_temp_build);
            building.target=target;
            building.planet=obj_controller.selecting_planet;
            if (p_data.has_upgrade(P_features.Secret_Base)) then building.lair=1;
            if (p_data.has_upgrade(P_features.Arsenal)) then building.arsenal=1;
            if (p_data.has_upgrade(P_features.Gene_Vault)) then building.gene_vault=1;
            obj_controller.temp[104]=string(scr_master_loc());
            obj_controller.menu=60;
            with(obj_star_select){
                instance_destroy();
            }
        }else if (current_button=="Raid" && instance_nearest(x,y,obj_p_fleet).acted<=1){
            instance_create_layer(x, y, layer_get_all()[0], obj_drop_select,{
                p_target:target,
                planet_number : obj_controller.selecting_planet,
                sh_target:instance_nearest(x,y,obj_p_fleet),
                purge:0,
            });

        }else if (current_button=="Attack"){
            var _allow_attack = true;
            var _targ = !target.present_fleet[1] ? -50 : instance_nearest(x,y,obj_p_fleet);
            if (instance_exists(_targ)){
                if (_targ.acted>=2){
                    _allow_attack = false;
                }
            }
            if (_allow_attack){
                instance_create_layer(x, y, layer_get_all()[0], obj_drop_select,{
                    p_target:target,
                    planet_number : obj_controller.selecting_planet,
                    attack :true,
                    sh_target : _targ,
                    purge:0,
                }); 
            }           

        }else if (current_button=="Purge"){
            var _allow_attack = true;
            var _targ = !target.present_fleet[1] ? -50 : instance_nearest(x,y,obj_p_fleet);
            if (instance_exists(_targ)){
                if (_targ.acted>=2){
                    _allow_attack = false;
                }
            }
            if (_allow_attack){           
                instance_create_layer(x, y, layer_get_all()[0], obj_drop_select,{
                    p_target:target,
                    purge:1,
                    planet_number : obj_controller.selecting_planet,
                    sh_target : _targ,
                });
            }

        }else if (current_button=="Bombard"){
            instance_create(x,y,obj_bomb_select);
            if (instance_exists(obj_bomb_select)){
                obj_bomb_select.p_target=target;
                obj_bomb_select.sh_target=instance_nearest(x,y,obj_p_fleet);
                obj_bomb_select.p_data = p_data;
                if (instance_nearest(x,y,obj_p_fleet).acted>0) then with(obj_bomb_select){
                    instance_destroy();
                }
            }
        }else if (current_button=="+Recruiting"){
            if (obj_controller.recruiting_worlds_bought > 0 && p_data.current_owner <= 5 && !p_data.at_war()) {
                if (!p_data.has_feature(P_features.Recruiting_World)) {
                    if (obj_controller.faction_status[eFACTION.Imperium] == "War") {
                        obj_controller.recruiting_worlds_bought -= 1;
                    }
                    array_push(target.p_feature[obj_controller.selecting_planet], new NewPlanetFeature(P_features.Recruiting_World));

                    if (obj_controller.selecting_planet) {
                        obj_controller.recruiting_worlds += planet_numeral_name(obj_controller.selecting_planet, target);
                    }
                    if (obj_controller.recruiting_worlds_bought == 0) {
                        if (button1 == "+Recruiting") {
                            button1 = "";
                        }
                        if (button2 == "+Recruiting") {
                            button2 = "";
                        }
                        if (button3 == "+Recruiting") {
                            button3 = "";
                        }
                        if (button4 == "+Recruiting") {
                            button4 = "";
                        }
                    }
                    // 135 ; popup?
                }
            }
        }else if (current_button=="Cyclonic Torpedo"){
            scr_destroy_planet(2);
        }
    } 
}


if (target!=0){
    if (player_fleet>0) and (imperial_fleet+mechanicus_fleet+inquisitor_fleet+eldar_fleet+ork_fleet+tau_fleet+heretic_fleet>0){
        draw_set_color(0);
        draw_set_alpha(0.75);
        draw_rectangle(37,413,270,452,0);
        draw_set_alpha(1);
        
        /*draw_set_color(CM_GREEN_COLOR);draw_rectangle(40,247,253,273,1);*/
        
        
        draw_set_halign(fa_left);
        
        
        draw_set_color(0);
        draw_set_font(fnt_40k_14b);
        draw_text(37,413,"Select Fleet Combat");
        
        draw_set_color(CM_GREEN_COLOR);
        draw_set_font(fnt_40k_14b);
        draw_text(37.5,413.5,"Select Fleet Combat");
        
        var i,x3,y3;i=0;
        // x3=46;y3=252;
        x3=49;y3=441;
        
        repeat(7){i+=1;
            if (en_fleet[i]>0){
                // draw_sprite_ext(spr_force_icon,en_fleet[i],x3,y3,0.5,0.5,0,c_white,1);
                scr_image("ui/force",en_fleet[i],x3-16,y3-16,32,32);
                x3+=64;
            }
        }
        
        
    }
}

pop_draw_return_values();

/* */


/*  */
