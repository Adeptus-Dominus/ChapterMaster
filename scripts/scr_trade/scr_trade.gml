
function TradeAttempt(diplomacy) constructor{
	diplomacy_faction = diplomacy;
	relative_trade_values = {
		"Test" : 5000,
		"Requisition" : 1,
		"Recruiting Planet" : obj_controller.disposition[2]<70 ? 4000 : 2000,
		"License: Repair" : 750,
		"License: Crusade" : 1500,
		"Terminator Armour" : 400,
		"Tartaros" : 900,
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
	demand_options = [];
	offer_options = [];

	static clear_options = function(){
		trade_likely="";
		var _offer_length = array_length(offer_options);
		var _demand_length = array_length(demand_options)
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
	clear_button = new UnitButtonObject({
		x1 : 510,
		y1 : 649,
		label : "Clear",
	});
	clear_button.bind_method  = clear_options;
	clear_button.bind_scope = self;

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
					number : _opt.number,
				}
			} else if (_opt.trade_type == "license"){
				switch (_opt.label){
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
			} else if (_opt.trade_type == "merc"){
				if (!struct_exists(trading_object, "mercenaries")){
					trading_object.mercenaries = {};
				}
				trading_object.mercenaries[$ _type] = {
					quality : "standard",
					number : _opt.number,
				}
			}
		}
		for (var i=0;i<array_length(offer_options);i++){
			var _opt = offer_options[i];
			if (_opt.number == 0){
				continue;
			}
			var _type = _opt.label;	
			if (_opt.trade_type == "equip"){
				scr_add_item(_opt.label, -_opt.label);
			} else if (_opt.trade_type == "req"){
				obj_controller.requisition -= _opt.number;
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
                if (diplomacy_faction<=5) and (diplomacy_faction!=4){
                	obj_controller.gene_sold+=_opt.number;
                }
                if (diplomacy_faction>=6){
                	obj_controller.gene_xeno+=_opt.number;	
                }			
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

		var flit = setup_ai_trade_fleet(trade_from_star, diplomacy_faction);

		flit.cargo_data.player_goods = trading_object;

		flit.target = trade_to_obj;
		with (flit){
			action_x=target.x;
	        action_y=target.y;
	        set_fleet_movement();
		}

	}

	static find_trade_locations = function(){
 		if (obj_ini.fleet_type=ePlayerBase.home_world){
 			var _stars_with_player_control = [];
	 		with(obj_star){
	 			if (array_contains(p_owner, 1)){
	 				array_push(_stars_with_player_control, id)
	 			}
		    }

		    var player_fleet_targets = [];

		    if (obj_ini.fleet_type != ePlayerBase.home_world || !array_length(_stars_with_player_control)){
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
	    	 if (diplomacy_faction==4){
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
		                if (p_owner[q]<6) and (planet_feature_bool(p_feature[q],P_features.Sororitas_Cathedral) == 1) then ahuh=1;
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
			show_debug_message("trade_success");
			if (_success){
				successful_trade_attempt();
				scr_dialogue("agree");
				//force_goodbye=1;
				obj_controller.trading=0;
				 if (diplomacy_faction=6) or (diplomacy_faction=7) or (diplomacy_faction=8){
				 	scr_loyalty("Xeno Trade","+");
				 }
			} else {
				show_debug_message("no trade locations");
			}
		} else {
			var _dip = diplomacy_faction;
			with (obj_controller){
				var _rela=relationship_hostility_matrix(diplomacy);
				if (trading_artifact==0){
					diplo_text="[[Trade Refused]]##";
				} else {
					diplo_text="";
				}
		        annoyed[_dip] += 1;
		        rando=choose(1,2,3);
		        if (_rela=="hostile"){
					force_goodbye=1;
		            if (rando==1) then diplo_text+="You would offer me scraps for the keys to a kingdom? You are foolish and, worse, you are unaware of your own incompetence.";
		            if (rando==2) then diplo_text+="Do not attempt exchanges with those so far above you, lapdog of the Corpse Emperor, it makes you look even more idiotic than you already do.";
		            if (rando==3) then diplo_text+="I would spit upon this ‘offer' you bring before me but I find myself too amused by it.";
		        }
		        else if (_rela!="hostile"){
		            if (rando==1) then diplo_text+="You may consider my response to be a ‘no' and assume my attitude to be whatever you like, Chapter Master.";
		            if (rando==2) then diplo_text+="Have a care that you do not overstep the mark, Chapter Master, I see no reason to accept such a trade.";
		            if (rando==3) then diplo_text+="An unreasonable trade, whatever our working relationship might be. I refuse.";
		        }
		        if (annoyed[_dip]>=10){
					force_goodbye=1;
		            turns_ignored[_dip]=max(turns_ignored[_dip],1);
					diplo_last="disagree";
					diplo_char=0;
					diplo_alpha=0;
					exit;
		        }
			}
			show_debug_message("trade_fail");
			clear_options();			
		}

	}

	offer_button = new UnitButtonObject({
		x1 : 630,
		y1 : 649,
		label : "Offer",
	});
	offer_button.bind_method = function(){
		if (obj_controller.diplo_last !=" offer"){
			attempt_trade(true);
		}		
	}
	offer_button.bind_scope = self;

	exit_button = new UnitButtonObject({
		x1 : 818,
		y1 : 796,
		label : "Exit",
	});

	exit_button.bind_method = function(){
		with (obj_controller){
            cooldown=8;
            trading=0;
            scr_dialogue("trade_close");
            click2=1;	
            if (trading_artifact!=0){
                scr_toggle_diplomacy();
                with(obj_popup){
                	instance_destroy();
                }
                obj_ground_mission.alarm[1]=1;
                exit;
            }	            			
		}		
	}
	exit_button.bind_scope = self;
	static new_demand_buttons = function(trade_disp, name, trade_type, max_take = 100000){
		var _option = new UnitButtonObject({
			label : name,
			number : 0,
			disp : trade_disp,
			trade_type : trade_type,
			max_take : max_take,
			number_last : 0,
		});
		with (_option){
			bind_method = function(){
				if (max_take == 1){
					 variable_struct_set(self, "number", 1);	
				} else {
					get_diag_integer($"{label} wanted?", max_take, self);
				}
			}
		}
		if (trader_disp < trade_disp){
			_option.disabled = true;
			_option.tooltip = $"{trade_disp} disposition required";
		}
		//_option.bind_scope = _option;
		array_push(demand_options, _option);
	}

	trader_disp = obj_controller.disposition[diplomacy_faction];

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
			new_demand_buttons(20, "Incinerator", "equip",10);
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

	static new_offer_option = function(trade_disp = -100, name, trade_type, max_count=1){
		var _option = new UnitButtonObject({
			label : name,
			number : 0,
			max_number : max_count,
			disp : trade_disp,
			trade_type : trade_type,
			number_last : 0,		
		});
		with (_option){
			bind_method = function(){
				if (max_number == 1){
					number = 1;
				} else {				
					get_diag_integer($"{label} offered?",max_number, self);
				}			
			}
		}
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
	if (trade_info > 0){
		new_offer_option(, "Info Chip","info", trade_info);
	}

	static draw_trade_screen = function(){
		recalc_values =  false;
        draw_set_color(38144);
        draw_rectangle(342,326,486,673,1);
        draw_rectangle(343,327,485,672,1);// Left Main Panel
        draw_rectangle(504,371,741,641,1);
        draw_rectangle(505,372,740,640,1);// Center panel
        draw_rectangle(759,326,903,673,1);
        draw_rectangle(760,327,902,672,1);// Right Main Panel
    
        draw_rectangle(342,326,486,371,1);// Left Title Panel
        draw_rectangle(759,326,903,371,1);// Right Title Panel
    
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_center);
        draw_text(411,330,$"{obj_controller.faction[diplomacy_faction]}\nItems");
        draw_text(829,330,$"{global.chapter_name}\nItems");
    
        if (trade_likely!="") then draw_text(623,348,$"[{trade_likely}]");

        clear_button.draw();
        offer_button.draw();
        exit_button.draw();
    
        draw_set_halign(fa_left);
        draw_set_font(fnt_40k_14);
        draw_set_color(38144);
        var _requested_count = 0;
        //if (obj_controller.trading_artifact = 0){
	        for (var i=0;i<array_length(demand_options);i++){
	        	var _opt = demand_options[i];
	        	if (_opt.number != _opt.number_last){
	        		recalc_values = true;
	        	}
	        	_opt.x1 = 347;
	        	_opt.y1 = 382 + i*(48);
	        	_opt.update_loc();
	        	_opt.number_last = _opt.number;
	        	var _allow_click = _opt.disp <= trader_disp;
	        	_opt.draw(_allow_click);
	        	if (_opt.number > 0){
	        		var _y_offset = 399 + (_requested_count * 20);
	        		draw_sprite(spr_cancel_small,0,507,_y_offset);
	        		if (point_and_click_sprite(507,_y_offset, spr_cancel_small)){
	        			_opt.number = 0;
	        			recalc_values = true;;
	        		}

	        		if (_opt.max_take > 1){
	        			draw_text(530,_y_offset,$"{_opt.label} : {_opt.number}");
	        		} else {
	        			draw_text(530,_y_offset,$"{_opt.label}");
	        		}
	        		_requested_count++;
	        	}
	        }
	    //}

	    var _requested_count = 0;
	    draw_text(507,529,$"{global.chapter_name}:");
        for (var i=0;i<array_length(offer_options);i++){
        	var _opt = offer_options[i];
        	if (_opt.number != _opt.number_last){
        		recalc_values = true;
        	}        	
        	_opt.x1 = 347+ 419;
        	_opt.y1 = 382 + i*(48);
        	_opt.update_loc();
        	_opt.draw();
        	_opt.number_last = _opt.number;
        	if (_opt.number > 0){
        		var _y_offset = 547 + (_requested_count * 20);
        		draw_sprite(spr_cancel_small,0,507,_y_offset);
	        	if (point_and_click_sprite(507,_y_offset, spr_cancel_small)){
        			_opt.number = 0;
        			recalc_values = true;;
        		}    		
        		if (_opt.max_number > 1){
        			draw_text(530,_y_offset,$"{_opt.label} : {_opt.number}");
        		} else {
        			draw_text(530,_y_offset,$"{_opt.label}");
        		}
        		_requested_count++;
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

	static calculate_trader_trade_value = function(){
		
		their_worth = 0;
		
		for (var i=0;i<array_length(demand_options);i++){
			var _opt = demand_options[i]

			if (_opt.number > 0 && struct_exists(relative_trade_values, _opt.label)){
				their_worth+=_opt.number*relative_trade_values[$ _opt.label];
			    if (_opt.label=="Artifact"){
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
			    	their_worth += _faction_barrier;
			    }
			}		    
		}
	}

	static calculate_player_trade_value = function(){
		my_worth = 0;
	    for (var i = 0; i < array_length(offer_options); i++) {
	    	var _opt = offer_options[i]
	    	if (_opt.number<=0){
	    		continue;
	    	}
		    if (_opt.label="Requisition"){
		    	my_worth += _opt.number;
		    }
	    
		    else if (_opt.label="Gene-Seed") {
		        if (diplomacy_faction=3) or (diplomacy_faction=4) then my_worth+=_opt.number*30;
		        if (diplomacy_faction=2) or (diplomacy_faction=5) then my_worth+=_opt.number*20;
		        if (diplomacy_faction=8) or (diplomacy_faction=10) then my_worth+=_opt.number*50;
		    }
	    
		    else if (_opt.label="Info Chip"){
		    	if (diplomacy_faction == eFACTION.Mechanicus){
		    		my_worth+=_opt.number*100;// 20% bonus
		    	} else {
		    		my_worth+=_opt.number*80;
		    	}
		    	my_worth+=_opt.number*80;
		    }
	    
		    if (_opt.label="STC Fragment") {
		        if (diplomacy_faction=2) then my_worth+=_opt.number*900;
		        if (diplomacy_faction=3) then my_worth+=_opt.number*1000;
		        if (diplomacy_faction=4) then my_worth+=_opt.number*1000;
		        if (diplomacy_faction=5) then my_worth+=_opt.number*900;
		        if (diplomacy_faction=10) then my_worth+=_opt.number*900;
	        
		        if (diplomacy_faction=6) then my_worth+=_opt.number*500;
		        if (diplomacy_faction=7) then my_worth+=_opt.number*500;
		        if (diplomacy_faction=8){
		        	my_worth+=_opt.number*1000;
		        }
		    }
		}
	}

	trade_likely = "";
	static chance_chart = ["Impossible", "Very Unlikely","Unlikely","Moderate Chance","Likely","Very Likely","Unrefusable"];
	static calculate_deal_chance = function(){

		var def_penalty=0;
		var penalty=0;
		calculate_player_trade_value();
		calculate_trader_trade_value();

		if (diplomacy_faction=2){
			dif_penalty=0.4;
			penalty=5;
		}else if (diplomacy_faction=3){
			dif_penalty=0.6;
			penalty=5;
		}else if (diplomacy_faction=4){
			dif_penalty=1;
			penalty=15;
		}else if (diplomacy_faction=5){
			dif_penalty=0.8;
			penalty=0;
		}else if (diplomacy_faction=6){
			dif_penalty=0.6;
			penalty=10;
		}else if (diplomacy_faction=7){
			dif_penalty=0.4;
			penalty=20;
		}else if (diplomacy_faction=8){
			dif_penalty=0.4;
			penalty=0;
		}else if (diplomacy_faction=10){
			dif_penalty=1;
			penalty=0;}

		deal_chance=(100-penalty)-(((their_worth-(my_worth*dif_penalty))/10));

		show_debug_message($"{their_worth},{my_worth},{deal_chance}");

		var _chance = clamp(floor((deal_chance/20)), 0, 6);

		trade_likely = chance_chart[_chance];
	}

}
 
