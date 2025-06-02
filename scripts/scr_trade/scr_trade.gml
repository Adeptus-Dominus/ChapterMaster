
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
		for (var i=0;i<array_length(demand_options);i++){
			var _opt = demand_options[i];
			var _type = _opt.label;
			switch (label){
				case "Recruiting Planet":
					obj_conotroller.recruiting_worlds_bought++;
			}
		}
	}
	static attempt_trade = function(){
		calculate_deal_chance();
		var attempt_rand = roll_dice_chapter(1, 100, "high");
		var _success = attempt_rand <= deal_chance;
		if (_success){

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
			new_demand_buttons(-15, "Useful Information", "info",1);	
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
		new_offer_option(, "STC Fragment", trade_chip);
	}
	if (info_chip > 0){
		new_offer_option(, "Info Chip", info_chip);
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
	    
		    if (trade_give[i]="Gene-Seed") and (_opt.number>0){
		        if (diplomacy_faction=3) or (diplomacy_faction=4) then my_worth+=_opt.number*30;
		        if (diplomacy_faction=2) or (diplomacy_faction=5) then my_worth+=_opt.number*20;
		        if (diplomacy_faction=8) or (diplomacy_faction=10) then my_worth+=_opt.number*50;
		    }
	    
		    if (trade_give[i]="Info Chip") and (_opt.number>0){
		    	my_worth+=_opt.number*80;
		    }
		    if (diplomacy_faction=3) and (trade_give[i]="Info Chip") and (_opt.number>0) then my_worth+=_opt.number*10;// 20% bonus
	    
		    if (trade_give[i]="STC Fragment") and (_opt.number>0){
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

function scr_trade(argument0) {

	// argument0: true for trade, false for just tabulate score

	var my_worth, their_worth, rando4, rando5;
	my_worth=0;
	their_worth=0;
	rando4=floor(random(100))+1;
	rando5=floor(random(100))+1;


	var ss1,ss2;
	ss1=string(trade_give[1])+string(trade_give[2])+string(trade_give[3])+string(trade_give[4]);
	ss2=string(trade_take[1])+string(trade_take[2])+string(trade_take[3])+string(trade_take[4]);
	if (ss1="Requisition") or (ss1="RequisitionRequisition") or (ss1="RequisitionRequisitionRequisition") or (string_count("Requisition",ss1)=4){
	    if (ss2="Requisition") or (ss2="RequisitionRequisition") or (ss2="RequisitionRequisitionRequisition") or (string_count("Requisition",ss2)=4){
	        my_worth=-10000;
	    }
	}
	if (ss1="Requisition") and (ss2="Requisition") then my_worth=-10000;
	if (ss1="") and (ss2="Requisition") then my_worth=-10000;
	// Modify their worth based on relationship

	    // show_message("A-1: "+string(liscensing));



	if (argument0=true){

	if (rando4<=deal) and (trading_artifact=0){

	    var step,lisc;step=0;lisc=0;
	    lisc=string_count("License",string(trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4]));
	    lisc+=string_count("Recruiting",string(trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4]));
	    lisc+=string_count("Useful Info",string(trade_take[1]+trade_take[2]+trade_take[3]+trade_take[4]));
	    if (trade_take[1]!="") and (trade_take[2]="") then step=1;
	    if (trade_take[2]!="") and (trade_take[3]="") then step=2;
	    if (trade_take[3]!="") and (trade_take[4]="") then step=3;
	    if (trade_take[4]!="") then step=4;

	    if (lisc>0) then obj_controller.liscensing=1;
	    if (trade_take[1]="Recruiting Planet") or (trade_take[2]="Recruiting Planet") or (trade_take[3]="Recruiting Planet") or (trade_take[4]="Recruiting Planet"){
	        obj_controller.liscensing=5;
        
	        if (trade_take[1]="Recruiting Planet") then recruiting_worlds_bought+=1;
	        if (trade_take[2]="Recruiting Planet") then recruiting_worlds_bought+=1;
	        if (trade_take[3]="Recruiting Planet") then recruiting_worlds_bought+=1;
	        if (trade_take[4]="Recruiting Planet") then recruiting_worlds_bought+=1;
	    }
	    if (trade_take[1]="License: Crusade") or (trade_take[2]="License: Crusade") or (trade_take[3]="License: Crusade") or (trade_take[4]="License: Crusade"){
	        obj_controller.liscensing=2;
	    }
	    if (trade_take[1]="Useful Information") or (trade_take[2]="Useful Information") or (trade_take[3]="Useful Information") or (trade_take[4]="Useful Information"){
	        obj_controller.liscensing=5;
	    }
	    if (trade_take[1]="License: Repair") or (trade_take[2]="License: Repair") or (trade_take[3]="License: Repair") or (trade_take[4]="License: Repair"){
	        repair_ships=1;
	    }
	    if (trade_take[1]="Exterminatus") or (trade_take[2]="Exterminatus") or (trade_take[3]="Exterminatus") or (trade_take[4]="Exterminatus"){
	        obj_controller.liscensing=0;
	        lisc=0;
	    }
    
	    // show_message("A: "+string(liscensing));
    
	    ;var goods;goods="";
	   
    
    
	    // Temporary work around
	    if (lisc>0){
            for (var i = 1; i <= 4; i += 1) {
	            if (trade_give[i]="Requisition") then requisition-=_opt.number;
	            if (trade_give[i]="Gene-Seed") and (_opt.number>0){
	                gene_seed-=_opt.number;
                
	                if (diplomacy_faction<=5) and (diplomacy_faction!=4) then gene_sold+=_opt.number;
	                if (diplomacy_faction>=6) then gene_xeno+=_opt.number;
	            }
	            if (trade_give[i]="Info Chip") and (_opt.number>0) then info_chips-=_opt.number;
	            if (trade_give[i]="STC Fragment") and (_opt.number>0){
                    for (var j = 0; j < 100; j += 1) {
                        var p = choose(1, 2, 3);
                        if (p == 1 && stc_wargear_un > 0) {
                            stc_wargear_un -= 1;
                            break;
                        }
                        if (p == 2 && stc_vehicles_un > 0) {
                            stc_vehicles_un -= 1;
                            break;
                        }
                        if (p == 3 && stc_ships_un > 0) {
                            stc_ships_un -= 1;
                            break;
                        }
                    }
	            }
	        }
        
        
	    }
    
    
    
	    if (lisc!=step) or (lisc=0){// Do not fly over licenses
    
	        if (obj_ini.fleet_type=ePlayerBase.home_world) then with(obj_star){
	            if ((p_owner[1]=1) or (p_owner[2]=1) or (p_owner[3]=1) or (p_owner[4]=1)){instance_create(x,y,obj_temp2);x-=10000;y-=10000;}
	        }
        
        
	        if (obj_ini.fleet_type != ePlayerBase.home_world){
	            // with(obj_star){if (present_fleet[1]>0){x-=10000;y-=10000;}}
	            with(obj_p_fleet){// Get the nearest star system that is viable for creating the trading fleet
	                if (capital_number>0) and (action="") then instance_create(instance_nearest(x,y,obj_star).x,instance_nearest(x,y,obj_star).y,obj_temp2);
	                if (frigate_number>0) and (action="") then instance_create(instance_nearest(x,y,obj_star).x,instance_nearest(x,y,obj_star).y,obj_ground_mission);
	            }
	        }
        
        
	        // temp2: ideal trade target
	        // temp3: origin
	        // temp4: possible trade target
        
        
	        with(obj_star){// Get origin star system for enemy fleet
	            /*var q;q=0;
	            repeat(4){q+=1;
	                if (p_owner[q]=1) or (string_count("Monastery",p_feature[q])>0) then instance_create(x,y,obj_temp3);
	            }*/
        
            
	            if /*(owner=obj_controller.diplomacy_faction) and */((p_owner[1]=obj_controller.diplomacy_faction) or (p_owner[2]=obj_controller.diplomacy_faction) 
	            or (p_owner[3]=obj_controller.diplomacy_faction) or (p_owner[4]=obj_controller.diplomacy_faction)){
	                instance_create(x,y,obj_temp3);
	            }
            
	            if (obj_controller.diplomacy_faction=4){
	                if (p_owner[1]=2) or (p_owner[2]=2) or (p_owner[3]=2) or (p_owner[4]=2) then instance_create(x,y,obj_temp3);
	            }
            
	            // if (obj_controller.diplomacy_faction=4) and (owner = eFACTION.Imperium) then instance_create(x,y,obj_temp3);
	        }
	        if (diplomacy_faction=5){
	            with(obj_star){var ahuh,q;ahuh=0;q=0;
	                repeat(4){q+=1;if (p_owner[q]=5) then ahuh=1;
	                    if (p_owner[q]<6) and (planet_feature_bool(p_feature[q],P_features.Sororitas_Cathedral )==1) then ahuh=1;
	                }
	                if (ahuh=1) then instance_create(x,y,obj_temp3);
	            }
	        }
        
        
	        // show_message("TG2:"+string(instance_number(obj_temp2))+", TG3:"+string(instance_number(obj_temp3))+", TG4:"+string(instance_number(obj_ground_mission)));
        
        
	        var targ, flit, chasing;chasing=0;targ=0;// Set target, chase
        
	        // if (obj_ini.fleet_type != ePlayerBase.home_world){
	            if (instance_exists(obj_temp2)) then targ=instance_nearest(obj_temp2.x,obj_temp2.y,obj_temp3);
	            if (!instance_exists(obj_temp2)) and (instance_exists(obj_ground_mission)) then targ=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_temp3);
            
	            if ((!instance_exists(obj_temp2)) and (!instance_exists(obj_ground_mission))) or (instance_number(obj_p_fleet)=1) and ((obj_p_fleet.x<=0) or (obj_p_fleet.x>room_width) or (obj_p_fleet.y<=0) or (obj_p_fleet.y>room_height)){
	                with(obj_star){
	                    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	                    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	                }
	                trading=0;scr_dialogue("trade_error_1");
                
	                if (trade_take[1]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[2]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[3]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[4]="Recruiting Planet") then recruiting_worlds_bought-=1;
	                if (trade_take[1]="License: Crusade") or (trade_take[2]="License: Crusade") or (trade_take[3]="License: Crusade") or (trade_take[4]="License: Crusade"){
	                    obj_controller.liscensing=0;
	                }
	                if (trade_take[1]="Useful Information") or (trade_take[2]="Useful Information") or (trade_take[3]="Useful Information") or (trade_take[4]="Useful Information"){
	                    obj_controller.liscensing=0;
	                }
	                if (trade_take[1]="License: Repair") or (trade_take[2]="License: Repair") or (trade_take[3]="License: Repair") or (trade_take[4]="License: Repair"){
	                    repair_ships=0;
	                }
                
	                instance_activate_all();exit;
	            }
            
	            // If player fleet is flying about then get their target for new target
	            if (!instance_exists(obj_temp2)) and (!instance_exists(obj_ground_mission)) and (instance_exists(obj_p_fleet)) and (obj_ini.fleet_type != ePlayerBase.home_world){
	                // show_message("no T2 or T4: chasing");
	                chasing=1;
	                with(obj_p_fleet){var pop;
	                    if (capital_number>0) and (action!=""){pop=instance_create(action_x,action_y,obj_temp2);pop.action_eta=action_eta;}
	                    if (frigate_number>0) and (action!=""){pop=instance_create(action_x,action_y,obj_ground_mission);pop.action_eta=action_eta;}
	                }
	            }
	            if (instance_exists(obj_temp2)) then targ=instance_nearest(obj_temp2.x,obj_temp2.y,obj_temp3);
	            if (!instance_exists(obj_temp2)) and (instance_exists(obj_ground_mission)) then targ=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_temp3);
	        // }

	        if (!instance_exists(obj_temp3)){
	            with(obj_star){
	                if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	                if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	            }
	            trading=0;scr_dialogue("trade_error_2");

	            for (var i=1;i<5;i++){
	            	if (trade_take[i]=="Recruiting Planet") then recruiting_worlds_bought-=1;
	            	if (trade_take[i]=="License: Crusade") then obj_controller.liscensing=0;
	            	if (trade_take[i]=="Useful Information") then obj_controller.liscensing=0;
	            	if (trade_take[i]=="License: Repair") then repair_ships=0;
	            }
            
	            instance_activate_all();
	            exit;
	        }
        
        	vara flit = setup_ai_trade_fleet();
	        i=0;
	        
	        remove_trade_items_from_inventory();

	        set_up_trade_cargo_struct();
        
	        flit.trade_goods=goods;
	        if (flit.trade_goods="") then flit.trade_goods="none";
        
	        if (obj_ini.fleet_type != ePlayerBase.home_world){
	            if (instance_exists(obj_temp2)){flit.action_x=obj_temp2.x;flit.action_y=obj_temp2.y;flit.target=instance_nearest(flit.action_x,flit.action_y,obj_p_fleet);}
	            if (!instance_exists(obj_temp2)) and (instance_exists(obj_ground_mission)){flit.action_x=obj_ground_mission.x;flit.action_y=obj_ground_mission.y;flit.target=instance_nearest(flit.action_x,flit.action_y,obj_p_fleet);}
	        }
	        if (obj_ini.fleet_type=ePlayerBase.home_world){
	            targ=instance_nearest(flit.x,flit.y,obj_temp2);
	            flit.action_x=targ.x;
	            flit.action_y=targ.y;
	        }
        
	        if (chasing=1){flit.minimum_eta=flit.target.action_eta;}
	        flit.alarm[4]=1;
        
	        with(obj_temp2){instance_destroy();}
	        with(obj_temp3){instance_destroy();}
	        with(obj_ground_mission){instance_destroy();}
        
        
	    // show_message("D: "+string(liscensing));
        
	        if (flit.trade_goods=""){// Elfdar mission 1 maybe
	            var got=0;
            
            
	    // show_message("E: "+string(liscensing));
            
	            if (trade_give[1]="Requisition") then got+=trade_mnum[1];
	            if (trade_give[2]="Requisition") then got+=trade_mnum[2];
	            if (trade_give[3]="Requisition") then got+=trade_mnum[3];
	            if (trade_give[4]="Requisition") then got+=trade_mnum[4];
            
	            if (trade_tnum[1]+trade_tnum[2]+trade_tnum[3]+trade_tnum[4]>0) then got=0;
            
	            if (got>=500) and (diplomacy_faction=6){
	                var got2;got2=0;
	                repeat(10){if (got2<50){got2+=1;if (quest[got2]="fund_elder") and (quest_faction[got2]=6){
	                    scr_dialogue("mission1_thanks");scr_quest(2,"fund_elder",6,0);got2=50;trading=0;
	                    trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	                    trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	                    exit;
	                }}}
	            }
	        }
        
	    }
    
    
	    trading=0;
    
	    // show_message("F: "+string(liscensing));
    
	    // show_message("rando4: "+string(rando4)+"#deal: "+string(deal));
    
    
	    // show_message("Lisc: "+string(lisc)+" | Step: "+string(step));
    
	    if (trade_take[1]="Useful Information") or (trade_take[2]="Useful Information") or (trade_take[3]="Useful Information") or (trade_take[4]="Useful Information"){
	        scr_dialogue("useful_information");
	    }
	    else{
	        if (lisc!=step) or (lisc=0) then scr_dialogue("agree");
	        if (lisc=step) and (obj_controller.liscensing>0) then scr_dialogue("agree_lisc");
	    }

	    trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	    trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	    if (diplomacy_faction=6) or (diplomacy_faction=7) or (diplomacy_faction=8) then scr_loyalty("Xeno Trade","+");
	}
	if (rando4>deal) and (trading_artifact=0){
	    trading=0;scr_dialogue("disagree");
	    trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	    trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	}


	    // show_message("G: "+string(liscensing));

	if (trading_artifact!=0){// Eheheheh, good space goy
	    if (rando4<=deal){
	        i=0;
	        repeat(4){i+=1;
	            if (trade_give[i]="Requisition") then requisition-=_opt.number;
	            if (trade_give[i]="Gene-Seed") and (_opt.number>0){
	                gene_seed-=_opt.number;
                
	                if (diplomacy_faction<=5) and (diplomacy_faction!=4) then gene_sold+=_opt.number;
	                if (diplomacy_faction>=6) then gene_xeno+=_opt.number;
	            }
	            if (trade_give[i]="Info Chip") and (_opt.number>0) then info_chips-=_opt.number;
	            if (trade_give[i]="STC Fragment") and (_opt.number>0){
	                var remov,p;remov=0;p=0;
	                repeat(100){
	                    if (remov=0){p=choose(1,2,3);
	                        if (p=1) and (stc_wargear_un>0){stc_wargear_un-=1;remov=1;}
	                        if (p=2) and (stc_vehicles_un>0){stc_vehicles_un-=1;remov=1;}
	                        if (p=3) and (stc_ships_un>0){stc_ships_un-=1;remov=1;}
	                    }
	                }
	            }
	        }
	        trading=0;scr_dialogue("agree");force_goodbye=1;trading_artifact=2;
	        trade_take[0]="";trade_take[1]="";trade_take[2]="";trade_take[3]="";trade_take[4]="";trade_take[5]="";trade_tnum[0]=0;trade_tnum[1]=0;trade_tnum[2]=0;trade_tnum[3]=0;trade_tnum[4]=0;trade_tnum[5]=0;
	        trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	        if (diplomacy_faction=6) or (diplomacy_faction=7) or (diplomacy_faction=8) then scr_loyalty("Xeno Trade","+");
	    }
	    if (rando4>deal){scr_dialogue("disagree");
	        trade_give[0]="";trade_give[1]="";trade_give[2]="";trade_give[3]="";trade_give[4]="";trade_give[5]="";trade_mnum[0]=0;trade_mnum[1]=0;trade_mnum[2]=0;trade_mnum[3]=0;trade_mnum[4]=0;trade_mnum[5]=0;
	    }
	}

	    // show_message("H: "+string(liscensing));

	}


	with(obj_star){
	    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	    if (x<-3500) and (y<-3500){x+=10000;y+=10000;}
	}

	instance_activate_all();


}
