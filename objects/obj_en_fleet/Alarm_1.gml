

try_and_report_loop("enemy fleet main end turn action",function(){
var orb=orbiting;

if (round(owner)!=eFACTION.Imperium) and (navy=1) then owner= noone;

//TODO centralise orbiting logic
var _is_orbiting = is_orbiting();
if (orbiting != 0 && action=="" && owner!=noone){
    var orbiting_found=_is_orbiting;
    if (orbiting_found){
        orbiting_found = variable_instance_exists(orbiting, "present_fleet");
        if (orbiting_found){
            orbiting.present_fleet[owner]+=1;
        }
    } 
    if (!orbiting_found) {
        orbiting = instance_nearest(x,y,obj_star);
        orbiting.present_fleet[owner]++;
    }
}

if ((trade_goods="Khorne_warband") or (trade_goods="Khorne_warband_landing_force")) and (owner=eFACTION.Chaos) {
    khorne_fleet_cargo();
}

if (_is_orbiting) {
	turns_static++;
	if (turns_static>5 && owner==eFACTION.Ork){
		if (!irandom(7)){
			ork_fleet_move();
			_is_orbiting=false;
		}
	}
	if (instance_exists(obj_crusade)){
		try{
			fleet_respond_crusade();
		} catch(_exception) {
			 handle_exception(_exception);
		}
	}
}

if (navy && action=="") {
	if trade_goods != "player_hold" {


	if (trade_goods="") and (_is_orbiting){
	    if (orbiting.present_fleet[20]>0) then exit;
	}


	// Check if the ground battle is victorious or not
	if (obj_controller.faction_status[eFACTION.Imperium]="War") and (trade_goods="invading_player") and (guardsmen_unloaded=1) {
	    if (_is_orbiting) {
			
			//slightly more verbose than the last way, but reduces reliance on fixed array sizes
	        var tar = array_reduce(orbiting.p_guardsmen, function(prev, curr, idx) {
				return curr > 0 ? idx : prev;
			},0)
			
	        if (tar == 0) {// Guard all dead
	            trade_goods="recr";
	            action="";
	        } else { //this was always a dead path previously since tar could never be bigger than i, now it will
	            if (orbiting.p_owner[tar]=eFACTION.Player) and (orbiting.p_player[tar]=0) and (planet_feature_bool(orbiting.p_feature[tar],P_features.Monastery)==0){
	                if (orbiting.p_first[tar] != eFACTION.Player) {
						orbiting.p_owner[tar] = orbiting.p_first[tar];
					} else {
						orbiting.p_owner[tar]= eFACTION.Imperium;
					}
					orbiting.dispo[tar]=-50;
	                trade_goods="";
					action="";
	            }
	        }
	    }
	}

	// Invade the player homeworld as needed
	navy_attack_player_world();
	// Bombard the shit out of the player homeworld
	if (obj_controller.faction_status[eFACTION.Imperium]="War") and (trade_goods="") and (!guardsmen_unloaded) and (_is_orbiting){
        var bombard=false;
	    if (orbiting!=noone){
            if (orbiting.object_index==obj_star) then bombard=true;
        }
        if (bombard){
			var orbiting_guardsmen = array_sum(orbiting.p_guardsmen);
			var player_forces = array_sum(orbiting.p_player);

	        if (orbiting_guardsmen == 0) or (player_forces > 0) {
				
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
						
	                    scare=(capital_number*3)+frigate_number;

	                    if (scare>2) then scare=2;
                        if (scare<1) then scare=0;
	                    //onceh=2;

	                    if (orbiting.p_large[bombard]) {
							kill=scare*0.15; // Population if large
						} else {
							kill=scare*15000000; // pop if small
						}

						var bombard_name = planet_numeral_name(bombard, orbiting);
	                    var bombard_report_string=$"Imperial Battlefleet bombards {bombard_name}.";
	                    var PDF_loses=min(orbiting.p_pdf[bombard],(scare*15000000)/2);
						
						var civil_loss_mod = orbiting.p_large[bombard]?scare*0.15:scare*15000000;

						var civilian_losses=min(orbiting.p_population[bombard],civil_loss_mod)


	                    if (civilian_losses>0) and (orbiting.p_large[bombard]=0) then {
							bombard_report_string+=$" {civilian_losses} civilian casualties";
						}
	                    if (civilian_losses>0) and (orbiting.p_large[bombard]=1) {
	                        if (civilian_losses>=1) then bombard_report_string+=$" {civilian_losses} billion civilian casualties";
	                        if (civilian_losses<1) then bombard_report_string+=$"  {floor(civilian_losses*1000)} million civilian casualties";
	                    }
	                    if (PDF_loses>0) then bombard_report_string+=$" and {scr_display_number(PDF_loses)} PDF lost.";
	                    if (PDF_loses<=0) and (civilian_losses>0) then bombard_report_string+=".";
	                    if (civilian_losses=0) and (PDF_loses>0) then bombard_report_string+=" {PDF_loses}  PDF lost.";
                        
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
                    
	                    if (orbiting.p_population[bombard]+orbiting.p_pdf[bombard]<=0) and (orbiting.p_owner[bombard]=eFACTION.Player){
	                        if (planet_feature_bool(orbiting.p_feature[bombard], P_features.Monastery)==0) {
	                            if (orbiting.p_first[bombard]!=eFACTION.Player) {
									orbiting.p_owner[bombard]=orbiting.p_first[bombard];
								} else {
									orbiting.p_owner[bombard]=eFACTION.Imperium;
								}
								orbiting.dispo[bombard]=-50;
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


	if (obj_controller.faction_status[eFACTION.Imperium]="War") and (action="") and (trade_goods="") and (guardsmen_unloaded=0) {
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
						chase_fleet_target_set();
	                    trade_goods="player_hold";
	                    exit;
	                }
	            }
	            with(obj_temp8){instance_destroy();}
	        }
	        // End chase
        
        
	        // Go after home planet or fleet?
        
        
	        if (trade_goods="") and (action="") {
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
            
	            if (homeworld_distance<fleet_distance) and (homeworld_distance<5000) and (homeworld_distance>40) {// Go towards planet
	                action_x=homeworld_nearby.x;
					action_y=homeworld_nearby.y;
					alarm[4]=1;// show_message("B");
	                with(obj_temp7){instance_destroy();}
	                with(obj_temp8){instance_destroy();}
	                exit;
	            }
            
            
            
	            if (fleet_distance<homeworld_distance) and (fleet_distance<7000) and (fleet_distance>40) and (instance_exists(obj_temp7)) {// Go towards that fleet
	                planet_nearby=instance_nearest(fleet_nearby.x,fleet_nearby.y,obj_star);
                
	                if (instance_exists(planet_nearby)) and (_is_orbiting){
						if (fleet_distance<=500) and (planet_nearby!=orbiting){// Case 1; really close, wait for them to make the move
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
								alarm[4]=1;
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
        
	        if (homeworld_distance<=fleet_distance) and (homeworld_distance<7000) and (instance_exists(homeworld_nearby)){// Go towards planet
	            action_x=homeworld_nearby.x;action_y=homeworld_nearby.y;alarm[4]=1;exit;
	        }
        
        
	    */
    
	    }
	}

	//Eldar shit I think? Doesn't check for eldar ships
	if (!new_navy_ships_forge()){
		exit;
	}
	if (trade_goods=="building_ships") then exit;


	//OK this calculates how many imperial guard the ships have and can have at a max
	guardsmen_ratio = fleet_remaining_guard_ratio();
	with(obj_temp_inq){instance_destroy();}



	if (action="") and (_is_orbiting) and (guardsmen_unloaded=1){// Move from one planet to another
	    var o=0,that=0,highest=0,cr=0;
	    o=0;that=0;highest=0;cr=0;
    
	    repeat(orbiting.planets){o+=1;
	        if (orbiting.p_guardsmen[o]>0) then cr=o;
	        if (orbiting.p_orks[o]+orbiting.p_chaos[o]+orbiting.p_tyranids[o]+orbiting.p_necrons[o]+orbiting.p_tau[o]+orbiting.p_traitors[o]>highest) and (orbiting.p_type[o]!="Daemon"){
	            that=o;
	            highest=orbiting.p_orks[o]+orbiting.p_chaos[o]+orbiting.p_tyranids[o]+orbiting.p_necrons[o]+orbiting.p_tau[o]+orbiting.p_traitors[o];
	        }
	    }
    
    
	    // Move on, man
	    if (orbiting.p_orks[cr]+orbiting.p_chaos[cr]+orbiting.p_tyranids[cr]+orbiting.p_necrons[cr]+orbiting.p_tau[cr]+orbiting.p_traitors[cr]=0){
	        var player_war=false;
	        if ((orbiting.p_player[cr]>0) and (obj_controller.faction_status[eFACTION.Imperium]=="War")) then player_war=true;
        
	        if (cr>0) and (that>0) and (!player_war){// Jump to next planet
	            orbiting.p_guardsmen[that]=orbiting.p_guardsmen[cr];
	            orbiting.p_guardsmen[that]=0;
	            exit;
	        }
        
	        if (cr>0) and (that=0) and (!player_war){// Get back onboard
	            var new_capacity;
	            var maxi = fleet_max_guard();
	            new_capacity=orbiting.p_guardsmen[1]+orbiting.p_guardsmen[2]+orbiting.p_guardsmen[3]+orbiting.p_guardsmen[4]/maxi;
            	
            	for (var i=0;i<max(capital_number,frigate_number,escort_number);i++){
            		if (capital_number>=i) then capital_imp[i]=floor(capital_max_imp[i]*new_capacity);
            		if (frigate_number>=i) then frigate_imp[i]=floor(frigate_max_imp[i]*new_capacity);
            		if (escort_number>=i) then escort_imp[i]=floor(escort_max_imp[i]*new_capacity);
            	}
            	orbiting.p_guardsmen = array_create(5,0);

	            trade_goods="";
	            guardsmen_unloaded=0;exit;
	        }
	    }
	}


	if (navy_strength_calc()<=14) and (guardsmen_unloaded=0){
		dock_navy_at_forge();

		send_navy_to_forge();
	}
	// Bombard the shit out of things when able
	 else if (trade_goods=="") and (_is_orbiting) and (action=""){
	    imperial_navy_bombard();
	}


	// If the guardsmen all die then move on
	var o=0;
	if (guardsmen_unloaded=1) and (_is_orbiting){
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
	if ((guardsmen_unloaded=0) and (guardsmen_ratio<0.5) and ((trade_goods=""))) or (trade_goods="recr"){// determine what sort of planet is needed
		var maxi = fleet_max_guard();
		var curr = fleet_guard_current();
	    var guard_wanted=maxi-curr,planet_needed=0;
	    if (guard_wanted<=50000) then planet_needed=1;// Pretty much any
	    if (guard_wanted>50000) then planet_needed=2;// Feudal and up
	    if (guard_wanted>200000) then planet_needed=3;// Temperate and up
	    if (guard_wanted>2000000) then planet_needed=4;// Hive
	    obj_controller.temp[200]=guard_wanted;trade_goods="";
    
	    if (planet_needed=1) or (planet_needed=2){
			var good
	        with(obj_star){
				if (scr_is_star_owned_by_allies(self)) {
					good=0;o=0;
		            repeat(planets){o+=1;
		                if (scr_is_planet_owned_by_allies(self, o)) and (p_type[o]!="Dead") and (p_population[o]>(obj_controller.temp[200]*6)){
		                    if (p_orks[o]+p_chaos[o]+p_tyranids[o]+p_necrons[o]+p_tau[o]+p_traitors[o]=0) then good=1;
		                }
		            }
		            if (good=1) then instance_create(x,y,obj_temp_inq);
		        }
			}
	    }
	    if (planet_needed=3){
			var good
	        with(obj_star) {
				if (scr_is_star_owned_by_allies(self)) {
					good=0;o=0;
			        repeat(planets){o+=1;
			            if (scr_is_planet_owned_by_allies(self, o)) and ((p_population[o]>(obj_controller.temp[200]*6)) or ((p_large[o]=1) and (p_population[o]>0.1))){
			                if (p_orks[o]+p_chaos[o]+p_tyranids[o]+p_necrons[o]+p_tau[o]+p_traitors[o]=0) then good=1;
			            }
			        }
			        if (good=1) then instance_create(x,y,obj_temp_inq);
			    }
			}
	    }
	    if (planet_needed=4) {
			var good
	        with(obj_star) {
				if (scr_is_star_owned_by_allies(self)) {
					good=0;o=0;
			        repeat(planets) {
						o+=1;
			            if (scr_is_planet_owned_by_allies(self, o)) and ((p_large[o]=1) and (p_population[o]>0.1)){
			                if (p_orks[o]+p_chaos[o]+p_tyranids[o]+p_necrons[o]+p_tau[o]+p_traitors[o]=0) then good=1;
			            }
			        }
			        if (good=1) then instance_create(x,y,obj_temp_inq);
			    }
			}
	    }
    
	    var closest,c_plan,closest_dist;
	    closest=instance_nearest(x,y,obj_temp_inq);
	    c_plan=instance_nearest(closest.x,closest.y,obj_temp_inq);
	    closest_dist=point_distance(x,y,closest.x,closest.y);
    
	    if (c_plan=orbiting) then trade_goods="recruiting";
	    if (c_plan!=orbiting){
	        trade_goods="goto_recruiting";
	        action_x=c_plan.x;
	        action_y=c_plan.y;
	        set_fleet_movement()	        
	        _is_orbiting=false;
	    }
    
	    with(obj_temp_inq){
	    	instance_destroy();
		}
		exit;
	}
	// Get recruits
	if (action="") and (trade_goods="goto_recruiting"){
	    if (_is_orbiting){
	        var o=0,that=0,te=0,te_large=0;
	        repeat(orbiting.planets){
	        	o+=1;
	            if (orbiting.p_owner[o]<=5){
	                if (orbiting.p_population[o]>te) and (orbiting.p_orks[o]+orbiting.p_chaos[o]+orbiting.p_tyranids[o]+orbiting.p_necrons[o]+orbiting.p_tau[o]+orbiting.p_traitors[o]=0){
	                    te=orbiting.p_population[o];
	                    that=o;
	                }
	                if (orbiting.p_large[o]=1) and (orbiting.p_population[o]>0) and (te_large=0) and (orbiting.p_orks[o]+orbiting.p_chaos[o]+orbiting.p_tyranids[o]+orbiting.p_necrons[o]+orbiting.p_tau[o]+orbiting.p_traitors[o]=0){
	                    te=orbiting.p_population[o];
	                    that=o;
	                    te_large=1;
	                }
	                if (te_large=1) and (orbiting.p_population[o]>te) and (orbiting.p_large[o]=1) and (orbiting.p_orks[o]+orbiting.p_chaos[o]+orbiting.p_tyranids[o]+orbiting.p_necrons[o]+orbiting.p_tau[o]+orbiting.p_traitors[o]=0){
	                    te=orbiting.p_population[o];
	                    that=o;
	                    te_large=1;
	                }
	            }
	        }
        
	        var guard_wanted=fleet_max_guard()-fleet_guard_current();
        
	        // if (orbiting.p_population[that]<guard_wanted) and (orbiting.p_large[that]=0) then trade_goods="";
	        if (orbiting.p_population[that]>guard_wanted) or (orbiting.p_large[that]=1){
	            if (orbiting.p_large[that]=0){orbiting.p_population[that]-=guard_wanted;
	                i=0;repeat(20){i+=1;capital_imp[i]=capital_max_imp[i];}
	                i=0;repeat(30){i+=1;frigate_imp[i]=frigate_max_imp[i];}
	                i=0;repeat(30){i+=1;escort_imp[i]=escort_max_imp[i];}
	            }
	            if (orbiting.p_large[that]=1){guard_wanted=guard_wanted/1000000000;
	                orbiting.p_population[that]-=guard_wanted;
	                i=0;repeat(20){i+=1;capital_imp[i]=capital_max_imp[i];}
	                i=0;repeat(30){i+=1;frigate_imp[i]=frigate_max_imp[i];}
	                i=0;repeat(30){i+=1;escort_imp[i]=escort_max_imp[i];}
	            }
	            trade_goods="recruited";
	        }
	    }
	}

	scr_navy_planet_action();
	if (trade_goods="recruited") then trade_goods="";
	/* */
	}
}

var dir=0;
var ret=0;


if (action=="" && _is_orbiting){
    var max_dis=400;
    

    if (orbiting.owner=eFACTION.Player) and (obj_controller.faction_status[eFACTION.Imperium]="War") and (owner=eFACTION.Imperium){
        for (var i=1;i<=orbiting.planets;i++){
            if (orbiting.p_owner[i]=1) then orbiting.p_pdf[i]-=capital_number*50000;
            if (orbiting.p_owner[i]=1) then orbiting.p_pdf[i]-=frigate_number*10000;
            if (orbiting.p_pdf[i]<0) then orbiting.p_pdf[i]=0;
        }
    }

    
    // 1355;
    
    
    if (instance_exists(obj_crusade)) and (owner=eFACTION.Ork) and (orbiting.owner=eFACTION.Ork){// Ork crusade AI
        var max_dis;
        max_dis=400;
    
        var fleet_owner = owner;
        with(obj_crusade){if (owner!=fleet_owner){x-=40000;}}
        
        with(obj_star){
            var ns=instance_nearest(x,y,obj_crusade);
            if (point_distance(x,y,ns.x,ns.y)>ns.radius){x-=40000;}
            if (owner=ns.owner){x-=40000;}
        }
        
        var ns=instance_nearest(x,y,obj_star);
        if (ns.owner != eFACTION.Ork) and (point_distance(x,y,ns.x,ns.y)<=max_dis) and (point_distance(x,y,ns.x,ns.y)>40) and (instance_exists(obj_crusade)) and (image_index>3){
            action_x=ns.x;
            action_y=ns.y;alarm[4]=1;
            home_x=orbiting.x;
            home_y=orbiting.y;
            exit;
        }
        
        with(obj_star){
            if (x<-30000) then x+=40000;
            if (x<-30000) then x+=40000;
            if (x<-30000) then x+=40000;
        }
        with(obj_crusade){
            if (x<-30000) then x+=40000;
            if (x<-30000) then x+=40000;
            if (x<-30000) then x+=40000;
        }
    }
    
    
    instance_activate_object(obj_star);
    instance_activate_object(obj_crusade);
    instance_activate_object(obj_en_fleet);
    
    /*if (action="") and (owner = eFACTION.Imperium){// Defend nearby systems and return when done
        
        with(obj_star){
            // 137 ; might want for it to defend under other circumstances
            if (present_fleet[8]>0) and (owner<=5) and (x>2) and (y>2) then instance_create(x,y,obj_temp3);
        }
        if (instance_number(obj_temp3)=0) then ret=1;
        if (instance_number(obj_temp3)>0){
            var you,dis,mem;
            you=instance_nearest(x,y,obj_temp3);
            dis=point_distance(x,y,you.x,you.y);
            
            if (dis<300) and (image_index>=3){
                action_x=you.x;action_y=you.y;
                home_x=instance_nearest(x,y,obj_star).x;
                home_y=instance_nearest(x,y,obj_star).y;
                alarm[4]=1;with(obj_temp3){instance_destroy();}
                exit;
            }
            if (dis>=300) then ret=1;
        }
        
        if (instance_exists(obj_crusade)){
            var cru;cru=instance_nearest(x,y,obj_crusade);
            if (cru.owner=self.owner) and (point_distance(x,y,cru.x,cru.y)<cru.radius) then ret=0;
        }
        
        if (ret=1){
            var cls;cls=instance_nearest(x,y,obj_star);
            if ((cls.x!=home_x) or (cls.y!=home_y)) and (home_x+home_y>0){
                action_x=home_x;
                action_y=home_y;
                alarm[4]=1;
            }
        }

        with(obj_temp3){instance_destroy();}
    }*/
    
    
    
    if (owner=eFACTION.Inquisition){
        var valid = true;
        if (instance_exists(target)){
            if (instance_nearest(target.x,target.y, obj_star).id != instance_nearest(x,y, obj_star).id){
                valid=false;
            }
        }
        if (((orbiting.owner = eFACTION.Player || system_feature_bool(orbiting.p_feature, P_features.Monastery)) or (obj_ini.fleet_type != ePlayerBase.home_world)) and (trade_goods!="cancel_inspection") && valid){
            if (obj_controller.disposition[6]>=60) then scr_loyalty("Xeno Associate","+");
            if (obj_controller.disposition[7]>=60) then scr_loyalty("Xeno Associate","+");
            if (obj_controller.disposition[8]>=60) then scr_loyalty("Xeno Associate","+");
            
            if (orbiting.p_owner[2]=1) and (orbiting.p_heresy[2]>=60) then scr_loyalty("Heretic Homeworld","+");
            
            var whom=-1;
            whom = inquisitor;
            var inquisitors = obj_controller.inquisitor;
            var inquis_string = $"Inquisitor {whom>-1 ? inquisitors[whom] : inquisitors[0]}";
            
            // INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; INVESTIGATE DEAD HERE 137 ; 
            var cur_star,t,type,cha,dem,tem1,tem1_base,perc,popup;
            t=0;type=0;cha=0;dem=0;tem1=0;popup=0;perc=0;tem1_base=0;
            
            cur_star=instance_nearest(x,y,obj_star);
            
            if (string_count("investigate",trade_goods)>0){
                // Check for xenos or demon-equip items on those planets
                //TODO update this to check weapon or artifact tags
                var e=0,ia=-1,ca=0;
                var unit;
                repeat(4400){
                    if (ca<=10) and (ca>=0){
                        ia+=1;
                        if (ia=400){ca+=1;ia=1;
                        if (ca=11) then ca=-5;}
                        if (ca>=0) and (ca<11){
                            unit=fetch_unit([ca,ia]);
                            if (obj_ini.loc[ca,ia]=cur_star.name) and (unit.planet_location>0){
                                if (unit.role()="Ork Sniper") and (obj_ini.race[ca,ia]!=1){tem1_base=3;}
                                if (unit.role()="Flash Git") and (obj_ini.race[ca,ia]!=1){tem1_base=3;}
                                if (unit.role()="Ranger") and (obj_ini.race[ca,ia]!=1){tem1_base=3;}
                                if (unit.equipped_artifact_tag("daemon")){
                                	tem1_base+=3;
                                	dem+=1;
                                }
                            }
                        }
                    }
                }
                repeat(cur_star.planets){
                    t+=1;
                    tem1=tem1_base;// Repeat to check each of the planets
                    if (cur_star.p_type[t]="Dead") and (array_length(cur_star.p_upgrades[t])>0){
						var base_search = search_planet_features(cur_star.p_upgrades[t], P_features.Secret_Base); 
                        if (array_length(base_search) >0){
							var player_base = cur_star.p_upgrades[t][base_search[0]]
                            if (player_base.vox>0) then tem1+=2;
                            if (player_base.torture>0) then tem1+=1;
                            if (player_base.narcotics>0) then tem1+=3;
                            // Should probably also check for xenos
                            obj_controller.disposition[2]-=tem1*2;obj_controller.disposition[4]-=tem1*3;
                            obj_controller.disposition[5]-=tem1*3;popup=1;
                            
                            if (tem1>=3){popup=2;obj_controller.inqis_flag_lair+=1;
                                obj_controller.loyalty-=10;obj_controller.loyalty_hidden-=10;
                                if ((obj_controller.inqis_flag_lair=2) or (obj_controller.disposition[4]<0) or (obj_controller.loyalty<=0)) and (obj_controller.faction_status[eFACTION.Inquisition]!="War"){popup=0.3;obj_controller.alarm[8]=1;}// {popup=0.2;obj_controller.alarm[8]=1;}
                            }
                            if  (player_base.inquis_hidden = 1){
							 	player_base.inquis_hidden = 0;							
                       		}
						}
						var arsenal_search = search_planet_features(cur_star.p_upgrades[t], P_features.Arsenal)
						var arsenal;

                        if (array_length(arsenal_search) > 0 ){
                        	e=0;
                        	arsenal = cur_star.p_upgrades[t][arsenal_search[0]];
                        	arsenal.inquis_hidden = 0;
                            for (e=0;e<array_length(obj_ini.artifact_tags[e]);e++){
                                if (obj_ini.artifact[e]!="") and (obj_ini.artifact_loc[e]=cur_star.name) and (obj_controller.und_armouries<=1){
                                    if (array_contains(obj_ini.artifact_tags[e],"chaos")) then cha+=1;
                                    if (array_contains(obj_ini.artifact_tags[e],"chaos_gift")) then cha+=1;
                                    if (array_contains(obj_ini.artifact_tags[e],"daemonic")) then dem+=1;
                                }
                            }
                            perc=((dem*10)+(cha*3))/100;
                            obj_controller.disposition[2]-=max(round((obj_controller.disposition[2]/6)*perc),round(8*perc));
                            obj_controller.disposition[4]-=max(round((obj_controller.disposition[4]/4)*perc),round(10*perc));
                            obj_controller.disposition[5]-=max(round((obj_controller.disposition[5]/4)*perc),round(10*perc));
                            
                            popup=3;
                            if ((dem*10)+(cha*3)>=10) then popup=4;

                            var start_inquisition_war = ((obj_controller.disposition[4]<0 || obj_controller.loyalty<=0) && obj_controller.faction_status[eFACTION.Inquisition]!="War")
                            
                            if (start_inquisition_war){
                                if (popup==3){
                                    popup=0.3;
                                    var moo=false;
                                    if (!moo){
                                        if (obj_controller.penitent=1) {
                                            obj_controller.alarm[8]=1;
                                            moo=true;
                                        }else if (obj_controller.penitent=0){
                                            scr_audience(4,"loyalty_zero",0,"",0,0);
                                        }
                                    }
                                }
                                else if (popup==4){
                                    popup=0.4;
                                    var moo=false;
                                    if (obj_controller.penitent=1) and (moo=false){obj_controller.alarm[8]=1;moo=true;}
                                    if (obj_controller.penitent=0) and (moo=false) then scr_audience(4,"loyalty_zero",0,"",0,0);
                                }
                            }
                        }
 						var vault = search_planet_features(cur_star.p_upgrades[t], P_features.Arsenal)
						var gene_vault;                       
                        if (array_length(vault) > 0 ){
                        	gene_vault = cur_star.p_upgrades[t][arsenal_search[0]];
                        	gene_vault.inquis_hidden = 0;
                            obj_controller.inqis_flag_gene+=1;
                            obj_controller.loyalty-=10;obj_controller.loyalty_hidden-=10;
                            obj_controller.disposition[4]-=tem1*3;
                            
                            if (obj_controller.inqis_flag_gene=1) then popup=5;
                            if (obj_controller.inqis_flag_gene=2) then popup=6;
                            if ((obj_controller.inqis_flag_gene>=3) or (obj_controller.loyalty<=0) or (obj_controller.disposition[4]<0)) and (obj_controller.faction_status[eFACTION.Inquisition]!="War"){popup=0.6;obj_controller.alarm[8]=1;}
                        }
                        
                        // Popup1: Lair Discovered
                        // Popup2: Heretic Lair Discovered
                        // Popup3: Arsenal Discovered
                        // Popup4: Aresenal with Chaos/Demonic Discovered
                        // Popup5: First Gene-Seed warning
                        // Popup6: Second Gene-Seed warning
                        var star_planet = $"{cur_star.name}{scr_roman(t)}";

                        if (popup=1){scr_event_log("",$"{inquis_string} discovers your Secret Lair on {star_planet}.");}
                        else if (popup=2) or (popup=0.2) {scr_event_log("red",$"{inquis_string} discovers your Secret Lair on {star_planet}.", cur_star);}
                        else if (popup=3) or (popup=0.3) {scr_event_log("",$"{inquis_string} discovers your Secret Arsenal on {star_planet}.", cur_star);}
                        else if (popup=4) or (popup=0.4) {scr_event_log("red",$"{inquis_string} discovers your Secret Arsenal on {star_planet}.", cur_star);}
                        else if (popup>=5) or (popup=0.6) {scr_event_log("",$"{inquis_string} discovers your Secret Gene-Vault on {star_planet}.", cur_star);}
                        
                        var pop_tit,pop_txt,pop_spe;
                        pop_tit="";pop_txt="";pop_spe="";
                        if (popup=1){
                            pop_tit="Inquisition Discovers Lair";
                            pop_txt=$"{inquis_string} has discovered your Secret Lair on {star_planet}.  A quick inspection revealed that there was no contraband or heresy, though the Inquisition does not appreciate your secrecy at all.";
                        }
                        else if (popup=2){
                            pop_tit="Inquisition Discovers Lair";
                            pop_txt=$"{inquis_string} has discovered your Secret Lair on {star_planet}.  A quick inspection turned up heresy, most foul, and it has all been reported to the Inquisition.  They are seething, as a whole, and relations are damaged.";
                        }
                        else if (popup=3){
                            pop_tit="Inquisition Discovers Arsenal";
                            pop_txt=$"{inquis_string} has discovered your Secret Arsenal on {star_planet}.  A quick inspection revealed that there was no contraband or heresy, though the Inquisition does not appreciate your secrecy at all.";
                        }
                        else if (popup=4){
                            pop_tit="Inquisition Discovers Arsenal";
                            pop_txt=$"{inquis_string} has discovered your Secret Arsenal on {star_planet}.  A quick inspection turned up heresy, most foul, and it has all been reported to the Inquisition.  Relations have been heavily damaged.";
                        }
                        else if (popup=5){
                            pop_tit="Inquisition Discovers Arsenal";
                            pop_txt=$"{inquis_string} has discovered your Secret Gene-Vault on {star_planet} and reported it.  The Inquisition does NOT appreciate your secrecy, nor the fact that you were able to mass produce Gene-Seed unknowest to the Imperium.  Relations are damaged.";
                        }
                        else if (popup=6){
                            pop_tit="Inquisition Discovers Arsenal";
                            pop_txt=$"{inquis_string} has discovered your Secret Gene-Vault on {star_planet} and reported it.  You were warned once already to not sneak about with Gene-Seed stores and Test-Slave incubators.  Do not let it happen again or your Chapter will be branded heretics.";
                        }
                        
                        if ((dem*10)+(cha*3)>=10){
                            pop_txt+="The Inquisitor responsible for the inspection also demands that you hand over all heretical materials and Artifacts.";
                            pop_spe="contraband";instance_create(x,y,obj_temp_arti);
                        }
                        
                        if (popup>=1) then scr_popup(pop_tit,pop_txt,"inquisition",pop_spe);
                        
                    }
                }
            }else if (string_count("investigate",trade_goods)==0){
                inquisition_inspection_logic();
            }
            // End Test-Slave Incubator Crap
            
            if (obj_controller.known[eFACTION.Inquisition]=1){obj_controller.known[eFACTION.Inquisition]=3;}
            if (obj_controller.known[eFACTION.Inquisition]=2){obj_controller.known[eFACTION.Inquisition]=4;}
            
            orbiting=instance_nearest(x,y,obj_star);

            // 135;
            if (obj_controller.loyalty_hidden<=0){// obj_controller.alarm[7]=1;global.defeat=2;
                var moo=false;
                if (obj_controller.penitent=1) and (moo=false){
                    obj_controller.alarm[8]=1;
                    moo=true;
                }
                if (obj_controller.penitent=0) and (moo=false) then scr_audience(4,"loyalty_zero",0,"",0,0);
            }
            
            exit_star=distance_removed_star(x,y, choose(2,3,4));
            action_x=exit_star.x;
            action_y=exit_star.y;
            orbiting=exit_star;
            alarm[4]=1;
            trade_goods="|DELETE|";
            exit;
        }
    }
    
    if (owner=eFACTION.Tau){
        if (instance_exists(obj_p_fleet)) and (obj_controller.known[eFACTION.Tau]==0){
            var p_ship =instance_nearest(x,y,obj_p_fleet);
            if (p_ship.action="") and (point_distance(x,y,p_ship.x,p_ship.y)<=80) then obj_controller.known[eFACTION.Tau] = 1;
        }
        
        
        /*if (image_index>=4){
            with(obj_star){
                if (owner = eFACTION.Tau) and (present_fleets>0) and (tau_fleets=0){
                    instance_create(x,y,obj_temp5);
                }
            }
            if (instance_exists(obj_temp5)){
                var wop;wop=instance_nearest(x,y,obj_temp5);
                if (wop!=0) and (point_distance(x,y,wop.x,wop.y)<300) and (wop.x>5) and (wop.y>5){
                    target_x=wop.x;target_y=wop.y;
                    home_x=x;home_y=y;
                    alarm[4]=1;
                }
            }
            with(obj_temp5){instance_destroy();}
        }*/
    }
    
    if (owner == eFACTION.Tyranids) {// Juggle bio-resources
        if (capital_number*2>frigate_number){
            capital_number-=1;frigate_number+=2;
        }
        
        if (capital_number*4>escort_number){
            var rand;
            rand=choose(1,2,3,4);
            if (rand=4) then escort_number+=1;
        }
        
        
        
        if (capital_number>0){
            var capitals_engaged=0;
            with (orbiting){
            	for (var i=1;i<planets;i++){
            		if (capitals_engaged=capital_number) then break;
            		if (p_type[i]!="Dead"){
            			p_tyranids[4]=5;
            			capitals_engaged+=1;
            		}
            	}
            }
        }
        
        

        var n=false;
        with (orbiting){
        	n = is_dead_star();
        }
        
        if (n){
            var xx,yy,good, plin, plin2;
            xx=0;yy=0;good=0;plin=0;plin2=0;
            
            if (capital_number>5) then n=5;
            
            instance_deactivate_object(orbiting);
            
            repeat(100){
                if (good!=5){
                    xx=self.x+random_range(-300,300);
                    yy=self.y+random_range(-300,300);
                    if (good=0) then plin=instance_nearest(xx,yy,obj_star);
                    if (good=1) and (n=5) then plin2=instance_nearest(xx,yy,obj_star);
                    
                    good = !array_contains(plin.p_type, "dead");

                    if (good=1) and (n=5){
                        if (!instance_exists(plin2)) then exit;
                        if (!array_contains(plin.p_type, "dead")) then good++
                        
                        var new_fleet;
                        new_fleet=instance_create(x,y,obj_en_fleet);
                        new_fleet.capital_number=floor(capital_number*0.4);
                        new_fleet.frigate_number=floor(frigate_number*0.4);
                        new_fleet.escort_number=floor(escort_number*0.4);
                        
                        capital_number-=new_fleet.capital_number;
                        frigate_number-=new_fleet.frigate_number;
                        escort_number-=new_fleet.escort_number;
                        
                        new_fleet.owner=eFACTION.Tyranids;
                        new_fleet.sprite_index=spr_fleet_tyranid;
                        new_fleet.image_index=1;
                        
                        /*with(new_fleet){
                            var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
                            if (ii<=1) then ii=1;image_index=ii;
                        }*/
                        
                        new_fleet.action_x=plin2.x;
                        new_fleet.action_y=plin2.y;
                        new_fleet.alarm[4]=1;
                        break;
                    }
                    
                    
                    if (good=1) and (instance_exists(plin)){action_x=plin.x;action_y=plin.y;alarm[4]=1;if (n!=5) then good=5;}
                }
            }
            instance_activate_object(obj_star);
        }
    }
}


if (action="move") and (action_eta>5000){
    var woop = instance_nearest(x,y,obj_star);
    if (woop.storm=0){
    	action_eta-=10000;
    } else {
    	if !(instance_nearest(target_x,target_y,obj_star).storm){
    		action_eta-=10000;
    	}
    }
}

else if (action="move") and (action_eta<5000){
    if (instance_nearest(action_x,action_y,obj_star).storm>0) then exit;
    if (action_x+action_y=0) then exit;
    
    var dos=0;
    dos=point_distance(x,y,action_x,action_y);
    orbiting=dos/action_eta;
    dir=point_direction(x,y,action_x,action_y);
    
    x=x+lengthdir_x(orbiting,dir);
    y=y+lengthdir_y(orbiting,dir);
    
    action_eta-=1;
    
    /*if (owner>5){
        
    }*/
    
    if (action_eta==2) and (owner=eFACTION.Inquisition) && (inquisitor>-1){
    	inquisitor_ship_approaches();
    } else if (action_eta==0) {
    	action = "";
    	if (array_length(complex_route)>0){
    		var target_loc = star_by_name(complex_route[0]);
    		if (target_loc != "none"){
    			array_delete(complex_route, 0, 1);
    			action_x = target_loc.x;
    			action_y = target_loc.y;
    			target = target_loc;
    			set_fleet_movement(false);
    		} else {
    			complex_route = [];
    			fleet_arrival_logic();
    		}
    	} else {
    		fleet_arrival_logic();
    	}
        
    }
    
}



});

/* */
/*  */
