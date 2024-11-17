// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function drop_down_sandwich(selection, draw_x, draw_y, options, open_marker,left_text,right_text){
	draw_text_transformed(draw_x, draw_y, left_text,1,1,0);
	draw_x += string_width(left_text)+5;
	var results = drop_down(selection, draw_x, draw_y-2, options,open_marker);
    draw_set_color(c_gray);
	draw_text_transformed(draw_x+9+ string_width(selection), draw_y, right_text,1,1,0);
    return results;
}

function set_up_armentarium(){
        static xx=__view_get( e__VW.XView, 0 );
        static yy=__view_get( e__VW.YView, 0 );    
        menu=14;
        onceh=1;
        cooldown=8000;
        click=1;
        temp[36]=scr_role_count(obj_ini.role[100][16],"");
        temp[37]=temp[36]+scr_role_count(string(obj_ini.role[100][16])+" Aspirant","");
        calculate_research_points();
        in_forge=false
        forge_button = new ShutterButton();
        stc_flashes = new GlowDot();
        /*for (var i =0;i<3;i++){
            for (var f =0;f<7;f++){
                stc_flashes[i][f] = new GlowDot();
               // stc_flashes[i][f].flash_size
            }
        }*/
        speeding_bits = [
            new SpeedingDot(0, 0,(210/6)*stc_wargear),
            new SpeedingDot(0, 0,(210/6)*stc_vehicles),
            new SpeedingDot(0, 0,(210/6)*stc_ships)
        ]        
}

function drop_down(selection, draw_x, draw_y, options,open_marker){
	if (selection!=""){
		draw_unit_buttons([draw_x, draw_y],selection,[1,1],c_green);
		draw_set_color(c_red);
		if (array_length(options)>1){
			if (point_in_rectangle(
				mouse_x,
				mouse_y,
				draw_x, 
				draw_y, 
				draw_x + 5 + string_width(selection), 
				draw_y + 4 + string_height(selection)
			)){
				open_marker = true;
			}
			if (open_marker){
                current_target=true;
				var roll_down_offset=4+string_height(selection);
				for (var col = 0;col<array_length(options);col++){
					if (options[col]==selection) then continue;
					draw_unit_buttons([draw_x , draw_y+roll_down_offset],options[col],[1,1],c_red,,,,true);
					if (mouse_check_button_pressed(mb_left) && 
						point_in_rectangle(
								mouse_x,
								mouse_y,
								draw_x, 
								draw_y+roll_down_offset, 
								draw_x +5 +string_width(options[col]), 
								draw_y+roll_down_offset+string_height(options[col])+4									
							)){
						selection = options[col];
						open_marker = false;
					}
					roll_down_offset += string_height(options[col])+4;

				}
				if (!point_in_rectangle(
						mouse_x,
						mouse_y,
						draw_x,
						draw_y,
						draw_x + 5 +string_width(selection),
						draw_y+roll_down_offset,
					)
				){
					open_marker = false;
                    if (current_target) then current_target=false;
				}
			} else {
                current_target=false;
            }
		}
	}
    return [selection,open_marker];
}

function same_locations(first_loc,second_loc){
    var same_loc = false;
    if (is_array(first_loc)&& is_array(second_loc)){
        if (first_loc[2] != "warp" && first_loc[2] != "lost"){
            if (first_loc[2] == second_loc[2]) then same_loc=true;
        } else {
            if (first_loc[1] == second_loc[1]) &&
                (first_loc[0] == second_loc[0]){
                    same_loc=true;
            }
        }
    }
    return same_loc;
}

function calculate_research_points(turn_end=false){
    with (obj_controller){
        research_points = 0;
        forge_points = 0;
        master_craft_chance = 0;
        if (tech_status == "heretics") then master_craft_chance+=5;
        forge_string = $"Forge Production Rate#";
        var heretics = [], forge_master=-1, notice_heresy=false, forge_point_gen=[], crafters=0, at_forge=0, gen_data={};
        var tech_locations=[]
        var techs = collect_role_group("forge");
        var total_techs = array_length(techs);
        for (var i=0; i<array_length(techs); i++){
            if (techs[i].IsSpecialist("heads")){
                forge_master=i;
            }            
            if (techs[i].in_jail()){
                array_delete(techs, i, 1);
                i--;
                total_techs--;
                continue;
            }
            if (techs[i].technology>40 && techs[i].hp() >0){
                research_points += techs[i].technology-40;
                forge_point_gen=techs[i].forge_point_generation(true);
                gen_data = forge_point_gen[1];
                if (struct_exists(gen_data,"crafter")) then crafters++;
                if (struct_exists(gen_data,"at_forge")){
                    at_forge++;
                    master_craft_chance += (techs[i].experience/50)
                }
                forge_points += forge_point_gen[0];
                if (techs[i].has_trait("tech_heretic")){
                    array_push(heretics, i);
                }
            }
            tech_locations[i] = techs[i].marine_location();
        }
        if (forge_master>-1){
            obj_controller.master_of_forge = techs[forge_master];
        }
        forge_string += $"Techmarines: +{floor(forge_points)}#";
        var forge_veh_maintenance={};
        for (var comp=0;comp<=10;comp++){
            for (var veh=0;veh<=100;veh++){
                if (obj_ini.veh_role[comp][veh]=="Land Raider"){
                    forge_veh_maintenance.land_raider = struct_exists(forge_veh_maintenance, "land_raider") ?forge_veh_maintenance.land_raider + 1 : 1;
                } else if (array_contains(["Rhino","Predator", "Whirlwind"],obj_ini.veh_role[comp][veh])){
                    forge_veh_maintenance.small_vehicles = struct_exists(forge_veh_maintenance, "small_vehicles") ?forge_veh_maintenance.small_vehicles + 0.2 :0.2;
                }
            }
        }

        if (struct_exists(forge_veh_maintenance, "land_raider")){
            forge_string += $"Land Raider Maintenance: -{forge_veh_maintenance.land_raider}#";
            forge_points-=forge_veh_maintenance.land_raider;
        }
        if (struct_exists(forge_veh_maintenance, "small_vehicles")){
            if (floor(forge_veh_maintenance.small_vehicles)>0){
                forge_string += $"Small Vehicle Maintenance: -{floor(forge_veh_maintenance.small_vehicles)}#";
                forge_points-=floor(forge_veh_maintenance.small_vehicles);
            }
        }
        if (player_forge_data.player_forges>0){
            forge_points += 5*player_forge_data.player_forges;
            forge_string += $"Forges: +{5*player_forge_data.player_forges}#";
        }
        forge_points = floor(forge_points);
        var tech_test, charisma_test, piety_test, met_non_heretic, heretics_pursuade_chances, new_pursuasion;
        //in this instance tech heretics are techmarines with the "tech_heretic" trait
        if (turn_end){
            if (array_length(techs)==0) then scr_loyalty("Upset Machine Spirits","+");
            if (array_length(heretics)>0 && turn>75){
                var heretic_location, same_location, current_heretic, current_tech;
                //iterate through tech heretics;
                for (var heretic=0; heretic<array_length(heretics); heretic++){
                    heretic_location = tech_locations[heretics[heretic]];
                    current_heretic = techs[heretics[heretic]];
                    if (current_heretic.in_jail()) then continue;
                    heretics_pursuade_chances = (floor(current_heretic.charisma/5) - 3)
                    //iterate through rest of techs
                    pursuasions =[];
                    met_non_heretic = false;
                    for (var i=0; i<array_length(techs) && heretics_pursuade_chances>0; i++){
                        same_location=false;
                        new_pursuasion = irandom(array_length(techs)-1);
                        //if tech is also heretic skip
                        if (array_contains(heretics,new_pursuasion)) then continue;
                        if (array_contains(pursuasions,new_pursuasion)) then continue;
                        heretics_pursuade_chances--;
                        current_tech = techs[new_pursuasion];

                        // find out if heretic is in same location as techmarine
                        if (same_locations(heretic_location,tech_locations[new_pursuasion])){
                            met_non_heretic=true;
                            //if so do a an opposed technology test of techmarine vs tech  heretic techmarine
                            tech_test = global.character_tester.oppposed_test(current_heretic,current_tech, "technology");


                            if (tech_test[0]==1){
                                // if heretic wins do an opposed charisma test
                                charisma_test =  global.character_tester.oppposed_test(current_heretic,current_tech, "charisma", -15+current_tech.corruption);                           
                                if (charisma_test[0]==1){
                                    // if heretic win tech is corrupted
                                    //tech is corrupted by half the pass margin of the heretic
                                    //this means high charisma heretics will spread corruption more quickly and more often
                                    if (current_heretic.corruption>current_tech.corruption){
                                        current_tech.edit_corruption(min(4,charisma_test[1]));
                                    }

                                    // tech takes a piety test to see if tehy break faith with cult mechanicus and become tech heretic
                                    //piety test is augmented by by the techs corruption with the test becoming harder to pass the more
                                    // corrupted the tech is
                                    piety_test = global.character_tester.standard_test(current_tech, "piety", +75 - current_tech.corruption);

                                    // if tech fails piety test tech also becomes tech heretic
                                    if (piety_test[0] == false && choose(true,false)){
                                        current_tech.add_trait("tech_heretic");
                                    }
                                } else if (charisma_test[0]==2){
                                    if (charisma_test[1] > 40 && notice_heresy=false){
                                        scr_alert("purple","Tech Heresy",$"{current_tech.name_role()} contacts you concerned of Tech Heresy in the Armentarium");
                                        notice_heresy=true;
                                    }
                                }
                            }
                            if (new_pursuasion==forge_master){
                                // if tech is the forge master then forge master takes a wisdom in this case doubling as a perception test
                                // if forge master passes tech heresy is noted and chapter master notified
                                if (global.character_tester.standard_test(current_tech, "wisdom", - 40)[0] && !notice_heresy){
                                    notice_heresy=true;
                                    scr_event_log("purple",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                    scr_alert("purple","Tech Heresy",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                    //pip=instance_create(0,0,obj_popup);
                                }
                            }
                        }
                    }
                    if (!met_non_heretic){
                        if (irandom(4)==0){
                            current_heretic.edit_corruption(1);
                        }
                    }
                    //add check to see if tech heretic is anywhere near mechanicus forge if so maybe do stuff??
                    /*if (heretic_location==location_types.planet){
                        if 
                    }*/
                }
                if (array_length(techs)>array_length(heretics)){
                    if (array_length(heretics)/array_length(techs)>=0.35){
                        if (irandom(9)==0){
                            /*var text_string = "You Recive an Urgent Transmision from";
                            if (forge_master>-1){
    
                            }*/
                            scr_popup("Technical Differences!","You Recive an Urgent Transmision A serious breakdown in culture has coccured causing believers in tech heresy to demand that they are given preseidence and assurance to continue their practises","tech_uprising","");
                        }
                    }
                }
            }
            possibility_of_heresy = 8;
            if (array_contains(obj_ini.dis,"Tech-Heresy")) then possibility_of_heresy = 6;
            if (irandom(power(possibility_of_heresy,(array_length(heretics)+2.2))) == 0 && array_length(techs)>0){
                var current_tech = techs[irandom(array_length(techs)-1)];
               if  (!global.character_tester.standard_test(current_tech, "piety")[0]){
                   current_tech.add_trait("tech_heretic");
                   current_tech.edit_corruption(20+irandom(15));
               }
            }
            if (forge_master==-1){ 
                var tech_count = scr_role_count(obj_ini.role[100][16]);
                if (tech_count>1){
                    var last_master = obj_ini.previous_forge_masters[array_length(obj_ini.previous_forge_masters)-1];
                    scr_popup("New Forge Master",$"The Demise of Forge Master {last_master} means a replacement must be chosen. Several Options have already been put forward to you but it is ultimatly your decision.","new_forge_master","");
                } else if (tech_count==1){
                    scr_role_count(obj_ini.role[100][16],"","units")[0].update_role("Forge Master");
                }
            }
            forge_queue_logic();       
        }
    }   
}
function scr_forge_item(item){
    var master_craft_count=0;
    var quality_string="";
    var normal_count=0;
    for (var s=0;s<item.count;s++){
        if (master_craft_chance && (irandom(100)<master_craft_chance)){
            master_craft_count++;
        } else {
            normal_count++;
        }
    }
    scr_add_item(item.name, normal_count);
    if (master_craft_count>0){
        scr_add_item(item.name, master_craft_count,"master_crafted");
        var numerical_string = master_craft_count==1?"was":"were";
        quality_string=$"X{master_craft_count} {numerical_string} Completed to a Master Crafted standard";
    }else {
        quality_string=$"all were completed to a standard STC compliant quality";
    }
    scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished {quality_string}","","");
}

function scr_advance_research(research){
    if (research.name[0]=="research"){
        var tier_depth = array_length(research.name[2]);
        var tier_names=research.name[2];
        if (tier_depth==1){
            production_research[$ tier_names[0]][0]++;
        } else if (tier_depth==2){
            production_research[$ tier_names[0]][1][$ tier_names[1]][0]++;
        } else if (tier_depth == 3){
            production_research[$ tier_names[0]][1][$ tier_names[1]][1][$ tier_names[2]][0]++;
        }
    }    
}

function scr_evaluate_forge_item_completion(item){
    if (is_string(item.name)){
        var vehicles = ["Rhino","Predator","Land Raider","Whirlwind","Land Speeder"];
        var is_vehicle =  array_contains(vehicles,item.name);
        if (!is_vehicle){
            scr_forge_item(item);
        } else {
            repeat(item.count){
                var vehicle = scr_add_vehicle(item.name,9,"standard","standard","standard","standard","standard");
                var build_loc = array_random_element(player_forge_data.vehicle_hanger);
                obj_ini.veh_loc[vehicle[0]][vehicle[1]] = build_loc[0];
                obj_ini.veh_wid[vehicle[0]][vehicle[1]] = build_loc[1];
                obj_ini.veh_lid[vehicle[0]][vehicle[1]] = 0;
            }
            scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished Vehicles Waiting at hanger on {build_loc[0]} {build_loc[1]}","","");
        }                      
    } else if (is_array(item.name)){
        scr_advance_research(item);
    }
}
function forge_queue_logic(){
    if (forge_points>0){
        var reduction_points = forge_points;
        if (array_length(forge_queue)>0 && forge_points>0){
            var forging_length = array_length(forge_queue);
            for (var i=0;i<forging_length;i++){
                if (forge_queue[i].forge_points<=reduction_points){
                    reduction_points-=forge_queue[i].forge_points;

                    scr_evaluate_forge_item_completion(forge_queue[i]);

                    array_delete(forge_queue, i, 1);
                    i--;
                    forging_length--;
                } else {
                    forge_queue[i].forge_points -= reduction_points;
                    reduction_points=0;
                }
                if (reduction_points<=0) then break;
            }
        }
    } 
}
function research_end(){
    calculate_research_points(true);
    stc_research[$ stc_research.research_focus] += research_points;
    var research_area_limit;
    if (stc_research.research_focus=="vehicles"){
        research_area_limit = stc_vehicles;
    } else if (stc_research.research_focus=="wargear"){
        research_area_limit = stc_wargear;
    }else if (stc_research.research_focus=="ships"){
        research_area_limit = stc_ships;
    }    
    if (stc_research[$ stc_research.research_focus]>5000*(research_area_limit+1)){
       identify_stc(stc_research.research_focus);  
    }
}

function identify_stc(area){
    switch(area){
        case "wargear":
            stc_wargear++;
            if (stc_wargear==2) then stc_bonus[1]=choose(1,2,3,4,5);
            if (stc_wargear==4) then stc_bonus[2]=choose(1,2,3);
            stc_research.wargear=0;
            break;
        case "vehicles":
            stc_vehicles++;
            if (stc_vehicles==2) then stc_bonus[3]=choose(1,2,3,4,5);
            if (stc_vehicles==4) then stc_bonus[4]=choose(1,2,3);
            stc_research.vehicles=0;
            break;
         case "ships":
            stc_ships++;
            if (stc_ships==2) then stc_bonus[5]=choose(1,2,3,4,5);
            if (stc_ships==4) then stc_bonus[6]=choose(1,2,3);
            stc_research.ships=0;
            break;                      
    }
}
function scr_draw_armentarium(){
	    var recruitment_pace = [
        " is currently halted.",
        " is advancing sluggishly.",
        " is advancing slowly.",
        " is advancing moderately fast.",
        " is advancing fast.",
        " is advancing frenetically.",
        " is advancing as fast as possible."
    ];
    var xx = __view_get(e__VW.XView, 0) + 0;
	var yy = __view_get(e__VW.YView, 0) + 0;
	draw_sprite(spr_rock_bg, 0, xx, yy);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
    draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);
    
    if (menu_adept = 0) {
        // draw_sprite(spr_advisors,4,xx+16,yy+43);
        scr_image("advisor", 4, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        var header =  in_forge ? "Forge" : "Armamentarium";
        draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline(header), 1, 1, 0);
        if (!in_forge){
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Forge Master " + string(obj_ini.name[0, 2])), 0.6, 0.6, 0);
        }
    }
    if (menu_adept = 1) {
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        scr_image("advisor", 0, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Armamentarium"), 1, 1, 0);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
    }

    draw_set_font(fnt_40k_30b);
    draw_set_color(c_black);

    draw_set_alpha(0.2);
    if (mouse_y >= yy + 76) and(mouse_y < yy + 104) {
        if (mouse_x >= xx + 957) and(mouse_x < xx + 1062) then draw_rectangle(xx + 957, yy + 76, xx + 1062, yy + 104, 0);
        if (mouse_x >= xx + 1068) and(mouse_x < xx + 1136) then draw_rectangle(xx + 1068, yy + 76, xx + 1136, yy + 104, 0);
        if (mouse_x >= xx + 1167) and(mouse_x < xx + 1255) then draw_rectangle(xx + 1167, yy + 76, xx + 1255, yy + 104, 0);
        if (mouse_x >= xx + 1447) and(mouse_x < xx + 1545) then draw_rectangle(xx + 1487, yy + 76, xx + 1545, yy + 104, 0);
    }
    draw_set_alpha(1);
    draw_set_color(c_gray);


    if (!in_forge){
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_text(xx + 384, yy + 468, string_hash_to_newline(string(stc_wargear_un + stc_vehicles_un + stc_ships_un) + " Unidentified Fragments"));

        draw_set_halign(fa_center);

        // Identify STC
        if (stc_wargear_un + stc_vehicles_un + stc_ships_un = 0) then draw_set_alpha(0.5);
        draw_set_color(c_gray);
        draw_rectangle(xx + 621, yy + 466, xx + 720, yy + 486, 0);
        draw_set_color(0);
        draw_text(xx + 670, yy + 467, string_hash_to_newline("Identify"));
        if (mouse_x > xx + 621) and(mouse_y > yy + 466) and(mouse_x < xx + 720) and(mouse_y < yy + 486) {
            draw_set_color(0);
            draw_set_alpha(0.2);
            draw_rectangle(xx + 621, yy + 466, xx + 720, yy + 486, 0);
            if (mouse_check_button_pressed(mb_left)){
                if (stc_wargear_un + stc_vehicles_un + stc_ships_un > 0){
                        
                    cooldown=8000;
                    audio_play_sound(snd_stc,-500,0)
                    audio_sound_gain(snd_stc,master_volume*effect_volume,0);


                    if (stc_wargear_un > 0 && 
                    stc_wargear < MAX_STC_PER_SUBCATEGORY) {
                            
                        stc_wargear_un--;
                       identify_stc("wargear");
                    }
                    else if (stc_vehicles_un > 0 && 
                    stc_vehicles < MAX_STC_PER_SUBCATEGORY) {
                            
                        stc_vehicles_un--;
                       identify_stc("vehicles");
                    }
                    else if(stc_ships_un > 0 && 
                    stc_ships < MAX_STC_PER_SUBCATEGORY) {
                        
                        stc_ships_un--;
                        identify_stc("ships");
                    }
                    
                    // Refresh the shop
                    instance_create(1000,1000,obj_shop);
                    set_up_armentarium();           
                } 
            }
        }
        draw_set_alpha(1);

        if (stc_wargear_un + stc_vehicles_un + stc_ships_un = 0) then draw_set_alpha(0.5);
        draw_set_color(c_gray);
        draw_rectangle(xx + 733, yy + 466, xx + 790, yy + 486, 0);
        draw_set_color(0);
        draw_text(xx + 761, yy + 467, string_hash_to_newline("Gift"));
        if (mouse_x > xx + 733) and(mouse_y > yy + 466) and(mouse_x < xx + 790) and(mouse_y < yy + 486) {
            draw_set_color(0);
            draw_set_alpha(0.2);
            draw_rectangle(xx + 733, yy + 466, xx + 790, yy + 486, 0);
            if (mouse_check_button_pressed(mb_left)){
                if (stc_wargear_un+stc_vehicles_un+stc_ships_un>0){
                    var chick=0;
                    if (known[eFACTION.Imperium]>1) and (faction_defeated[2]==0) then chick=1;
                    if (known[eFACTION.Mechanicus]>1) and (faction_defeated[3]==0) then chick=1;
                    if (known[eFACTION.Inquisition]>1) and (faction_defeated[4]==0) then chick=1;
                    if (known[eFACTION.Ecclesiarchy]>1) and (faction_defeated[5]==0) then chick=1;
                    if (known[eFACTION.Eldar]>1) and (faction_defeated[6]==0) then chick=1;
                    if (known[eFACTION.Tau]>1) and (faction_defeated[8]==0) then chick=1;
                    if (chick!=0){
                        var pop=instance_create(0,0,obj_popup);
                        pop.type=9.1;
                        cooldown=8000;
                    }
                }
            }
        }
        draw_set_alpha(1);

        draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);

        var max_techs;
        blurp = "";
        max_techs = round((disposition[3] / 2)) + 5;

        var yyy1, yyy;
        yyy1 = max_techs - temp[37];
        if (yyy1 < 0) then yyy1 = yyy1 * -1;
        yyy = (yyy1 * 2);
        if (disposition[3] mod 2 == 0) then yyy += 2;
        else {
            yyy += 1;
        }

        blurp = "Subject ID confirmed.  Rank Identified: Chapter Master.  Salutations Chapter Master.  We have assembled the following Data: ##" + string(obj_ini.role[100, 16]) + "s: " + string(temp[36]) + ".##Summation: ";
        if (max_techs > temp[37]) then blurp += "Our Mechanicus Requisitionary powers are sufficient to train " + string(max_techs - temp[37]) + " additional " + string(obj_ini.role[100, 16]) + ".";
        if (max_techs <= temp[37]) then blurp += "We require " + string(yyy) + " additional Mechanicus Disposition to train one additional " + string(obj_ini.role[100, 16]) + ".";
        blurp += "  The training of new " + string(obj_ini.role[100, 16]) + "s";

        if (menu_adept = 1) {
            blurp = "Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100, 16]) + ".##";
            blurp += "The training of a new " + string(obj_ini.role[100, 16]);
        }
        if (training_techmarine = 0) {
            blurp += recruitment_pace[training_techmarine];
        }
        if (training_techmarine = 1) {
            blurp += recruitment_pace[training_techmarine];
            eta = floor((359 - tech_points) / 1) + 1;
        }
        if (training_techmarine = 2) {
            blurp += recruitment_pace[training_techmarine];
            eta = floor((359 - tech_points) / 2) + 1;
        }
        if (training_techmarine = 3) {
            blurp += recruitment_pace[training_techmarine];
            eta = floor((359 - tech_points) / 4) + 1;
        }
        if (training_techmarine = 4) {
            blurp += recruitment_pace[training_techmarine];
            eta = floor((359 - tech_points) / 6) + 1;
        }
        if (training_techmarine = 5) {
            blurp += recruitment_pace[training_techmarine];
            eta = floor((359 - tech_points) / 10) + 1;
        }
        if (training_techmarine = 6) {
            blurp += recruitment_pace[training_techmarine];
            eta = floor((359 - tech_points) / 14) + 1;
        }

        if (tech_aspirant > 0) and(training_techmarine > 0) and(menu_adept = 1) {
            if (eta = 1) then blurp += "  Your current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " month.";
            if (eta != 1) then blurp += "  Your current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " months.";
        }
        if (tech_aspirant > 0) and(training_techmarine > 0) and(menu_adept = 0) {
            if (eta = 1) then blurp += "  The current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " month.";
            if (eta != 1) then blurp += "  The current " + string(obj_ini.role[100, 16]) + " Aspirant will finish training in " + string(eta) + " months.";
        }
        if (menu_adept = 0) then blurp += "##Data compilation complete.  We currently possess the technology to produce the following:";

        if (menu_adept = 1) {
            if (max_techs > temp[37]) then blurp += "##Mechanicus Requisitionary powers are sufficient to train " + string(max_techs - temp[37]) + " additional " + string(obj_ini.role[100, 16]) + ".";
            if (max_techs <= temp[37]) then blurp += "You require " + string(yyy) + " additional Mechanicus Disposition to train one additional " + string(obj_ini.role[100, 16]) + ".";

            blurp += "##Data compilation complete.  You currently possess the technology to produce the following:";
        }

        draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

		var y_offset = yy + 130 + string_height_ext(string_hash_to_newline(string(blurp)), -1, 536)+10;
        var research_area_limit;
        if (stc_research.research_focus=="vehicles"){
            research_area_limit = stc_vehicles;
        } else if (stc_research.research_focus=="wargear"){
            research_area_limit = stc_wargear;
        }else if (stc_research.research_focus=="ships"){
            research_area_limit = stc_ships;
        }
        var research_progress = ceil(((5000*(research_area_limit+1))-stc_research[$ stc_research.research_focus])/research_points);
		static research_drop_down = false;
        var research_eta_message = $"Based on current progress it will be {research_progress} months until next significant research step is complete";
        draw_text_ext(xx + 336 + 16, y_offset+25, string_hash_to_newline(research_eta_message), -1, 536);        



        var forge_buttons= [xx + 450 + 16, y_offset+40+string_height(research_eta_message), 0, 0]
        if (forge_button.draw_shutter(forge_buttons[0]+60, forge_buttons[1], "Enter Forge", 0.5)){
            in_forge=true;
        }
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text_transformed(xx + 605, yy + 432, string_hash_to_newline("STC Fragments"), 0.75, 0.75, 0);
         draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);       
        var drop_down_results = drop_down_sandwich(
            stc_research.research_focus,
            xx + 336 + 16,
            y_offset,
            ["vehicles","wargear", "ships"],
            research_drop_down,
            "Research is currently focussed on", 
            ".");
        research_drop_down = drop_down_results[1];
        stc_research.research_focus = drop_down_results[0]; 
              
        var hi;
        draw_set_color(38144);
        hi = 0;
        var f, y_loc;
        draw_sprite_ext(spr_research_bar, 0, xx+359, yy+554, 1, 0.7, 0, c_white, 1)
        draw_sprite_ext(spr_research_bar, 0, xx+539, yy+554, 1, 0.7, 0, c_white, 1)
       draw_sprite_ext(spr_research_bar, 0, xx+719, yy+554, 1, 0.7, 0, c_white, 1)

        if (stc_wargear > 0) then speeding_bits[0].draw(xx+359, yy+554);
        for (f =0;f<6;f++){
            if (f>=stc_wargear){
                draw_sprite_ext(spr_research_bar, 1, xx+359, yy+554+((210/6)*f), 1, 0.6, 0, c_white, 1)
            }            
               /* y_loc = yy+560+((210/6)*f);
                if ((speeding_bits[0].current_y()-y_loc)<5 && (speeding_bits[0].current_y()-y_loc)>-5){
                    stc_flashes[0][f].one_flash_finished=false;
                }
                stc_flashes[0][f].draw_one_flash(xx+359, y_loc);*/
        } 
        //draw_rectangle(xx + 351, yy + 539, xx + 368, yy + 539 + hi, 0);

        if (stc_vehicles > 0) then speeding_bits[1].draw(xx+539, yy+554);
          for (f =0;f<6;f++){
            if (f>=stc_vehicles){
                draw_sprite_ext(spr_research_bar, 1, xx+539, yy+554+((210/6)*f), 1, 0.6, 0, c_white, 1)
            }
            //stc_flashes[1][f].draw_one_flash(xx+539, yy+560+((210/6)*f));
        }     
        //draw_rectangle(xx + 531, yy + 539, xx + 548, yy + 539 + hi, 0);

        if (stc_ships > 0) then speeding_bits[2].draw(xx+719, yy+554);
       for (f =0;f<6;f++){
            if (f>=stc_ships){
                draw_sprite_ext(spr_research_bar, 1, xx+719, yy+554+((210/6)*f), 1, 0.6, 0, c_white, 1)
            }        
            //stc_flashes[2][f].draw_one_flash(xx+719,yy+ 560+((210/6)*f));
        }  
        switch(stc_research.research_focus){
            case "wargear":
                stc_flashes.draw(xx+359,yy+560+((210/6)*stc_wargear));
                break;
            case "vehicles":
                stc_flashes.draw(xx+539,yy+560+((210/6)*stc_vehicles));
                break;
            case "ships":
                stc_flashes.draw(xx+719,yy+560+((210/6)*stc_ships));
                break;

        }              
       // draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 539 + hi, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        //draw_rectangle(xx + 351, yy + 539, xx + 368, yy + 749, 1);
        //draw_rectangle(xx + 531, yy + 539, xx + 548, yy + 749, 1);
        //draw_rectangle(xx + 711, yy + 539, xx + 728, yy + 749, 1);

        draw_set_font(fnt_40k_14);
        draw_text(xx + 386, yy + 517, string_hash_to_newline("Wargear"));
        draw_text(xx + 566, yy + 517, string_hash_to_newline("Vehicles"));
        draw_text(xx + 746, yy + 517, string_hash_to_newline("Ships"));

        draw_set_font(fnt_40k_12);
        draw_set_alpha(1);
        if (stc_wargear < 1) then draw_set_alpha(0.5);
        draw_text(xx + 372, yy + 549, string_hash_to_newline("1) 8% discount"));

        var stc_bonus_strings = ["Random","Enhanced Bolts","Enhanced Chain Weapons","Enhanced Flame Weapons","Enhanced Missiles","Enhanced Armour"];
        var bonus_string=stc_bonus_strings[stc_bonus[1]];
        draw_set_alpha(1);

        if (stc_wargear < 2) then draw_set_alpha(0.5);
        draw_text_ext(xx + 372, yy + 549 + 35, string_hash_to_newline("2) " + string(bonus_string)),-1,150);
        draw_set_alpha(1);

        if (stc_wargear < 3) then draw_set_alpha(0.5);
        draw_text(xx + 372, yy + 549 + 70, string_hash_to_newline("3) 16% discount"));

        stc_bonus_strings = [ "Random","Enhanced Fist Weapons Bolts","Enhanced Plasma","Enhanced Armour"]
        bonus_string=stc_bonus_strings[stc_bonus[2]];

        draw_set_alpha(1);

        if (stc_wargear < 4) then draw_set_alpha(0.5);
        draw_text_ext(xx + 372, yy + 549 + 105, string_hash_to_newline("4) " + string(bonus_string)), -1,150);
        draw_set_alpha(1);

        if (stc_wargear < 5) then draw_set_alpha(0.5);
        draw_text(xx + 372, yy + 549 + 140, string_hash_to_newline("5) 25% discount"));
        draw_set_alpha(1);

        if (stc_wargear < 6) then draw_set_alpha(0.5);
        draw_text_ext(xx + 372, yy + 549 + 175, string_hash_to_newline("6) Can produce Terminator Armour and Dreadnoughts."), -1, 140);
        draw_set_alpha(1);

        // 21 right of the gray bar
        draw_set_font(fnt_40k_12);
        draw_set_alpha(1);
        if (stc_vehicles < 1) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549, string_hash_to_newline("1) 8% discount"));

        bonus_string = "Random";
        if (stc_bonus[3] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[3] = 2) then bonus_string = "Enhanced Accuracy";
        if (stc_bonus[3] = 3) then bonus_string = "New Weapons";
        if (stc_bonus[3] = 4) then bonus_string = "Survivability";
        if (stc_bonus[3] = 5) then bonus_string = "Enhanced Armour";
        draw_set_alpha(1);

        if (stc_vehicles < 2) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 35, string_hash_to_newline("2) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_vehicles < 3) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 70, string_hash_to_newline("3) 16% discount"));

        bonus_string = "Random";
        if (stc_bonus[4] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[4] = 2) then bonus_string = "Enhanced Armour";
        if (stc_bonus[4] = 3) then bonus_string = "New Weapons";
        draw_set_alpha(1);

        if (stc_vehicles < 4) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 105, string_hash_to_newline("4) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_vehicles < 5) then draw_set_alpha(0.5);
        draw_text(xx + 552, yy + 549 + 140, string_hash_to_newline("5) 25% discount"));
        draw_set_alpha(1);

        if (stc_vehicles < 6) then draw_set_alpha(0.5);
        draw_text_ext(xx + 552, yy + 549 + 175, string_hash_to_newline("6) Can produce Land Speeders and Land Raiders."), -1, 140);
        draw_set_alpha(1);

        // 21 right of the gray bar
        draw_set_font(fnt_40k_12);
        draw_set_alpha(1);
        if (stc_ships < 1) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549, string_hash_to_newline("1) 8% discount"));
        bonus_string = "Random";
        if (stc_bonus[5] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[5] = 2) then bonus_string = "Enhanced Accuracy";
        if (stc_bonus[5] = 3) then bonus_string = "Enhanced Turning";
        if (stc_bonus[5] = 4) then bonus_string = "Enhanced Boarding";
        if (stc_bonus[5] = 5) then bonus_string = "Enhanced Armour";
        draw_set_alpha(1);

        if (stc_ships < 2) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 35, string_hash_to_newline("2) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_ships < 3) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 70, string_hash_to_newline("3) 16% discount"));

        bonus_string = "Random";
        if (stc_bonus[6] = 1) then bonus_string = "Enhanced Hull";
        if (stc_bonus[6] = 2) then bonus_string = "Enhanced Armour";
        if (stc_bonus[6] = 3) then bonus_string = "Enhanced Speed";
        draw_set_alpha(1);

        if (stc_ships < 4) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 105, string_hash_to_newline("4) " + string(bonus_string)));
        draw_set_alpha(1);

        if (stc_ships < 5) then draw_set_alpha(0.5);
        draw_text(xx + 732, yy + 549 + 140, string_hash_to_newline("5) 25% discount"));
        draw_set_alpha(1);

        if (stc_ships < 6) then draw_set_alpha(0.5);
        draw_text_ext(xx + 732, yy + 549 + 175, string_hash_to_newline("6) Warp Speed is increased and ships self-repair."), -1, 140);
        draw_set_alpha(1);
    }else {
        yy+=25;
        draw_set_halign(fa_left);
        draw_set_color(0);       
        //draw_rectangle(xx + 359, yy + 66, xx + 886, yy + 818, 0);

        var forge_buttons= [xx + 359, yy + 77, 0, 0]
        draw_unit_buttons([forge_buttons[0] , forge_buttons[1]],"<-- Overview",[1,1],c_red);
        forge_buttons[2] = forge_buttons[0] + (string_width("<-- Overview")) + 8;
        forge_buttons[3] = forge_buttons[1] + (string_height("<-- Overview")) + 5;
        if (point_in_rectangle(
            mouse_x,
            mouse_y, 
            forge_buttons[0], 
            forge_buttons[1], 
            forge_buttons[2],
            forge_buttons[3]
            ) && mouse_check_button_pressed(mb_left)
        ){
            in_forge=false;
        }        
        draw_set_color(c_gray);
        draw_rectangle(xx + 359, yy + 107, xx + 886, yy + 127, 0);
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);
        draw_set_color(0);
        draw_text(xx+359,yy+109,"Name");
        draw_text(xx+500,yy+109,"Number");
        draw_text(xx+600,yy+109,"Forge Points");
        draw_text(xx+700,yy+109,"Construction ETA");        
        draw_set_color(c_gray);
        var item_gap = 130;
        var total_eta=0;
        static top_point=0;
        for (var i=top_point; i<13; i++){
            if (i+1>array_length(forge_queue)) then break;
            draw_set_color(c_gray);
            if point_in_rectangle(mouse_x, mouse_y, xx + 359,yy +item_gap, xx + 886, yy +item_gap+20){
                draw_set_color(c_white)
            }
            if (is_string(forge_queue[i].name)){
                draw_text(xx+359,yy + item_gap,string_hash_to_newline(forge_queue[i].name));
                draw_text(xx+525,yy + item_gap,string_hash_to_newline(forge_queue[i].count));
                if (forge_queue[i].ordered==obj_controller.turn){
                    if (forge_queue[i].count>1){
                         draw_unit_buttons([xx+500 , yy + item_gap],"-",[0.75,0.75],c_red);
                         if (point_in_rectangle(
                            mouse_x,
                            mouse_y, 
                            xx+500, 
                            yy + item_gap, 
                            xx+500+3+(0.75*string_width("-")),
                            yy + item_gap+3+(0.75*string_height("-")), 
                            ) && mouse_check_button_pressed(mb_left)
                        ){
                            var unit_cost = forge_queue[i].forge_points/forge_queue[i].count;
                            forge_queue[i].count--;
                            forge_queue[i].forge_points-=unit_cost;
                         }               
                    }
                    if (forge_queue[i].count<100){
                        draw_unit_buttons([xx+545 , yy + item_gap],"+",[0.75,0.75],c_green);
                         if (point_in_rectangle(
                            mouse_x,
                            mouse_y, 
                            xx+545, 
                            yy + item_gap, 
                            xx+545+3+(0.75*string_width("+")),
                            yy + item_gap+3+(0.75*string_height("+")) 
                            ) && mouse_check_button_pressed(mb_left) && current_target==false
                        ){
                            var unit_cost = forge_queue[i].forge_points/forge_queue[i].count;
                            forge_queue[i].count++;
                            forge_queue[i].forge_points+=unit_cost;
                         }                  
                    }
                }
            } else if (is_array(forge_queue[i].name)){
                if (forge_queue[i].name[0]  == "research"){
                    draw_text(xx+359,yy + item_gap,string_hash_to_newline(forge_queue[i].name[1]));
                }
            }
            draw_text(xx+630,yy + item_gap,string_hash_to_newline(forge_queue[i].forge_points));
            total_eta += ceil(forge_queue[i].forge_points/forge_points);
            draw_text(xx+735,yy+ item_gap,string_hash_to_newline(total_eta) + " turns");        
            forge_buttons= [xx+850, yy + item_gap, 0, 0]
            draw_unit_buttons([forge_buttons[0] , forge_buttons[1]],"X",[0.75,0.75],c_red);
            forge_buttons[2] = forge_buttons[0] + (string_width("X")) + 8;
            forge_buttons[3] = forge_buttons[1] + (string_height("X")) + 5;            
             if (point_in_rectangle(
                mouse_x,
                mouse_y, 
                forge_buttons[0], 
                forge_buttons[1], 
                forge_buttons[2],
                forge_buttons[3]
                ) && mouse_check_button_pressed(mb_left)
            ){
                array_delete(forge_queue, i, 1);
             }                     
            item_gap +=20
        }
        // draw_set_color(c_red);
        //draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);         
        draw_set_color(#af5a00);
        draw_set_font(fnt_40k_14b)
        var forge_text = $"Forge point production per turn: {forge_points}#";
        // draw_sprite_ext(spr_forge_points_icon,0,xx+359+string_width(forge_text), yy+410,0.3,0.3,0,c_white,1);
        forge_text += $"Chapter total {obj_ini.role[100, 16]}s: {temp[36]}#";
        forge_text += $"Planetary Forges in operation: {obj_controller.player_forge_data.player_forges}#";
        forge_text += $"Master Craft Forge Chance: {master_craft_chance}%#    Assign techmarines to forges to increase Master Craft Chance";
        // forge_text += $"A total of {obj_ini.role[100, 16]}s assigned to Forges: {var}#";
        draw_text_ext(xx+359, yy+410, string_hash_to_newline(forge_text),-1,670);
    }
}