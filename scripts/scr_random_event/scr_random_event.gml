function scr_random_event(execute_now) {

	var _evented = false;
	/*This is some eldar mission, it should be fixed
		var rando4=floor(random(200))+1;
	if (obj_controller.turns_ignored[6]<=0) and (obj_controller.faction_gender[6]=2) then rando4-=2;
	if (obj_controller.turns_ignored[6]<=0) and (rando4<=3) and execute_now and (faction_defeated[6]=0){
	    if (obj_controller.known[eFACTION.Eldar]=2) and (obj_controller.disposition[6]>=-10) and (string_count("Eldar",obj_ini.strin)=0){
			log_message("RE: Eldar Mission 1");
	        // Need something else here that prevents them from asking missions when they are pissed
        
	        obj_turn_end.audiences+=1;// obj_turn_end.audiences+=1;
	        obj_turn_end.audience_stack[obj_turn_end.audiences]=6;
        
	        // if (obj_controller.known[eFACTION.Eldar]>2) then obj_turn_end.audien_topic[obj_turn_end.audiences]="mission";// Random mission?
	        if (obj_controller.known[eFACTION.Eldar]=2){
					scr_audience(eFACTION.Eldar, "mission1", 0, "", 0, 2.2);
	            scr_quest(0,"fund_elder",6,24);
	        }
        
	        exit;
	    }
	}*/
	var chosen_event;

	var inquisition_mission_roll = irandom(100);
	var force_inquisition_mission = false;
	if (((last_mission+50) <= turn) && (inquisition_mission_roll <= 5) && (known[eFACTION.Inquisition] != 0) && (obj_controller.faction_status[eFACTION.Inquisition] != "War")){
		force_inquisition_mission = true;
	}

	if (force_inquisition_mission && random_event_next == EVENT.none) {
		chosen_event = EVENT.inquisition_mission;
	}
	else {
		if(execute_now)
		{
			var random_event_roll = irandom(100);
		    if ((last_event+30)<=turn) then random_event_roll=1;// If 30 turns without random event then do one
			if (random_event_roll>5) then exit;// Frequency of events
			if ((turn-15)<last_event) then exit;// Minimum interval between
		}
		
		if(random_event_next != EVENT.none) {
			chosen_event = random_event_next;
		}
		else {
			var player_luck;
			var luck_roll = roll_dice_chapter(1, 100, "low");

			if (luck_roll<=45) then player_luck=luck.good;
			if (luck_roll>45) and (luck_roll<55) then player_luck=luck.neutral;
			if (luck_roll>=55) then player_luck=luck.bad;

		
				var events;
				if(player_luck == luck.good){
					events = 
					[
						EVENT.space_hulk,
						EVENT.promotion,
						EVENT.strange_building,
						EVENT.sororitas,
						EVENT.rogue_trader,
						EVENT.inquisition_mission,
						EVENT.inquisition_planet,
						EVENT.mechanicus_mission
					];
				}
				else if(player_luck == luck.neutral){
					events = 
					[
						EVENT.strange_behavior,
						EVENT.fleet_delay,
						EVENT.harlequins,
						EVENT.succession_war,
						EVENT.random_fun,
					];
				}
				else if(player_luck == luck.bad){
					events = 
					[
						EVENT.warp_storms,
						EVENT.enemy_forces,
						EVENT.crusade, // Reportly breaks often because of lack of imperial fleets and eats player ships // TODO LOW CRUSADE_EVENT // fix
						EVENT.enemy, // Save-scumming event, Should probably base this on something else than tech-scavs
						EVENT.mutation,
						EVENT.ship_lost, // Another save-scumming event, mainly due to rarity of player ships
						//EVENT.chaos_invasion, // Spawns Chaos fleets way too close to player owned worlds with no warning and usually lots of big ships, save-scum galore and encourages fleet-based chapters // TODO LOW INVASION_EVENT // Make them spawn way farther with more warning, make them have a different goal or remove this event entirely
						EVENT.necron_awaken, // Inquisitor check for this is inverted
						EVENT.fallen, // Event mission cannot be completed and never expires // TODO LOW FALLEN_EVENT // fix
					];
				}
	
				var events_count = array_length(events);
				var events_total = events_count;
				var events_share = array_create(events_count, 1);
	
				for(var i = 0; i < events_count; i++){
					var curr_event = events[i];			
					
					//DEBUG-INI (EVENTS DEBUG CODE - 1)
					//Comment/delete this when not debugging events
					//List of possible events above
					/*curr_event =  EVENT.necron_awaken
					events_count = 1
					events_total = events_count;
					events_share = array_create(events_count, 1);*/
					//DEBUG-FIN (EVENTS DEBUG CODE - 1)
					
					switch (curr_event){
						case EVENT.inquisition_planet:
							if (known[eFACTION.Inquisition]==0 || obj_controller.faction_status[eFACTION.Inquisition]=="War") {
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.inquisition_mission:
							if (known[eFACTION.Inquisition]==0 || obj_controller.disposition[4] < 0 || obj_controller.faction_status[eFACTION.Inquisition] == "War") {
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.mechanicus_mission:
							if (known[eFACTION.Mechanicus] == 0 || obj_controller.disposition[3] < 50 || obj_controller.faction_status[eFACTION.Mechanicus] == "War") {
								events_share[i] -= 1;
								events_total -= 1;
							}
							else if(scr_has_adv("Tech-Brothers")){
								events_share[i] += 2;
								events_total += 2;
							}
							break;
						case EVENT.enemy:
							if(scr_has_adv("Scavangers")){
								events_share[i] += 2;
								events_total += 2;
							}
							break;
						case EVENT.mutation:
							if(gene_seed < 5){
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.necron_awaken:
							if((known[eFACTION.Inquisition] == 0)){
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.crusade:
							if (obj_controller.faction_status[eFACTION.Imperium] == "War"){
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.fleet_delay:
							var has_moving_fleet = false;
							with(obj_p_fleet){
								if(action=="move")
								{
									has_moving_fleet = true;
									break;
								}
							}
							if(!has_moving_fleet){
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.ship_lost:
							var has_moving_fleet = false;
							with(obj_p_fleet){
								if(action=="move")
								{
									has_moving_fleet = true;
									break;
								}
							}
							if(!has_moving_fleet){
								events_share[i] -= 1;
								events_total -= 1;
							}
							break;
						case EVENT.fallen:
							if(!scr_has_disadv("Never Forgive"))
							{
								events_share[i] -= 1;
								events_total -= 1;
							}
					}
				}
	
				chosen_event = irandom(events_total);
				for(var i = 0; i < events_count; i++){
					chosen_event -= events_share[i];
					if(chosen_event <= 0)
					{
						chosen_event = events[i];
						break;
					}
				}
				//DEBUG-INI (EVENTS DEBUG CODE - 2)
				//Comment/delete this when not debugging events
				//If event on the switch above, (EVENTS DEBUG CODE - 1) var should be set to event too.
				/*chosen_event =  EVENT.necron_awaken*/
				//DEBUG-FIN (EVENTS DEBUG CODE - 2)
		}
	}
	
	if (!execute_now){
		random_event_next = chosen_event;
		exit;
	}

	if (chosen_event == EVENT.strange_behavior){
		//TODO this event currenlty dose'nt do anything but now we have marine structs there is lots of potential here
		init_marine_acting_strange()
		_evented=true;
	}
	
	else if (chosen_event == EVENT.space_hulk){
	
		log_message("RE: Space Hulk");
	    var own=choose(1,1,2);
		
	    var star_id = scr_random_find(own,true,"","");
		if(star_id == undefined && own == 1){
			// find the nearest star to a player fleet and user that one, dukecode did that
			// we could also try to find to find another star but this one is owned by the imperium and not the player, this code is doing that
			own = 2;
			star_id = scr_random_find(own,true,"","");
		}
		if(star_id == undefined && own == 2){
			star_id = scr_random_find(0,true,"",""); // try for litteraly any star
		}
		
		if(star_id == undefined){
			log_error("RE: Space Hulk, couldn't find a star for the spacehulk");
			exit;
		}
		else {
			var positionFound = false;
			var spaceHulkX, spaceHulkY, tries_to_place_space_hulk;
			tries_to_place_space_hulk = 0;
			while(!positionFound && tries_to_place_space_hulk < 50){
				spaceHulkX=star_id.x+(choose(-1,1)*irandom_range(50,60));
				spaceHulkY=star_id.y+(choose(-1,1)*irandom_range(50,80));
				spaceHulkY = max(spaceHulkY,40);
				var distanceToNearestStarOk = point_distance(spaceHulkX,spaceHulkY,instance_nearest(spaceHulkX,spaceHulkY,obj_star).x,instance_nearest(spaceHulkX,spaceHulkY,obj_star).y)>=70
                if (distanceToNearestStarOk){
					positionFound=true; 
	            }
				tries_to_place_space_hulk++; 
			}
			if(tries_to_place_space_hulk >= 50)
			{
				// its possible for there to be no good spot for the space hulk at a star, if there are too many stars in close proximity
				log_error($"RE: Space Hulk, couldn't find a spot for the spacehulk at the {star_id.name} system");
				exit;	
			}
			try{
				var spaceHulk = scr_create_space_hulk(spaceHulkX,spaceHulkY);
				
				scr_alert(own?"red":"green","space_hulk",$"The Space Hulk {spaceHulk.name} appears near the {star_id.name} system.",spaceHulkX,spaceHulkY);

				scr_event_log("",$"The Space Hulk {spaceHulk.name} appears near the {star_id.name} system.",star_id.name);
		        _evented = true;
			}
			catch(_exception){
				handle_exception(_exception);
			}
		}
	}
	
	else if (chosen_event == EVENT.promotion){
		log_message("RE: Promotion");
	    var marine_and_company = scr_random_marine([obj_ini.role[100][8],obj_ini.role[100][12],obj_ini.role[100][9],obj_ini.role[100][10]],0);
		if(marine_and_company == "none")
		{
			log_error("RE: Promotion, couldn't pick a space marine");
			exit;
		}
		var marine=marine_and_company[1];
		var company=marine_and_company[0];
		var _unit = obj_ini.TTRPG[company][marine];
		var role=_unit.role();
		var text = _unit.name_role();
		var company_text = scr_convert_company_to_string(company);
		//var company_text = scr_company_string(company);
		if(company_text != ""){
			company_text = "("+company_text+")";
		}
		text += company_text;
		text += " has distinguished himself.##He åis up for review to be promoted.";
		
		if (company != 10){
			_unit.add_exp(10);
		}
		else {
			_unit.add_exp(max(20, _unit.experience));
		}
		
		scr_popup("Promotions!",text,"distinguished","");
        scr_event_log("green",text);
		_evented = true;
	}
    
	else if (chosen_event == EVENT.strange_building){
		_evented = strange_build_event();
	}
    
	else if (chosen_event == EVENT.sororitas){
		log_message("RE: Sororitas Company");
	    var own;
	    own=choose(1,2);
		var star_id = scr_random_find(own,true,"","");
		
		if(star_id == undefined && own == 1){
			own = 2;
			star_id = scr_random_find(own,true,"","");
		}
		
		if(star_id == undefined){
			log_error("RE: Sororitas Company, couldn't find a star for the company");
			exit;
		}
		else{
			var eligible_planets = [];
			for(var i = 1; i <= star_id.planets;i++){
				if(star_id.p_type[i] != "Dead"){
					array_push(eligible_planets,i);
				}	
			}
			if(array_length(eligible_planets) == 0){
				log_error("RE: Sororitas Company, couldn't find a planet on the " + star_id.name + " system for the company");
				exit;
			}
			
			var planet = eligible_planets[irandom(array_length(eligible_planets)-1)];
			++(star_id.p_sisters[planet]);
			_evented = true;
			
			if ((own!=1) && (star_id.p_player[planet]<=0) && (star_id.present_fleet[1]==0)){
				scr_alert("green","sororitas","Sororitas place a company of sisters on "+string(star_id.name)+" "+string(planet)+".",star_id.x,star_id.y);
			}
			else{
	            scr_popup("Sororitas","The Ecclesiarchy have placed a company of sisters on "+string(star_id.name)+" "+string(planet)+".","sororitas","");
	            if (known[eFACTION.Ecclesiarchy]==0){
					known[eFACTION.Ecclesiarchy]=1; // this seesms like a thing another part of code already does, not sure tho
				}
			}
		}
    
	} else if (chosen_event == EVENT.mechanicus_mission) {
		evented = spawn_mechanicus_mission();

	}
    
	else if (chosen_event == EVENT.inquisition_planet || chosen_event == EVENT.inquisition_mission) {
		scr_inquisition_mission(chosen_event);
	    _evented = true;
	}

	else if (chosen_event == EVENT.rogue_trader){
		log_message("RE: Rogue Trader");
		var eligible_stars = [];
		with(obj_star) {
			for(var i = 0; i <= 4; i++) {
				//feather sometimes thinks the Player part is an object..silly feather
				if(p_owner[i] == eFACTION.Player) {
					array_push(eligible_stars,self);
					break;
				}
			}
		}
		with(obj_p_fleet) {
			if(capital_number>0 && action=="") {
				var star = instance_nearest(x,y,obj_star)
				array_push(eligible_stars,star);			
			}
		}
		
		var stars_count = array_length(eligible_stars);
		if(stars_count == 0) {
			log_error("RE: Rogue Trader, couldn't find a star");
			exit;
		}
		
		var star = eligible_stars[irandom(stars_count - 1)];
	    var text = "A Rogue Trader fleet has arrived in the ";
        text += star.name;
		text += " system to trade.  ";
		var owns_planet_on_star = false;
		for(var i = 0; i <= 4; i++) {
			if(star.p_owner[i] == eFACTION.Player){
				owns_planet_on_star = true;
				break;
			}
		}
		if (owns_planet_on_star) {
			text+="Wargear is slightly cheaper for the duration of their visit.";
		}
		else {
			text+="Present Battle Barges will have access to cheaper wargear for the duration of their visit.";
		}
		scr_popup("Rogue Trader", text, "rogue_trader", "");
		star.trader += choose(3,4,5);
        var star_alert;
		star_alert = instance_create(star.x+16,star.y-24,obj_star_event);
		star_alert.image_alpha = 1;
		star_alert.image_speed = 1;
        _evented = true;
	}

	else if (chosen_event == EVENT.fleet_delay){
		log_message("RE: Fleet Delay");
	    var eligible_fleets = [];
		with(obj_p_fleet) {
			if (action == "move")
			{
				array_push(eligible_fleets, id);
			}
		}
		
		var fleet_count = array_length(eligible_fleets);
		if(fleet_count == 0) {
			log_error("RE: Fleet Delay, couldn't pick a fleet");
			exit;
		}
		
		var fleet = eligible_fleets[irandom(fleet_count - 1)];
		
    
	    if (fleet.action="move"){
	            var targ,delay;targ=0;delay=0;
	            if (instance_exists(fleet)){
	                delay=choose(1,2,2,3);
					fleet.action_eta += delay;
					var text = "Eldar pirates have attacked your fleet destined for ";
	                var target_star = instance_nearest(fleet.action_x, fleet.action_y,obj_star); // isn't there a better way?
	                var fleet_destination;
					if(instance_exists(target_star)){
						fleet_destination = target_star.name;
						text += string(fleet_destination) + ". Damage was minimal but the voyage has been delayed by " + string(delay)+ " months.";
					}
					else {
						text = "Eldar pirates have attacked your fleet. Damage was minimal but the voyage has been delayed by " + string(delay)+ " months.";
					}
	                scr_popup("Fleet Attacked",text,"","");
					_evented = true;
	                var star_alert =instance_create(fleet.x+16,fleet.y-24,obj_star_event);
					star_alert.image_alpha=1;
					star_alert.image_speed=1;
					star_alert.col = "red";
	        }
	    }
	}
    
	else if (chosen_event == EVENT.harlequins) {
		log_message("RE: Harlequins");
	    var owner = choose(1,2,2,2,3);
		var star = scr_random_find(owner,true,"","");
		if(!instance_exists(star) && owner != 2) {
			owner = 2;
			star = scr_random_find(owner,true,"","");
		}
		if(!instance_exists(star)){ 
			log_error("RE: Harlequins, couldn't find star");
			exit;
		}
		
	    var planet=irandom_range(1,star.planets);
	    if ( add_new_problem(planet, "harlequins", irandom_range(2,5),star)){
		    var text="Eldar Harlequins have been seen on planet " + string(star.name) + " " + scr_roman(planet) + ". Their purposes are unknown.";
		    scr_popup("Harlequin Troupe",text,"harlequin","");
		    var star_alert = instance_create(star.x+16,star.y-24,obj_star_event);
			star_alert.image_alpha=1;
			star_alert.image_speed=1;
			star_alert.col="green";
	    }
	}
    
	else if (chosen_event == EVENT.succession_war){
		log_message("RE: Succession War");
		var eligible_stars=[];
	    with(obj_star){
	        for(var planet = 1; planet <= planets; planet++){
				if(p_owner[planet] == eFACTION.Imperium && p_type[planet] != "Dead" && p_type[planet] != "Ice" &&p_type[planet] != "Lava") {
					array_push(eligible_stars,id);
					break;
				}
			}
	    }
		var star_count = array_length(eligible_stars);
		if(star_count == 0)
		{
			log_error("RE: Succession War, couldn't find a star");
			exit;
		}
		
		var star = eligible_stars[irandom(star_count-1)];
		var planet;
		for(var i = 1; i <= star.planets; i++){
			if(star.p_owner[i] == eFACTION.Imperium && star.p_type[i] != "Dead" && star.p_type[i] != "Ice" && star.p_type[i] != "Lava") {
				planet = i;
				break;
			}
		}
		
		array_push(star.p_feature[planet], new PlanetFeature(P_features.SuccessionWar));
		add_new_problem(planet, "succession",irandom(6) + 4, star);
		star.dispo[planet] = -5000; 
		
		var text = string(star.name) + scr_roman(planet);
		scr_popup("War of Succession","The planetary governor of "+string(text)+" has died.  Several subordinates and other parties each claim to be the true heir and successor- war has erupted across the planet as a result.  Heresy thrives in chaos.","succession","");
	    var star_alert=instance_create(star.x+16,star.y-24,obj_star_event);
		star_alert.image_alpha=1;
		star_alert.image_speed=1;
		star_alert.col="red";
		scr_event_log("red","War of Succession on "+string(text));       
		_evented = true;
	}
    
	// Flavor text/events
	else if (chosen_event == EVENT.random_fun){
		log_message("RE: Random");
	    var text;
	    var situation = irandom(4);
		var place = irandom(9);
		
		switch(situation) {
			case 0:
				text="Alien contamination in ";
				break;
			case 1:
				text="Servitors misbehaving at ";
				break;
			case 2:
				text="Nonhuman presence detected at ";
				break;
			case 3:
				text="Critical malfunction in ";
				break;
			case 4:
				text="Abnormal warp flux in ";
				break;
		}
		
		switch (place){
			case 0:
				text +="the Fortress Monastery.";
				break;
			case 1:
				text +="the Refectory.";
				break;
			case 2:
				text +="the Armamentarium.";
				break;
			case 3:
				text +="the Librarium.";
				break;
			case 4:
				text +="the Apothecarium.";
				break;
			case 5:
				text +="the Command sanctum.";
				break;
			case 6:
				text +="the Xenos Bestiarium.";
				break;
			case 7:
				text +="the Hall of Trophies.";
				break;
			case 8:
				text +="the Chapter Crypt.";
				break;
			case 9:
				text +="the Chapter Garage.";
				break;
		}
		scr_alert("color","lol",text,0,0);
        scr_event_log("red",text); 
		_evented = true;
	}

	else if (chosen_event == EVENT.warp_storms){
		log_message("RE: Warp Storm");
	    var own,time,him;
		
		time=irandom_range(6,24);
	    if (scr_has_disadv("Shitty Luck")){
			own=choose(1,2,0,0,0);
		} else if (scr_has_adv("Great Luck")) {
			own=choose(1,1,2,2,0);
		} else {
			own=choose(1,1,2,0,0);
		}
		
		var star_id = scr_random_find(own,true,"","");
		if(star_id == undefined && own == 1){
			own = 2;
			star_id = scr_random_find(own,true,"","");
		}
		if(star_id == undefined && own == 2){
			own = 0;
			star_id = scr_random_find(own,true,"","");
		}
		
		if(star_id == undefined){
			log_error("RE: Warp Storm, couldn't pick a star for the warp storm");
			exit;
		}
		else{
			star_id.storm += time;
			_evented = true;
			var _col = own == 1 ? "red" : "green";
			scr_alert(_col, "Warp", $"Warp Storms rage across the {star_id.name} system.", star_id.x, star_id.y);
			scr_event_log(_col, $"Warp Storms rage across the {star_id.name} system.");
		}
	}
    
	else if (chosen_event == EVENT.enemy_forces){
		log_message("RE: Enemy Forces");
		var own;
	    if (scr_has_disadv("Shitty Luck")){
			own=choose(1,1,1,1,1,1,2,2,3);
		} else if (scr_has_adv("Great Luck")) {
			own=choose(1,1,1,2,2,2,2,3,3);
		} else {
			own=choose(1,1,1,2,2,3);
		}
		
		var star_id = scr_random_find(own,true,"","");
		if(star_id == undefined && own == 1){
			own = 2;
			star_id = scr_random_find(own,true,"","");
		}
		if(star_id == undefined && own == 2){
			own = 3;
			star_id = scr_random_find(own,true,"","");
		}
		
		if(star_id == undefined)
		{
			log_error("RE: Enemy Forces, couldn't find a star for the enemy");
			exit;
		}
		else{
			var eligible_planets = [];
			for(var i = 1; i <= star_id.planets; i++){
				if(star_id.p_type[i] != "Dead")
				{
					array_push(eligible_planets,i);
				}
			}
			if(array_length(eligible_planets) == 0){
				log_error("RE: Enemy Forces, couldn't find a planet in the " + star_id.name +" system for the enemy");
				exit;			
			}
			var planet = eligible_planets[irandom(array_length(eligible_planets) - 1)];
			//var enemy = choose(7,8,9,10,13);
			var enemy = choose(7,8,9);
			var text;
			var max_enemies_on_planet = 5; // I don't know the actual value, i need to change it;
			switch(enemy)
			{
				case 7:
					text = "Orks";
					star_id.p_orks[planet] += 4;
					star_id.p_orks[planet] = min(star_id.p_orks[planet], max_enemies_on_planet);
					break;
				case 8:
					text = "Tau";
					star_id.p_tau[planet] += 4;
					star_id.p_tau[planet] = min(star_id.p_tau[planet], max_enemies_on_planet);
					break;
				case 9:
					text = "Tyranids";
					star_id.p_tyranids[planet] += 5;
					star_id.p_tyranids[planet] = min(star_id.p_tyranids[planet], max_enemies_on_planet);
					break;
				//case 10: this doesn't work
				//	text = "Heretics";
				//	star_id.p_heretics[planet] = 4;
				//	star_id.p_heretics[planet] = min(star_id.p_heretics[planet], max_enemies_on_planet);
				//	break;
				//case 13:
				//	text = "Necron"; // I don't know if its a good idea to spawn necrons from this event, leaving it in for now
				//	star_id.p_necron[planet] = 4;
				//	star_id.p_necron[planet] = min(star_id.p_necron[planet], max_enemies_on_planet);
				//	break;
				default:
					log_error("RE: Enemy Forces, couldn't pick an enemy faction");
					exit;
			}
			scr_alert("red","enemy", $"{text} forces suddenly appear at {star_id.name} {planet}!",star_id.x,star_id.y);
            scr_event_log("red",$"{text} forces suddenly appear at {star_id.name} {planet}!");
			_evented = true;
		}
	}

	else if ((chosen_event == EVENT.crusade)){
		//i think all events should be hanlded like this then we have far more options on when to call them and how they work
		_evented = launch_crusade();
	}
    
	else if (chosen_event == EVENT.enemy) {
		_evented = make_faction_enemy_event();
	}
    
	else if ((chosen_event == EVENT.mutation)) {
		//TODO make reprocussions to ignoring this
		log_message("RE: Gene-Seed Mutation");
	    var text = "The Chapter's gene-seed has mutated!  Apothecaries are scrambling to control the damage and prevent further contamination.  What is thy will?";
		var _opt1 = "Dispose of ";
		var _percent_remove = 0;
		if (obj_controller.gene_seed <= 30) {
			_opt1 += "100% of the gene-seed.";
			_percent_remove = 100;
		}
		if ((obj_controller.gene_seed > 30) && (obj_controller.gene_seed < 60)) {
			_opt1 += "50% of all gene-seed.";
			_percent_remove = 50;
		}
		if (obj_controller.gene_seed >= 60) {
			_opt1 += "33% of all gene-seed.";
			_percent_remove = 33;
		}

		var _opt2 = "Tell the apothecaries to let it be.";


	    var _pop_data = {
	    	percent_remove : _percent_remove,
	    	options : [
	    		{
	    			str1:_opt1,
	    			method : event_dispose_of_mutated_gene,
	    		},
	    		{
	    			str1:_opt2,
	    			method : function(){
	    				scr_loyalty("Mutant Gene-Seed", "+");
	    				popup_default_close();
	    			}
	    		},	    		
	    	]
	    }

	    scr_popup("Gene-Seed Mutated!",text,"gene_bad","",_pop_data);
		_evented = true;
	    scr_event_log("red","The Chapter Gene-Seed has mutated.");
	}

	else if (chosen_event == EVENT.ship_lost){
		loose_ship_to_warp_event();
	}
    
	else if (chosen_event == EVENT.chaos_invasion){
	    log_message("RE: Chaos Invasion");
    
		add_event({
			e_id : "chaos_invasion",
			duration : 1
		})
		
		var psyker_intolerant = scr_has_disadv("Psyker Intolerant");
	    var has_chief_psyker = scr_role_count("Chief "+string(obj_ini.role[100,17]),"") >= 1;
		var cm_is_psyker = false;
		for(var i = 1; i < 100; i++){
			if (obj_ini.role[0,i] == obj_ini.role[100][eROLE.ChapterMaster] && string_count("0",obj_ini.spe[0,i]) > 0) { 
				cm_is_psyker = true;
				break;
			}
		}
		
	    if ((!psyker_intolerant) && (has_chief_psyker)) {
			scr_popup("The Maw of the Warp Yawns Wide","Chief "+string(obj_ini.role[100,17])+" "+string(obj_ini.name[0,5])+" reports that the barrier between the realm of man and the Immaterium feels thin and tested.","Warp","");
		}
	    else if ((psyker_intolerant || !has_chief_psyker) && (cm_is_psyker)) {
			scr_popup("The Maw of the Warp Yawns Wide","The barrier between the realm of man and the Immaterium feels thin and tested to you.  Dark forces are afoot.","Warp","");
		}

	}
    
	else if (chosen_event == EVENT.necron_awaken){
		_evented = awaken_tomb_event();
	}
	
	else if(chosen_event == EVENT.fallen){
		event_fallen();
		_evented = true;
	}

	if(_evented) {
		if(force_inquisition_mission && chosen_event == EVENT.inquisition_mission) {
			last_mission=turn;
		}
		else {
			last_event=turn;
			if (random_event_next != EVENT.none){
				random_event_next = EVENT.none;
			}
		}
	}


	// these shouldn't be needed anymore, the old code moved object to hide them sometimes
	//instance_activate_object(obj_p_fleet);
	//with(obj_p_fleet){if (x<-10000){x+=20000;y+=20000;}}
	//with(obj_en_fleet){if (x<-10000){x+=20000;y+=20000;}}
	//with(obj_star){if (x<-10000){x+=20000;y+=20000;}}


}


function event_fallen(){
	log_message("RE: Hunt the Fallen");
	var stars = scr_get_stars();
	var valid_stars = scr_get_stars(false, [eFACTION.Imperium]);
	
	if (array_length(valid_stars) == 0){
		log_error("RE: Hunt the Fallen, coulnd't find a star");
		exit;
	}
	log_message($"Fallen: valid_stars {valid_stars}")
	
	var star = choose_array(stars);
	var planet = scr_get_planet_with_owner(star,eFACTION.Imperium);
	var eta = scr_mission_eta(star.x,star.y, 1);

	if (planet>0){
		log_message($"Fallen: found star {star.name} planet {planet} as candidate")
		
		var assigned_problem = add_new_problem(planet, "fallen", eta,star)
		log_message($"assigned_problem {assigned_problem}")

		if (!assigned_problem) {
			log_error("RE: Hunt the Fallen, coulnd't assign a problem to the planet");
			return;
		}
		
		var text = "Sources indicate one of the Fallen may be upon "+string(star.name)+" "+string(scr_roman(planet))+".  We have "+string(eta)+" months to send out a strike team and scour the planet.  Any longer and any Fallen that might be there will have escaped.";
		scr_popup("Hunt the Fallen",text,"fallen","");
		scr_event_log("","Sources indicate one of the Fallen may be upon "+string(star.name)+" "+string(scr_roman(planet))+".  We have "+string(eta)+" months to investigate.");
		var star_alert = instance_create(star.x+16,star.y-24,obj_star_event);
		star_alert.image_alpha=1;
		star_alert.image_speed=1;
		star_alert.col="purple";
	}

}
