
function specialistfunct (specialist, req_exp) {
    var spec_tips = [
        string("{0} Potential", obj_ini.role[100][16]),
        string("{0} Potential", obj_ini.role[100][15]),
        string("{0} Potential", obj_ini.role[100][14]),
        string("{0} Potential", obj_ini.role[100][17]),
        string("{0} Applicant", obj_ini.role[100][16]),
        string("{0} Applicant", obj_ini.role[100][15]),
        string("{0} Applicant", obj_ini.role[100][14]),
        string("{0} Applicant", obj_ini.role[100][17]),
        string("Promote to Marine")
    ];

    var colors;
    var tips_list = [0, 0, spec_tips[8]];
    var spec_tip;
    switch (specialist) {
        case "Techmarine":
            colors = [c_dkgray, c_red];
            tips_list[0] = spec_tips[0];
            tips_list[1] = spec_tips[4];
            break;
        case "Librarian":
            colors = [c_white, c_aqua];
            tips_list[0] = spec_tips[3];
            tips_list[1] = spec_tips[7];
            break;
        case "Chaplain":
            colors = [c_black, c_yellow];
            tips_list[0] = spec_tips[2];
            tips_list[1] = spec_tips[6];
            break;
        case "Apothecary":
            colors = [c_red, c_white];
            tips_list[0] = spec_tips[1];
            tips_list[1] = spec_tips[5];
            break;
    }

    if (role() == obj_ini.role[100][12]) {
        colors[0] = c_fuchsia;
    }

    if (experience < req_exp) {
        colors = array_reverse(colors);
    }

    if (experience >= req_exp) {
        if (!(role() == obj_ini.role[100][12])) {
            spec_tip = tips_list[1];
        } else {
            spec_tip = tips_list[2];
        }
    } else {
        spec_tip = tips_list[0];
    }

    return {spec_tip: spec_tip, colors: colors};
};


function apothecary_training(){
	// ** Training **
	// * Apothecary *
	var recruit_count=0;
	var training_points_values = ARR_apothecary_training_tiers;
	apothecary_recruit_points += training_points_values[training_apothecary]

	novice_type = string("{0} Aspirant",obj_ini.role[100][15])
	if (training_apothecary>0){
	    recruit_count=scr_role_count(novice_type,"");

	    if (apothecary_recruit_points>=48){
	        if (recruit_count>0){
	            random_marine=scr_random_marine(novice_type,0);
	            // show_message(marine_position);
	            // show_message(obj_ini.role[0,marine_position]);
	            if (random_marine != "none"){
	                marine_position=random_marine[1];
	                marine_company=random_marine[0];
	                apothecary_recruit_points-=48;
	                unit = fetch_unit(random_marine);
	                scr_alert("green","recruitment",unit.name_role()+" has finished training.",0,0);
	                unit.update_role(obj_ini.role[100][15]);
	                unit.add_exp(10);

	                warn="";
	                if (unit.update_weapon_one(obj_ini.wep1[100,15]) == "no_items"){
	                    warn += $", {obj_ini.wep1[100,15]}";
	                }
	                if (unit.update_weapon_two(obj_ini.wep2[100,15]) == "no_items"){
	                    warn += $", {obj_ini.wep2[100,15]}";
	                }
	                if (unit.update_gear(obj_ini.gear[100,15]) == "no_items"){
	                    warn += $", {obj_ini.gear[100,15]}";
	                }
	               
	                if (warn!=""){
	                    warn+=".";
	                    scr_alert("red","recruitment","Not enough equipment: "+string(warn),0,0);
	                }
	                
	                with(obj_ini){
	                	scr_company_order(0);
	                }
	            }
	        } else {
	            apothecary_recruit_points=0;
	        }
	    }else if (apothecary_recruit_points>=4) and (recruit_count==0){
	    	var _data = spec_train_data[3];
	        var marine_company=0;
	        var random_marine=scr_random_marine(
	            [
	            	obj_ini.role[100][8],
	            	obj_ini.role[100][18],
	            	obj_ini.role[100][10],
	            	obj_ini.role[100][9]
	            ],
	            _data.min_exp,
	            {
	            	"stat":_data.req
	            }
	        );

	        if (random_marine != "none"){
	            marine_position=random_marine[1];
	            marine_company=random_marine[0];
	            // This gets the last open slot for company 0
	            var open_slot = find_company_open_slot(0);
	            if (open_slot!=-1){
	                scr_move_unit_info(marine_company,0, marine_position, open_slot)
	                unit = fetch_unit([0,open_slot]);
	                unit.update_role(novice_type);
	                unit.update_gear("");
	                unit.update_mobility_item("");
	                scr_alert("green","recruitment",unit.name_role()+" begins training.",0,0);
	                with(obj_ini){
	                    scr_company_order(marine_company);
	                    scr_company_order(0);
	                }
	            }                  
	        } else {
	            scr_alert("red","recruitment","No marines available for apothecary traning",0,0);
	        }
	    }
	}	
}


function chaplain_training(){
	// * Chaplain training *
	// TODO add functionality for Space Wolves and Iron Hands
	var recruit_count=0;
	var training_points_values = ARR_chaplain_training_tiers;
	if (global.chapter_name!="Space Wolves") and (global.chapter_name!="Iron Hands"){
		chaplain_points += training_points_values[training_chaplain];
	    novice_type = string("{0} Aspirant",obj_ini.role[100][14]);

	    if (training_chaplain>0){
	        recruit_count=scr_role_count(novice_type,"");
	        if (chaplain_points>=48){
	            if (recruit_count>0){
	                random_marine=scr_random_marine(novice_type,0);
	                if (random_marine != "none"){
	                    marine_position = random_marine[1];
	                    unit = fetch_unit(random_marine);
	                    scr_alert("green","recruitment",unit.name_role()+" has finished training.",0,0);
	                    chaplain_points-=48;
	                    unit.update_role(obj_ini.role[100][14]);
	                    unit.add_exp(10);
	                    chaplain_aspirant=0;
	                    warn="";
	                    if (unit.update_weapon_one(obj_ini.wep1[100,14]) == "no_items"){
	                        warn += $", {obj_ini.wep1[100,14]}";
	                    }
	                    if (unit.update_weapon_two(obj_ini.wep2[100,14]) == "no_items"){
	                        warn += $", {obj_ini.wep2[100,14]}";
	                    }
	                    if (unit.update_gear(obj_ini.gear[100,14]) == "no_items"){
	                        warn += $", {obj_ini.gear[100,14]}";
	                    }
	                   
	                    if (warn!=""){
	                        warn+=".";
	                        scr_alert("red","recruitment","Not enough equipment: "+string(warn),0,0);
	                    }
	                    with(obj_ini){scr_company_order(0);}                
	                }
	            } else{
	                chaplain_points=0;
	            }
	        }else if (chaplain_points>=4) and (recruit_count==0){
	        	var _data = spec_train_data[2]; 
	            var marine_company=0;
	            random_marine=scr_random_marine(
	                [
	                	obj_ini.role[100][8],
	                	obj_ini.role[100][18],
	                	obj_ini.role[100][10],
	                	obj_ini.role[100][9]
	                ],
	                _data.min_exp,
	                {
	                	"stat":_data.req
	                }
	            );
	            if (random_marine != "none"){
	                marine_position = random_marine[1];
	                marine_company = random_marine[0];
	            	var open_slot = find_company_open_slot(0);
	                if (open_slot!=-1){
	                    chaplain_aspirant=1;
	                    scr_move_unit_info(marine_company,0, marine_position, open_slot);
	                    unit = fetch_unit([0,open_slot]);
	                    unit.update_role(novice_type)
	                    unit.update_gear("");
	                    unit.update_mobility_item("");
	                    scr_alert("green","recruitment",unit.name_role()+" begins training.",0,0);
	                    with(obj_ini){
	                        scr_company_order(marine_company);
	                        scr_company_order(0);
	                    }
	                }                      
	            }
	        }
	    }
	}	
}


function librarian_training(){
	var recruit_count=0;
	// * Psycher Training *
	var training_points_values = ARR_chaplain_training_tiers;
	psyker_points += training_points_values[training_psyker];

	var goal=60,yep=0;
	novice_type = string("{0} Aspirant",obj_ini.role[100,17]);
	if (scr_has_adv("Psyker Abundance")){
	    goal=40;
	    yep=1;
	}


	if (training_psyker>0){
	    recruit_count=scr_role_count(novice_type,"");
	    if (psyker_points>=goal){
	        if (recruit_count>0){
	            marine_position=0;
	            random_marine=scr_random_marine(novice_type,0,{"stat":[["psionic", 8, "more"]]});
	            if (random_marine != "none"){

	                unit = fetch_unit(random_marine)
	                psyker_points-=48;
	                psyker_aspirant=0;

	                scr_alert("green","recruitment",unit.name_role()+" has finished training.",0,0);
	                unit.update_role("Lexicanum");
	                with(obj_ini){scr_company_order(0);}
	            }
	        }else {
	            psyker_points=0;
	        }
	    } else if (psyker_points>=4) and (recruit_count==0){

        	var _data = spec_train_data[1]; 
            var marine_company=0;
            var random_marine=scr_random_marine(
                [
                	obj_ini.role[100][8],
                	obj_ini.role[100][18],
                	obj_ini.role[100][10],
                	obj_ini.role[100][9]
                ],
                _data.min_exp,
                {
                	"stat":_data.req
                }
            );
	        if (random_marine == "none"){
	            training_psyker=0;
	            scr_alert("red","recruitment","No remaining warp sensitive marines for training",0,0);
	        }else if (random_marine != "none"){
	            // This gets the last open slot for company 0
	            marine_position = random_marine[1];
	            marine_company = random_marine[0];
	            var open_slot = find_company_open_slot(0);
	            scr_move_unit_info(marine_company,0, marine_position, open_slot);
	            unit = fetch_unit([0,open_slot]);
	            unit.update_role(novice_type)
	            unit.update_powers();
	            psyker_aspirant=1;
	            
	            if (scr_has_adv("Psyker Abundance")){
	                unit.add_exp(irandom_range(5, 8));
	            }

	            unit.update_gear("");
	            unit.update_mobility_item("");
	            scr_alert("green","recruitment",unit.name_role()+" begins training.",0,0);
	            with(obj_ini){
	                scr_company_order(marine_company);
	                scr_company_order(0);
	            }  
	        }
	    }
	}
}

function techmarine_training(){
	var recruit_count=0;

	var training_points_values = [ 0, 1,2,4,6,10,14];
	tech_points += training_points_values[training_techmarine];
	novice_type = string("{0} Aspirant",obj_ini.role[100][16]);
	if (training_techmarine>0){
	    recruit_count=scr_role_count(novice_type,"");

	    if (tech_points>=360){
	        if (recruit_count>0){
	            random_marine=scr_random_marine(novice_type,0);
	            if (random_marine != "none"){
	                unit = fetch_unit(random_marine)
	                tech_points-=360;

	                unit.update_role(obj_ini.role[100][16]);
	                unit.add_exp(30);
	                
	                t=0;
	                r=0;
	                unit.religion="cult_mechanicus";
                    if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                        unit.add_trait("mars_trained");
	                    scr_alert("green","recruitment",$"{unit.name()} returns from Mars, a {unit.role()}.",0,0);
                    } else {
                        unit.add_trait("chapter_trained_tech");
                        scr_alert("green","recruitment",$"{unit.name_role()} has finished training.",0,0);
                    }

	                 warn="";
	                if (unit.update_weapon_one(obj_ini.wep1[100,16]) == "no_items"){
	                    warn += $", {obj_ini.wep1[100,16]}"
	                }
	                if (unit.update_weapon_two(obj_ini.wep2[100,16]) == "no_items"){
	                    warn += $", {obj_ini.wep2[100,16]}"
	                }
	                if (unit.update_gear(obj_ini.gear[100,16]) == "no_items"){
	                    warn += $", {obj_ini.gear[100,16]}"
	                }
	               
	                if (warn!=""){
	                    warn+=".";
	                    scr_alert("red","recruitment","Not enough equipment: "+string(warn),0,0);
	                }

                    if (obj_ini.loc[unit.company][unit.marine_number] == "Terra") {
                        unit.allocate_unit_to_fresh_spawn("default");
                    }

	 				var extra_bio = 0;
	                if (global.chapter_name!="Iron Hands"|| !unit.has_trait("flesh_is_weak")){
	                	extra_bio = unit.bionics<4 ? choose(1,2,3): 1
	                } else {
	                	extra_bio = choose(4,5,6);
	                }
	                repeat(extra_bio){
	                	unit.add_bionics();
	                }
	                // 135 ; probably also want to increase the p_player by 1 just because
	                with(obj_ini){scr_company_order(0);}
	            }
	        } else {
	            tech_points=0;
	        }
	    }else if (tech_points>=4) and (recruit_count==0){    
	        marine_position=0;
        	var _data = spec_train_data[0];
            var marine_company=0;
            var random_marine=scr_random_marine(
                [
                	obj_ini.role[100][8],
                	obj_ini.role[100][18],
                	obj_ini.role[100][10],
                	obj_ini.role[100][9]
                ],
                _data.min_exp,
                {
                	"stat":_data.req
                }
            );
	        if (random_marine != "none"){
	            marine_position = random_marine[1];
	            marine_company = random_marine[0];
	            // This gets the last open slot for company 0
	            var open_slot = find_company_open_slot(0);
	            if (open_slot!=-1){
	                scr_move_unit_info(marine_company,0, marine_position, open_slot);
	                unit=fetch_unit([0,open_slot]);
	                unit.update_role(novice_type);

	                // Remove from ship
                    if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                        if (unit.ship_location>-1){
                            var man_size=unit.get_unit_size();
                            obj_ini.ship_carrying[unit.ship_location]-=man_size;
                        }
                        obj_ini.loc[0][open_slot]="Terra";
                        unit.planet_location=4;
                        unit.ship_location=-1;
                    }
	                unit.update_weapon_one("");
	                unit.update_weapon_two("");
	                unit.update_gear("");
	                unit.update_mobility_item("");
                    if (obj_controller.faction_status[eFACTION.Mechanicus] != "War") {
                        scr_alert("green","recruitment",$"{unit.name_role()} journeys to Mars.",0,0);
                    } else {
                        scr_alert("green","recruitment",$"{unit.name_role()} begins training.",0,0);
                    }
	                with(obj_ini){
	                    scr_company_order(marine_company);
	                    scr_company_order(0);
	                }
	            }    
	        } else{
	            training_techmarine = 0;
	            scr_alert("red",string("recruitment","No marines with sufficient technology aptitude for {0} training",obj_ini.role[100][16]),0,0);
	        }
	    }
	}
}
