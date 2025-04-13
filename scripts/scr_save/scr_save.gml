

function ini_encode_and_json(ini_area, ini_code,value){
	return ini_write_string(ini_area,ini_code,base64_encode(json_stringify(value)));
}
function scr_save(save_part,save_id) {
	try{
	var num=0,tot=0;
	num=0;tot=0;

	num=instance_number(obj_star);
	instance_array[tot]=0;
	
	// if (file_exists("save1.ini")) then file_delete("save1.ini");
	// argument 0 = the part of the save to do
	//save_id = the save ID

	if (save_part=1) or (save_part=0){
		scr_save_controller(save_id);
		
	}


	if (save_part=2) or (save_part=0){
		log_message("Saving to slot "+string(save_id)+" part 2");
	    ini_open($"save{save_id}.ini");
	    // Stars

	    var num=instance_number(obj_star);
	    instance_array=0;
	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_star,i);
	        // save crap here
	        ini_write_string("Star","sr"+string(i)+"name",instance_array[i].name);
	        ini_write_string("Star","sr"+string(i)+"star",instance_array[i].star);
	        ini_write_real("Star","sr"+string(i)+"planets",instance_array[i].planets);
	        ini_write_real("Star","sr"+string(i)+"owner",instance_array[i].owner);
	        ini_encode_and_json("Star",$"sr{i}warp_lanes",instance_array[i].warp_lanes);

	        ini_write_real("Star","sr"+string(i)+"x",instance_array[i].x);
	        ini_write_real("Star","sr"+string(i)+"y",instance_array[i].y);
	        ini_write_real("Star","sr"+string(i)+"x2",instance_array[i].x2);
	        ini_write_real("Star","sr"+string(i)+"y2",instance_array[i].y2);
	        ini_write_real("Star","sr"+string(i)+"ox",instance_array[i].old_x);
	        ini_write_real("Star","sr"+string(i)+"oy",instance_array[i].old_y);

	        ini_write_real("Star","sr"+string(i)+"vision",instance_array[i].vision);
	        ini_write_real("Star","sr"+string(i)+"storm",instance_array[i].storm);
	        ini_write_real("Star","sr"+string(i)+"trader",instance_array[i].trader);
	        ini_write_real("Star","sr"+string(i)+"craftworld",instance_array[i].craftworld);
	        ini_write_real("Star","sr"+string(i)+"spacehulk",instance_array[i].space_hulk);
	        ini_write_string("Star","sr"+string(i)+"present_fleets",base64_encode(json_stringify(instance_array[i].present_fleet)));

	        var g=0;
	        repeat(4){
	        	g+=1;
	            if (instance_array[i].planets>=g){
	                ini_write_real("Star","sr"+string(i)+"plan"+string(g),instance_array[i].planet[g]);
	                ini_write_real("Star","sr"+string(i)+"dispo"+string(g),instance_array[i].dispo[g]);
	                ini_write_string("Star","sr"+string(i)+"type"+string(g),instance_array[i].p_type[g]);
					var save_features = [];
					if (array_length(instance_array[i].p_feature[g])> 0){
						for (var f = 0;f < array_length(instance_array[i].p_feature[g]);f++){
							save_features[f]=0;
							var copy_feature = instance_array[i].p_feature[g][f];
							var new_feature = {};
							var names = variable_struct_get_names(copy_feature);
							for (var name = 0; name < array_length(names); name++) {
							  if (!is_method(copy_feature[$ names[name]])){
								  variable_struct_set(new_feature, names[name],copy_feature[$ names[name]])
							  }
							}
							save_features[f] = new_feature;
						}
					}
	                ini_write_string("Star","sr"+string(i)+"feat"+string(g),base64_encode(json_stringify(save_features)));
	                ini_write_string("Star","sr"+string(i)+"operatives"+string(g),base64_encode(json_stringify(instance_array[i].p_operatives[g])));
	                ini_write_real("Star","sr"+string(i)+"own"+string(g),instance_array[i].p_owner[g]);
	                ini_write_real("Star","sr"+string(i)+"fir"+string(g),instance_array[i].p_first[g]);
	                ini_write_real("Star","sr"+string(i)+"popul"+string(g),instance_array[i].p_population[g]);
	                ini_write_real("Star","sr"+string(i)+"maxpop"+string(g),instance_array[i].p_max_population[g]);
	                ini_write_real("Star","sr"+string(i)+"large"+string(g),instance_array[i].p_large[g]);
	                ini_write_string("Star","sr"+string(i)+"pop"+string(g),instance_array[i].p_pop[g]);
	                ini_write_real("Star","sr"+string(i)+"guard"+string(g),instance_array[i].p_guardsmen[g]);
	                ini_write_real("Star","sr"+string(i)+"pdf"+string(g),instance_array[i].p_pdf[g]);
	                ini_write_real("Star","sr"+string(i)+"forti"+string(g),instance_array[i].p_fortified[g]);
	                ini_write_real("Star","sr"+string(i)+"stat"+string(g),instance_array[i].p_station[g]);

	                ini_write_real("Star","sr"+string(i)+"play"+string(g),instance_array[i].p_player[g]);
	                if (instance_array[i].p_first[g]=1) or (instance_array[i].p_owner[g]=1){
	                    ini_write_real("Star","sr"+string(i)+"p_lasers"+string(g),instance_array[i].p_lasers[g]);
	                    ini_write_real("Star","sr"+string(i)+"p_silo"+string(g),instance_array[i].p_silo[g]);
	                    ini_write_real("Star","sr"+string(i)+"p_defenses"+string(g),instance_array[i].p_defenses[g]);
	                }
	                save_features = [];
					if (array_length(instance_array[i].p_upgrades[g])> 0){
						for (var f = 0;f < array_length(instance_array[i].p_upgrades[g]);f++){
							save_features[f]=0;
							var copy_feature = instance_array[i].p_upgrades[g][f];
							var new_feature = {};
							var names = variable_struct_get_names(copy_feature);
							for (var name = 0; name < array_length(names); name++) {
							  if (!is_method(copy_feature[$ names[name]])){
								  variable_struct_set(new_feature, names[name],copy_feature[$ names[name]])
							  }
							}
							save_features[f] = new_feature;
						}
					}
	                ini_write_string("Star","sr"+string(i)+"upg"+string(g),base64_encode(json_stringify(save_features)));					
	                ini_write_real("Star","sr"+string(i)+"or"+string(g),instance_array[i].p_orks[g]);
	                ini_write_real("Star","sr"+string(i)+"ta"+string(g),instance_array[i].p_tau[g]);
	                ini_write_real("Star","sr"+string(i)+"el"+string(g),instance_array[i].p_eldar[g]);
	                ini_write_real("Star","sr"+string(i)+"tr"+string(g),instance_array[i].p_traitors[g]);
	                ini_write_real("Star","sr"+string(i)+"ch"+string(g),instance_array[i].p_chaos[g]);
	                ini_write_real("Star","sr"+string(i)+"de"+string(g),instance_array[i].p_demons[g]);
	                ini_write_real("Star","sr"+string(i)+"si"+string(g),instance_array[i].p_sisters[g]);
	                ini_write_real("Star","sr"+string(i)+"ne"+string(g),instance_array[i].p_necrons[g]);
	                ini_write_real("Star","sr"+string(i)+"tyr"+string(g),instance_array[i].p_tyranids[g]);
	                    ini_write_real("Star","sr"+string(i)+"halp"+string(g),instance_array[i].p_halp[g]);

	                ini_write_real("Star","sr"+string(i)+"hurssy"+string(g),instance_array[i].p_hurssy[g]);
	                ini_write_real("Star","sr"+string(i)+"hurssy_time"+string(g),instance_array[i].p_hurssy_time[g]);
	                ini_write_real("Star","sr"+string(i)+"heresy"+string(g),instance_array[i].p_heresy[g]);
	                ini_write_real("Star","sr"+string(i)+"heresy_secret"+string(g),instance_array[i].p_heresy_secret[g]);
	                ini_write_string("Star","sr"+string(i)+"influence"+string(g),base64_encode(json_stringify(instance_array[i].p_influence[g])));
	                ini_write_real("Star","sr"+string(i)+"raided"+string(g),instance_array[i].p_raided[g]);

	                for (var p=0;p<8;p++){
		                ini_write_string("Star",$"sr{i}prob{g}.{p}",instance_array[i].p_problem[g,p]);
		                ini_write_real("Star",$"sr{i}time{g}.{p}",instance_array[i].p_timer[g,p]);
		                ini_write_string("Star",$"sr{i}prob_other{g}.{p}",base64_encode(json_stringify(instance_array[i].p_problem_other_data[g,p])));	                	
	                }
	            }
	        }
	    }


	    // Temporary artifact objects
	    ini_write_real("Controller","temp_arti",instance_number(obj_temp_arti));
	    num=instance_number(obj_temp_arti);instance_array=0;
	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_temp_arti,i);
	        ini_write_real("Star","ar"+string(i)+"x",instance_array[i].x);
	        ini_write_real("Star","ar"+string(i)+"y",instance_array[i].y);
	    }

	    // PLAYER FLEET OBJECTS
	    num=0;tot=0;num=instance_number(obj_p_fleet);
	    instance_array[tot]=0;

	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_p_fleet,i);

	        ini_write_real("Fleet","pf"+string(i)+"image",instance_array[i].image_index);
	        ini_write_real("Fleet","pf"+string(i)+"x",instance_array[i].x);
	        ini_write_real("Fleet","pf"+string(i)+"y",instance_array[i].y);
	        ini_write_real("Fleet","pf"+string(i)+"capitals",instance_array[i].capital_number);
	        ini_write_real("Fleet","pf"+string(i)+"frigates",instance_array[i].frigate_number);
	        ini_write_real("Fleet","pf"+string(i)+"escorts",instance_array[i].escort_number);
	        ini_write_real("Fleet","pf"+string(i)+"selected",instance_array[i].selected);
	        ini_write_real("Fleet","pf"+string(i)+"capital_hp",instance_array[i].capital_health);
	        ini_write_real("Fleet","pf"+string(i)+"frigate_hp",instance_array[i].frigate_health);
	        ini_write_real("Fleet","pf"+string(i)+"escort_hp",instance_array[i].escort_health);
	        ini_write_string("Fleet","pf"+string(i)+"action",instance_array[i].action);
	        ini_write_real("Fleet","pf"+string(i)+"action_x",instance_array[i].action_x);
	        ini_write_real("Fleet","pf"+string(i)+"action_y",instance_array[i].action_y);
	        ini_write_real("Fleet","pf"+string(i)+"action_spd",instance_array[i].action_spd);
	        ini_write_real("Fleet","pf"+string(i)+"action_eta",instance_array[i].action_eta);
	        ini_write_real("Fleet","pf"+string(i)+"connected",instance_array[i].connected);
	        ini_write_real("Fleet","pf"+string(i)+"acted",instance_array[i].acted);
	        ini_write_real("Fleet","pf"+string(i)+"hurssy",instance_array[i].hurssy);
	        ini_write_real("Fleet","pf"+string(i)+"hurssy_time",instance_array[i].hurssy_time);
	        ini_write_real("Fleet","pf"+string(i)+"orb",instance_array[i].orbiting);

	        ini_encode_and_json("Fleet",$"pf{i}complex_route", instance_array[i].complex_route);
	        ini_write_real("Fleet",$"pf{i}just_left",instance_array[i].just_left);

	        ini_encode_and_json("Fleet",$"pf{i}capital", instance_array[i].capital);
	        ini_encode_and_json("Fleet",$"pf{i}capital_num", instance_array[i].capital_num);
	        ini_encode_and_json("Fleet",$"pf{i}capital_sel", instance_array[i].capital_sel);
	        ini_encode_and_json("Fleet",$"pf{i}capital_uid", instance_array[i].capital_uid);


	        ini_encode_and_json("Fleet",$"pf{i}frigate", instance_array[i].frigate);
	        ini_encode_and_json("Fleet",$"pf{i}frigate_num", instance_array[i].frigate_num);
			ini_encode_and_json("Fleet",$"pf{i}frigate_sel", instance_array[i].frigate_sel);	        
	        ini_encode_and_json("Fleet",$"pf{i}frigate_uid", instance_array[i].frigate_uid);


	        ini_encode_and_json("Fleet",$"pf{i}escort", instance_array[i].escort);
	        ini_encode_and_json("Fleet",$"pf{i}escort_num", instance_array[i].escort_num);
			ini_encode_and_json("Fleet",$"pf{i}escort_sel", instance_array[i].escort_sel);	        
	        ini_encode_and_json("Fleet",$"pf{i}escort_uid", instance_array[i].escort_uid);	        	        

	    }

	    // ENEMY FLEET OBJECTS
	    num=0;tot=0;num=instance_number(obj_en_fleet);
	    instance_array[tot]=0;

	    for (var i=0; i<num; i+=1){
	        instance_array[i] = instance_find(obj_en_fleet,i);
	        ini_write_real("Fleet",$"ef{i}owner",instance_array[i].owner);
	        ini_write_real("Fleet",$"ef{i}x",instance_array[i].x);
	        ini_write_real("Fleet",$"ef{i}y",instance_array[i].y);
	        ini_write_real("Fleet",$"ef{i}sprite",instance_array[i].sprite_index);
	        ini_write_real("Fleet",$"ef{i}image",instance_array[i].image_index);
	        ini_write_real("Fleet",$"ef{i}alpha",instance_array[i].image_alpha);
	        ini_write_real("Fleet",$"ef{i}capitals",instance_array[i].capital_number);
	        ini_write_real("Fleet",$"ef{i}frigates",instance_array[i].frigate_number);
	        ini_write_real("Fleet",$"ef{i}escorts",instance_array[i].escort_number);
	        ini_write_real("Fleet",$"ef{i}selected",instance_array[i].selected);
	        ini_write_string("Fleet",$"ef{i}action",instance_array[i].action);
	        ini_write_real("Fleet",$"ef{i}action_x",instance_array[i].action_x);
	        ini_write_real("Fleet",$"ef{i}action_y",instance_array[i].action_y);
	        ini_write_real("Fleet",$"ef{i}home_x",instance_array[i].home_x);
	        ini_write_real("Fleet",$"ef{i}home_y",instance_array[i].home_y);
	        ini_write_real("Fleet",$"ef{i}inquis",instance_array[i].inquisitor);
	        ini_encode_and_json("Fleet",$"ef{i}complex_route", instance_array[i].complex_route);

	        ini_write_real("Fleet",$"ef{i}target",instance_array[i].target);
	        ini_write_real("Fleet",$"ef{i}target_x",instance_array[i].target_x);
	        ini_write_real("Fleet",$"ef{i}target_y",instance_array[i].target_y);

	        ini_write_real("Fleet",$"ef{i}action_spd",instance_array[i].action_spd);
	        ini_write_real("Fleet",$"ef{i}action_eta",instance_array[i].action_eta);
	        ini_write_real("Fleet",$"ef{i}connected",instance_array[i].connected);
	        ini_write_real("Fleet",$"ef{i}loaded",instance_array[i].loaded);
	        ini_write_string("Fleet",$"ef{i}trade",instance_array[i].trade_goods);
	        ini_encode_and_json("Fleet",$"ef{i}cargo", instance_array[i].cargo_data);
	        ini_write_real("Fleet",$"ef{i}guardsmen",instance_array[i].guardsmen);
	        ini_write_real("Fleet",$"ef{i}orb",instance_array[i].orbiting);
	        ini_write_real("Fleet",$"ef{i}navy",instance_array[i].navy);
	        ini_write_real("Fleet",$"ef{i}unl",instance_array[i].guardsmen_unloaded);
	        ini_write_real("Fleet",$"ef{i}turns_static",instance_array[i].turns_static);
	        var e
	        if (instance_array[i].navy=1){e=-1;
	            repeat(20){e+=1;
	                ini_write_real("Fleet",$"ef{i}navy_cap."+string(e),instance_array[i].capital_imp[e]);
	                ini_write_real("Fleet",$"ef{i}navy_cap_max."+string(e),instance_array[i].capital_max_imp[e]);
	            }
	            e=-1;
	            repeat(30){e+=1;
	                ini_write_real("Fleet",$"ef{i}navy_fri."+string(e),instance_array[i].frigate_imp[e]);
	                ini_write_real("Fleet",$"ef{i}navy_fri_max."+string(e),instance_array[i].frigate_max_imp[e]);
	                ini_write_real("Fleet",$"ef{i}navy_esc."+string(e),instance_array[i].escort_imp[e]);
	                ini_write_real("Fleet",$"ef{i}navy_esc_max."+string(e),instance_array[i].escort_max_imp[e]);
	            }
	        }
	    }

	    try{
			// Save chapter icon
			ini_write_real("Ini", "global_chapter_icon_sprite", global.chapter_icon_sprite);
			ini_write_real("Ini", "global_chapter_icon_frame", global.chapter_icon_frame);
			ini_write_string("Ini", "global_chapter_icon_path", global.chapter_icon_path);
			//ini_write_real("Ini", "global_chapter_icon_filename", global.chapter_icon_filename);
		} catch(_exception){
            handle_exception(_exception);
        }




	    // obj_ini
	    ini_encode_and_json("Ini", "full_liveries", obj_ini.full_liveries);
	    ini_encode_and_json("Ini", "custom_advisors", obj_ini.custom_advisors);
	    ini_write_string("Ini","home_name",obj_ini.home_name);
	    ini_write_string("Ini","home_type",obj_ini.home_type);
	    ini_write_string("Ini","recruiting_name",obj_ini.recruiting_name);
	    ini_write_string("Ini","recruiting_type",obj_ini.recruiting_type);
	    ini_write_string("Ini","chapter_name",obj_ini.chapter_name);
	    // ini_write_string("Ini","fortress_name",obj_ini.fortress_name);
	    ini_write_string("Ini","flagship_name",obj_ini.flagship_name);
	    ini_write_real("Ini","icon",obj_ini.icon);
	    ini_write_string("Ini","icon_name",obj_ini.icon_name);
	    ini_write_real("Ini","man_size",obj_ini.man_size);
	    // ini_write_string("Ini","strin1",obj_ini.strin);
	    // ini_write_string("Ini","strin2",obj_ini.strin2);
	    ini_write_string("Ini","psy_powers",obj_ini.psy_powers);
	    ini_encode_and_json("Ini", "FullLivery",obj_ini.full_liveries)
		ini_write_real("Ini","companies",obj_ini.companies);
		ini_encode_and_json("Ini", "comp_title", obj_ini.company_title);

		ini_encode_and_json("Ini", "gene_slaves", obj_ini.gene_slaves);

	    ini_write_string("Ini","battle_cry",obj_ini.battle_cry);

	    ini_write_string("Controller","main_color",obj_controller.col[obj_controller.main_color]);
	    ini_write_string("Controller","secondary_color",obj_controller.col[obj_controller.secondary_color]);
	    ini_write_string("Controller","main_trim",obj_controller.col[obj_controller.main_trim]);
	    ini_write_string("Controller","left_pauldron",obj_controller.col[obj_controller.left_pauldron]);
	    ini_write_string("Controller","right_pauldron",obj_controller.col[obj_controller.right_pauldron]);
	    ini_write_string("Controller","lens_color",obj_controller.col[obj_controller.lens_color]);
	    ini_write_string("Controller","weapon_color",obj_controller.col[obj_controller.weapon_color]);
	    ini_write_real("Controller","col_special",obj_controller.col_special);
	    ini_write_real("Controller","trimmed",obj_controller.trim);
	    ini_write_real("Controller","skin_color",obj_ini.skin_color);

	    ini_write_string("Controller","production_research",base64_encode(json_stringify(obj_controller.production_research)));
	    ini_write_string("Controller","forge_queue",base64_encode(json_stringify(obj_controller.specialist_point_handler.forge_queue)));
	    ini_write_string("Controller","stc_research",base64_encode(json_stringify(obj_controller.stc_research)));

	    ini_write_string("Ini","adept_name",obj_controller.adept_name);
	    ini_write_string("Ini","recruiter_name",obj_controller.recruiter_name);
	    // ini_write_string("Ini","progenitor",obj_controller.progenitor);
	    ini_write_string("Ini","mutation",obj_controller.mutation);
	    ini_write_real("Ini","successors",obj_controller.successor_chapters);
	    ini_write_real("Ini","progenitor_disposition",obj_controller.progenitor_disposition);
	    ini_write_real("Ini","imperium_disposition",obj_controller.imperium_disposition);
	    ini_write_real("Ini","astartes_disposition",obj_controller.astartes_disposition);
	    
	    ini_write_string("Ini","complex_livery",base64_encode(json_stringify(obj_ini.complex_livery_data)));


	    //
	    ini_write_real("Ini","preomnor",obj_ini.preomnor);
	    ini_write_real("Ini","voice",obj_ini.voice);
	    ini_write_real("Ini","doomed",obj_ini.doomed);
	    ini_write_real("Ini","lyman",obj_ini.lyman);
	    ini_write_real("Ini","omophagea",obj_ini.omophagea);
	    ini_write_real("Ini","ossmodula",obj_ini.ossmodula);
	    ini_write_real("Ini","membrane",obj_ini.membrane);
	    ini_write_real("Ini","zygote",obj_ini.zygote);
	    ini_write_real("Ini","betchers",obj_ini.betchers);
	    ini_write_real("Ini","catalepsean",obj_ini.catalepsean);
	    ini_write_real("Ini","secretions",obj_ini.secretions);
	    ini_write_real("Ini","occulobe",obj_ini.occulobe);
	    ini_write_real("Ini","mucranoid",obj_ini.mucranoid);
	    //
	    ini_write_string("Ini","master_name",obj_ini.master_name);
	    ini_write_string("Ini","chief_name",obj_ini.chief_librarian_name);
	    ini_write_string("Ini","high_name",obj_ini.high_chaplain_name);
	    ini_write_string("Ini","high2_name",obj_ini.high_apothecary_name);
	    ini_write_string("Ini","forgey_name",obj_ini.forge_master_name);
	    ini_write_string("Ini","lord_name",obj_ini.lord_admiral_name);
	    ini_write_string("Ini","previous_forge_masters",base64_encode(json_stringify(obj_ini.previous_forge_masters)));
	    //

		ini_encode_and_json("Ini",$"equipment",obj_ini.equipment);
		ini_encode_and_json("Ini",$"equipment_type",obj_ini.equipment_type);
		ini_encode_and_json("Ini",$"equipment_number",obj_ini.equipment_number);
		ini_encode_and_json("Ini",$"equipment_condition",obj_ini.equipment_condition);
		ini_encode_and_json("Ini",$"equipment_quality",obj_ini.equipment_quality);

	    for (var g=0;g<array_length(obj_ini.artifact);g++){
            ini_write_string("Ini","artifact"+string(g),obj_ini.artifact[g]);
            ini_write_string("Ini","artifact_tags"+string(g),base64_encode(json_stringify(obj_ini.artifact_tags[g])));
            ini_write_real("Ini","artifact_ident"+string(g),obj_ini.artifact_identified[g]);
            ini_write_real("Ini","artifact_condition"+string(g),obj_ini.artifact_condition[g]);
            ini_write_real("Ini","artifact_equipped"+string(g),obj_ini.artifact_equipped[g]);
            ini_write_string("Ini","artifact_loc"+string(g),obj_ini.artifact_loc[g]);
            ini_write_real("Ini","artifact_sid"+string(g),obj_ini.artifact_sid[g]);
            ini_write_string("Ini","artifact_quality"+string(g),obj_ini.artifact_quality[g]);
			var copy_artifact = obj_ini.artifact_struct[g];
			var new_artifact = {};
			var names = variable_struct_get_names(copy_artifact);
			for (var name = 0; name < array_length(names); name++) {
			  if (!is_method(copy_artifact[$ names[name]])){
				  variable_struct_set(new_artifact, names[name],copy_artifact[$ names[name]]);
			  }
			}
            ini_write_string("Ini","artifact_struct"+string(g),base64_encode(json_stringify(new_artifact)));	            
	    }

	    //
	    ini_encode_and_json("Ships","shi",obj_ini.ship);
	    ini_encode_and_json("Ships","shi_uid",obj_ini.ship_uid);
	    ini_encode_and_json("Ships","shi_class",obj_ini.ship_class);
	    ini_encode_and_json("Ships","shi_size",obj_ini.ship_size);
	    ini_encode_and_json("Ships","shi_leadership",obj_ini.ship_leadership);
	    ini_encode_and_json("Ships","shi_hp",obj_ini.ship_hp);
	    ini_encode_and_json("Ships","shi_maxhp",obj_ini.ship_maxhp);
	    ini_encode_and_json("Ships","shi_owner",obj_ini.ship_owner);


	    ini_encode_and_json("Ships","shi_location",obj_ini.ship_location);
	    ini_encode_and_json("Ships","shi_shields",obj_ini.ship_shields);
	    ini_encode_and_json("Ships","shi_conditions",obj_ini.ship_conditions);
	    ini_encode_and_json("Ships","shi_speed",obj_ini.ship_speed);
	    ini_encode_and_json("Ships","shi_turning",obj_ini.ship_turning);

	    ini_encode_and_json("Ships","shi_front_ac",obj_ini.ship_front_armour);
	    ini_encode_and_json("Ships","shi_other_ac",obj_ini.ship_other_armour);
	    ini_encode_and_json("Ships","shi_weapons",obj_ini.ship_weapons);

	    ini_encode_and_json("Ships","wep",obj_ini.ship_wep);
	    ini_encode_and_json("Ships","wep_facing",obj_ini.ship_wep_facing);
	    ini_encode_and_json("Ships","wep_condition",obj_ini.ship_wep_condition);

	    ini_encode_and_json("Ships","shi_capacity",obj_ini.ship_capacity);
	    ini_encode_and_json("Ships","shi_carrying",obj_ini.ship_carrying);
	    ini_encode_and_json("Ships","shi_contents",obj_ini.ship_contents);
	    ini_encode_and_json("Ships","shi_turrets",obj_ini.ship_turrets);

	    ini_close();
	}


	if (save_part=3) or (save_part=0){log_message($"Saving to slot {save_id} part 3");
	    ini_open($"save{save_id}.ini");
	    var coh,mah,good;
	    for (coh=1;coh<=10;coh++){
            for (mah=1;mah<=100;mah++){
                if (obj_ini.veh_role[coh][mah]!=""){
                    ini_write_real("Veh",$"co{coh}.{mah}",obj_ini.veh_race[coh,mah]);
                    ini_write_string("Veh",$"lo{coh}.{mah}",obj_ini.veh_loc[coh,mah]);
                    ini_write_string("Veh",$"rol{coh}.{mah}",obj_ini.veh_role[coh,mah]);
                    ini_write_real("Veh",$"lid{coh}.{mah}",obj_ini.veh_lid[coh,mah]);
                    ini_write_real("Veh",$"uid{coh}.{mah}",obj_ini.veh_uid[coh,mah]);
                    ini_write_real("Veh",$"wid{coh}.{mah}",obj_ini.veh_wid[coh,mah]);
    
                    ini_write_string("Veh",$"w1{coh}.{mah}",obj_ini.veh_wep1[coh,mah]);
                    ini_write_string("Veh",$"w2{coh}.{mah}",obj_ini.veh_wep2[coh,mah]);
                    ini_write_string("Veh",$"w3{coh}.{mah}",obj_ini.veh_wep3[coh,mah]);
                    ini_write_string("Veh",$"up{coh}.{mah}",obj_ini.veh_upgrade[coh,mah]);
                    ini_write_string("Veh",$"ac{coh}.{mah}",obj_ini.veh_acc[coh,mah]);
    
                    ini_write_real("Veh",$"hp{coh}.{mah}",obj_ini.veh_hp[coh,mah]);
                    ini_write_real("Veh",$"cha{coh}.{mah}",obj_ini.veh_chaos[coh,mah]);
                }
            }
	    }
	    ini_close();
	}

	if (save_part=4) or (save_part=0){
		log_message("Saving to slot "+string(save_id)+" part 4");
	    ini_open($"save{save_id}.ini");
	    var coh,mah,good;
	    good=0;coh=100;mah=0;
	    repeat(30){mah+=1;
	        if (obj_ini.role[coh,mah]!=""){
	            ini_write_real("Mar",$"co{coh}.{mah}",obj_ini.race[coh,mah]);
	            ini_write_string("Mar",$"num{coh}.{mah}",obj_ini.name[coh,mah]);
	            ini_write_string("Mar",$"rol{coh}.{mah}",obj_ini.role[coh,mah]);
	            ini_write_string("Mar",$"w1{coh}.{mah}",obj_ini.wep1[coh,mah]);
	            ini_write_string("Mar",$"w2{coh}.{mah}",obj_ini.wep2[coh,mah]);
	            ini_write_string("Mar",$"ar{coh}.{mah}",obj_ini.armour[coh,mah]);
	            ini_write_string("Mar",$"ge{coh}.{mah}",obj_ini.gear[coh,mah]);
	            ini_write_string("Mar",$"mb{coh}.{mah}",obj_ini.mobi[coh,mah]);	
	        }
	    }
	    for (coh=0;coh<=10;coh++){
	    	with (obj_ini){
	    		scr_company_order(coh);
	    	}
	        for (mah=0;mah<=500;mah++){
	        	if (obj_ini.name[coh][mah] != ""){
	                ini_write_real("Mar",$"co{coh}.{mah}",obj_ini.race[coh,mah]);
	                ini_write_string("Mar",$"lo{coh}.{mah}",obj_ini.loc[coh,mah]);
	                ini_write_string("Mar",$"num{coh}.{mah}",obj_ini.name[coh,mah]);
	                ini_write_string("Mar",$"rol{coh}.{mah}",obj_ini.role[coh,mah]);

	                ini_write_string("Mar",$"w1{coh}.{mah}",obj_ini.wep1[coh,mah]);
	                ini_write_string("Mar",$"w2{coh}.{mah}",obj_ini.wep2[coh,mah]);
	                ini_write_string("Mar",$"ar{coh}.{mah}",obj_ini.armour[coh,mah]);
	                ini_write_string("Mar",$"ge{coh}.{mah}",obj_ini.gear[coh,mah]);
	                ini_write_string("Mar",$"mb{coh}.{mah}",obj_ini.mobi[coh,mah]);
	                ini_write_real("Mar",$"ag{coh}.{mah}",obj_ini.age[coh,mah]);
	                ini_write_string("Mar",$"spe{coh}.{mah}",obj_ini.spe[coh,mah]);
	                ini_write_real("Mar",$"god{coh}.{mah}",obj_ini.god[coh,mah]);
					if (!is_struct(obj_ini.TTRPG[coh][mah])){
						TTRPG[coh][mah] = new TTRPG_stats("chapter", coh,mah, "blank");
					} else{
						ini_write_string("Mar",$"Struct{coh}.{mah}",base64_encode(jsonify_marine_struct(coh,mah)));
					}
				} else {
					if (mah>0) then break;
				}
	        }
	    }
	    var squad_copies = [];
		if (array_length(obj_ini.squads)> 0){
			for (var i = 0;i < array_length(obj_ini.squads);i++){
				array_push(squad_copies, obj_ini.squads[i].jsonify());
			}
		}
        ini_write_string("Mar","squads",base64_encode(json_stringify(squad_copies)));
        ini_write_string("Mar","squad_types",base64_encode(json_stringify(obj_ini.squad_types)));

	    coh=100;mah=-1;
	    repeat(21){mah+=1;
	    	coh=100
	        if (obj_ini.role[coh,mah]!=""){
	            ini_write_string("Mar",$"rol{coh}.{mah}",obj_ini.role[coh,mah]);
	            ini_write_string("Mar",$"w1{coh}.{mah}",obj_ini.wep1[coh,mah]);
	            ini_write_string("Mar",$"w2{coh}.{mah}",obj_ini.wep2[coh,mah]);
	            ini_write_string("Mar",$"ar{coh}.{mah}",obj_ini.armour[coh,mah]);
	            ini_write_string("Mar",$"ge{coh}.{mah}",obj_ini.gear[coh,mah]);
	            ini_write_string("Mar",$"mb{coh}.{mah}",obj_ini.mobi[coh,mah]);				
	        }
	        coh=102;
	        if (obj_ini.role[coh,mah]!=""){
	            ini_write_string("Mar",$"rol{coh}.{mah}",obj_ini.role[coh,mah]);
	            ini_write_string("Mar",$"w1{coh}.{mah}",obj_ini.wep1[coh,mah]);
	            ini_write_string("Mar",$"w2{coh}.{mah}",obj_ini.wep2[coh,mah]);
	            ini_write_string("Mar",$"ar{coh}.{mah}",obj_ini.armour[coh,mah]);
	            ini_write_string("Mar",$"ge{coh}.{mah}",obj_ini.gear[coh,mah]);
	            ini_write_string("Mar",$"mb{coh}.{mah}",obj_ini.mobi[coh,mah]);			
	        }	        
	    }

	    ini_close();
	}

	if (save_part=5) or (save_part=0){
	    ini_open($"save{save_id}.ini");
	    instance_activate_object(obj_event_log);
	    ini_encode_and_json("Event", "loglist", obj_event_log.event);
	    obj_saveload.hide=true;
	    obj_controller.invis=true;
	    obj_saveload.alarm[2]=2;

	    var svt=0,svc="",svm="",smr=0,svd="";
	    svt=ini_read_real("Controller","turn",0);
	    svc=ini_read_string("Save","chapter_name","Error");
	    svm=ini_read_string("Ini","master_name","Error");
	    smr=ini_read_real("Controller","marines",0);
	    svd=ini_read_string("Save","date","Error");
	    ini_write_real("Save","corrupt",0);
	    ini_close();

	    ini_open("saves.ini");
	    ini_write_real(string(save_id),"turn",svt);
	    ini_write_string(string(save_id),"chapter_name",svc);
	    ini_write_string(string(save_id),"master_name",svm);
	    ini_write_real(string(save_id),"marines",smr);
	    ini_write_string(string(save_id),"date",svd);
	    ini_write_real(string(save_id),"time",obj_controller.play_time);
	    ini_write_real(string(save_id),"seed",global.game_seed);
	    ini_close();

	    obj_saveload.save[save_id]=1;

	    log_message("Saving to slot "+string(save_id)+" complete");
	}

	// Finish here



	// scr_load();


	/*

	probably need to add something like

	comp1_marines
	comp1_vehicles

	these will be loaded into a temporary variable and determine how many times the checks need to repeat








	////////////////////////////////
	////////Loading////////////////////////
	//////////////////////////////////
	ini_open(saveFile);
	num = ini_read_real("Save", "count", 0); //get the number of instances

	for ( i = 0; i < num; i += 1)
	{
	     myID = ini_read_real( "Save", "object" + string(i), 0); //loads id from file
	     myX = ini_read_real( "Save", "object" + string(i) + "x", 0); //loads x from file
	     myY = ini_read_real( "Save", "object" + string(i) + "y", 0); //loads y from file

	     instance_create( myX, myY, myID);
	}
	ini_close();




	1. Make it so that save files are named 'Save1', 'Save2', etc, then store the name of the save file that appears in the game as part of the save file.

	2. Check if 'Save1' exists, 'Save2', etc, and display them accordingly by reading their names from the file

	3. When clicked, load the file by its FILENAME. When the user deletes a file, remove it and rename all the files with names AFTER it (for example, if Save3 was deleted, rename Save4 to Save3, and Save5 to Save4). This way, the structure stays tidy.


	file_exists(fname) Returns whether the file with the given name exists (true) or not (false).




	Use Splash Webpage(from d&d) ! (hehe) Usually you want to open in browser not in game (splash_show_web(url,delay) shows only in game )

	Note: You can use working_directory to point the folder where the game is



	*/
	} catch(_exception){
        handle_exception(_exception);
    }


}
