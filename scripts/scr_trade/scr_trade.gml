
function TradeAttempt(diplomacy){
	diplomacy_faction = diplomacy;
	relative_trade_values = {
		"Test" : 5000,
		"Requisition" : 1,
		"Recruiting Planet" : disposition[2]<70 ? 4000 : 2000,
		"License: Repair" : 750,
		"License: Crusade" : 1500,
		"Terminator Armour" : 400,
		"Tartaros" : 900,s
		"Land Raider" : 800,
		"Castellax Battle Automata" : 1200,
		"Minor Artifact" : 250,
		"Skitarii" : 15,
		"Techpriest" : 450,
		//"Condemnor Boltgun" : 20,
		"Hellrifle" : 20,
		"Incinerator" : 20,
		"Crusader" : 20,
		"Exterminatus" : 1500,
		"Cyclonic Torpedo" : 3000,
		"Eviscerator" : 20,
		"Heavy Flamer" : 12,
		"Inferno Bolts" : 5,
		"Sister of Battle" : 40,
		"Sister Hospitaler" : 75,
		"Eldar Power Sword" : 50,
		"Archeotech Laspistol" : 150,
		"Ranger" : 100,
		"Useful Information" : 600,
		"Power Klaw" : 50,
		"Ork Sniper" : 30,
		"Flash Git" : 60,
	}

	clear_button = new UnitButtonObject({
		x1 : 510,
		y1 : 649,
		label : "Clear",
		bind_method = function(){
			trade_likely="";
			var _offer_length = array_length(offer_options);
			var _demand_length = array_length(offer_options)
			var trade_options = max(_demand_length,_offer_length)
			for (var i=0;i<trade_options;i++){
				if (i<_offer_length){
					offer_options[i].number = 0;
				}
				if (i<_demand_length){
					demand_options[i].number = 0;
				}			
			}
		}
	});

	static successful_trade_attempt = function(){
		var trading_object = {};
		for (var i=0;i<array_length(demand_options);i++){
			var _opt = demand_options[i];
			if (_opt.number == 0){
				continue;
			}			
			var _type = _opt.label;
			if (_opt.trade_type == "equip"){
				if (!struct_exists(trading_object, "items")){
					trading_object.items = {};
				}
				trading_object.items[$ _type] = {
					quality : "standard",
					number : opt.number,
				}
			} else if (_opt.trade_type == "license"){
				switch (label){
					case "Recruiting Planet":
						obj_controller.recruiting_worlds_bought++;
						obj_controller.liscensing=5;
						break;
					case "License: Repair":
						obj_controller.repair_ships = true;
						break;
					case "Useful Information":
						obj_controller.liscensing=5;
						break;
					case "License: Crusade":
						obj_controller.liscensing=2;
						break;												
				}
			} else if (_opt.trade_type == "req"){
				obj_controller.requisition += _opt.number;
			}
		}
		for (var i=0;i<array_length(offer_options);i++){
			var _opt = offer_options[i];
			if (_opt.number == 0){
				continue;
			}
			var _type = _opt.label;	
			if (_opt.trade_type == "equip"){

			} else if (_opt.trade_type == "req"){
				controller.requisition -= _opt.number;
				if (_opt.number > 500 && diplomacy_faction==6){
	                var got2=0;
	                with (obj_controller){
		                repeat(10){
		                	if (got2<50){
		                		got2+=1;
				                	if (quest[got2]="fund_elder") and (quest_faction[got2]=6){
				                    scr_dialogue("mission1_thanks");
				                    scr_quest(2,"fund_elder",6,0);
				                    got2=50;
				                    trading=0;
				                    exit;
			                	}
			                }
		            	}
		            }					
				}
			} else if (_opt.trade_type == "gene"){
				gene_seed-=_opt.number;
                if (diplomacy_faction<=5) and (diplomacy_faction!=4) then obj_conotroller.gene_sold+=_opt.number;
                if (diplomacy_faction>=6) then obj_controller.gene_xeno+=_opt.number;				
			} else if(_opt.trade_type == "stc"){
                for (var j = 0; j < 100; j += 1) {
                    var p = choose(1, 2, 3);
                    if (p == 1 && obj_controller.stc_wargear_un > 0) {
                        obj_controller.stc_wargear_un -= 1;
                        break;
                    }
                    if (p == 2 && obj_controller.stc_vehicles_un > 0) {
                        obj_controller.stc_vehicles_un -= 1;
                        break;
                    }
                    if (p == 3 && obj_controller.stc_ships_un > 0) {
                        obj_controller.stc_ships_un -= 1;
                        break;
                    }
                }
			} else if(_opt.trade_type == "info"){
				obj_controller.info_chips-=_opt.number;
			}
		}

		var flit = setup_ai_trade_fleet();

		flit.cargo_data.player_goods = trading_object;

		flit.target = trade_to_obj;
		flit.x = trade_from_star.x;
		flit.y = trade_from_star.y;
		with (flit){
			action_x=target.x;
	        action_y=target.y;
	        set_fleet_movement();
		}

	}

	static find_trade_locations(){
 		if (obj_ini.fleet_type=ePlayerBase.home_world){
 			var _stars_with_player_control = [];
	 		with(obj_star){
	 			if (array_contains(p_owner, 1)){
	 				array_push(_stars_with_player_control, id)
	 			}
		    }

		    var player_fleet_targets = [];

		    if (obj_ini.fleet_type != ePlayerBase.home_world || !arraay_length(_stars_with_player_control)){
		        // with(obj_star){if (present_fleet[1]>0){x-=10000;y-=10000;}}
		        with(obj_p_fleet){// Get the nearest star system that is viable for creating the trading fleet
		            if ((capital_number>0 || frigate_number>0) && action=""){
		            	array_push(player_fleet_targets, id);
		            }
		   
		        }
		    }


		    // temp2: ideal trade target
		    // temp3: origin
		    // temp4: possible trade target


		    var viable_faction_trade_stars = [];
	    	var _check_val = diplomacy_faction;
	    	 if (obj_controller.diplomacy_faction=4){
	    	 	_check_val = 2
	    	 }
		    with(obj_star){// Get origin star system for enemy fleet
		    	if (array_contains(p_owner, _check_val)){
		    		array_push(viable_faction_trade_stars, id);
		    	}
			    if (_check_val=5){

		        	var ahuh=0,q=0;
		            repeat(planets){
		            	q+=1;
		            	if (p_owner[q]=5) then ahuh=1;
		                if (p_owner[q]<6) and (planet_feature_bool(p_feature[q],P_features.Sororitas_Cathedral )==1) then ahuh=1;
		            }
		            if (ahuh=1){
		            	array_push(viable_faction_trade_stars, id);
		            }

			    }
		    }		
		}

		if (!array_length(_stars_with_player_control) && !array_length(player_fleet_targets)){
			with (obj_controller){
				scr_dialogue("trade_error_1");
				trading = false;
			}
			return false
		}
		if (!array_length(viable_faction_trade_stars)){
			with (obj_controller){
				scr_dialogue("trade_error_2");
				trading = false;
			}
			return false			
		}
		trade_from_star = array_random_element(viable_faction_trade_stars);
		if (!array_length(_stars_with_player_control)){
			trade_to_obj = array_random_element(player_fleet_targets);
		} else if (!array_length(player_fleet_targets)){
			trade_to_obj = array_random_element(_stars_with_player_control);
		} else {
			trade_to_obj = choose(array_random_element(_stars_with_player_control), array_random_element(player_fleet_targets));
		}
		return true;
	}
	static attempt_trade = function(){
		calculate_deal_chance();
		var attempt_rand = roll_dice_chapter(1, 100, "high");
		var _success = attempt_rand <= deal_chance;
		if (_success){
			_success = find_trade_locations();
			if (_success){
				successful_trade_attempt();
				scr_dialogue("agree");
				force_goodbye=1;
				trading=0;
				 if (diplomacy_faction=6) or (diplomacy_faction=7) or (diplomacy_faction=8){
				 	scr_loyalty("Xeno Trade","+");
				 }
			}
		} else {
			with (obj_controller){
				scr_dialogue("disagree");
				clear_button.bind_method();
			}			
		}

	}

	offer_button = new UnitButtonObject({
		x1 : 630,
		y1 : 649,
		label : "Offer",
		bind_method = function(){
			if (obj_controller.diplo_last!="offer"){
				attempt_trade(true);
			}
		}
	});

	exit_button = new UnitButtonObject({
		x1 : 818,
		y1 : 796,
		label : "Exit",
		bind_method = function(){ 
			with (obj_controller){
	            cooldown=8;
	            trading=0;
	            scr_dialogue("trade_close");
	            click2=1;	
	            if (trading_artifact!=0){
	                diplomacy=0;
	                menu=0;
	                force_goodbye=0;
	                with(obj_popup){
	                	instance_destroy();
	                }
	                obj_ground_mission.alarm[1]=1;
	                exit;
	            }	            			
			}		
		}
	});

	static new_demand_buttons = function(trade_disp, name, trade_type, max_take:100000){
		var _option = new UnitButtonObject({
			label : name,
			number : 0,
			disp : trade_disp,
			trade_type : trade_type,
			max_take : max_take,
			bind_method : function(){
				if (max_take == 1){
					number = 1;
				} else {
					get_diag_integer("{label} wanted?", max_take, self);
				}
			}

		});
		array_push(demand_options, _option);
	}
	demand_options = [];
	offer_options = [];

	trader_disp = obj_controller.dispostion[diplomacy_faction];

    trade_req=obj_controller.requisition;
    trade_gene=obj_controller.gene_seed;
    trade_chip=obj_controller.stc_wargear_un+obj_controller.stc_vehicles_un+obj_controller.stc_ships_un;
    trade_info=obj_controller.info_chips;	

	switch (diplomacy_faction){
		case 2:
			new_demand_buttons(0, "Requisition","req");
			new_demand_buttons(0, "Recruiting Planet", "license",1);
			new_demand_buttons(0, "License: Repair","license",1);
			new_demand_buttons(0, "License: Crusade","license",1);
			break;
		case 3:
			new_demand_buttons(35, "Terminator Armour", "equip",5);
			new_demand_buttons(20, "Land Raider", "vehic",1);
			new_demand_buttons(40, "Minor Artifact", "arti",1);
			new_demand_buttons(25, "Skitarii", "merc",200);
			new_demand_buttons(55, "Techpriest", "merc",3);
			break;
		case 4:
			new_demand_buttons(30, "Hellrifle", "equip",3);
			new_demand_buttons(20, "Incinerator", "equip"10);
			new_demand_buttons(25, "Crusader", "merc", 5);
			new_demand_buttons(40, "Exterminatus", "equip",1);
			new_demand_buttons(60, "Cyclonic Torpedo", "equip",1);
			break;
		case 5:
			new_demand_buttons(20, "Eviscerator", "equip",10);
			new_demand_buttons(30, "Heavy", "equip",10);
			//new_demand_buttons(30, "Inferno Bolts", "equip");
			new_demand_buttons(40, "Sister of Battle", "merc",5);
			new_demand_buttons(45, "Sister Hospitaler", "merc",3);
			break;
		case 6:
			new_demand_buttons(-10, "Master Crafted Power Sword", "equip",3);
			new_demand_buttons(-10, "Archeotech Laspistol", "equip",1);
			new_demand_buttons(10, "Ranger", "merc",3);
			new_demand_buttons(-15, "Useful Information", "license",1);	
			break;
		case 7:	
			new_demand_buttons(-100, "Power Klaw", "equip",10);
			new_demand_buttons(-100, "Ork Sniper", "merc",50);
			new_demand_buttons(-100, "Flash Git", "merc",50);	
			break;	
	}

	static new_offer_option(trade_disp-100, name, trade_type, max_count=1){
		var _option = new UnitButtonObject({
			label : name,
			number : 0,
			max_number : max_count,
			disp : trade_disp,
			trade_type : trade_type,
			bind_method : function(){
				get_diag_integer("{label} offered?",max_number, self);
			}
		});
		array_push(offer_options, _option);		
	}

	if (obj_controller.requisition > 0){
		new_offer_option(, "Requisition", "req", obj_controller.requisition);
	}

	if (obj_controller.gene_seed > 0){
		new_offer_option(, "Gene Seed", "gene", obj_controller.gene_seed);
	}

	if (trade_chip > 0){
		new_offer_option(, "STC Fragment","stc" ,trade_chip);
	}
	if (info_chip > 0){
		new_offer_option(, "Info Chip","info", info_chip);
	}

	static draw_trade_screen(){
		recalc_values =  false;
        draw_set_color(38144);
        draw_rectangle(xx+342,yy+326,xx+486,yy+673,1);
        draw_rectangle(xx+343,yy+327,xx+485,yy+672,1);// Left Main Panel
        draw_rectangle(xx+504,yy+371,xx+741,yy+641,1);
        draw_rectangle(xx+505,yy+372,xx+740,yy+640,1);// Center panel
        draw_rectangle(xx+759,yy+326,xx+903,yy+673,1);
        draw_rectangle(xx+760,yy+327,xx+902,yy+672,1);// Right Main Panel
    
        draw_rectangle(xx+342,yy+326,xx+486,yy+371,1);// Left Title Panel
        draw_rectangle(xx+759,yy+326,xx+903,yy+371,1);// Right Title Panel
    
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_center);
        draw_text(xx+411,yy+330,string_hash_to_newline(string(obj_controller.faction[diplomacy_faction])+"#Items"));
        draw_text(xx+829,yy+330,string_hash_to_newline(string(global.chapter_name)+"#Items"));
    
        if (trade_likely!="") then draw_text(xx+623,yy+348,string_hash_to_newline($"[{trade_likely}]"));

        clear_button.draw();
        offer_button.draw();
        exit_button.draw();
    
        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_14);
        draw_set_color(38144);
        var _requested_count = 0
        if (obj_controller.trading_artifact = 0){
	        for (var i=0;i<array_length(demand_options);i++){
	        	var _opt = demand_options[i];
	        	if (opt.number != opt.number_last){
	        		recalc_values = true;
	        	}
	        
	        	opt.x1 = 347;
	        	opt.y1 = 382 + i*(48);
	        	opt.update_loc();
	        	opt.number_last = number;
	        	var _allow_click = opot.disp >= trader_disp;
	        	opt.draw(_allow_click);
	        	if (opt.number > 0){
	        		var _y_offset = 399 + (_requested_count * 20);
	        		draw_sprite(spr_cancel_small,0,507,_y_offset);
	        		if (point_and_click_sprite(507,_y_offset, spr_cancel_small)){
	        			opt.number = 0;
	        			recalc_values = true;;
	        		}

	        		if (opt.max_take > 1){
	        			draw_text(530,_y_offset,"{opt.label} : {opt.number}");
	        		} else {
	        			draw_text(530,_y_offset,"{opt.label}");
	        		}
	        	}
	        }
	    }

	    draw_text(507,529,string(global.chapter_name)+":");
        for (var i=0;i<array_length(offer_options);i++){
        	var _opt = offer_options[i];
        	if (opt.number != opt.number_last){
        		recalc_values = true;
        	}        	
        	opt.x1 = 347+ 419;
        	opt.y1 = 382 + i*(48);
        	opt.update_loc();
        	opt.draw();
        	opt.number_last = number;
        	if (opt.number > 0){
        		var _y_offset = 547 + (_requested_count * 20);
        		draw_sprite(spr_cancel_small,0,507,_y_offset);
	        	if (point_and_click_sprite(507,_y_offset, spr_cancel_small)){
        			opt.number = 0;
        			recalc_values = true;;
        		}    		
        		if (opt.max_number > s1){
        			draw_text(530,_y_offset,"{opt.label} : {opt.number}");
        		} else {
        			draw_text(530,_y_offset,"{opt.label}");
        		}
        	}        	
        }

        if (recalc_values){
        	calculate_deal_chance();
        }		
	}
	var _info_val = 0;
	with (obj_controller){
		if (random_event_next != EVENT.none) and ((string_count("WL10|",useful_info)>0) or (turn<chaos_turn)) and ((string_count("WL7|",useful_info)>0) or (known[eFACTION.Ork]<1)) and  (string_count("WG|",useful_info)>1) and (string_count("CM|",useful_info)>0){
			_info_val=1000;
		}
	}
	information_value = _info_val;

	static calculate_trader_trade_value(){
		
		their_worth = 0;
		
		for (var i=0;i<array_length(demand_options);i++){
			var _opt = demand_options[i]
		}
		if (_opt.number > 0 && struct_exists(relative_trade_values, _opt.label)){
			their_worth+=_opt.number*relative_trade_values[$ _opt.label];
		}



	    if (trade_take[i]="Artifact"){
	    	var _faction_barrier = 0;
	    	switch (diplomacy_faction){
	    		case 2:
	    			_faction_barrier = 300;
	    			break;
	    		case 3:
	    			_faction_barrier = 800;
	    			break;
	    		case 4:
	    			_faction_barrier = 600;
	    			break;
	    		case 5:
	    			_faction_barrier = 500;
	    			break;	    			    				    			
	    	}
	    	if (diplomacy_faction < 5){
	    		_faction_barrier = 1200
	    	}
	    	their_worth += 1200;
	    }	
	}

	static calculate_player_trade_value(){
		my_worth = 0;
	    for (var i = 1; i < 5; i++) {
	    	var _opt = offer_options[i]
		    if (my_worth.label="Requisition"){
		    	my_worth += _opt.number;
		    }
	    
		    if (_opt.label="Gene-Seed") and (_opt.number>0){
		        if (diplomacy_faction=3) or (diplomacy_faction=4) then my_worth+=_opt.number*30;
		        if (diplomacy_faction=2) or (diplomacy_faction=5) then my_worth+=_opt.number*20;
		        if (diplomacy_faction=8) or (diplomacy_faction=10) then my_worth+=_opt.number*50;
		    }
	    
		    if (_opt.label="Info Chip") and (_opt.number>0){
		    	my_worth+=_opt.number*80;
		    }
		    if (diplomacy_faction=3) and (_opt.label="Info Chip") and (_opt.number>0) then my_worth+=_opt.number*10;// 20% bonus
	    
		    if (_opt.label="STC Fragment") and (_opt.number>0){
		        if (diplomacy_faction=2) then my_worth+=_opt.number*900;
		        if (diplomacy_faction=3) then my_worth+=_opt.number*1000;
		        if (diplomacy_faction=4) then my_worth+=_opt.number*1000;
		        if (diplomacy_faction=5) then my_worth+=_opt.number*900;
		        if (diplomacy_faction=10) then my_worth+=_opt.number*900;
	        
		        if (diplomacy_faction=6) then my_worth+=_opt.number*500;
		        if (diplomacy_faction=7) then my_worth+=_opt.number*500;
		        if (diplomacy_faction=8) then my_worth+=_opt.number*1000;
		    }
		}
	}

	trade_likely = "";
	static calculate_deal_chance(){
		var dif_penalty, penalty;
		def_penalty=0;penalty=0;
		calculate_player_trade_value();
		calculate_trader_trade_value();

		if (diplomacy_faction=2){dif_penalty=.4;penalty=5;}
		else if (diplomacy_faction=3){dif_penalty=.6;penalty=5;}
		else if (diplomacy_faction=4){dif_penalty=1;penalty=15;}
		else if (diplomacy_faction=5){dif_penalty=0.8;penalty=0;}
		else if (diplomacy_faction=6){dif_penalty=0.6;penalty=10;}
		else if (diplomacy_faction=7){dif_penalty=0.4;penalty=20;}
		else if (diplomacy_faction=8){dif_penalty=0.4;penalty=0;}
		else if (diplomacy_faction=10){dif_penalty=1;penalty=0;}

		deal_chance=(100-penalty)-((their_worth-my_worth)*dif_penalty);


		if (deal_chance<=20) then trade_likely="Very Unlikely";
	    if (deal_chance<=0) then trade_likely="Impossible";
	    if (deal_chance>20) and (deal_chance<=40) then trade_likely="Unlikely";
	    if (deal_chance>40) and (deal_chance<=60) then trade_likely="Moderate Chance";
	    if (deal_chance>60) and (deal_chance<=80) then trade_likely="Likely";
	    if (deal_chance>80) then trade_likely="Very Likely";
	    if (deal_chance>100) then trade_likely="Unrefusable";
	}

}
 
