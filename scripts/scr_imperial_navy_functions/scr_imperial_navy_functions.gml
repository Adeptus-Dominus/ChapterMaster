function new_navy_ships_forge(){
    if (trade_goods=="building_ships"){
        var onceh=0,advance=false,p=0;
    
        p=0;
        if (!instance_exists(orbiting) && action==""){
            orbiting = instance_nearest(x,y, obj_star);
        }
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
    
        if (capital_number=1) and (frigate_number>=5) and (escort_number>=12){
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

    
        //if (trade_goods="building_ships") or (!advance) then exit;
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
    if (action="") and (trade_goods="goto_forge") and (instance_exists(orbiting)){
        trade_goods="building_ships";
    }
}

function send_navy_to_forge(){
    // Quene a visit to a forge world
    if (action="") and (trade_goods="") and (instance_exists(orbiting)){

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
    if (guardsmen_unloaded=0) or ((array_sum(orbiting.p_guardsmen)==0) and (guardsmen_unloaded=1)) or ((array_sum(orbiting.p_player)>0) and (obj_controller.faction_status[eFACTION.Imperium]=="War")){
        if (orbiting.present_fleet[6]+orbiting.present_fleet[7]+orbiting.present_fleet[8]+orbiting.present_fleet[9]+orbiting.present_fleet[10]+orbiting.present_fleet[13]=0){
            var hol=false;
            if ((orbiting.present_fleet[1]>0) and (obj_controller.faction_status[eFACTION.Imperium]="War")) then hol=true;
    
            if (hol=false){
                var p,bombard,deaths,hurss,scare,onceh,wob,kill;
                p=0;bombard=0;deaths=0;hurss=0;onceh=0;wob=0;kill=0;
            
                repeat(orbiting.planets){
                    p+=1;
                    if (orbiting.p_type[p]!="Daemon"){
                        if (orbiting.p_population[p]=0) and (orbiting.p_tyranids[p]>0) and (onceh=0){
                            bombard=p;
                            onceh=1;
                        }
                        if (orbiting.p_population[p]=0) and (orbiting.p_orks[p]>0) and (orbiting.p_owner[p]=7) and (onceh=0){bombard=p;onceh=1;}
                        if (orbiting.p_owner[p]=8) and (orbiting.p_tau[p]+orbiting.p_pdf[p]>0) and (onceh=0){
                            bombard=p;
                            onceh=1;
                        }
                        if (orbiting.p_owner[p]=10) and ((orbiting.p_chaos[p]+orbiting.p_traitors[p]+orbiting.p_pdf[p]>0) or (orbiting.p_heresy[p]>=50)){bombard=p;onceh=1;}
                    }
                }
            
                if (bombard>0){
                    scare=(capital_number*3)+frigate_number;
                
                
                
                    // Eh heh heh
                    if (onceh<2) and (orbiting.p_tyranids[bombard]>0){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                        orbiting.p_tyranids[bombard]-=2;onceh=2;
                    }
                    if (onceh<2) and (orbiting.p_orks[bombard]>0){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                        orbiting.p_orks[bombard]-=2;onceh=2;
                    }
                    if (onceh<2) and (orbiting.p_owner[bombard]=8) and (orbiting.p_tau[bombard]>0){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                        orbiting.p_tau[bombard]-=2;onceh=2;
                    
                        if (orbiting.p_large[bombard]=0) then kill=scare*15000000;// Population if normal
                        if (orbiting.p_large[bombard]=1) then kill=scare*0.15;// Population if large
                    }
                    if (onceh<2) and (orbiting.p_owner[bombard]=8) and (orbiting.p_pdf[bombard]>0){
                        wob=scare*5000000+choose(floor(random(100000)),floor(random(100000))*-1);
                        orbiting.p_pdf[bombard]-=wob;
                        if (orbiting.p_pdf[bombard]<0) then orbiting.p_pdf[bombard]=0;
                    
                        if (orbiting.p_large[bombard]=0) then kill=scare*15000000;// Population if normal
                        if (orbiting.p_large[bombard]=1) then kill=scare*0.15;// Population if large
                    }
                    if (onceh<2) and (orbiting.p_owner[bombard]=10){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                    
                        if (onceh!=2) and (orbiting.p_chaos[bombard]>0){orbiting.p_chaos[bombard]=max(0,orbiting.p_traitors[bombard]-1);onceh=2;}
                        if (onceh!=2) and (orbiting.p_traitors[bombard]>0){orbiting.p_traitors[bombard]=max(0,orbiting.p_traitors[bombard]-2);onceh=2;}
                    
                        if (orbiting.p_large[bombard]=0) then kill=scare*15000000;// Population if normal
                        if (orbiting.p_large[bombard]=1) then kill=scare*0.15;// Population if large
                        if (orbiting.p_heresy[bombard]>0) then orbiting.p_heresy[bombard]=max(0,orbiting.p_heresy[bombard]-5);
                    }
                
                    orbiting.p_population[bombard]-=kill;
                    if (orbiting.p_population[bombard]<0) then orbiting.p_population[bombard]=0;
                    if (orbiting.p_pdf[bombard]<0) then orbiting.p_pdf[bombard]=0;
                
                    if (orbiting.p_population[bombard]+orbiting.p_pdf[bombard]<=0) and (orbiting.p_owner[bombard]=1) and (obj_controller.faction_status[eFACTION.Imperium]="War"){
                        if (planet_feature_bool(orbiting.p_feature[bombard],P_features.Monastery)==0){orbiting.p_owner[bombard]=2;orbiting.dispo[bombard]=-50;}
                    }
                    exit;
                }
            }
        }
    }    
}


function navy_attack_player_world(){
	if (obj_controller.faction_status[eFACTION.Imperium]="War") and (trade_goods="invade_player") and (guardsmen_unloaded=0){
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
function fleet_max_guard(){
	var maxi=0, i=0;
	for (i=1;i<array_length(capital_imp);i++){
	    if (capital_max_imp[i]>0) {
	    	if (capital_number>i){
	    		capital_max_imp[i]=0;
	    	} else if (capital_number<=i){
	    		maxi+=capital_max_imp[i];
	    	}
	    }
	}
	for (i=1;i<array_length(frigate_imp);i++){
	    if (frigate_max_imp[i]>0) {
	    	if (frigate_number>i){
	    		frigate_max_imp[i]=0;
	    	} else if (frigate_number<=i){
	    		maxi+=frigate_max_imp[i];
	    	}
	    }
	}
	for (i=1;i<array_length(escort_imp);i++){
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
	for (i=1;i<array_length(capital_imp);i++){
	    if (capital_imp[i]>0){ 
	      	if (capital_number<=i){
	    		if (!guardsmen_unloaded){
	    			curr+=capital_imp[i];
	    		}
	    	}
	    }
	}
	for (i=1;i<array_length(frigate_imp);i++){
	    if (frigate_imp[i]>0){
	      	if (frigate_number<=i){
	    		if (!guardsmen_unloaded){
	    			curr+=frigate_imp[i];
	    		}
	    	}
	    }
	}

	for (i=1;i<array_length(escort_imp);i++){
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
	if (action=="") and (is_orbiting()) and (!guardsmen_unloaded){// Unload if problem sector, otherwise patrol
	    var selected_planet=0,highest=0,popu=0,popu_large=false;
    
	    for (var p=1;p<=orbiting.planets;p++){
	    	var planet_enemies = planet_imperial_base_enemies(p, orbiting);

	        if (planet_enemies > highest) and (orbiting.p_type[p]!="Daemon"){
	            selected_planet=p;
	            highest=planet_enemies;
	            popu=orbiting.p_population[p];
	            if (orbiting.p_large[p]) then popu_large=true;
	        }
        
	        // New shit here, prioritize higher population worlds
	        if (planet_enemies>=highest) and (orbiting.p_type[p]!="Daemon") and (p>1){
	            if (orbiting.p_orks[p]+orbiting.p_chaos[p]+orbiting.p_tyranids[p]+orbiting.p_necrons[p]+orbiting.p_tau[p]+orbiting.p_traitors[p]>0){
	                var isnew=false;
                
	                if (!popu_large) and (orbiting.p_large[p]=true) and (floor(popu/1000000000)<orbiting.p_population[p]) then isnew=true;
	                if (!popu_large) and (orbiting.p_large[p]=true) and (popu<orbiting.p_population[p]) then isnew=true;
	                if (!popu_large) and (orbiting.p_large[p]=false) and (popu<(orbiting.p_population[p]/1000000000)) then isnew=true;
                
	                if (isnew=true){
	                    selected_planet=p;
	                    highest=planet_imperial_base_enemies(p, orbiting);
	                    popu_large = orbiting.p_large[p];
	                }
                
	            }
	        }
        
	        if (obj_controller.faction_status[eFACTION.Imperium]="War"){
	        	if (orbiting.p_owner[p]=1) and (orbiting.p_player[p]=0) and (highest=0){
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

	    if (selected_planet>0) and (highest>0) and (array_sum(orbiting.p_guardsmen)<=0){
	        if (highest>2) or (orbiting.p_pdf[selected_planet]=0){
	            scr_navy_unload_guard(selected_planet)
	        }
	    }
    
	    var _player_planet=false;
	    if (obj_controller.faction_status[eFACTION.Imperium]=="War"){
	        if (scr_orbiting_fleet(eFACTION.Player)!="none") then _player_planet=true;

            for (var r=1;r<=orbiting.planets;r++){
	            _player_planet = orbiting.p_owner[r]==eFACTION.Player;
	            if (!_player_planet){
	            	_player_planet = planet_feature_bool(orbiting.p_feature[r], P_features.Monastery);
	            }
	        }
	    }
    
	    if (selected_planet=0) and (highest=0) and (!_player_planet){
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
                
	                var star_to_rescue=instance_nearest(_current_star.x,_current_star.y,obj_star);
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
	            with(orbiting){y-=10000;}
	            with(obj_star){
	            	if (craftworld=1) or (space_hulk=1) then y-=10000;
	            }
            
	            var next,ndis;
	            var ndir=floor(random_range(0,360))+1;
	            if (y<=300) then ndir=floor(random_range(180,359))+1;
	            if (y>(room_height-300)) then ndir=floor(random_range(0,180))+1;
	            if (x<=300) then ndir=choose(floor(random_range(0,90))+1,floor(random_range(270,359))+1);
	            if (x>(room_width-300)) then ndir=floor(random_range(90,270))+1;
            
	            ndis=random_range(200,400);
	            next=instance_nearest(x+lengthdir_x(ndis,ndir),y+lengthdir_y(ndis,ndir),obj_star);
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