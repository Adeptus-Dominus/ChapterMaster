var __b__;
__b__ = action_if_number(obj_drop_select, 0, 0);
if __b__
{
__b__ = action_if_number(obj_bomb_select, 0, 0);
if __b__
{

if (obj_controller.diplomacy>0) then exit;


draw_set_color(38144);

draw_set_font(fnt_40k_14b);
draw_set_halign(fa_center);

var ppp="";
switch(owner){
    case eFACTION.Player:
        ppp=global.chapter_name;
        break;
    case eFACTION.Imperium:
        ppp="Imperial Navy";
        break;
    case eFACTION.Mechanicus:
        pppp="Mechanicus Fleet";
        break;
    case eFACTION.Tau:
        ppp="Tau Fleet";
        break;                

}
// 
var scale = obj_controller.zoomed ? 3.5 : 1;
if (obj_controller.zoomed=0) then draw_text_transformed(x,y-32,ppp,scale,scale,0);

draw_set_halign(fa_left);


// Order here
player_fleet = instance_nearest(x,y,obj_p_fleet).id;
currently_entered = selection_window.currently_entered;
if (player_fleet.just_left){
    var cancel_button = draw_unit_buttons([player_fleet.x+20, player_fleet.y-10], "X",[1,1], c_red,, fnt_40k_30b, 1);

    if (scr_hit(cancel_button)){
        currently_entered = true;
    }

    if (point_and_click(cancel_button)){
        show_debug_message("cancel fleet")
        with (player_fleet){
            cancel_fleet_movement();
        }
    }
}

if (owner  == eFACTION.Player) and (player_fleet.action==""){
    var xx = __view_get( e__VW.XView, 0 );
    var yy = __view_get( e__VW.YView, 0 );
    var free =  !(currently_entered);
    
    if (free=1){

        var sys_dist=9999,connected=0;
        
        with(obj_star){
            if (p_type[1]="Craftworld" && obj_controller.known[eFACTION.Eldar]=0) then instance_deactivate_object(id);
        }

        var sys=instance_nearest(mouse_x,mouse_y,obj_star);
        sys_dist=point_distance(mouse_x,mouse_y,sys.x,sys.y);
        act_dist=point_distance(x,y,sys.x,sys.y);
        
        var mine=instance_nearest(x,y,obj_star);
        connected = determine_warp_join(mine, sys);
        
        var web=0;
        
        if (sys_dist<32){
            web = (system_feature_bool(mine.p_feature,P_features.Webway) && system_feature_bool(sys.p_feature,P_features.Webway));
            if (mine.id=sys.id) then web=0;
        }
        
        
        if (sys_dist<32) and (sys.id!=mine.id){
             
            var selection_travel_speed = calculate_action_speed(player_fleet,true);
            player_fleet.action_spd = selection_travel_speed;
            if (is_array(star_travel)){
                star_travel = new FastestRouteAlgorithm(mine.x,mine.y,sys.x,sys.y, player_fleet);
            }else if (sys.id != star_travel.final_route_info[0]){
                star_travel = new FastestRouteAlgorithm(mine.x,mine.y,sys.x,sys.y, player_fleet);
            }
            star_travel.draw_route();
            draw_set_color(c_white);
            draw_set_alpha(1);            
            if (web!=0) then draw_set_color(c_orange);
            if (sys.storm>0) or (instance_nearest(x,y,obj_star).storm>0) then draw_set_color(c_red);
    
            
            draw_line_dashed(x,y,sys.x,sys.y,16,scale);
            
            draw_set_font(fnt_40k_14b);
            var eta=0;       

            eta = calculate_fleet_eta(mine.x,mine.y,sys.x,sys.y, selection_travel_speed, ,,player_fleet.warp_able);

            if (sys.storm>0) or (instance_nearest(x,y,obj_star).storm>0) then eta="N/A";
            
            draw_set_font(fnt_40k_14b);
            eta = "ETA "+string(eta) + "#Press SHIFT to ignore way points";
            var speed_string = "";
            var viable=true;
            var types = [0,0,0];
            with (player_fleet){
                types = selected_ship_types();
            }
            if (!types[0]){
                speed_string = "#Speed bonus *1.25 frigates and smaller";
                if (!types[1]){
                    speed_string = "#Speed bonus *1.75 Escort fleet"
                    if (!types[2]){
                        speed_string = "#No Ships Selected"
                        viable=false;
                    }                     
                } 
            }
            eta+=speed_string;      

            draw_text_transformed(sys.x+17,sys.y,string_hash_to_newline(eta),scale,scale,0);
            if (mouse_check_button(mb_right) && viable){
                var ship_count = player_fleet_ship_count(player_fleet);
                var fleet_selected = player_fleet_selected_count(player_fleet);
                var move_fleet;
                if (ship_count && fleet_selected){
                    if (ship_count== fleet_selected){
                        move_fleet = player_fleet;
                    } else {
                        move_fleet = split_selected_into_new_fleet(player_fleet);
                    }
                    if (keyboard_check(vk_shift)){
                        final_course = [sys.name];
                    } else {
                        var final_course = star_travel.final_array_path();
                    }
                    with (move_fleet){
                        set_new_player_fleet_course(final_course);
                    }
                }
                instance_destroy();
            }
        }
        instance_activate_object(obj_star);
    }
}
if (!currently_entered){
    currently_entered =  keyboard_check(vk_shift);
}
if (mouse_check_button_pressed(mb_left) ){
    if (!currently_entered && point_distance(mouse_x,mouse_y,player_fleet.x,player_fleet.y)>32 && !keyboard_check(vk_shift)){
        instance_destroy();
    }
}

/* */
}
}
/*  */
