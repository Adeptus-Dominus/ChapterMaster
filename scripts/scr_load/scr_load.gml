function return_json_from_ini(ini_area,ini_code, default_val=[]){
	var ini_fetch = ini_read_string(ini_area,ini_code,"");
	if (ini_fetch!=""){
		return json_parse(base64_decode(ini_fetch));
	} else {
		return default_val;
	}
}

function load_marine_struct(company, marine){
		var marStruct = ini_read_string("Mar","Struct"+string(company)+"."+string(marine),"");
		if (marStruct != ""){
			marStruct = json_parse(base64_decode(marStruct));
			obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine, "blank");
			obj_ini.TTRPG[company, marine].load_json_data(marStruct);
			delete marStruct;
		} else {
			obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine,"blank");
		}		
};

function scr_load(save_part, save_id) {
	var unit;
	var rang=0,stars=0,pfleets=0,efleets=0;



	if (save_part=1) or (save_part=0){
		scr_load_controller(save_id);
	}


	if (save_part=2) or (save_part=0){
		log_message("Loading slot "+string(save_id)+" part 2");
	    ini_open("tsave.ini");

	    stars=ini_read_real("Save","stars",0);

	    // Stars
	    var i=-1;
	    repeat(stars){i+=1;
	        var new_star;
	        new_star=instance_create(
	        	ini_read_real("Star",$"sr{i}x",0),
	        	ini_read_real("Star",$"sr{i}y",0),
	        	obj_star
	        );

	        new_star.name=ini_read_string("Star",$"sr{i}name","");
	        new_star.star=ini_read_string("Star",$"sr{i}star","");
	        new_star.planets=ini_read_real("Star",$"sr{i}planets",0);
	        new_star.owner=ini_read_real("Star",$"sr{i}owner",0);
	        new_star.x2=ini_read_real("Star",$"sr{i}x2",0);
	        new_star.y2=ini_read_real("Star",$"sr{i}y2",0);
	        new_star.old_x=ini_read_real("Star",$"sr{i}ox",0);
	        new_star.old_y=ini_read_real("Star",$"sr{i}oy",0);
	        new_star.warp_lanes = return_json_from_ini("Star",$"sr{i}warp_lanes",[]);

	        new_star.vision=ini_read_real("Star",$"sr{i}vision",1);
	        new_star.storm=ini_read_real("Star",$"sr{i}storm",0);
	        new_star.trader=ini_read_real("Star",$"sr{i}trader",0);
	        new_star.craftworld=ini_read_real("Star",$"sr{i}craftworld",0);
	        new_star.space_hulk=ini_read_real("Star",$"sr{i}spacehulk",0);
	        if (new_star.space_hulk=1) then new_star.sprite_index=spr_star_hulk;
	        new_star.present_fleet=ini_read_string("Star",$"sr{i}present_fleets","");
	        if (new_star.present_fleet!=""){
	        	new_star.present_fleet = json_parse(base64_decode(new_star.present_fleet));
	        } else {
	        	new_star.present_fleet = array_create(30, 0);
	        }

	        var g=0;
	        repeat(4){g+=1;
	            if (new_star.planets>=g){
	                new_star.planet[g]=ini_read_real("Star",$"sr{i}plan"+string(g),0);
	                new_star.dispo[g]=ini_read_real("Star",$"sr{i}dispo"+string(g),-10);
	                new_star.p_type[g]=ini_read_string("Star",$"sr{i}type"+string(g),"");
					new_star.p_feature[g] = [];
					var  p_features = ini_read_string("Star",$"sr{i}feat"+string(g),"");
					if (p_features != ""){
						var p_features = json_parse(base64_decode(p_features));
						for (var feat = 0;feat < array_length(p_features);feat++){
							var new_feat = new NewPlanetFeature(p_features[feat].f_type);
							new_feat.load_json_data(p_features[feat]);
							array_push(new_star.p_feature[g], new_feat);
						}
					}
	                new_star.p_owner[g]=ini_read_real("Star",$"sr{i}own"+string(g),0);
	                new_star.p_first[g]=ini_read_real("Star",$"sr{i}fir"+string(g),0);
	                new_star.p_population[g]=ini_read_real("Star",$"sr{i}popul"+string(g),0);
	                new_star.p_max_population[g]=ini_read_real("Star",$"sr{i}maxpop"+string(g),0);
	                new_star.p_large[g]=ini_read_real("Star",$"sr{i}large"+string(g),0);
	                new_star.p_pop[g]=ini_read_string("Star",$"sr{i}pop"+string(g),"");
	                new_star.p_guardsmen[g]=ini_read_real("Star",$"sr{i}guard"+string(g),0);
	                new_star.p_pdf[g]=ini_read_real("Star",$"sr{i}pdf"+string(g),0);
	                new_star.p_fortified[g]=ini_read_real("Star",$"sr{i}forti"+string(g),0);
	                new_star.p_station[g]=ini_read_real("Star",$"sr{i}stat"+string(g),0);

	                new_star.p_player[g]=ini_read_real("Star",$"sr{i}play"+string(g),0);
	                new_star.p_lasers[g]=ini_read_real("Star",$"sr{i}p_lasers"+string(g),0);
	                new_star.p_silo[g]=ini_read_real("Star",$"sr{i}p_silo"+string(g),0);
	                new_star.p_defenses[g]=ini_read_real("Star",$"sr{i}p_defenses"+string(g),0);
	                new_star.p_operatives[g]=ini_read_string("Star",$"sr{i}operatives"+string(g),0);
	                if (new_star.p_operatives[g]!=0){
	                	new_star.p_operatives[g] = json_parse(base64_decode(new_star.p_operatives[g]))
	                }
					new_star.p_upgrades[g] = [];
					var  p_upgrades = ini_read_string("Star",$"sr{i}upg"+string(g),"");
					if (p_upgrades != ""){
						var p_upgrades = json_parse(base64_decode(p_upgrades));
						for (var feat = 0;feat < array_length(p_upgrades);feat++){
							var new_feat = new NewPlanetFeature(p_upgrades[feat].f_type);
							new_feat.load_json_data(p_upgrades[feat]);
							array_push(new_star.p_upgrades[g], new_feat);
						}
					}					

	                new_star.p_orks[g]=ini_read_real("Star",$"sr{i}or"+string(g),0);
	                new_star.p_tau[g]=ini_read_real("Star",$"sr{i}ta"+string(g),0);
	                new_star.p_eldar[g]=ini_read_real("Star",$"sr{i}el"+string(g),0);
	                new_star.p_traitors[g]=ini_read_real("Star",$"sr{i}tr"+string(g),0);
	                new_star.p_chaos[g]=ini_read_real("Star",$"sr{i}ch"+string(g),0);
	                new_star.p_demons[g]=ini_read_real("Star",$"sr{i}de"+string(g),0);
	                new_star.p_sisters[g]=ini_read_real("Star",$"sr{i}si"+string(g),0);
	                new_star.p_necrons[g]=ini_read_real("Star",$"sr{i}ne"+string(g),0);
	                new_star.p_tyranids[g]=ini_read_real("Star",$"sr{i}tyr"+string(g),0);
	                new_star.p_halp[g]=ini_read_real("Star",$"sr{i}halp"+string(g),0);

	                new_star.p_heresy[g]=ini_read_real("Star",$"sr{i}heresy"+string(g),0);
	                new_star.p_hurssy[g]=ini_read_real("Star",$"sr{i}hurssy"+string(g),0);
	                new_star.p_hurssy_time[g]=ini_read_real("Star",$"sr{i}hurssy_time"+string(g),0);
	                new_star.p_heresy_secret[g]=ini_read_real("Star",$"sr{i}heresy_secret"+string(g),0);
	                new_star.p_influence[g]=ini_read_string("Star",$"sr{i}influence"+string(g),"");
	                if (new_star.p_influence[g] != ""){
	                	new_star.p_influence[g]=json_parse(base64_decode(new_star.p_influence[g]));
	                } else {
	                	new_star.p_influence[g] = array_create(15, 0);
	                }
	                new_star.p_raided[g]=ini_read_real("Star",$"sr{i}raided"+string(g),0);


	                for (var p=0;p<8;p++){
	                	new_star.p_problem[g,p]=ini_read_string("Star",$"sr{i}prob{g}.{p}","");
	                	new_star.p_timer[g,p]=ini_read_real("Star",$"sr{i}time{g}.{p}",-1);
	                	new_star.p_problem_other_data[g,p]=ini_read_string("Star",$"sr{i}prob_other{g}.{p}","");
	                	if (new_star.p_problem_other_data[g][p]!=""){
	                		new_star.p_problem_other_data[g][p] = json_parse(base64_decode(new_star.p_problem_other_data[g][p]));
	                	} else {
	                		new_star.p_problem_other_data[g][p]={};
	                	}
	                }
	            }
	        }
	    }


	    // obj_ini
	    //TODO allow methods to be passed as teh default to return_json_from_ini to optomise load speed
	    var livery_picker = new ColourItem(0,0);
		livery_picker.scr_unit_draw_data();
	    obj_ini.full_liveries = return_json_from_ini("Ini", "full_liveries",array_create(21,DeepCloneStruct(livery_picker.map_colour)));
	    obj_ini.custom_advisors = return_json_from_ini("Ini", "custom_advisors",{});
	    obj_ini.home_name=ini_read_string("Ini","home_name","Error");
	    obj_ini.home_type=ini_read_string("Ini","home_type","Error");
	    obj_ini.recruiting_name=ini_read_string("Ini","recruiting_name","Error");
	    obj_ini.recruiting_type=ini_read_string("Ini","recruiting_type","Error");
	    obj_ini.chapter_name=ini_read_string("Ini","chapter_name","Error");
	    obj_ini.fortress_name=ini_read_string("Ini","fortress_name","Error");
	    obj_ini.flagship_name=ini_read_string("Ini","flagship_name","Error");
	    obj_ini.icon=ini_read_real("Ini","icon",0);
	    obj_ini.icon_name=ini_read_string("Ini","icon_name","custom1");
	    global.icon_name=obj_ini.icon_name;
	    obj_ini.man_size=ini_read_real("Ini","man_size",0);
	    // obj_ini.strin=ini_read_string("Ini","strin1","");
	    // obj_ini.strin2=ini_read_string("Ini","strin2","");
	    obj_ini.psy_powers=ini_read_string("Ini","psy_powers","default");

		
		global.chapter_icon_sprite = ini_read_real("Ini", "global_chapter_icon_sprite", spr_icon_chapters);
		global.chapter_icon_frame = ini_read_real("Ini", "global_chapter_icon_frame", 0);
		global.chapter_icon_path = ini_read_string("Ini", "global_chapter_icon_path", "Error");
		global.chapter_icon_filename = ini_read_real("Ini", "global_chapter_icon_filename", 0);


		if(global.chapter_icon_path != "Error" && global.chapter_icon_path != "") {
			global.chapter_icon_sprite = scr_image_cache(global.chapter_icon_path, global.chapter_icon_filename);
		} else {
			global.chapter_icon_sprite = spr_icon_chapters;
		}


	    obj_ini.companies=ini_read_real("Ini","companies",10);
		obj_ini.company_title = return_json_from_ini("Ini","comp_title",array_create(21,""));

		obj_ini.gene_slaves = return_json_from_ini("Ini","gene_slaves",[]);
	
	    obj_ini.complex_livery_data=ini_read_string("Ini","complex_livery","");
	    if (obj_ini.complex_livery_data!=""){
	    	obj_ini.complex_livery_data=json_parse(base64_decode(obj_ini.complex_livery_data));
	    } else{
	    	//TODO centralise and initialisation method for this other reference place is obj_creation create
			obj_ini.complex_livery_data = complex_livery_default();	    	
	    }
	    var colour_temp = new ColourItem(0,0);

	    obj_ini.full_liveries = return_json_from_ini("Ini", "FullLivery",colour_temp.scr_unit_draw_data());
	    //
	    obj_ini.preomnor=ini_read_real("Ini","preomnor",0);
	    obj_ini.voice=ini_read_real("Ini","voice",0);
	    obj_ini.doomed=ini_read_real("Ini","doomed",0);
	    obj_ini.lyman=ini_read_real("Ini","lyman",0);
	    obj_ini.omophagea=ini_read_real("Ini","omophagea",0);
	    obj_ini.ossmodula=ini_read_real("Ini","ossmodula",0);
	    obj_ini.membrane=ini_read_real("Ini","membrane",0);
	    obj_ini.zygote=ini_read_real("Ini","zygote",0);
	    obj_ini.betchers=ini_read_real("Ini","betchers",0);
	    obj_ini.catalepsean=ini_read_real("Ini","catalepsean",0);
	    obj_ini.secretions=ini_read_real("Ini","secretions",0);
	    obj_ini.occulobe=ini_read_real("Ini","occulobe",0);
	    obj_ini.mucranoid=ini_read_real("Ini","mucranoid",0);
	    //
	    obj_ini.master_name=ini_read_string("Ini","master_name","Error");
	    obj_ini.chief_librarian_name=ini_read_string("Ini","chief_name","Error");
	    obj_ini.high_chaplain_name=ini_read_string("Ini","high_name","Error");
	    obj_ini.high_apothecary_name=ini_read_string("Ini","high2_name","Error");
	    obj_ini.forge_master_name=ini_read_string("Ini","forgey_name","Error");
	    obj_ini.lord_admiral_name=ini_read_string("Ini","lord_name","Error");
	    obj_ini.previous_forge_masters=ini_read_string("Ini","previous_forge_masters",[]);
	    if (!is_array(obj_ini.previous_forge_masters)){
	    	obj_ini.previous_forge_masters=json_parse(base64_decode(obj_ini.previous_forge_masters));
	    }
	    //
	    //
		obj_ini.equipment=return_json_from_ini("Ini",$"equipment", array_create(200,""))
		obj_ini.equipment_type=return_json_from_ini("Ini",$"equipment_type", array_create(200,""))
		obj_ini.equipment_number=return_json_from_ini("Ini",$"equipment_number", array_create(200,""))
		obj_ini.equipment_condition=return_json_from_ini("Ini",$"equipment_condition",array_create(200,""))
		obj_ini.equipment_quality = return_json_from_ini("Ini", $"equipment_quality", array_create(200,""))

		for (var g=0; g<array_length(obj_ini.artifact); g++){
			obj_ini.artifact[g]=ini_read_string("Ini","artifact"+string(g),"");
			obj_ini.artifact_tags[g]=ini_read_string("Ini","artifact_tags"+string(g),"");
			if (obj_ini.artifact_tags[g] != ""){
				obj_ini.artifact_tags[g] = json_parse(base64_decode(obj_ini.artifact_tags[g]));
			} else {
				obj_ini.artifact_tags[g] = [];
			}
			obj_ini.artifact_identified[g]=ini_read_real("Ini","artifact_ident"+string(g),0);
			obj_ini.artifact_condition[g]=ini_read_real("Ini","artifact_condition"+string(g),0);
			obj_ini.artifact_loc[g]=ini_read_string("Ini","artifact_loc"+string(g),"");
			obj_ini.artifact_sid[g]=ini_read_real("Ini","artifact_sid"+string(g),0);
			obj_ini.artifact_equipped[g]=ini_read_real("Ini","artifact_equipped"+string(g),0);
			obj_ini.artifact_quality[g]=ini_read_string("Ini","artifact_quality"+string(g),"artifact");
			obj_ini.artifact_struct[g] = new ArtifactStruct(g);
			var temp_data = ini_read_string("Ini","artifact_struct"+string(g),"");
			if (temp_data!=""){
				obj_ini.artifact_struct[g].load_json_data(json_parse(base64_decode(temp_data)));
			}
		}
	    //
	    if (global.restart=0){
			obj_ini.ship = return_json_from_ini("Ships","shi",[]);
		    obj_ini.ship_uid =return_json_from_ini("Ships","shi_uid",[]);
		    obj_ini.ship_class= return_json_from_ini("Ships","shi_class",[]);
		    obj_ini.ship_size = return_json_from_ini("Ships","shi_size",[]);
		    obj_ini.ship_leadership =return_json_from_ini("Ships","shi_leadership",[]);
		    obj_ini.ship_hp =return_json_from_ini("Ships","shi_hp",[]);
		    obj_ini.ship_maxhp =return_json_from_ini("Ships","shi_maxhp",[]);
		    obj_ini.ship_owner = return_json_from_ini("Ships","shi_owner",[]);

		    obj_ini.ship_location=return_json_from_ini("Ships","shi_location",[]);
		    obj_ini.ship_shields=return_json_from_ini("Ships","shi_shields",[]);
		    obj_ini.ship_conditions=return_json_from_ini("Ships","shi_conditions",[]);
		    obj_ini.ship_speed=return_json_from_ini("Ships","shi_speed",[]);
		    obj_ini.ship_turning=return_json_from_ini("Ships","shi_turning",[]);

		    obj_ini.ship_front_armour=return_json_from_ini("Ships","shi_front_ac",[]);
		    obj_ini.ship_other_armour=return_json_from_ini("Ships","shi_other_ac",[]);
		    obj_ini.ship_weapons=return_json_from_ini("Ships","shi_weapons",[]);

		    obj_ini.ship_wep=return_json_from_ini("Ships","wep",array_create(6, ""));
		    obj_ini.ship_wep_facing=return_json_from_ini("Ships","wep_facing",array_create(6, ""));
		    obj_ini.ship_wep_condition=return_json_from_ini("Ships","wep_condition",array_create(6, ""));

		    obj_ini.ship_capacity=return_json_from_ini("Ships","shi_capacity",[]);
		    obj_ini.ship_carrying=return_json_from_ini("Ships","shi_carrying",[]);
		    obj_ini.ship_contents=return_json_from_ini("Ships","shi_contents",[]);
		    obj_ini.ship_turrets=return_json_from_ini("Ships","shi_turrets",[]);

		}
	    // the fun begins here
	    ini_close();
	}




	if (save_part=3) or (save_part=0){log_message("Loading slot "+string(save_id)+" part 3");
	    ini_open("tsave.ini");

	    var coh,mah,good;
	    good=0;coh=100;mah=-1;

	    if (global.restart=0){
	        good=0;coh=10;mah=205;
	        repeat(2255){
	            if (good=0){
	                mah-=1;
	                if (mah=0){mah=205;coh-=1;}

	                // var temp_name;temp_name="";
	                // temp_name=ini_read_string("Veh","rol"+string(coh)+"."+string(mah),"");

	                // if (temp_name!=""){
	                    obj_ini.veh_race[coh,mah]=ini_read_real("Veh","co"+string(coh)+"."+string(mah),0);
	                    obj_ini.veh_loc[coh,mah]=ini_read_string("Veh","lo"+string(coh)+"."+string(mah),"");
	                    obj_ini.veh_role[coh,mah]=ini_read_string("Veh","rol"+string(coh)+"."+string(mah),"");// temp_name;
	                    obj_ini.veh_lid[coh,mah]=ini_read_real("Veh","lid"+string(coh)+"."+string(mah),-1);
	                    obj_ini.veh_uid[coh,mah]=ini_read_real("Veh","uid"+string(coh)+"."+string(mah),0);
	                    obj_ini.veh_wid[coh,mah]=ini_read_real("Veh","wid"+string(coh)+"."+string(mah),0);

	                    obj_ini.veh_wep1[coh,mah]=ini_read_string("Veh","w1"+string(coh)+"."+string(mah),"");
	                    obj_ini.veh_wep2[coh,mah]=ini_read_string("Veh","w2"+string(coh)+"."+string(mah),"");
	                    obj_ini.veh_wep3[coh,mah]=ini_read_string("Veh","w3"+string(coh)+"."+string(mah),"");
	                    obj_ini.veh_upgrade[coh,mah]=ini_read_string("Veh","up"+string(coh)+"."+string(mah),"");
	                    obj_ini.veh_acc[coh,mah]=ini_read_string("Veh","ac"+string(coh)+"."+string(mah),"");

	                    obj_ini.veh_hp[coh,mah]=ini_read_real("Veh","hp"+string(coh)+"."+string(mah),0);
	                    obj_ini.veh_chaos[coh,mah]=ini_read_real("Veh","cha"+string(coh)+"."+string(mah),0);
	                    // ini_write_real("Veh","pil"+string(coh)+"."+string(mah),obj_ini.veh_pilots[coh,mah]);
	                // }
	                if (coh=1) and (mah=1) then good=1;
	            }
	        }

	        good=0;coh=100;mah=-1;
	        repeat(31){mah+=1;
	            obj_ini.race[coh,mah]=ini_read_real("Mar","co"+string(coh)+"."+string(mah),0);
	            obj_ini.name[coh,mah]=ini_read_string("Mar","num"+string(coh)+"."+string(mah),"");
	            obj_ini.role[coh,mah]=ini_read_string("Mar","rol"+string(coh)+"."+string(mah),"");
	            obj_ini.wep1[coh,mah]=ini_read_string("Mar","w1"+string(coh)+"."+string(mah),"");
	            obj_ini.wep2[coh,mah]=ini_read_string("Mar","w2"+string(coh)+"."+string(mah),"");
	            obj_ini.armour[coh,mah]=ini_read_string("Mar","ar"+string(coh)+"."+string(mah),"");
	            obj_ini.gear[coh,mah]=ini_read_string("Mar","ge"+string(coh)+"."+string(mah),"");
	            obj_ini.mobi[coh,mah]=ini_read_string("Mar","mb"+string(coh)+"."+string(mah),"");	
	        }
	        for (coh=0;coh<=10;coh++){
	        	for (mah=0;mah<=500;mah++){

	                // var temp_name;temp_name="";
	                // temp_name=ini_read_string("Mar","rol"+string(coh)+"."+string(mah),"Error");

                    obj_ini.race[coh,mah]=ini_read_real("Mar","co"+string(coh)+"."+string(mah),0);
                    obj_ini.loc[coh,mah]=ini_read_string("Mar","lo"+string(coh)+"."+string(mah),"");
                    obj_ini.name[coh,mah]=ini_read_string("Mar","num"+string(coh)+"."+string(mah),"");
                    obj_ini.role[coh,mah]=ini_read_string("Mar","rol"+string(coh)+"."+string(mah),"");// temp_name;					

                    if (coh=0){
                        if (obj_ini.role[coh,mah]="Chapter Master"){
                        	obj_ini.race[coh,mah]=1;
                        }else if (obj_ini.role[coh,mah]="Master of Sanctity"){
                        	obj_ini.race[coh,mah]=1;
                        }else if (obj_ini.role[coh,mah]="Master of the Apothecarion"){
                        	obj_ini.race[coh,mah]=1;
                        } else if (obj_ini.role[coh,mah]="Forge Master") then obj_ini.race[coh,mah]=1;
                        if (string_count("Chief",obj_ini.role[coh,mah])>0) then obj_ini.race[coh,mah]=1;
                    }

                    obj_ini.wep1[coh,mah]=ini_read_string("Mar","w1"+string(coh)+"."+string(mah),"");
                    obj_ini.wep2[coh,mah]=ini_read_string("Mar","w2"+string(coh)+"."+string(mah),"");
                    obj_ini.armour[coh,mah]=ini_read_string("Mar","ar"+string(coh)+"."+string(mah),"");
                    obj_ini.gear[coh,mah]=ini_read_string("Mar","ge"+string(coh)+"."+string(mah),"");
                    obj_ini.mobi[coh,mah]=ini_read_string("Mar","mb"+string(coh)+"."+string(mah),"");

                    obj_ini.age[coh,mah]=ini_read_real("Mar","ag"+string(coh)+"."+string(mah),0);
                    obj_ini.spe[coh,mah]=ini_read_string("Mar","spe"+string(coh)+"."+string(mah),"");
                    obj_ini.god[coh,mah]=ini_read_real("Mar","god"+string(coh)+"."+string(mah),0);
                    load_marine_struct(coh,mah);
                    unit = obj_ini.TTRPG[coh,mah];
					if (string_length(unit.weapon_one()) != 0 && string_length(string_digits(unit.weapon_one())) == string_length(unit.weapon_one())) {
						obj_ini.wep1[coh, mah] = real(obj_ini.wep1[coh, mah]);
					}
					if (string_length(unit.weapon_two()) != 0 && string_length(string_digits(unit.weapon_two())) == string_length(unit.weapon_two())) {
						obj_ini.wep2[coh, mah] = real(obj_ini.wep2[coh, mah]);
					}
					if (string_length(unit.gear()) != 0 && string_length(string_digits(unit.gear())) == string_length(unit.gear())) {
						obj_ini.gear[coh, mah] = real(obj_ini.gear[coh, mah]);
					}
					if (string_length(unit.mobility_item()) != 0 && string_length(string_digits(unit.mobility_item())) == string_length(unit.mobility_item())) {
						obj_ini.mobi[coh, mah] = real(obj_ini.mobi[coh, mah]);
					}
					if (string_length(unit.armour()) != 0 && string_length(string_digits(unit.armour())) == string_length(unit.armour())) {
						obj_ini.armour[coh, mah] = real(obj_ini.armour[coh, mah]);
					}
				}
			}


	        if (string_count(obj_ini.spe[0,1],"$")>0) then obj_controller.born_leader=1;

	        coh=100;mah=-1;
	        repeat(21){mah+=1;
	            obj_ini.race[coh,mah]=ini_read_real("Mar","co"+string(coh)+"."+string(mah),0);
	            obj_ini.role[coh,mah]=ini_read_string("Mar","rol"+string(coh)+"."+string(mah),"");
	            obj_ini.wep1[coh,mah]=ini_read_string("Mar","w1"+string(coh)+"."+string(mah),"");
	            obj_ini.wep2[coh,mah]=ini_read_string("Mar","w2"+string(coh)+"."+string(mah),"");
	            obj_ini.armour[coh,mah]=ini_read_string("Mar","ar"+string(coh)+"."+string(mah),"");
	            obj_ini.gear[coh,mah]=ini_read_string("Mar","ge"+string(coh)+"."+string(mah),"");
	            obj_ini.mobi[coh,mah]=ini_read_string("Mar","mb"+string(coh)+"."+string(mah),"");
	        }
	        coh=102;
	        mah=-1;
	        repeat(21){mah+=1;
	            obj_ini.race[coh,mah]=ini_read_string("Mar","co"+string(coh)+"."+string(mah),0);
	            obj_ini.role[coh,mah]=ini_read_string("Mar","rol"+string(coh)+"."+string(mah),"");
	            obj_ini.wep1[coh,mah]=ini_read_string("Mar","w1"+string(coh)+"."+string(mah),"");
	            obj_ini.wep2[coh,mah]=ini_read_string("Mar","w2"+string(coh)+"."+string(mah),"");
	            obj_ini.armour[coh,mah]=ini_read_string("Mar","ar"+string(coh)+"."+string(mah),"");
	            obj_ini.gear[coh,mah]=ini_read_string("Mar","ge"+string(coh)+"."+string(mah),"");
	            obj_ini.mobi[coh,mah]=ini_read_string("Mar","mb"+string(coh)+"."+string(mah),"");			
	        }

	        obj_ini.squads = [];
	        var squad_fetch = ini_read_string("Mar","squads","");
	        if (squad_fetch != ""){
	        	squad_fetch = json_parse(base64_decode(squad_fetch));
	        	for (i=0;i<array_length(squad_fetch);i++){
	        		array_push(obj_ini.squads, new UnitSquad());
	        		obj_ini.squads[i].load_json_data(json_parse(squad_fetch[i]));
	        	}
	        	delete squad_fetch;
	        }

	        obj_ini.squad_types = return_json_from_ini("Mar","squad_types","");

	    }

	    ini_close();
	}



	if (save_part=4) or (save_part=0){
		log_message("Loading slot "+string(save_id)+" part 4");// PLAYER FLEET OBJECTS
	    ini_open("tsave.ini");

	    var num,i,fla;
	    // Temporary artifact objects
	    num=ini_read_real("Controller","temp_arti",0);
	    i=-1;fla=0;
	    repeat(num){i+=1;
	        fla=instance_create(0,0,obj_temp_arti);
	        fla.x=ini_read_real("Star",$"ar{i}x",0);
	        fla.y=ini_read_real("Star",$"ar{i}y",0);
	    }

	    num=ini_read_real("Save","p_fleets",0);
	    i=-1;fla=0;

	    repeat(num){
	    	i+=1;
	    	fla=instance_create(0,0,obj_p_fleet);
	        fla.image_index=ini_read_real("Fleet",$"pf{i}image",0);
	        fla.x=ini_read_real("Fleet",$"pf{i}x",0);
	        fla.y=ini_read_real("Fleet",$"pf{i}y",0);
	        fla.capital_number=ini_read_real("Fleet",$"pf{i}capitals",0);
	        fla.frigate_number=ini_read_real("Fleet",$"pf{i}frigates",0);
	        fla.escort_number=ini_read_real("Fleet",$"pf{i}escorts",0);
	        fla.selected=ini_read_real("Fleet",$"pf{i}selected",0);
	        fla.capital_health=ini_read_real("Fleet",$"pf{i}capital_hp",0);
	        fla.frigate_health=ini_read_real("Fleet",$"pf{i}frigate_hp",0);
	        fla.escort_health=ini_read_real("Fleet",$"pf{i}escort_hp",0);
	        fla.action=ini_read_string("Fleet",$"pf{i}action","");
	        fla.action_x=ini_read_real("Fleet",$"pf{i}action_x",0);
	        fla.action_y=ini_read_real("Fleet",$"pf{i}action_y",0);
	        fla.action_spd=ini_read_real("Fleet",$"pf{i}action_spd",0);
	        fla.action_eta=ini_read_real("Fleet",$"pf{i}action_eta",0);
	        // $fla.connected=ini_read_real("Fleet","pf{i}",0);
	        fla.acted=ini_read_real("Fleet",$"pf{i}acted",0);
	        fla.hurssy=ini_read_real("Fleet",$"pf{i}hurssy",0);
	        fla.hurssy_time=ini_read_real("Fleet",$"pf{i}hurssy_time",0);
	        fla.orbiting=ini_read_real("Fleet",$"pf{i}orb",0);

	        fla.complex_route = return_json_from_ini("Fleet", $"pf{i}complex_route", []);
	        fla.just_left = ini_read_real("Fleet",$"pf{i}just_left",0);

	        fla.capital = return_json_from_ini("Fleet", $"pf{i}capital", array_create(100, ""));
	        fla.capital_num = return_json_from_ini("Fleet", $"pf{i}capital_num", array_create(100, -1));
	        fla.capital_sel = return_json_from_ini("Fleet", $"pf{i}capital_sel", array_create(100, 0));
	        fla.capital_uid = return_json_from_ini("Fleet", $"pf{i}capital_uid", array_create(100, -1));


	        fla.frigate = return_json_from_ini("Fleet", $"pf{i}frigate", array_create(100, ""));
	        fla.frigate_num = return_json_from_ini("Fleet", $"pf{i}frigate_num", array_create(100, -1));
	        fla.frigate_sel = return_json_from_ini("Fleet", $"pf{i}frigate_sel", array_create(100, 0));
	        fla.frigate_uid = return_json_from_ini("Fleet", $"pf{i}frigate_uid", array_create(100, -1));


	        fla.escort = return_json_from_ini("Fleet", $"pf{i}escort", array_create(100, ""));
	        fla.escort_num = return_json_from_ini("Fleet", $"pf{i}escort_num", array_create(100, -1));
	        fla.escort_sel = return_json_from_ini("Fleet", $"pf{i}escort_sel", array_create(100, 0));
	        fla.escort_uid = return_json_from_ini("Fleet", $"pf{i}escort_uid", array_create(100, -1));	        
	    }

	    // ENEMY FLEET OBJECTS
	    num=ini_read_real("Save","en_fleets",0);
	    i=-1;fla=0;

	    repeat(num){i+=1;fla=instance_create(0,0,obj_en_fleet);
	        fla.owner=ini_read_real("Fleet",$"ef{i}owner",0);
	        fla.x=ini_read_real("Fleet",$"ef{i}x",0);
	        fla.y=ini_read_real("Fleet",$"ef{i}y",0);
	        fla.sprite_index=ini_read_real("Fleet",$"ef{i}sprite",0);
	        fla.image_index=ini_read_real("Fleet",$"ef{i}image",0);
	        fla.image_alpha=ini_read_real("Fleet",$"ef{i}alpha",1);
	        fla.capital_number=ini_read_real("Fleet",$"ef{i}capitals",0);
	        fla.frigate_number=ini_read_real("Fleet",$"ef{i}frigates",0);
	        fla.escort_number=ini_read_real("Fleet",$"ef{i}escorts",0);
	        fla.selected=ini_read_real("Fleet",$"ef{i}selected",0);
	        fla.action=ini_read_string("Fleet",$"ef{i}action","");
	        fla.action_x=ini_read_real("Fleet",$"ef{i}action_x",0);
	        fla.action_y=ini_read_real("Fleet",$"ef{i}action_y",0);
	        fla.home_x=ini_read_real("Fleet",$"ef{i}home_x",0);
	        fla.home_y=ini_read_real("Fleet",$"ef{i}home_y",0);
	        fla.target=ini_read_real("Fleet",$"ef{i}target",0);
	        fla.target_x=ini_read_real("Fleet",$"ef{i}target_x",0);
	        fla.target_y=ini_read_real("Fleet",$"ef{i}target_y",0);
	        fla.action_spd=ini_read_real("Fleet",$"ef{i}action_spd",0);
	        fla.action_eta=ini_read_real("Fleet",$"ef{i}action_eta",0);
	        fla.connected=ini_read_real("Fleet",$"ef{i}connected",0);
	        fla.loaded=ini_read_real("Fleet",$"ef{i}loaded",0);
	        fla.trade_goods=ini_read_string("Fleet",$"ef{i}trade","");
	        fla.cargo_data = return_json_from_ini("Fleet",$"ef{i}cargo",{});
	        fla.guardsmen=ini_read_real("Fleet",$"guardsmen{i}guardsmen",0);
	        fla.orbiting=ini_read_real("Fleet",$"ef{i}orb",0);
	        fla.navy=ini_read_real("Fleet",$"ef{i}navy",0);
	        fla.guardsmen_unloaded=ini_read_real("Fleet",$"ef{i}unl",0);
	        fla.turns_static=ini_read_real("Fleet",$"ef{i}turns_static",0);
	        fla.inquisitor=ini_read_real("Fleet",$"ef{i}inquis",-1);
	        fla.complex_route = return_json_from_ini("Fleet", $"ef{i}complex_route", []);

	        if (fla.navy=1){var e;e=-1;
	            repeat(20){e+=1;
	                fla.capital_imp[e]=ini_read_real("Fleet",$"ef{i}navy_cap."+string(e),0);
	                fla.capital_max_imp[e]=ini_read_real("Fleet",$"ef{i}navy_cap_max."+string(e),0);
	            }
	            e=-1;
	            repeat(30){e+=1;
	                fla.frigate_imp[e]=ini_read_real("Fleet",$"ef{i}navy_fri."+string(e),0);
	                fla.frigate_max_imp[e]=ini_read_real("Fleet",$"ef{i}navy_fri_max."+string(e),0);
	                fla.escort_imp[e]=ini_read_real("Fleet",$"ef{i}navy_esc."+string(e),0);
	                fla.escort_max_imp[e]=ini_read_real("Fleet",$"ef{i}navy_esc_max."+string(e),0);
	            }
	        }

	    }
	    with(obj_en_fleet){if (owner=0) then instance_destroy();}
	    ini_close();
	    instance_create(-100,-100,obj_event_log);
	    ini_open("tsave.ini");
	    obj_event_log.event = return_json_from_ini("Event","loglist",[]);	    	    
	    ini_close();
	}

	if (save_part=5) or (save_part=0){
	    ini_open("tsave.ini");
	    // file_delete("tsave.ini");



	    with(obj_controller){
	        scr_colors_initialize();
	        scr_shader_initialize();
	    }
	    with (obj_star){
//	    	star_ui_name_node();
	    }

	    
	    obj_controller.squads = false;

	    i=99;
	    repeat(3){i+=1;
	         var o;o=1;
	         repeat(14){o+=1;
	            if (o=11) then o=12;
	            if (o=13) then o=14;

	            obj_controller.r_race[i,o]=ini_read_real("Res",$"r_race{i}."+string(o),0);
	            obj_controller.r_role[i,o]=ini_read_string("Res",$"r_role{i}."+string(o),"");
	            obj_controller.r_wep1[i,o]=ini_read_string("Res",$"r_wep1{i}."+string(o),"");
	            obj_controller.r_wep2[i,o]=ini_read_string("Res",$"r_wep2{i}."+string(o),"");
	            obj_controller.r_armour[i,o]=ini_read_string("Res",$"r_armour{i}."+string(o),"");
	            obj_controller.r_mobi[i,o]=ini_read_string("Res",$"r_mobi{i}."+string(o),"");
	            obj_controller.r_gear[i,o]=ini_read_string("Res",$"r_gear{i}."+string(o),"");
	         }
	    }// 100 is defaults, 101 is the allowable starting equipment
	    ini_close();

	    with(obj_en_fleet){
			choose_fleet_sprite_image();
	    }
	    obj_saveload.alarm[1]=30;
	    obj_controller.invis=false;
	    global.load=0;
	    scr_image("force",-50,0,0,0,0);
	    log_message("Loading slot "+string(save_id)+" completed");
	}


}
