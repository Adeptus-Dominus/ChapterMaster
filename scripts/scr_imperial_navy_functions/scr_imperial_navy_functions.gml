function navy_orbiting_planet_end_turn_action(){
	end_sequence_finished = false;
	var _war_with_player = obj_controller.faction_status[eFACTION.Imperium] == "War";
	if trade_goods != "player_hold" {


	if (trade_goods="" && _is_orbiting){
	    if (orbiting.present_fleet[20]>0){
	    	end_sequence_finished = true;
	    }
	}


	// Check if the ground battle is victorious or not
	if (!end_sequence_finished && _war_with_player && trade_goods="invading_player" && guardsmen_unloaded=1) {
		navy_finish_destroying_player_world();
	}

	// Invade the player homeworld as needed
	if (!end_sequence_finished){
		navy_attack_player_world();
	}
	// Bombard the shit out of the player homeworld
	if (!end_sequence_finished &&_war_with_player && trade_goods="" && !guardsmen_unloaded && _is_orbiting){
		navy_bombard_player_world();
	}


	if (!end_sequence_finished &&_war_with_player && action="" && trade_goods="" && guardsmen_unloaded=0) {
	    navy_hunt_player_assets()
	}

	//Eldar shit I think? Doesn't check for eldar ships
	if (!new_navy_ships_forge()){
		exit;
	}
	if (trade_goods=="building_ships"){
		end_sequence_finished = true;;
	}


	//OK this calculates how many imperial guard the ships have and can have at a max
	guardsmen_ratio = fleet_remaining_guard_ratio();
	with(obj_temp_inq){instance_destroy();}



	if (action="" && _is_orbiting && guardsmen_unloaded=1){// Move from one planet to another
		scr_navy_has_unloaded_guardsmen_turn_end();
	}


	if (navy_strength_calc()<=14 && guardsmen_unloaded=0){
		dock_navy_at_forge();

		send_navy_to_forge();
	}
	// Bombard the shit out of things when able
	 else if (trade_goods=="" && action=""){
	    imperial_navy_bombard();
	}


	// If the guardsmen all die then move on
	var o=0;
	if (!end_sequence_finished && guardsmen_unloaded=1{
	    var o=0,guardsmen_alive=1;
	    repeat(orbiting.planets){
            o+=1;
	        if (orbiting.p_guardsmen[o]>0){
	        	guardsmen_alive=false;
	        	break;
	        }
	    }
	    if (guardsmen_alive=1){
            guardsmen_unloaded=0;
            guardsmen_ratio=0;
            trade_goods="";
        }
	}


	// Go to recruiting grounds
	if ((guardsmen_unloaded=0 && guardsmen_ratio<0.5 && (trade_goods="")) || trade_goods="recr"){// determine what sort of planet is needed
		scr_navy_find_recruit_world();
	}
	// Get recruits
	if (action=""  && trade_goods="goto_recruiting" && _is_orbiting){
		scr_navy_recruit_new_guard();
	}
	scr_navy_planet_action();
	if (trade_goods="recruited"){
		trade_goods="";
	}
	/* */
	}	
}



function build_new_navy_fleet(construction_forge){
	    new_navy_fleet=instance_create(construction_forge.x,construction_forge.y,obj_en_fleet);

	    with(new_navy_fleet){
    	    owner=eFACTION.Imperium;
    	    
    	    capital_number=0;
    	    frigate_number=0;
    	    escort_number=1;
    	    home_x=x;
    	    home_y=y;
    	    warp_able = true;
    	    with (construction_forge){present_fleet[2]+=1;}
    	    orbiting=construction_forge;
    	    navy=1;
    	    
    	    var total_ships=0;
    	    total_ships+=capital_number-1;
    	    total_ships+=round((frigate_number/2));
    	    total_ships+=round((escort_number/4));
    	    if (total_ships<=1 && capital_number+frigate_number+escort_number>0) then total_ships=1;
    	    choose_fleet_sprite_image()
    	    image_index=total_ships;
    	    image_speed=0;
    	    
    	    trade_goods="building_ships";
    	}
}



function new_navy_ships_forge(){
    if (trade_goods=="building_ships"){
        var onceh=0,advance=false,p=0;
    
        p=0;
        is_orbiting();
        for (var p=1;p<=orbiting.planets;p++){
            if (orbiting.p_type[p]="Forge"){
                //if no non-imperium,player, or eldar aligned fleets or ground forces, continue
                if (orbiting.p_orks[p]+orbiting.p_chaos[p]+orbiting.p_tyranids[p]+orbiting.p_necrons[p]+orbiting.p_tau[p]+orbiting.p_traitors[p]=0){
                    if (orbiting.present_fleet[7]+orbiting.present_fleet[8]+orbiting.present_fleet[9]+orbiting.present_fleet[10]+orbiting.present_fleet[13]=0){
                        advance=1;
                    }
                }
            }
        }
        
        if (!advance) then return false;

        //TODO here we can make fleet be restored more quickly by better forge worlds 
        if (escort_number<12)  {
            escort_number+=1;
        }

        else if (frigate_number<5) {
            frigate_number+=0.25;
            onceh=1;
            if (frigate_number>4.99) then frigate_number=5;
        }

        else if (capital_number<1) {
            capital_number+=0.0834;
            if (capital_number>1) then capital_number=1;
        }
        if (onceh=1){
            var ii=0;
            ii+=capital_number;
            ii+=round((frigate_number/2));
            ii+=round((escort_number/4));

            image_index=ii<=1?1:ii;
        }
    
        if (capital_number>=1 && frigate_number>=5 && escort_number>=12){
            var i=0;
            repeat(capital_number){i+=1;
                capital_max_imp[i]=(((floor(random(15))+1)*1000000)+15000000)*2;
            }
            i=0;
            repeat(frigate_number){i+=1;
                frigate_max_imp[i]=(500000+(floor(random(50))+1)*10000)*2;
            }
            trade_goods="";
        }

    
        //if (trade_goods="building_ships" || !advance) then exit;
        return advance;
    } else{
    	return true;
    } 
}
//TODO further breakup into a nvay fleet functions script
function navy_strength_calc(){
    return ((capital_number*8)+(frigate_number*2)+escort_number);
}

function dock_navy_at_forge(){

    // Got to forge world
    if (action="" && trade_goods="goto_forge" && instance_exists(orbiting)){
        trade_goods="building_ships";
    }
}

function send_navy_to_forge(){
    // Quene a visit to a forge world
    if (action="" && trade_goods="" && instance_exists(orbiting)){

        var forge_list = [];
        with(obj_star){
            var cont=0;
            for (var p=1;p<planets;p++){

                if (p_type[p]=="Forge"){
                    if (p_orks[p]+p_chaos[p]+p_tyranids[p]+p_necrons[p]+p_tau[p]+p_traitors[p]=0){
                        if (present_fleet[7]+present_fleet[8]+present_fleet[9]+present_fleet[10]+present_fleet[13]=0){
                            cont=1;
                        }
                    }
                }
            }
            if (cont){
                array_push(forge_list,id);
            }
        }
        if (array_length(forge_list)){
            var go_there=nearest_from_array(x,y,forge_list);
            var target_forge = forge_list[go_there];
            action_x=target_forge.x;
            action_y=target_forge.y;
            trade_goods="goto_forge";// show_message("D");
            set_fleet_movement();
        }
    }
}

function imperial_navy_bombard(){
	if (turns_static < 12){
		exit;
	}
	var _fleets = get_orbiting_fleets([6,7,8,9,10,11,12,13],orbiting);
	if (array_length(_fleets)){
		exit;
	}

	if ((orbiting.present_fleet[1]>0 && obj_controller.faction_status[eFACTION.Imperium]="War")){
		exit;
	}

    for (var p=0;p<=orbiting.planets;p++){
        if (orbiting.p_type[p]!="Daemon"){
            if (orbiting.p_population[p]=0 && orbiting.p_tyranids[p]>0 && onceh=0){
                bombard=p;

            }
            else if (orbiting.p_population[p]=0 && orbiting.p_orks[p]>0 && orbiting.p_owner[p]=7 && onceh=0){
            	bombard=p;
            }
            else if (orbiting.p_owner[p]=8 && orbiting.p_tau[p]+orbiting.p_pdf[p]>0 && onceh=0){
                bombard=p;

            }
            else if (orbiting.p_owner[p]=10 && (orbiting.p_chaos[p]+orbiting.p_traitors[p]+orbiting.p_pdf[p]>0 || orbiting.p_heresy[p]>=50)){
            	bombard=p;
            }
            else{
            	var _cults = return_planet_features(orbiting.p_features[p],P_features.Gene_Stealer_Cult);
            	if (array_length(_cults)){
            		if (!_cults[0].hiding){
            			bombard=p;
            		}
            	}
            }
        }
    }

    if (bombard>0){
		if (guardsmen_unloaded){
			navy_load_guardsmen();
		}
    	var _p_data = new PlanetData(bombard, orbiting);
    	scare=(capital_number*3)+frigate_number;
    	_p_data.suffer_navy_bombard(scare);
       
        exit;
    }    
}


function navy_hunt_player_assets(){
	var hold = false;
    if (_is_orbiting){
		var player_owns_planet = scr_get_planet_with_owner(orbiting, eFACTION.Player);	    	
        hold = player_owns_planet or (orbiting.present_fleet[eFACTION.Player] > 0)
    }

    if (hold){
        // Chase player fleets
        var chase_fleet = get_nearest_player_fleet(x,y, false, true);
        if (chase_fleet!="none"){
            var thatp,my_dis;
			etah=chase_fleet.eta;
        	
        	var intercept =  fleet_intercept_time_calculate(chase_fleet);
            if (intercept){

                if (intercept<=etah) {
                	target = chase_fleet.id;
					chase_fleet_target_set(target);
                    trade_goods="player_hold";
                    exit;
                }
            }
            with(obj_temp8){instance_destroy();}
        }
        // End chase
    
    
        // Go after home planet or fleet?
    
    
        if (trade_goods="" && action="") {
            var homeworld_distance,homeworld_nearby,fleet_nearby,fleet_distance,planet_nearby;
            homeworld_distance=9999;fleet_distance=9999;fleet_nearby=0;homeworld_nearby=0;planet_nearby=0;
        
            with(obj_p_fleet){ 
				if (action="") then instance_create(x,y,obj_temp7);
			}
            with(obj_star) {
				if array_contains(p_owner, eFACTION.Player)
					instance_create(x,y,obj_temp8);
			}
        
            if (instance_exists(obj_temp7)) {
				fleet_nearby=instance_nearest(x,y,obj_temp7);
				fleet_distance=point_distance(x,y,fleet_nearby.x,fleet_nearby.y);
			}
            if (instance_exists(obj_temp8)) {homeworld_nearby=instance_nearest(x,y,obj_temp8);
				homeworld_distance=point_distance(x,y,homeworld_nearby.x,homeworld_nearby.y)-30;
			}
        
            if (homeworld_distance<fleet_distance && homeworld_distance<5000 && homeworld_distance>40) {// Go towards planet
                action_x=homeworld_nearby.x;
				action_y=homeworld_nearby.y;
				set_fleet_movement();// show_message("B");
                with(obj_temp7){instance_destroy();}
                with(obj_temp8){instance_destroy();}
                exit;
            }
        
        
        
            if (fleet_distance<homeworld_distance && fleet_distance<7000 && fleet_distance>40 && instance_exists(obj_temp7)) {// Go towards that fleet
                planet_nearby=instance_nearest(fleet_nearby.x,fleet_nearby.y,obj_star);
            
                if (instance_exists(planet_nearby) && _is_orbiting){
					if (fleet_distance<=500 && planet_nearby!=orbiting){// Case 1; really close, wait for them to make the move
                        with(obj_temp7){instance_destroy();}
                        with(obj_temp8){instance_destroy();}
                        exit;
                    }
                    if (fleet_distance>500) {// Case 2; kind of far away, move closer
                        var diss=fleet_distance/2;
                        var goto=0;
                        var dirr=point_direction(x,y,fleet_nearby.x,fleet_nearby.y);
                    
                        with(orbiting){y-=20000;}
                        goto=instance_nearest(x+lengthdir_x(diss,dirr),y+lengthdir_x(diss,dirr),obj_star);
                        with(orbiting){y+=20000;}
                        if (goto.present_fleet[eFACTION.Player]=0) {
							action_x=goto.x;
							action_y=goto.y;
							set_fleet_movement();
						}
                    
                        with(obj_temp7){instance_destroy();}
                        with(obj_temp8){instance_destroy();}
                        exit;
                    }
                }
            
            }
        }
    
        with(obj_temp7){instance_destroy();}
        with(obj_temp8){instance_destroy();}

        /*var homeworld_distance,homeworld_nearby,fleet_nearby,fleet_distance;
        homeworld_distance=9999;fleet_distance=9999;fleet_nearby=0;homeworld_nearby=0;
    
        with(obj_p_fleet){if (action!="") then y-=20000;}// Disable non-stationary player fleets
        if (instance_exists(obj_p_fleet)){fleet_nearby=instance_nearest(x,y,obj_p_fleet);fleet_distance=point_distance(x,y,fleet_nearby.x,fleet_nearby.y);}// Get closest player fleet
        with(obj_star){if (owner  = eFACTION.Player) then instance_create(x,y,obj_temp7);}// Create temp7 at player stars
        if (instance_exists(obj_temp7)){homeworld_nearby=instance_nearest(x,y,obj_temp7);homeworld_distance=point_distance(x,y,homeworld_nearby.x,homeworld_nearby.y);}// Get closest star
        with(obj_p_fleet){if (y<-10000) then y+=20000;}// Enable non-stationary player fleets
    
        if (homeworld_distance<=fleet_distance && homeworld_distance<7000 && instance_exists(homeworld_nearby)){// Go towards planet
            action_x=homeworld_nearby.x;action_y=homeworld_nearby.y;set_fleet_movement();;exit;
        }
    
    
    */

    }
}

function navy_finish_destroying_player_world(){
			
	//slightly more verbose than the last way, but reduces reliance on fixed array sizes
    var tar = array_reduce(orbiting.p_guardsmen, function(prev, curr, idx) {
		return curr > 0 ? idx : prev;
	},0)
	
    if (tar == 0) {// Guard all dead
        trade_goods="recr";
        action="";
    } else { //this was always a dead path previously since tar could never be bigger than i, now it will
    	var _targ = new PlanetData(tar, orbiting);
        if (orbiting.p_owner[tar]=eFACTION.Player && orbiting.p_player[tar]=0 && planet_feature_bool(orbiting.p_feature[tar],P_features.Monastery)==0){
            _targ.return_to_first_owner();
			_targ.add_disposition(-50);
            trade_goods="";
			action="";
        }
    }	
}
function navy_attack_player_world(){
	if (obj_controller.faction_status[eFACTION.Imperium]="War" && trade_goods="invade_player" && guardsmen_unloaded=0){
	    if (instance_exists(orbiting)){
	        var tar=0;
			var i=0;
	        for (i = 1; i <= orbiting.planets; i++) {
	            if (orbiting.p_owner[i]=eFACTION.Player) 
					and (planet_feature_bool(orbiting.p_feature[i],P_features.Monastery)==0) 
					and (orbiting.p_guardsmen[i]=0) 
					then tar=i;
	        }
	        if (tar){
	            guardsmen_unloaded=1;
	            i=0;
				repeat(20) {
					i+=1;
					if (capital_imp[i]>0) {
						orbiting.p_guardsmen[tar]+=capital_imp[i];
						capital_imp[i]=0;
					}
				}
	            i=0;
				repeat(30) {
					i+=1;
					if (frigate_imp[i]>0) {
						orbiting.p_guardsmen[tar]+=frigate_imp[i];
						frigate_imp[i]=0;
					}
				}
	            i=0;
				repeat(30) {
					i+=1;
					if (escort_imp[i]>0) {
						orbiting.p_guardsmen[tar]+=escort_imp[i];
						escort_imp[i]=0;
					}
				}
	            trade_goods="invading_player";
				exit;
	        }
	    }
	}
}

function navy_bombard_player_world(){
	var bombard=false;
    if (orbiting!=noone){
        if (orbiting.object_index==obj_star) then bombard=true;
    }
    if (bombard){
		var orbiting_guardsmen = array_sum(orbiting.p_guardsmen);
		var player_forces = array_sum(orbiting.p_player);

        if (orbiting_guardsmen == 0 || player_forces > 0) {
			
			//cleaned this up so it is easier to read, even though it reads more verbosely
			var hostile_fleet_count = 0;
			with(orbiting) {
				hostile_fleet_count += present_fleet[eFACTION.Player]
					+ present_fleet[eFACTION.Eldar]
					+ present_fleet[eFACTION.Ork]
					+ present_fleet[eFACTION.Tau]
					+ present_fleet[eFACTION.Tyranids]
					+ present_fleet[eFACTION.Chaos]
					+ present_fleet[eFACTION.Necrons]
			}
            if (hostile_fleet_count == 0){
            
                var bombard=0,deaths=0,hurss=0,onceh=0,wob=0,kill=0;
            
                for (var o=1;o<=orbiting.planets;o++){
                	if (orbiting.p_owner[o]==eFACTION.Player){
                		if (orbiting.p_population[o]+orbiting.p_pdf[o]>0) ||  (orbiting.p_player[o]>0){
                			bombard=o;
                			break;
                		}
                	}
                }
            
                if (bombard){
					var _orbiting_data = new PlanetData(bombard, orbiting);
                    scare=(capital_number*3)+frigate_number;

                    if (scare>2) then scare=2;
                    if (scare<1) then scare=0;
                    //onceh=2;

                    if (orbiting.p_large[bombard]) {
						kill=scare*0.15; // Population if large
					} else {
						kill=scare*15000000; // pop if small
					}

					var bombard_name = _orbiting_data.name();
                    var bombard_report_string=$"Imperial Battlefleet bombards {bombard_name}.";
                    var PDF_loses=min(orbiting.p_pdf[bombard],(scare*15000000)/2);
					
					var civil_loss_mod = orbiting.p_large[bombard]?scare*0.15:scare*15000000;

					var civilian_losses=min(orbiting.p_population[bombard],civil_loss_mod)


                    if (civilian_losses>0 && orbiting.p_large[bombard]=0) then {
						bombard_report_string+=$" {civilian_losses} civilian casualties";
					}
                    if (civilian_losses>0 && orbiting.p_large[bombard]=1) {
                        if (civilian_losses>=1) then bombard_report_string+=$" {civilian_losses} billion civilian casualties";
                        if (civilian_losses<1) then bombard_report_string+=$"  {floor(civilian_losses*1000)} million civilian casualties";
                    }
                    if (PDF_loses>0) then bombard_report_string+=$" and {scr_display_number(PDF_loses)} PDF lost.";
                    if (PDF_loses<=0 && civilian_losses>0) then bombard_report_string+=".";
                    if (civilian_losses=0 && PDF_loses>0) then bombard_report_string+=" {PDF_loses}  PDF lost.";
                    
                    if (bombard_report_string!="") {
                        scr_alert("red","owner",bombard_report_string,orbiting.x,orbiting.y);
                        scr_event_log("red",bombard_report_string, orbiting.name);
                        bombard_report_string=string_replace(bombard_report_string,",.",",");
                    }
                    
                    orbiting.p_pdf[bombard]-=(scare*15000000)/2;
                    if (orbiting.p_pdf[bombard]<0) then orbiting.p_pdf[bombard]=0;

                
                    orbiting.p_population[bombard]-=kill;
                    if (orbiting.p_population[bombard]<0) then orbiting.p_population[bombard]=0;
                    if (orbiting.p_pdf[bombard]<0) then orbiting.p_pdf[bombard]=0;
                
                    if (orbiting.p_population[bombard]+orbiting.p_pdf[bombard]<=0 && orbiting.p_owner[bombard]=eFACTION.Player){
                        if (planet_feature_bool(orbiting.p_feature[bombard], P_features.Monastery)==0) {
                            _orbiting_data.return_to_first_owner();
							_orbiting_data.add_disposition(-50)
                        } else {
                            trade_goods="invade_player";
                        }
                    }
                    exit;
                }
            }
        }
    }
}


function fleet_max_guard(){
	var maxi=0, i=0;
	for (i=0;i<array_length(capital_imp);i++){
	    if (capital_max_imp[i]>0) {
	    	if (capital_number>i){
	    		capital_max_imp[i]=0;
	    	} else if (capital_number<=i){
	    		maxi+=capital_max_imp[i];
	    	}
	    }
	}
	for (i=0;i<array_length(frigate_imp);i++){
	    if (frigate_max_imp[i]>0) {
	    	if (frigate_number>i){
	    		frigate_max_imp[i]=0;
	    	} else if (frigate_number<=i){
	    		maxi+=frigate_max_imp[i];
	    	}
	    }
	}
	for (i=0;i<array_length(escort_imp);i++){
	    if (escort_max_imp[i]>0) {
	    	if (escort_number>i){
	    		escort_max_imp[i]=0;
	    	} else if (escort_number<=i){
	    		maxi+=escort_max_imp[i];
	    	}
	    }
	}
	return maxi;
}

function fleet_guard_current(){
	var curr=0,i=0;
	for (i=0;i<array_length(capital_imp);i++){
	    if (capital_imp[i]>0){ 
	      	if (capital_number<=i){
	    		if (!guardsmen_unloaded){
	    			curr+=capital_imp[i];
	    		}
	    	}
	    }
	}
	for (i=0;i<array_length(frigate_imp);i++){
	    if (frigate_imp[i]>0){
	      	if (frigate_number<=i){
	    		if (!guardsmen_unloaded){
	    			curr+=frigate_imp[i];
	    		}
	    	}
	    }
	}

	for (i=0;i<array_length(escort_imp);i++){
	    if (escort_imp[i]>0){
	      	if (escort_number<=i){
	    		if (!guardsmen_unloaded){
	    			curr+=escort_imp[i];
	    		}
	    	}
	    }
	}
	return curr;	
}

function fleet_remaining_guard_ratio(){
	var curr=fleet_guard_current();
	var maxi = fleet_max_guard();
	guardsmen_ratio=1;
	if (guardsmen_unloaded=0) then guardsmen_ratio=curr/maxi;
	return 	guardsmen_ratio;
}

function scr_navy_unload_guard(planet){
	var total_guard = array_sum(capital_imp);
	total_guard += array_sum(frigate_imp);
	total_guard += array_sum(escort_imp);

	array_set_value(frigate_imp, 0);
	array_set_value(escort_imp, 0);
	array_set_value(capital_imp, 0);

    orbiting.p_guardsmen[planet] = total_guard;
    guardsmen_unloaded=1;
}


function scr_navy_planet_action(){
	if (action=="" && is_orbiting() && !guardsmen_unloaded){// Unload if problem sector, otherwise patrol
	    var selected_planet=0,highest=0,_target_pop=0,_popu_large=false;
    
	    for (var p=1; p<=orbiting.planets; p++){
	    	var planet_enemies = planet_imperial_base_enemies(p, orbiting);

	        if (planet_enemies > highest && orbiting.p_type[p] != "Daemon"){
	            selected_planet=p;
	            highest=planet_enemies;
	            _target_pop=orbiting.p_population[p];
	            if (orbiting.p_large[p]){
	            	_popu_large=true;
	            }
	        }
        
	        // New shit here, prioritize higher population worlds
	        if (planet_enemies>=highest && orbiting.p_type[p]!="Daemon" && p>1){
	        	var _large_planet_pop = orbiting.p_large[p]
	        	var _planet_pop = orbiting.p_population[p];
	            if (has_imperial_enemies(p, orbiting)){
                
	                if (population_larger(_large_planet_pop,_planet_pop,_popu_large,_target_pop)){
	                    selected_planet=p;
	                    highest=planet_imperial_base_enemies(p, orbiting);
	                    _popu_large = _large_planet_pop;
	                }
	            }
	        }
        
	        if (obj_controller.faction_status[eFACTION.Imperium]=="War"){
	        	if (orbiting.p_owner[p]=1 && orbiting.p_player[p]=0 && highest=0){
	        		selected_planet=p;
	        		highest=0.5;
	        	}
	        	if ((orbiting.p_player[p]/50)>=highest){
	        		selected_planet=p;
	        		highest=orbiting.p_player[p]/50;
	        	}
	        	if (planet_feature_bool(orbiting.p_feature[p], P_features.Monastery)==1){
	        		selected_planet=p;
	        		highest=1000+p;
	        	}
	        }
	    }

	    if (selected_planet>0 && highest>0 && array_sum(orbiting.p_guardsmen)<=0){
	        if (highest>2 || orbiting.p_pdf[selected_planet]=0){
	            scr_navy_unload_guard(selected_planet);
	        }
	    }
    
	    var _player_planet=false;
	    if (obj_controller.faction_status[eFACTION.Imperium]=="War"){
	        if (scr_orbiting_fleet(eFACTION.Player)!="none") then _player_planet=true;

            for (var r=1; r<=orbiting.planets; r++){
	            _player_planet = orbiting.p_owner[r]==eFACTION.Player;
	            if (!_player_planet){
	            	_player_planet = planet_feature_bool(orbiting.p_feature[r], P_features.Monastery);
	            }
	        }
	    }
    
	    if (selected_planet == 0 && highest == 0 && !_player_planet){
	        var halp=0;
	        var stars_needing_help = [];
        
	        // Check for any help requests
	        with(obj_star){
	            if array_contains(p_halp, 1) {
	            	array_push(stars_needing_help,id);
	            }
	        }
	        if (array_length(stars_needing_help)){
	            var _current=nearest_from_array(x,y,stars_needing_help);
	            var _current_star = stars_needing_help[_current];
	            var _star_distance = point_distance(x,y,_current_star.x,_current_star.y);
	            if (_star_distance>600) then halp=0;

	            if (_star_distance<=600){
                
	                var star_to_rescue = instance_nearest(_current_star.x,_current_star.y,obj_star);
	                with(star_to_rescue){
	                	array_replace_value(p_halp, 1,1.1);
	                }
                
	                action_x=_current_star.x;
	                action_y=_current_star.y;
	                set_fleet_movement();
	                halp=1;// show_message("F");
	            }
	        }
        
	        // Patrol otherwise
	        if (halp=0){
	            with(orbiting){
	            	y-=10000;
	            }
	            with(obj_star){
	            	if (craftworld=1 || space_hulk=1) then y-=10000;
	            }
            
	            var ndir=floor(random_range(0,360))+1;
	            if (y<=300) then ndir=floor(random_range(180,359))+1;
	            if (y>(room_height-300)){
	            	ndir=irandom_range(0,180);
	            }
	            if (x<=300){
	            	ndir=choose(irandom_range(1,91),irandom_range(270,360));
	            }
	            if (x>(room_width-300)){
	            	ndir=irandom_range(90,270);
	            }
            
	            ndis=random_range(200,400);
	            var next=instance_nearest(x+lengthdir_x(ndis,ndir),y+lengthdir_y(ndis,ndir),obj_star);
	            // next=instance_nearest(x,y,obj_star);
            
	            with(obj_star){
	                if (y<-5000) then y+=10000;
	                if (y<-5000) then y+=10000;
	            }
            
	            action_x=next.x;
                action_y=next.y;
                set_fleet_movement();// show_message("G");
	        }
	    }
	}	
}

function navy_load_up_guardsmen_or_move_planet(planet, valid_next_planet){
    var _player_war=false;
    var _pdata = new PlanetData(planet, orbiting)
    if (_pdata.player_forces>0 && obj_controller.faction_status[eFACTION.Imperium]=="War"){
    	_player_war=true;
	}
	if (planet<=0 || _player_war){
		exit;
	}

    if  (valid_next_planet>0) {// Jump to next planet
        orbiting.p_guardsmen[that] = _pdata.guardsmen;
        _pdata.edit_guardsmen(-_pdata.guardsmen)
        exit;
    }else {// Get back onboard
        navy_load_guardsmen();

        trade_goods="";
        guardsmen_unloaded=0;
        exit;
    }	
}

function navy_load_guardsmen(){
    var new_capacity;
    var maxi = fleet_max_guard();
    new_capacity = min(orbiting.p_guardsmen[1]+orbiting.p_guardsmen[2]+orbiting.p_guardsmen[3]+orbiting.p_guardsmen[4], maxi);
	
	for (var i=0;i<max(capital_number,frigate_number,escort_number);i++){
		if (new_capacity > 0 && capital_number >= i){
			capital_imp[i] = min(capital_max_imp[i],new_capacity);
			new_capacity -=capital_imp[i];
		}
		if (new_capacity > 0 && frigate_number >= i){
			frigate_imp[i] = min(frigate_max_imp[i],new_capacity);
			new_capacity -=frigate_imp[i];
		}

		if (new_capacity > 0 && capital_number >= i){
			escort_imp[i] = min(escort_max_imp[i],new_capacity);
			new_capacity -=escort_imp[i];
		}
	}
	orbiting.p_guardsmen = array_create(5,0);	
}

function scr_navy_has_unloaded_guardsmen_turn_end(){
    var _next_planet=0,_current_planet=0;

	var _move_data = planet_with_most_enemy_forces(orbiting);

	_next_planet = _move_data[0];
	_current_planet = _move_data[1];

    // Move on, man
    if (_next_planet > 0 && has_imperial_enemies(_current_planet, orbiting)==0){
    	navy_load_up_guardsmen_or_move_planet(_current_planet,_next_planet);
    }	
}

function scr_navy_recruit_new_guard(){


    var o=0,that=0,te=0,te_large=0;
    for (var o=1;o<=orbiting.planets;o++){
        if (orbiting.p_owner[o]<=5){
        	var _imp_enemies = has_imperial_enemies(o, orbiting);
        	if (_imp_enemies){
        		continue;
        	}
        	if (orbiting.p_population[o] <= 0){
        		continue;
        	}
        	var _cur_large = orbiting.p_large[o];
        	var _cur_pop = orbiting.p_population[o];
        	if (that == 0 || population_larger(_cur_large,_cur_pop,te_large,te)){
                te = _cur_pop;
                that = o; 
                te_large = _cur_large;       		
        	}
        }
    }

    var guard_wanted = fleet_max_guard() - fleet_guard_current();

    var recruit_planet = new PlanetData(that, orbiting);

    // if (orbiting.p_population[that]<guard_wanted && orbiting.p_large[that]=0) then trade_goods="";
    if (recruit_planet.population > guard_wanted || recruit_planet.large_population){
        if (recruit_planet.large_population) {
        	guard_wanted = recruit_planet.populaton_large_conversion(1000000000);

        }
		var _max_array = max_array_length([capital_imp,frigate_imp,escort_imp]);
        recruit_planet.edit_population(-guard_wanted);
    	for (var i=0;i<_max_array;i++){
    		if (i<array_length(capital_imp)){
    			capital_imp[i]=capital_max_imp[i];
    		}
    		if (i<array_length(frigate_imp)){
    			frigate_imp[i]=frigate_max_imp[i];
    		}
    		if (i<array_length(escort_imp)){
    			escort_imp[i]=escort_max_imp[i];
    		}        		     
    	}
        trade_goods="recruited";
    }
}


function scr_navy_find_recruit_world(){
	var maxi = fleet_max_guard();
	var curr = fleet_guard_current();
    var _guard_wanted=maxi-curr,planet_needed=0;

    if (guard_wanted<=50000) then planet_needed=1;// Pretty much any
    if (guard_wanted>50000) then planet_needed=2;// Feudal and up
    if (guard_wanted>200000) then planet_needed=3;// Temperate and up
    if (guard_wanted>2000000) then planet_needed=4;// Hive
    trade_goods="";

    var _nearest = -1;
    if (planet_needed=1 || planet_needed=2){
		var good
		var _eligible_stars = [];
		var _start = id;
        with(obj_star){
            for (var o =1 ; o<=planets;o++){
	        	if (planet_needed <= 3){
	        		if (!p_large[o] && p_population[o] < (_guard_wanted*6)){
	        			continue;
	        		}
	        	}
	        	if (planet_needed < 5 && planet_needed > 2){
	        		if (p_large[o] && p_population[o]<0.1){
	        			continue;
	        		}
	        	}
	        	if (planet_needed > 3 && !p_large[o]){
	        		continue;
	        	}
                if (scr_is_planet_owned_by_allies(self, o) && (p_type[o]!="Dead")){
                    if (p_orks[o]+p_chaos[o]+p_tyranids[o]+p_necrons[o]+p_tau[o]+p_traitors[o] <= 0) {
                    	array_push(_eligible_stars, id);
                    	if (!instance_exists(_nearest)){
                    		_nearest=id;
                    	} else {
                    		if (point_distance(x,y,_start.x,_start.y) < point_distance(_nearest.x,i_nearestd.y,_start.x,_start.y)){
                    			_nearest = id;
                    		}
                    	}
                    	break;
                    }
                }
            }
		}
    }

    if (instance_exists(_nearest)){
	    if (_nearest.id == id){
	    	trade_goods="recruiting";
	    } else {
	        trade_goods="goto_recruiting";
	        action_x=c_plan.x;
	        action_y=c_plan.y;
	        set_fleet_movement();	        
	    }
	}
}


