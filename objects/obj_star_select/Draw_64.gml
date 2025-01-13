var __b__;
__b__ = action_if_number(obj_bomb_select, 0, 0);
if __b__
{
__b__ = action_if_number(obj_drop_select, 0, 0);
if __b__
{
__b__ = action_if_number(obj_popup, 0, 0);
if __b__
{

if (obj_controller.zoomed=1) then exit;
if (!instance_exists(target)) then exit;
if (obj_controller.menu=60) then exit;

draw_set_font(fnt_40k_14b);
draw_set_halign(fa_center);
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
        if (target.space_hulk=1) then exit;
    }
}
if (obj_controller.selecting_planet>target.planets){
    obj_controller.selecting_planet = 0;
}
var click_accepted = (!obj_controller.menu) and (!obj_controller.zoomed) and (!instance_exists(obj_bomb_select)) and (!instance_exists(obj_drop_select));
if (click_accepted) {
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
                if (scr_hit(
                    main_data_slate.XX-4,
                    main_data_slate.YY,
                    main_data_slate.XX+main_data_slate.width,
                    main_data_slate.YY + main_data_slate.height,
                )){
                    closes=false;
                }
                if (scr_hit(
                    garrison_data_slate.XX-4,
                    165,
                    garrison_data_slate.YY+garrison_data_slate.width,
                    165 + garrison_data_slate.height,
                )){
                    closes=false
                    if (is_struct(garrison)){
                        closes=false
                    }  
                    if (population){
                        closes=false
                    }
                }

                if (!is_string(feature)){
                    if (scr_hit(
                        feature.main_slate.XX,
                        feature.main_slate.YY,
                        feature.main_slate.XX+feature.main_slate.width,
                        feature.main_slate.YY+feature.main_slate.height
                        )){
                        closes=false;
                    }
                }
            }
            var shutter_button;
            var shutters = [shutter_1, shutter_2, shutter_3, shutter_4];
            for (var i=0; i<4;i++){
                shutter_button = shutters[i];
                if (scr_hit(shutter_button.XX,shutter_button.YY,shutter_button.XX+shutter_button.width,shutter_button.YY+shutter_button.height)){
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

var system_string = target.name+" System"
if (target.owner!=1) then draw_set_color(0);
if (target.owner  = eFACTION.Player) then draw_set_color(c_blue);
if (target.craftworld=0) and (target.space_hulk=0){
    draw_text_transformed(184,180,system_string,1,1,0);
}

if (target.craftworld=0) and (target.space_hulk=0){
    draw_set_color(global.star_name_colors[target.owner]);
    draw_text_transformed(184,180,system_string,1,1,0);
}


if (global.cheat_debug && obj_controller.selecting_planet && !loading)
    {
        draw_set_color(c_gray);
        var rect = [(( 184) - 123), ( 200), (( 184) + 123), ( 226)];
        draw_rectangle(rect[0],rect[1],rect[2],rect[3], false);
        draw_set_color(c_black);
        draw_text(( 184), ( 204), "Debug");
        draw_set_color(c_white);
        draw_set_alpha(0.2);
        if (point_and_click(rect)){
            debug = true;
        }
        if (scr_hit(rect)){
            draw_rectangle((( 184) - 123), ( 200), (( 184) + 123), ( 226), false);
        }
    }



if (loading!=0){
    draw_set_font(fnt_40k_14);
    draw_set_color(38144);
    draw_text(184,202,
    string_hash_to_newline("Select Destination"));
}


//the draw and click on planets logic
planet_selection_action();
draw_set_font(fnt_40k_14b);

if (obj_controller.selecting_planet!=0){
// Buttons that are available
    if (!buttons_selected){
        var is_enemy=false;
        if (obj_controller.selecting_planet>0){
            if (target.present_fleet[1]=0)/* and (target.p_type[obj_controller.selecting_planet]!="Dead")*/{
                if (target.p_owner[obj_controller.selecting_planet]>5) then is_enemy=true;
                if (obj_controller.faction_status[target.p_owner[obj_controller.selecting_planet]]="War") then is_enemy=true;
                
                if (target.p_player[obj_controller.selecting_planet]>0){
                    if (is_enemy){
                        button1="Attack";
                        button2="Purge";
                    }
                }
            }
            if (target.present_fleet[1]>0)/* and (target.p_type[obj_controller.selecting_planet]!="Dead")*/{
                if (target.p_owner[obj_controller.selecting_planet]>5) then is_enemy=true;
                if (obj_controller.faction_status[target.p_owner[obj_controller.selecting_planet]]="War") then is_enemy=true;
                
                if (is_enemy){
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
        if (((target.p_type[obj_controller.selecting_planet]=="Dead") or (array_length(target.p_upgrades[obj_controller.selecting_planet])>0)) and ((target.present_fleet[1]>0) or (target.p_player[obj_controller.selecting_planet]>0))){
            if (array_length(target.p_feature[obj_controller.selecting_planet])==0) or (array_length(planet_upgrades)>0){
                var chock=1;
                if ((target.p_orks[obj_controller.selecting_planet]>0) or
                    (target.p_chaos[obj_controller.selecting_planet]>0) or
                    (target.p_tyranids[obj_controller.selecting_planet]>0) or
                    (target.p_necrons[obj_controller.selecting_planet]>0) or
                    (target.p_tau[obj_controller.selecting_planet]>0) or
                    (target.p_demons[obj_controller.selecting_planet]>0)){chock=0;}
                if (chock==1){
                    if (planet_feature_bool(planet_upgrades, P_features.Secret_Base)==1){
                        button1="Base";
                    }else if (planet_feature_bool(planet_upgrades, P_features.Arsenal)==1){
                        button1="Arsenal"; 
                    }else if (planet_feature_bool(planet_upgrades, P_features.Gene_Vault)==1){
                        button1="Gene-Vault";
                    }else if (array_length(target.p_upgrades[obj_controller.selecting_planet])==0){
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
        
        if (obj_controller.recruiting_worlds_bought>0) and (target.p_owner[obj_controller.selecting_planet]<=5) and (obj_controller.faction_status[target.p_owner[obj_controller.selecting_planet]]!="War"){
            if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet], P_features.Recruiting_World)==0) and (target.p_type[obj_controller.selecting_planet]!="Dead") and (target.space_hulk=0){
                button4="+Recruiting";
            }
        }
        if (target.space_hulk=1){
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
        improve=0
        var xx=15;
        var yy=25;
        var current_planet=obj_controller.selecting_planet;
        var planet_data = new PlanetData(current_planet, target);
        var nm=scr_roman(current_planet), temp1=0;
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14);
        
        var xenos_and_heretics = planet_data.xenos_and_heretics();
        var planet_forces = planet_data.planet_forces;
        if (planet_data.current_owner<=5) and (!xenos_and_heretics){
            if (planet_forces[eFACTION.Player]>0) or (target.present_fleet[1]>0){
                if (planet_data.fortification_level<5) then improve=1;
            }
        }
        
        // Draw disposition here
        var yyy=0;

        var succession = (has_problem_planet(current_planet, "succession",target));

        if ((target.dispo[current_planet]>=0) and (target.p_owner[current_planet]<=5) and (target.p_population[current_planet]>0)) and (succession=0){
            var wack=0;
            draw_set_color(c_blue);
            draw_rectangle(xx+349,yy+175,xx+349+(min(100,target.dispo[current_planet])*3.68),yy+192,0);
        }
        draw_set_color(c_gray);
        draw_rectangle(xx+349,yy+175,xx+717,yy+192,1);
        draw_set_color(c_white);
        
        var player_dispo = planet_data.player_disposition;
        if (!succession){
            if (player_dispo>=0) and (target.p_first[current_planet]<=5) and (target.p_owner[current_planet]<=5) and (target.p_population[current_planet]>0) then draw_text(xx+534,yy+176,string_hash_to_newline("Disposition: "+string(min(100,player_dispo))+"/100"));
            if (player_dispo>-30) and (player_dispo<0) and (planet_data.current_owner<=5) and (planet_data.population>0){
                draw_text(xx+534,yy+176,"Disposition: ???/100");
            }
            if ((player_dispo>=0) and (planet_data.origional_owner<=5) and (target.p_owner[current_planet]>5)) or (target.p_population[current_planet]<=0){
                draw_text(xx+534,yy+176,"-------------");
            }

            if (player_dispo<=-3000) then draw_text(xx+534,yy+176,"Disposition: N/A");
        } else  if (succession=1) then draw_text(xx+534,yy+176,"War of Succession");
        draw_set_color(c_gray);
        // End draw disposition
        draw_set_color(c_gray);
        draw_rectangle(xx+349,yy+193,xx+717,yy+210,0);
        var bar_width = 717-349;
        var bar_start_point = xx+349;
        var bar_percent_length = (bar_width/100);
        var current_bar_percent = 0;
        var hidden_cult = false;
        if (planet_data.has_feature(P_features.Gene_Stealer_Cult)){
            hidden_cult = planet_data.get_features(P_features.Gene_Stealer_Cult)[0].hiding;
        }          
        with (target){          
            for (var i=1;i<13;i++){
                if (p_influence[current_planet][i]>0){
                    draw_set_color(global.star_name_colors[i]);
                    if (hidden_cult){
                        draw_set_color(global.star_name_colors[eFACTION.Imperium]);
                    }
                    var current_start = bar_start_point+(current_bar_percent*bar_percent_length)
                    draw_rectangle(current_start,yy+193,current_start+(bar_percent_length*p_influence[current_planet][i]),yy+210,0);
                    current_bar_percent+=p_influence[current_planet][i];
                }
                draw_set_color(c_gray);
            }
        }
        draw_set_color(c_white);   
        draw_text(xx+534,yy+194,"Population Influence");
        yy+=20;
        draw_set_font(fnt_40k_14b);draw_set_halign(fa_left);
        if (target.craftworld=0) and (target.space_hulk=0) then draw_text(xx+480,yy+196,$"{target.name} {nm}  ({target.p_type[current_planet]})");
        if (target.craftworld=1) then draw_text(xx+480,yy+196,string(target.name)+" (Craftworld)");
        // if (target.craftworld=0) and (target.space_hulk=0) then draw_text(xx+534,yy+214,string(target.p_type[current_planet])+" World");
        // if (target.craftworld=1) then draw_text(xx+594,yy+214,"Craftworld");
        if (target.space_hulk=1) then draw_text(xx+480,yy+196,string_hash_to_newline("Space Hulk"));
        
        var planet_type = target.p_type[current_planet];
        // draw_sprite(spr_planet_splash,temp1,xx+349,yy+194);
        scr_image("ui/planet",scr_planet_image_numbers(planet_type),xx+349,yy+194,128,128);
        draw_rectangle(xx+349,yy+194,xx+477,yy+322,1);
        draw_set_font(fnt_40k_14);
        
        
        if (!target.p_large[current_planet]){
            var temp2=string(scr_display_number(target.p_population[current_planet]));
            var pop_string = $"Population: {temp2}";
        }
        else if (target.p_large[current_planet]){
            var pop_string = $"Population: {target.p_population[current_planet]} billion"
        }

        button_manager.update({
            label:pop_string,
            tooltip : "population data toggle with 'P'",
            keystroke : press_exclusive(ord("P")),
            x1 : xx+480,
            y1 : yy+217,
            w : 200,
            h : 22
        })
        button_manager.update_loc();
        if (button_manager.draw()){
            population = !population;
            if (population){
                potential_doners = find_population_doners(target.id);
            }
        }
        
        if (target.craftworld=0) and (target.space_hulk=0){
            var y7=240,temp3=string(scr_display_number(target.p_guardsmen[current_planet]));
            if (target.p_guardsmen[current_planet]>0){
                draw_text(xx+480,yy+y7,$"Imperial Guard: {temp3}");
                y7+=20;
            }
            if (target.p_owner[current_planet]!=8){
                var temp4=string(scr_display_number(target.p_pdf[current_planet]));
                draw_text(xx+480,yy+y7,$"Defense Force: {temp4}");
            }
            if (target.p_owner[current_planet]=8){
                var temp4=string(scr_display_number(target.p_pdf[current_planet]));
                draw_text(xx+480,yy+y7,$"Gue'Vesa Force:  {temp4}");
            }
        }
        
        var temp5="";
        
        
        if (target.space_hulk=0){
            if (improve=1){
                draw_set_color(c_green);
                draw_rectangle(xx+481,yy+280,xx+716,yy+298,0);
                draw_sprite(spr_requisition,0,xx+657,yy+283);
                
                
                var improve_cost=1500,yep=0,o=0;

                if (scr_has_adv("Siege Masters")) then improve_cost=1100;
                
                draw_text_glow(xx+671, yy+281,string(improve_cost),16291875,0);
                
                if (scr_hit(xx+481,yy+282,xx+716,yy+300)){
                    draw_set_color(0);
                    draw_set_alpha(0.2);
                    draw_rectangle(xx+481,yy+280,xx+716,yy+298,0);
                    if (scr_click_left()) and (obj_controller.requisition>=improve_cost){
                        obj_controller.requisition-=improve_cost;
                        target.p_fortified[current_planet]+=1;
                        
                        if (target.dispo[current_planet]>0) and (target.dispo[current_planet]<=100){
                            target.dispo[current_planet]=min(100,target.dispo[current_planet]+(9-target.p_fortified[current_planet]));
                        }
                    }
                    
                }
                draw_set_alpha(1);
                draw_set_color(0);
            }
            var forti_string = ["None", "Sparse","Light","Moderate","Heavy","Major","Extreme"];
            var planet_forti = $"Defenses: {forti_string[target.p_fortified[current_planet]]}";

            draw_text(xx+480,yy+280,planet_forti);
        }
        
        draw_set_color(c_gray);
        
        if (target.space_hulk=1){
            temp5="Integrity: "+string(floor(target.p_fortified[current_planet]*20))+"%";
            draw_text(xx+480,yy+280,string_hash_to_newline(string(temp5)));
        }
        
        var temp6="???";
        var tau_influence = target.p_influence[current_planet][eFACTION.Tau];
        var target_planet_heresy=target.p_heresy[current_planet];
        if (max(target_planet_heresy,tau_influence)<=10) then temp6="None";
        if (max(target_planet_heresy,tau_influence)>10) and (max(target_planet_heresy,tau_influence)<=30) then temp6="Little";
        if (max(target_planet_heresy,tau_influence)>30) and (max(target_planet_heresy,tau_influence)<=50) then temp6="Major";
        if (max(target_planet_heresy,tau_influence)>50) and (max(target_planet_heresy,tau_influence)<=70) then temp6="Heavy";
        if (max(target_planet_heresy,tau_influence)>70) and (max(target_planet_heresy,tau_influence)<=96) then temp6="Extreme";
        if (target_planet_heresy>=96) or (tau_influence>=96) then temp6="Maximum";
        draw_text(xx+480,yy+300,$"Corruption: {temp6}");
        
        
        draw_set_font(fnt_40k_14b);
        draw_text(xx+349,yy+326,string_hash_to_newline("Planet Forces"));
        draw_text(xx+535,yy+326,string_hash_to_newline("Planet Features"));
        draw_set_font(fnt_40k_14);
        
        
        var temp8="",t=-1;
        repeat(8){
            var ahuh,ahuh2,ahuh3;ahuh="";ahuh2=0;ahuh3=0;t+=1;
            with (target){
                if (t=0){ahuh="Adepta Sororitas: ";ahuh2=p_sisters[current_planet];}
                if (t=1){ahuh="Ork Presence: ";ahuh2=p_orks[current_planet];}
                if (t=2){ahuh="Tau Presence: ";ahuh2=p_tau[current_planet];}
                if (t=3){ahuh="Tyranid Presence: ";ahuh2=p_tyranids[current_planet];}
                if (t=4){ahuh="Traitor Presence: ";ahuh2=p_traitors[current_planet];if (ahuh2>6) then ahuh="Daemon Presence: ";}
                if (t=5){ahuh="CSM Presence: ";ahuh2=p_chaos[current_planet];}
                if (t=6){ahuh="Daemon Presence: ";ahuh2=p_demons[current_planet];}
                if (t=7){ahuh="Necron Presence: ";ahuh2=p_necrons[current_planet];}
            }
            
            if (t!=0){
                if (ahuh2=1) then ahuh3="Tiny";if (ahuh2=2) then ahuh3="Sparse";
                if (ahuh2=3) then ahuh3="Moderate";if (ahuh2=4) then ahuh3="Heavy";
                if (ahuh2=5) then ahuh3="Extreme";if (ahuh2>=6) then ahuh3="Rampant";
            }
            if (t=0){
                if (ahuh2=1) then ahuh3="Very Few";if (ahuh2=2) then ahuh3="Few";
                if (ahuh2=3) then ahuh3="Moderate";if (ahuh2=4) then ahuh3="Numerous";
                if (ahuh2=5) then ahuh3="Very Numerous";if (ahuh2>=6) then ahuh3="Overwhelming";
            }
            
            if (ahuh!="") and (ahuh2>0) then temp8+=string(ahuh)+" "+string(ahuh3)+"#";
        }
        draw_text(xx+349,yy+346,string_hash_to_newline(string(temp8)));
        
        
        var fit,to_show,temp9;t=-1;to_show=0;temp9="";

        fit =  array_create(11, "");
        var planet_displays = [], i;
        var feat_count, _cur_feature;
        var feat_count = array_length(target.p_feature[current_planet]);
        var upgrade_count = array_length(target.p_upgrades[current_planet]);
        var size = ["", "Small", "", "Large"];
        if ( feat_count > 0){
            for (i =0; i <  feat_count ;i++){
                cur_feature= target.p_feature[current_planet][i]
                if (cur_feature.planet_display != 0){
                    if (cur_feature.f_type == P_features.Gene_Stealer_Cult){
                        if (!cur_feature.hiding){
                            array_push(planet_displays, [cur_feature.planet_display, cur_feature]);
                        }
                    }else if (cur_feature.player_hidden == 1){
                        array_push(planet_displays, ["????", ""] );
                    }else{
                        array_push(planet_displays, [cur_feature.planet_display, cur_feature]);
                    }
                    if (cur_feature.f_type == P_features.Monastery){
                        if (cur_feature.forge>0){
                            var forge = cur_feature.forge_data;
                            var size_string= $"{size[forge.size]} Chapter Forge"
                            array_push(planet_displays, [size_string, forge]);
                        }
                    }                
                }
            }
        }
        if (upgrade_count>0){
            for (i =0; i <  upgrade_count ;i++){
                var _upgrade = target.p_upgrades[current_planet][i];
                if (_upgrade.f_type == P_features.Secret_Base){
                    if (_upgrade.forge>0){
                        var forge = _upgrade.forge_data;
                        var size_string= $"{size[forge.size]} Chapter Forge"
                        array_push(planet_displays, [size_string, forge]);
                    }
                }
            }
        }
        var problems = target.p_problem[current_planet];
        var problems_data = target.p_problem_other_data[current_planet];
        var problem_data;
        for (i=0;i<array_length(problems);i++){
            if (problems[i]=="") then continue;
            problem_data = problems_data[i];
            if (struct_exists(problem_data, "stage")){
                if (problem_data.stage == "preliminary"){
                    var mission_string  = $"{problem_data.applicant} Audience";
                    problem_data.f_type = P_features.Mission;
                    problem_data.time = target.p_timer[current_planet][i];
                    problem_data.problem = problems[i];
                    problem_data.array_position = i;
                    array_push(planet_displays, [mission_string, problem_data]);
                }
            }
        }

        t=0;
        var button_size, y_move=0, button_colour;
        for (i=0; i< array_length(planet_displays); i++){
            button_colour = c_green;
            if (planet_displays[i][0] == "????") then button_colour = c_red;
            button_size = draw_unit_buttons([xx+535,yy+346+y_move], planet_displays[i][0],[1,1], button_colour,, fnt_40k_14b, 1);
            y_move += button_size[3]-button_size[1];
            if (point_and_click(button_size)){
                if (planet_displays[i][0] != "????"){
                    feature = new FeatureSelected(planet_displays[i][1], target, current_planet);
                } else {
                    feature = "";
                }
            }
        }
        if (obj_controller.selecting_planet>0){
            var current_planet=obj_controller.selecting_planet;
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            
            /*if (obj_controller.recruiting_worlds_bought>0) and (target.p_owner[obj_controller.selecting_planet]<=5) and (obj_controller.faction_status[target.p_owner[obj_controller.selecting_planet]]!="War"){
                if (string_count("Recr",target.p_feature[obj_controller.selecting_planet])=0){
                    button4="+Recruiting";
                }
            }*/
            
            /*if (target.p_first[current_planet]=1){
                if (mouse_x>=xx+363) and (mouse_y>=yy+194) and (mouse_x<xx+502) and (mouse_y<yy+204){
                    if (string_count("Monastery",target.p_feature[current_planet])>0){
                        var wid,hei,tex;draw_set_halign(fa_left);
                        tex=string(target.p_lasers[current_planet])+" Defense Laser, "+string(target.p_defenses[current_planet])+" Weapon Emplacements, "+string(target.p_silo[current_planet])+" Missile Silo";
                        hei=string_height_ext(tex,-1,200)+4;wid=string_width_ext(tex,-1,200)+4;
                        draw_set_color(c_black);
                        draw_rectangle(xx+363,yy+210,xx+363+wid,yy+210+hei,0);
                        draw_set_color(38144);
                        draw_rectangle(xx+363,yy+210,xx+363+wid,yy+210+hei,1);
                        draw_text_ext(xx+365,yy+212,tex,-1,200);
                    }
                }
            }*/
        }
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
                exit;
            }
        }
    }else if (garrison!="" && !population){
        if (garrison.garrison_force ){
            draw_set_font(fnt_40k_14);
            if (!garrison.garrison_leader){
                garrison.find_leader()
                garrison.garrison_disposition_change(target, obj_controller.selecting_planet, true);
                garrison_data_slate.sub_title = $"Garrison Leader {garrison.garrison_leader.name_role()}"
                garrison_data_slate.body_text = garrison.garrison_report();
            }
            garrison_data_slate.inside_method=function(){
                garrison_data_slate.title = "Garrison Report"
                draw_set_color(c_gray);
                var xx = garrison_data_slate.XX;
                var yy = garrison_data_slate.YY;
                var cur_planet = obj_controller.selecting_planet;
                var half_way =  yy+garrison_data_slate.height/2;
                draw_set_halign(fa_left);
                draw_line(xx+10, half_way, garrison_data_slate.width-10, half_way);
                var defence_data  = determine_pdf_defence(target.p_pdf[cur_planet], garrison,target.p_fortified[cur_planet]);
                var defence_string = $"Planetary Defence : {defence_data[0]}";
                draw_text(xx+20, half_way, defence_string);
                if (scr_hit(xx+20, half_way+10, xx+20+string_width(defence_string), half_way+10+20)){
                    tooltip_draw(defence_data[1], 400);
                }
                if (garrison.dispo_change!="none"){
                    if (garrison.dispo_change>55){
                        draw_text(xx+20, half_way+30, $"Garrison Disposition Effect : Positive");
                    } else if (garrison.dispo_change>44){
                        draw_text(xx+20, half_way+30, $"Garrison Disposition Effect : Neutral");
                    } else{ 
                        draw_text(xx+20, half_way+30, $"Garrison Disposition Effect : Negative");
                    }
                }
            }
            garrison_data_slate.draw(340+main_data_slate.width, 160, 0.6, 0.6);

        } 
    } else if (population){
        garrison_data_slate.title = "Population Report";
        garrison_data_slate.inside_method = function(){
            var xx = garrison_data_slate.XX;
            var yy = garrison_data_slate.YY;                
            var cur_planet = obj_controller.selecting_planet;
            var half_way =  garrison_data_slate.height/2;
            draw_set_halign(fa_left);
            var doner_length = array_length(potential_doners);
            if (doner_length){
                //TODO swap this out for an object button with a bound tooltip option
                var colonist_coords = draw_unit_buttons([xx+20, half_way], "Request Colonists");
                if (scr_hit(colonist_coords)){
                    tooltip_draw("Planets with higher populations can provide more recruits both for your chapter and to keep a planets PDF bolstered, however colonists from other planets bring with them their home planets influences and evils /n REQ : 1000");
                    if (point_and_click(colonist_coords)){
                        var doners = potential_doners[irandom(doner_length-1)];
                        new_colony_fleet(potential_doners[0][0],potential_doners[0][1],target.id,cur_planet,"bolster_population");
                        obj_controller.requisition -= 1000;
                    }
                }
            }
            //draw_text(20, half_way, defence_string);
        }
        garrison_data_slate.draw(344+main_data_slate.width-4, 160, 0.6, 0.6);          
    }   
    if (obj_controller.selecting_planet>0){
        main_data_slate.draw(344,160, slate_draw_scale, slate_draw_scale+0.1);
    }
    var current_button="";
    var shutter_x = main_data_slate.XX-165;
    var shutter_y = 296+165;
    if (shutter_1.draw_shutter(shutter_x, shutter_y, button1, 0.5, true)) then current_button=button1;
    if (shutter_2.draw_shutter(shutter_x, shutter_y+47, button2,0.5, true))then current_button=button2;
    if (shutter_3.draw_shutter(shutter_x, shutter_y+(47*2), button3,0.5, true))then current_button=button3;
    if (shutter_4.draw_shutter(shutter_x, shutter_y+(47*3), button4,0.5, true))then current_button=button4;
    if (current_button!=""){
        if (array_contains(["Build","Base","Arsenal","Gene-Vault"],current_button)){
            var building=instance_create(x,y,obj_temp_build);
            building.target=target;
            building.planet=obj_controller.selecting_planet;
            if (planet_feature_bool(target.p_upgrades[obj_controller.selecting_planet], P_features.Secret_Base)) then building.lair=1;
            if (planet_feature_bool(target.p_upgrades[obj_controller.selecting_planet], P_features.Arsenal)) then building.arsenal=1;
            if (planet_feature_bool(target.p_upgrades[obj_controller.selecting_planet], P_features.Gene_Vault)) then building.gene_vault=1;
            obj_controller.temp[104]=string(scr_master_loc());
            obj_controller.menu=60;
            with(obj_star_select){instance_destroy();}
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
                if (instance_nearest(x,y,obj_p_fleet).acted>0) then with(obj_bomb_select){instance_destroy();}
            }
        }else if (current_button=="+Recruiting"){
            if (obj_controller.recruiting_worlds_bought>0) and (target.p_owner[obj_controller.selecting_planet]<=5) and (obj_controller.faction_status[target.p_owner[obj_controller.selecting_planet]]!="War"){
                if (planet_feature_bool(target.p_feature[obj_controller.selecting_planet],P_features.Recruiting_World)==0){
                    obj_controller.recruiting_worlds_bought-=1;
                    array_push(target.p_feature[obj_controller.selecting_planet] ,new NewPlanetFeature(P_features.Recruiting_World))
                    
                    if (obj_controller.selecting_planet){
                         obj_controller.recruiting_worlds+=planet_numeral_name(obj_controller.selecting_planet,target);
                    }
                    obj_controller.income_recruiting=(obj_controller.recruiting*-2)*string_count("|",obj_controller.recruiting_worlds);
                    if (obj_controller.recruiting_worlds_bought=0){
                        if (button1=="+Recruiting") then button1="";
                        if (button2=="+Recruiting") then button2="";
                        if (button3=="+Recruiting") then button3="";
                        if (button4=="+Recruiting") then button4="";
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
        
        /*draw_set_color(38144);draw_rectangle(40,247,253,273,1);*/
        
        
        draw_set_halign(fa_left);
        
        
        draw_set_color(0);
        draw_set_font(fnt_40k_14b);
        draw_text(37,413,"Select Fleet Combat");
        
        draw_set_color(38144);
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






if (debug){
    var current_planet;
    
    if (!scr_hit([36,174,337,455]) && scr_click_left()) {
        debug=0;
        exit;
    }

    current_planet = obj_controller.selecting_planet;

    draw_set_color(c_black);
    draw_rectangle(36, 174, 337, 455, 0);
    draw_set_font(fnt_40k_14b);
    draw_set_color(c_gray);
    draw_set_halign(fa_left);

    draw_text(38, 176, ("Orks: " + string(target.p_orks[current_planet])));
    draw_text(38, 196, ("Tau: " + string(target.p_tau[current_planet])));
    draw_text(38, 216, ("Tyranids: " + string(target.p_tyranids[current_planet])));
    draw_text(38, 236, ("Traitors: " + string(target.p_traitors[current_planet])));
    draw_text(38, 256, ("CSM: " + string(target.p_chaos[current_planet])));
    draw_text(38, 276, ("Daemons: " + string(target.p_demons[current_planet])));
    draw_text(38, 296, ("Necrons: " + string(target.p_necrons[current_planet])));
    draw_text(38, 316, ("Sisters: " + string(target.p_sisters[current_planet])));

    draw_text(147, 176, string_hash_to_newline("[-] [+]"));
    draw_text(147, 196, string_hash_to_newline("[-] [+]"));
    draw_text(147, 216, string_hash_to_newline("[-] [+]"));
    draw_text(147, 236, string_hash_to_newline("[-] [+]"));
    draw_text(147, 256, string_hash_to_newline("[-] [+]"));
    draw_text(147, 276, string_hash_to_newline("[-] [+]"));
    draw_text(147, 296, string_hash_to_newline("[-] [+]"));
    draw_text(147, 316, string_hash_to_newline("[-] [+]"));

    if (point_and_click([147, 176, 167, 196])) {
        target.p_orks[current_planet] = clamp(target.p_orks[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 196, 167, 216])) {
        target.p_tau[current_planet] = clamp(target.p_tau[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 216, 167, 236])) {
        target.p_tyranids[current_planet] = clamp(target.p_tyranids[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 236, 167, 256])) {
        target.p_traitors[current_planet] = clamp(target.p_traitors[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 256, 167, 276])) {
        target.p_chaos[current_planet] = clamp(target.p_chaos[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 276, 167, 296])) {
        target.p_demons[current_planet] = clamp(target.p_demons[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 296, 167, 316])) {
        target.p_necrons[current_planet] = clamp(target.p_necrons[current_planet] - 1, 0, 6);
    } else if (point_and_click([147, 316, 167, 336])) {
        target.p_sisters[current_planet] = clamp(target.p_sisters[current_planet] - 1, 0, 6);
    }
    
    else if (point_and_click([177, 176, 197, 196])) {
        target.p_orks[current_planet] = clamp(target.p_orks[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 196, 197, 216])) {
        target.p_tau[current_planet] = clamp(target.p_tau[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 216, 197, 236])) {
        target.p_tyranids[current_planet] = clamp(target.p_tyranids[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 236, 197, 256])) {
        target.p_traitors[current_planet] = clamp(target.p_traitors[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 256, 197, 276])) {
        target.p_chaos[current_planet] = clamp(target.p_chaos[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 276, 197, 296])) {
        target.p_demons[current_planet] = clamp(target.p_demons[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 296, 197, 316])) {
        target.p_necrons[current_planet] = clamp(target.p_necrons[current_planet] + 1, 0, 6);
    } else if (point_and_click([177, 316, 197, 336])) {
        target.p_sisters[current_planet] = clamp(target.p_sisters[current_planet] + 1, 0, 6);
    }

}

/* */
}
}
}


/*  */