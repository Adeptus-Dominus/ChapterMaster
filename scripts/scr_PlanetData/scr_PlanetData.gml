// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro ARR_strength_descriptions ["none", "Minimal", "Sparse", "Moderate", "Numerous", "Very Numerous", "Overwhelming"];

function PlanetData(planet, system) constructor{
//safeguards // TODO LOW DEBUG_LOGGING // Log when tripped somewhere
    //disposition
    if (system.dispo[planet] < -100 && system.dispo[planet] > -1000 && system.p_owner[planet] != eFACTION.Player ) { // Personal Rule code be doing some interesting things
        system.dispo[planet] = -100; // TODO LOW DISPOSITION_REVAMP // Consider revamping the disposition system
    } else if (system.dispo[planet] > 100) {
        system.dispo[planet] = 100;
    }
//

	self.planet = planet;
	self.system = system;
	player_disposition = system.dispo[planet];
	planet_type = system.p_type[planet];
    operatives = system.p_operatives[planet];
    features =system.p_feature[planet];
    current_owner = system.p_owner[planet];
    origional_owner = system.p_first[planet];
    population = system.p_population[planet];
    max_population = system.p_max_population[planet];
    large_population = system.p_large[planet];
    secondary_population = system.p_pop[planet];
    is_craftworld = system.craftworld;
    is_hulk = system.space_hulk;

    static display_population = function(){
    	if (large_population){
    		return $"{population} B";
    	} else {
    		return $"{scr_display_number(population)}";
    	}
    }

    static at_war = function(){
    	var _at_war = false
    	if (current_owner>5) then _at_war=true;
        if (obj_controller.faction_status[current_owner]="War") then _at_war=true;
        return _at_war;
    }

    static owner_status = function(){
    	return obj_controller.faction_status[current_owner];
    }
    guardsmen = system.p_guardsmen[planet];
    pdf = system.p_pdf[planet];
    fortification_level  = system.p_fortified[planet];
    static alter_fortification = function(alteration){
    	system.p_fortified[planet] += alteration;
    	fortification_level = system.p_fortified[planet];
    }

    star_station = system.p_station[planet];
    pdf_loss_reduction = 0;

    // Whether or not player forces are on the planet
    player_forces = system.p_player[planet];
    defence_lasers = system.p_lasers[planet];
    defence_silos = system.p_silo[planet];
    ground_defences = system.p_defenses[planet];
    upgrades = system.p_upgrades[planet];
    // v how much of a problem they are from 1-5
    planet_forces = array_create(14, 0);

    try{
    	planet_forces[1] = player_forces;

	    planet_forces[2] =	guardsmen;

	    planet_forces[5] =	system.p_sisters[planet];
	    planet_forces[6] =	system.p_eldar[planet];
	    planet_forces[7] =	system.p_orks[planet];
	    planet_forces[8] =	system.p_tau[planet];
	    planet_forces[9] =	system.p_tyranids[planet];
		planet_forces[10] =	system.p_traitors[planet];   	
	    planet_forces[11] =	system.p_chaos[planet]+ system.p_demons[planet];

	    planet_forces[13] =	system.p_necrons[planet];
	}catch(_exception){
		handle_exception(_exception);
	}

    deamons = system.p_demons[planet];
    chaos_forces = system.p_chaos[planet];

    requests_help = system.p_halp[planet];

    // current planet heresy
    if (population == 0) {
        system.p_heresy[planet] = 0;
        system.p_heresy_secret[planet] = 0;
        for (var i = 0; i < array_length(system.p_influence[planet]); ++i) {
            system.p_influence[planet][i] = 0;
        }
    }

    corruption = system.p_heresy[planet];

    is_heretic = system.p_hurssy[planet];

    heretic_timer = system.p_hurssy_time[planet];

    secret_corruption = system.p_heresy_secret[planet];

    population_influences = system.p_influence[planet];

    raided_this_turn = system.p_raided[planet];
    // 
    governor = system.p_governor[planet];

    problems = system.p_problem[planet];
    problems_data = system.p_problem_other_data[planet];
    problem_timers = system.p_timer[planet];

    static has_problem = function(problem){
    	has_problem_planet(planet, problem, system);
    }

    static name = function(){
    	var _name="";
    	with (system){
    		_name =  planet_numeral_name(planet);
    	}
    	return _name;
    }

    static xenos_and_heretics = function(){
    	var xh_force = 0;
    	for (var i=5;i<array_length(planet_forces); i++){
    		xh_force += planet_forces[i];
    	} 
    	return xh_force;
    }
    
    static marine_training = planet_training_sequence;

    static has_feature = function(feature){
    	return planet_feature_bool(features, feature);
    }
    
    static has_upgrade= function(feature){
    	return planet_feature_bool(upgrades, feature);
    }

    static get_features = function(request_feature){
    	var _array_positions = search_planet_features(features,request_feature);
    	var _select_features = [];
  		for (var i=0;i<array_length(_array_positions);i++){
  			array_push(_select_features, features[_array_positions[i]]);
  		}
  		return _select_features;
    }
    static planet_training = function(local_screening_points){
    	var _training_happend = false;
	    if (has_feature(P_features.Recruiting_World)){
	        if (obj_controller.gene_seed == 0) and (obj_controller.recruiting > 0) {

                obj_controller.recruiting = 0;
                obj_controller.income_recruiting = 0;
                scr_alert("red", "recruiting", "The Chapter has run out of gene-seed!", 0, 0);

	        }else if (obj_controller.recruiting > 0){
	        	if (local_screening_points>0){

	           		marine_training(local_screening_points);

	           		_training_happend = true;
	        	} else {
	        		scr_alert("red", "recruiting", $"Recruitment on {name()} halted due to insufficient apothecary rescources", 0, 0);
	        	}
	        }
		}
		return _training_happend;   	
    }

    static recover_starship = function(techs){
    	try {
			var engineer_count = array_length(techs);
			if (has_feature(P_features.Starship) && engineer_count>0){
				//TODO allow total tech point usage here
		        var _starship = get_features(P_features.Starship)[0];

		        var _engineer_score_start = _starship.engineer_score;
		    	if (_starship.engineer_score<2000){
		        	for (var v=0;v<engineer_count;v++){
		        		_starship.engineer_score += (techs[v].technology/2);
		        	}
		        	scr_alert("green","owner",$"Ancient ship repairs {min((_starship.engineer_score/2000)*100, 100)}% complete",system.x,system.y);
		    	}

		        var _target_spend=10000;

		        var _maxr=floor(obj_controller.requisition/50);
		        var _requisition_spend=min(_maxr*50,array_length(techs)*50,_target_spend-_starship.funds_spent);
		        obj_controller.requisition-=_requisition_spend;
		        _starship.funds_spent+=_requisition_spend;
		    
		        if (_requisition_spend>0 && _starship.funds_spent<_target_spend){
		            scr_alert("green","owner",$"{_requisition_spend} Requision spent on Ancient Ship repairs in materials and outfitting (outfitting {(_starship.funds_spent/_target_spend)*100}%)",system.x,system.y);
		        }
		        if (_starship.funds_spent>=_target_spend && _starship.engineer_score>=2000){// u2=tar;
		        	//TODO refactor into general new ship logic
		            delete_features(features,P_features.Starship);
		        
		            var locy=$"{name()}";
		        
		            var flit=instance_create(system.x,system.y,obj_p_fleet);
		      
		        	var _slaughter = new_player_ship("Gloriana", system.name, "Slaughtersong");
		        	add_ship_to_fleet(_slaughter, flit);
		            flit.oribiting = system.id;
		        
		            scr_popup($"Ancient Ship Restored",$"The ancient ship within the ruins of {locy} has been fully repaired.  It is determined to be a Gloriana Class vessel and is bristling with golden age weaponry and armour.  Your {string(obj_ini.role[100][16])}s are excited; the Slaughtersong is ready for it's maiden voyage, at your command.","","");                
		        }
		    }    	
	    }catch (_exception){
			handle_exception(_exception);
		}
	} 

	static guard_score_calc = function(){
		guard_score = 0;
        if (guardsmen < 500 && guardsmen>0) {
		    guard_score = 0.1;
		} else if (guardsmen >= 100000000) {
		    guard_score = 7;
		} else if (guardsmen >= 50000000) {
		    guard_score = 6;
		} else if (guardsmen >= 15000000) {
		    guard_score = 5;
		} else if (guardsmen >= 6000000) {
		    guard_score = 4;
		} else if (guardsmen >= 1000000) {
		    guard_score = 3;
		} else if (guardsmen >= 100000) {
		    guard_score = 2;
		} else if (guardsmen >= 2000) {
		    guard_score = 1;
		} else {
		    guard_score = 0.5;
		}

		return guard_score;
	}

	static continue_to_planet_battle = function(stop){

	    var _nids_real = planet_forces[eFACTION.Tyranids];
	    var _nids_score = _nids_real < 4 ? 0 : _nids_real;
	    var _nid_diff = _nids_score-_nids_real;

	    if (chaos_forces==6.1) and (_nids_real>0) then tyranids_score=_nids_real;

	    if (current_owner == eFACTION.Tau){
 			stop = (xenos_and_heretics() + _nid_diff + player_forces + planet_forces[eFACTION.Ecclesiarchy]) <= 0;
	    }
	   	
	   	if (stop){
	   		if (planet_forces[eFACTION.Ork]>0) and (planet_forces[eFACTION.Ecclesiarchy]>0) then stop=0;
	   	}

	    var imperium_forces = ((guardsmen>0) or (pdf>0) or (planet_forces[eFACTION.Ecclesiarchy]>0));

	    if (stop){
	    	if (planet_forces[eFACTION.Necrons]>=5 || planet_forces[eFACTION.Tyranids]>=5 && imperium_forces) then stop=0;
	    }


	    //tau fight imperial
	    if (stop){
	    	if (current_owner = eFACTION.Tau){
				if ((guardsmen>0) or (planet_forces[eFACTION.Ecclesiarchy]>0)) and ((pdf>0) or (planet_forces[eFACTION.Tau]>0)) then stop=0;
	    	}
	    	
	    }
    
	    // Attack heretics whenever possible, even player controlled ones
	    if (stop){
	    	if (player_forces+pdf>0) and (guardsmen>0) and (obj_controller.faction_status[2]="War") then stop=0;
	    }
	    if (stop){
	    	if (player_forces+pdf>0) and (planet_forces[eFACTION.Ecclesiarchy]>0) and (obj_controller.faction_status[5]="War") then stop=0;
	    }

	    return stop;
	}

	static pdf_will_support_player = function(){
		if (current_owner== eFACTION.Tau){
			return false;
		}
		if (has_feature(P_features.Gene_Stealer_Cult) && current_owner==eFACTION.Tyranids){
			return false;
		}

		if ((current_owner=1 || obj_controller.faction_status[2]!="War") && pdf){
			return true;
		}
		return false;
	}

	static guard_attack_matrix = function(){
		var guard_attack = "";
	    // if (p_eldar[planet]>0) and (p_owner[planet]!=6) then guard_attack="eldar";
	    //if (planet_forces[eFACTION.Tau] + planet_forces[eFACTION.Ork] + planet_forces[eFACTION.Heretics]+ planet_forces[eFACTION.Chaos])
	    if (planet_forces[eFACTION.Tau]>0) then guard_attack="tau";
	    if (planet_forces[eFACTION.Ork]>0) then guard_attack="ork";
	    if (planet_forces[eFACTION.Heretics]>0){
	    		    // Always goes after traitors first, unless
	    	guard_attack="traitors";
			if (planet_forces[eFACTION.Heretics]<=1 && planet_forces[eFACTION.Tau]>=4) and (current_owner!=8) then guard_attack="tau";	    	
	    }
	    if (planet_forces[eFACTION.Chaos]>0) then guard_attack="csm";
	    if (pdf>0) and (current_owner=eFACTION.Tau) then guard_attack="pdf";

	    if (current_owner = eFACTION.Player){
	    	if (pdf>0 && obj_controller.faction_status[2]=="War") then guard_attack="pdf";
	    }
	    if (planet_forces[eFACTION.Tyranids]<=1) and (planet_forces[eFACTION.Ork]>=4) then guard_attack="ork";
	    // if (p_tyranids[planet]>0) and (guard_attack="") then guard_attack="tyranids";
	    if (planet_forces[eFACTION.Tyranids]>=4){
	    	guard_attack="tyranids";
	    }else if (planet_forces[eFACTION.Tyranids]<4 && planet_forces[eFACTION.Tyranids]>0){
			 if (has_feature(P_features.Gene_Stealer_Cult)){
	 			var _hidden_cult = get_features(P_features.Gene_Stealer_Cult)[0].hiding;
	 			if (!_hidden_cult){
	 				guard_attack="tyranids";
	 			}
	 		}
	    }	

	    return guard_attack;		
	}


	static pdf_attack_matrix = function(){
		var _no_notable_traitors = planet_forces[eFACTION.Heretics]<=1;
		var _pdf_attack = "";
		if (planet_forces[eFACTION.Tyranids]>=4 && !has_feature(P_features.Gene_Stealer_Cult)){
			_pdf_attack = "tyranids";
		}

		if (_no_notable_traitors &&  _pdf_attack=="") {
			if ((planet_forces[eFACTION.Ork]>=4)){
				_pdf_attack="ork";
			} else if (planet_forces[eFACTION.Tau]>=4 && current_owner!=8){
				_pdf_attack="tau";
			}
		} 
		if (guardsmen && _pdf_attack==""){
			if (obj_controller.faction_status[2]=="War"){
				if (pdf_will_support_player()){
					_pdf_attack="guard";
				}
			} else if (current_owner == eFACTION.Tau){
				_pdf_attack="guard";
			}
		}

		if (_pdf_attack==""){
			if (planet_forces[eFACTION.Chaos]>0){
				_pdf_attack="csm";
			} else if (planet_forces[eFACTION.Heretics]>0){
				_pdf_attack="traitors";
			} else if ((planet_forces[eFACTION.Ork]>0)){
				_pdf_attack="ork";
			} else  if (planet_forces[eFACTION.Tau]>0) and (current_owner!=eFACTION.Tau){
				_pdf_attack="tau";
			}
		}
        // Always goes after traitors first, unless
        return _pdf_attack;				
	}

	static pdf_loss_reduction_calc = function(){
		pdf_loss_reduction = fortification_level*0.001;
		if (pdf_will_support_player()){
			pdf_loss_reduction+=garrison.viable_garrison*0.0005;
		}
		return pdf_loss_reduction;
	}

	static pdf_defence_loss_to_orks = function(){
		var active_garrison = pdf_will_support_player() && garrison.viable_garrison>0;
        if (planet_forces[eFACTION.Ork]>=4) and (pdf>=30000){
        	pdf=floor(pdf*(min(0.95, 0.55+pdf_loss_reduction)));
    	}
        else if (planet_forces[eFACTION.Ork]>=4 && pdf<30000 && pdf>=10000){
        	pdf=active_garrison?pdf*0.4:0;
        }
        else if (planet_forces[eFACTION.Ork]>=3) and (pdf<10000){
        	pdf=active_garrison?pdf*0.4:0;
        }
        else if (planet_forces[eFACTION.Ork]<3 && pdf>30000){
        	pdf=floor(pdf*(min(0.95, 0.7+pdf_loss_reduction)));
        }
        if (planet_forces[eFACTION.Ork]>=2) and (pdf<2000){ pdf=0;}
        if (planet_forces[eFACTION.Ork]>=1) and (pdf<200){ pdf=0;}

        system.p_pdf[planet] = pdf;
	}


	static planet_info_screen = function(){
		var improve=0
        var xx=15;
        var yy=25;
        var current_planet=obj_controller.selecting_planet;
        var nm=scr_roman(current_planet), temp1=0;
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14);
        
        var _xenos_and_heretics = xenos_and_heretics();
        if (current_owner<=5) and (!_xenos_and_heretics){
            if (planet_forces[eFACTION.Player]>0||system.present_fleet[1]>0){
                if (fortification_level<5) then improve=1;
            }
        }
        
        // Draw disposition here
        var yyy=0;

        var _succession = has_problem("succession");

        if ((player_disposition>=0 && current_owner<=5 && population>0)) and (_succession=0){
            var wack=0;
            draw_set_color(c_blue);
            draw_rectangle(xx+349,yy+175,xx+349+(min(100,player_disposition)*3.68),yy+192,0);
        }
        draw_set_color(c_gray);
        draw_rectangle(xx+349,yy+175,xx+717,yy+192,1);
        draw_set_color(c_white);
        
        var player_dispo = player_disposition;
        if (!_succession){
            if (player_dispo>=0) and (origional_owner<=5) and (current_owner<=5) and (population>0) then draw_text(xx+534,yy+176,"Disposition: "+string(min(100,player_dispo))+"/100");
            if (player_dispo>-30) and (player_dispo<0) and (current_owner<=5) and (population>0){
                draw_text(xx+534,yy+176,"Disposition: ???/100");
            }
            if ((player_dispo>=0) and (origional_owner<=5) and (current_owner>5)) or (population<=0){
                draw_text(xx+534,yy+176,"-------------");
            }

            if (player_dispo<=-3000) then draw_text(xx+534,yy+176,"Disposition: N/A");
        } else  if (_succession=1) then draw_text(xx+534,yy+176,"War of _Succession");
        draw_set_color(c_gray);
        // End draw disposition
        draw_set_color(c_gray);
        draw_rectangle(xx+349,yy+193,xx+717,yy+210,0);
        var bar_width = 717-349;
        var bar_start_point = xx+349;
        var bar_percent_length = (bar_width/100);
        var current_bar_percent = 0;
        var hidden_cult = false;
        if (has_feature(P_features.Gene_Stealer_Cult)){
            hidden_cult = get_features(P_features.Gene_Stealer_Cult)[0].hiding;
        }          
        
        for (var i=1;i<13;i++){
            if (population_influences[i]>0){
                draw_set_color(global.star_name_colors[i]);
                if (hidden_cult){
                    draw_set_color(global.star_name_colors[eFACTION.Imperium]);
                }
                var current_start = bar_start_point+(current_bar_percent*bar_percent_length)
                draw_rectangle(current_start,yy+193,current_start+(bar_percent_length*population_influences[i]),yy+210,0);
                current_bar_percent+=population_influences[i];
            }
            draw_set_color(c_gray);
        }

        draw_set_color(c_white);   
        draw_text(xx+534,yy+194,"Population Influence");
        yy+=20;
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        if (!is_craftworld && !is_hulk) then draw_text(xx+480,yy+196,$"{system.name} {nm}  ({planet_type})");
        if (is_craftworld) then draw_text(xx+480,yy+196,string(system.name)+" (Craftworld)");
        // if (is_craftworld=0) and (is_hulk=0) then draw_text(xx+534,yy+214,string(planet_type)+" World");
        // if (is_craftworld=1) then draw_text(xx+594,yy+214,"Craftworld");
        if (is_hulk) then draw_text(xx+480,yy+196,"Space Hulk");
        
        // draw_sprite(spr_planet_splash,temp1,xx+349,yy+194);
        scr_image("ui/planet",scr_planet_image_numbers(planet_type),xx+349,yy+194,128,128);
        draw_rectangle(xx+349,yy+194,xx+477,yy+322,1);
        draw_set_font(fnt_40k_14);
        
        var pop_string = $"Population: {display_population()}";

        if (instance_exists(obj_star_select)){
            var _button_manager = obj_star_select.button_manager;
            _button_manager.update({
                label:pop_string,
                tooltip : "population data toggle with 'P'",
                keystroke : press_exclusive(ord("P")),
                x1 : xx+480,
                y1 : yy+217,
                w : 200,
                h : 22
            });
            _button_manager.update_loc();
            if (_button_manager.draw()){
                obj_star_select.population = !obj_star_select.population;
                if (obj_star_select.population){
                    obj_star_select.potential_doners = find_population_doners(system.id);
                }
            }
        }
        
        if (is_craftworld=0) and (is_hulk=0){
            var y7=240,temp3=string(scr_display_number(guardsmen));
            if (guardsmen>0){
                draw_text(xx+480,yy+y7,$"Imperial Guard: {temp3}");
                y7+=20;
            }
            var temp4=string(scr_display_number(pdf));
            if (current_owner!=8){
                draw_text(xx+480,yy+y7,$"Defense Force: {temp4}");
            }
            if (current_owner=8){
                draw_text(xx+480,yy+y7,$"Gue'Vesa Force:  {temp4}");
            }
        }
        
        var temp5="";
        
        
        if (!is_hulk){
            if (improve=1){
                draw_set_color(c_green);
                draw_rectangle(xx+481,yy+280,xx+716,yy+298,0);
                draw_sprite(spr_requisition,0,xx+657,yy+283);
                
                
                var improve_cost=1500,yep=0,o=0;

                if (scr_has_adv("Siege Masters")){
                	improve_cost=1100;
                }
                
                draw_text_glow(xx+671, yy+281,improve_cost,16291875,0);
                
                if (scr_hit(xx+481,yy+282,xx+716,yy+300)){
                    draw_set_color(0);
                    draw_set_alpha(0.2);
                    draw_rectangle(xx+481,yy+280,xx+716,yy+298,0);
                    if (scr_click_left()) and (obj_controller.requisition>=improve_cost){
                        obj_controller.requisition-=improve_cost;
                        alter_fortification(1);
                        
                        if (player_disposition>0) and (player_disposition<=100){
                            player_disposition=min(100,player_disposition+(9-fortification_level));
                        }
                    }
                    
                }
                draw_set_alpha(1);
                draw_set_color(0);
            }
            var forti_string = ["None", "Sparse","Light","Moderate","Heavy","Major","Extreme"];
            var planet_forti = $"Defenses: {forti_string[fortification_level]}";

            draw_text(xx+480,yy+280,planet_forti);
        }
        
        draw_set_color(c_gray);
        
        if (is_hulk=1){
            temp5="Integrity: "+string(floor(fortification_level*20))+"%";
            draw_text(xx+480,yy+280,temp5);
        }
        
        var temp6="???";
        var target_planet_heresy=corruption;

        if (target_planet_heresy < 0) {
            temp6 = "DEBUG: Heresy below 0!"
        } else if (target_planet_heresy <= 10) {
            temp6 = "None";
        } else if (target_planet_heresy <= 30) {
            temp6 = "Little";
        } else if (target_planet_heresy <= 50) {
            temp6 = "Major";
        } else if (target_planet_heresy <= 70) {
            temp6 = "Heavy";
        } else if (target_planet_heresy <= 96) {
            temp6 = "Extreme";
        } else if (target_planet_heresy <= 100) {
            temp6 = "Maximum";
        } else if (target_planet_heresy > 100) {
            temp6 = "DEBUG: Heresy above 100!";
        } else {
            temp6 = "DEBUG: Heresy somehow unknown value!"
        }

        draw_text(xx+480,yy+300,$"Corruption: {temp6}");
        
        
        draw_set_font(fnt_40k_14b);
        draw_text(xx+349,yy+326,"Planet Forces");
        draw_text(xx+535,yy+326,"Planet Features");
        draw_set_font(fnt_40k_14);
        
        
        var temp8="",t=-1;
        repeat(8){
            var ahuh,ahuh2,ahuh3;ahuh="";ahuh2=0;ahuh3=0;t+=1;
            with (system){
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
        
        
        var to_show=0,temp9="";t=-1;

        var fit =  array_create(11, "");
        var planet_displays = [], i;
        var feat_count, _cur_feature;
        var feat_count = array_length(features);
        var upgrade_count = array_length(upgrades);
        var size = ["", "Small", "", "Large"];
        if ( feat_count > 0){
            for (i =0; i <  feat_count ;i++){
                cur_feature= features[i]
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
                var _upgrade = upgrades[i];
                if (_upgrade.f_type == P_features.Secret_Base){
                    if (_upgrade.forge>0){
                        var forge = _upgrade.forge_data;
                        var size_string= $"{size[forge.size]} Chapter Forge"
                        array_push(planet_displays, [size_string, forge]);
                    }
                }
            }
        }

        for (i=0;i<array_length(problems);i++){
            if (problems[i]=="") then continue;
            problem_data = problems_data[i];
            if (struct_exists(problem_data, "stage")){
                if (problem_data.stage == "preliminary"){
                    var mission_string  = $"{problem_data.applicant} Audience";
                    problem_data.f_type = P_features.Mission;
                    problem_data.time = problem_timers[i];
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
                    obj_star_select.feature = new FeatureSelected(planet_displays[i][1], system, current_planet);
                } else {
                    obj_star_select.feature = "";
                }
            }
        }
        if (obj_controller.selecting_planet>0){
            var current_planet=obj_controller.selecting_planet;
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            
            /*if (obj_controller.recruiting_worlds_bought>0) and (system.p_owner[obj_controller.selecting_planet]<=5) and (obj_controller.faction_status[system.p_owner[obj_controller.selecting_planet]]!="War"){
                if (string_count("Recr",system.p_feature[obj_controller.selecting_planet])=0){
                    button4="+Recruiting";
                }
            }*/
            
            /*if (origional_owner=1){
                if (mouse_x>=xx+363) and (mouse_y>=yy+194) and (mouse_x<xx+502) and (mouse_y<yy+204){
                    if (string_count("Monastery",features)>0){
                        var wid,hei,tex;draw_set_halign(fa_left);
                        tex=string(system.p_lasers[current_planet])+" Defense Laser, "+string(system.p_defenses[current_planet])+" Weapon Emplacements, "+string(system.p_silo[current_planet])+" Missile Silo";
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
}
