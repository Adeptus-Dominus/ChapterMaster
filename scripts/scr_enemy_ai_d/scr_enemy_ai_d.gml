function scr_enemy_ai_d() {

	if (x<-15000){x+=20000;y+=20000;}
	if (x<-15000){x+=20000;y+=20000;}
	if (x<-15000){x+=20000;y+=20000;}


	// Planetary problems here

	for (var i=1;i<=planets;i++){

        //this will skip for given planet if no problems associated wiht planet
		var numeral_name = planet_numeral_name(i);
	    if (p_necrons[i]>0) and (p_necrons[i]<6) then p_necrons[i]+=1;
    
	    var wob=0;
	    var fallen = find_problem_planet(i, "fallen");
	    if (fallen>-1 and storm-1>0){
	    	p_timer[i][fallen]++;
	    }
    
    
	    // Requesting help here
	    if ((p_halp[i]=1) or (p_halp[i]=1.1)) and (p_population[i]>0) and (p_owner[i]<6){
	        if (p_orks[i]+p_tau[i]+p_traitors[i]+p_chaos[i]+p_necrons[i]=0) and (p_tyranids[i]<4) then p_halp[i]=0;
	    }
	    if (p_halp[i]=0) and (p_population[i]>0) and (p_owner[i]<6) and (p_owner[i]!=1) and (present_fleet[1]<=0) and (p_player[i]<=0){

	        var enemy1="",enemies=0,minimum=5,tx="";
        
	        if (p_guardsmen[i]+p_pdf[i]<=1000000) { minimum=4;}
	        else if (p_guardsmen[i]+p_pdf[i]<=500000) { minimum=3;}
	        else if (p_guardsmen[i]+p_pdf[i]<=200000) { minimum=2;}
	        else if (p_guardsmen[i]+p_pdf[i]<=1000) { minimum=1;}
        
	        if (p_orks[i]>=minimum){enemy1="Ork";enemies+=1;}
	        if (p_tau[i]>=minimum){enemy1="Tau";enemies+=1;}
	        if (p_traitors[i]>=minimum){enemy1="Heretic";enemies+=1;}
	        if (p_chaos[i]>=minimum){enemy1="Chaos Space Marine";enemies+=1;}
	        if (p_necrons[i]>=minimum){enemy1="Necron";enemies+=1;}
	        if (p_tyranids[i]>=minimum) and (vision>0) and (p_tyranids[i]>3){enemy1="Tyranid";enemies+=1;}
        
	        if (enemies=1){
	        	p_halp[i]=1;
	        	tx=$"The Planetary Governor of {planet_numeral_name(i)} requests help against {enemy1} forces!";
	            scr_alert("green","halp",string(tx),x,y);
	            scr_event_log("",string(tx), name);
	        }
	        if (enemies>1){p_halp[i]=1;tx="The Planetary Governor of "+string(name)+" "+scr_roman(i)+" requests help against numerous enemy forces!";
	            scr_alert("green","halp",string(tx),x,y);
	            scr_event_log("",string(tx), name);
	        }
	    }
    }
    for (var i=1;i<=planets;i++){
        problem_count_down(i);
        if (planet_problemless(i)) then continue;
        numeral_name = planet_numeral_name(i);

	    if (has_problem_planet_and_time(i, "succession", 0)){
            var result,alert_text;
            var dice1=roll_dice(1, 100);
            var dice2=roll_dice(1, 100);
        
            result="";
            alert_text="";
            if (dice1<=(p_heresy[i]*2)) then result="chaos";
            if (dice2<=(p_influence[i][eFACTION.Tau]*2)) and (result="") then result="tau";
            if (result="") then result="imperial";

        	alert_text=$"War of Succession on {planet_numeral_name(1)} has ended";
        
            if (p_owner[i]=2) and (result="chaos"){
                alert_text+=" with Chaos in control.";
                dispo[i]=0;
                p_owner[i]=10;
                p_pdf[i]+=p_guardsmen[i];
                p_guardsmen[i]=0;
                scr_alert("red","succession",alert_text,x,y);
            }
            else if (p_owner[i]=2) and (result="tau"){
                alert_text+=" with a Tau sympathizer in control.";
                dispo[i]=10+choose(1,2,3,4,5,6);
                p_owner[i]=8;
                p_pdf[i]+=p_guardsmen[i];
                p_guardsmen[i]=0;
                p_tau[i]=2;
                scr_alert("red","succession",alert_text,x,y);
            
            } else if (result="imperial"){
                alert_text+=" The resultant governor is the most staunch pillar of the imperium.";
            }else {
                alert_text+=" Word is the new Governor has Heretical leanings and sympathises with xenos.";
            }
            if (result="imperial"){alert_text+=".";
                scr_alert("green","succession",alert_text,x,y);
            }
            delete_features(p_feature[i], P_features.Succession_War);
            if (result="chaos") then scr_event_log("purple",alert_text);
            if (result="tau") then scr_event_log("red",alert_text);
            if (result="imperial") then scr_event_log("",alert_text);
            remove_planet_problem(i, "succession");
	    }
	   if (has_problem_planet_and_time(i, "recon", 0)>-1){
            var alert_text="Inquisition Mission Failed: Investigate ";
            alert_text+=string(name)+" "+scr_roman(i)+".";
            scr_alert("red","mission_failed",alert_text,0,0);
            scr_event_log("red",alert_text);
            obj_controller.disposition[4]-=5;
            remove_planet_problem(i, "recon");
        }

        if (has_problem_planet_and_time(i, "great_crusade", 0)>-1){
            var dir;
            var join_crusade=false;
            var _player_fleet = instance_nearest(x,y,obj_p_fleet);
        
            if (_player_fleet.action=""){
                if (point_distance(x, y, _player_fleet.x, _player_fleet.y)<10 ){
                    join_crusade=true;
                }
            }
        
            if (join_crusade){
                dir=point_direction(room_width/2,room_height/2,x,y);
                with (_player_fleet){
                    action_x=x+lengthdir_x(1200,dir);
                    action_y=y+lengthdir_y(1200,dir);
                    set_fleet_movement(false, "crusade1");
                }

                scr_alert("green","crusade","Fleet embarks upon Crusade.",x,y);
                scr_event_log("","Fleet embarks upon Crusade.");
            }else {
                // hit loyalty here
                obj_controller.disposition[2]-=5;
                obj_controller.disposition[4]-=10;
                scr_alert("red","crusade","No ships designated for Crusade.",x,y);
                scr_loyalty("Refusing to Crusade","+");
                scr_event_log("red","No ships designated for Crusade.");
                if (obj_controller.penitent=1) then obj_controller.penitent_current=0;
            }
        	remove_planet_problem(i, "great_crusade");
        }

        mechanicus_missions_end_turn(i);
        if (has_problem_planet_and_time(i,"bomb", 0)>-1){

            var alert_text="The Necron Tomb of planet ";

            alert_text+=$"{numeral_name} has not been deactivated in time.  It has awakened, rank upon rank of Necrons pouring out to the planet's surface.  The Inquisition is not pleased with your failure.";
            scr_popup("Inquisition Mission Failed",alert_text,"necron_army","");
            scr_event_log("red",$"Inquisition Mission Failed: Bombing run failed; the Necron Tomb on {planet_numeral_name(i)} has become active.");
        
            p_necrons[i]=4;
            if (awake_tomb_world(p_feature[i])==0) then awaken_tomb_world(p_feature[i]);
        	remove_planet_problem(i,"necron"); 
            // scr_alert("red","mission_failed",alert_text,0,0);
            obj_controller.disposition[4]-=8;
        }
        if (has_problem_planet_and_time(i,"inquisitor1", 6)>-1|| has_problem_planet_and_time(i,"inquisitor2", 6)>-1){
            var flit, x7,y7,drr;
            drr=random(floor(360))+1;
            x7=x+lengthdir_x(384,drr);
            y7=y+lengthdir_y(384,drr);
        
            if (x7<0) or (x7>room_width) or (y7>room_height) or (y7<0){
                drr=point_direction(x,y,room_width/2,room_height/2);
                x7=x+lengthdir_x(384,drr);y7=y+lengthdir_y(384,drr);
            }
        
            // show_message("x1:"+string(x)+", y1:"+string(y)+"#x2:"+string(x7)+", y2:"+string(y7));
        
            flit=instance_create(x7,y7,obj_en_fleet);
            if (has_problem_planet_and_time(i,"inquisitor1", 6)) then flit.trade_goods="male_her";
            if (has_problem_planet_and_time(i,"inquisitor2", 6)) then flit.trade_goods="female_her";
            flit.action_x=x;
            flit.action_y=y;
            with (flit){
                owner  = eFACTION.Inquisition;
                sprite_index=spr_fleet_inquisition;
                image_index=0;
                action_spd=128;
                escort_number=1;
                set_fleet_movement()
            }
           remove_planet_problem(i,"inquisitor1"); 
           remove_planet_problem(i,"inquisitor2"); 
        }
         if (has_problem_planet_and_time(i,"spyrer", 0)>-1){
            var alert_text,text;
            var planet_name = planet_numeral_name(i, self);
            alert_text=$"The Spyrer on {planet_name} has been left unchecked.  In the ensuing carnage some high-ranking officials have been killed, along with several Nobles.  Panic is running amock in several parts of the hives and the Inquisition is less than pleased.";
            text="Inquisition Mission Failed: The Spyrer on {planet_name} was not removed.";
            scr_popup("Inquisition Mission Failed",alert_text,"spyrer","");
            obj_controller.disposition[eFACTION.Inquisition]-=3;
            scr_event_log("red",text);
            remove_planet_problem(i,"spyrer"); 
         }
         if (has_problem_planet_and_time(i,"fallen", 0)>-1){
            //TODO marker point for cohesion mechanics
            var alert_text="";
            var unit;
            if (ran>33){// Give all marines +3d6 corruption and reduce loyalty by 20*/
                var me=0;
                for (var co=0;co<=obj_ini.companies;co++){
                    me=0;
                    for (me=0;me<array_length(obj_ini.role[co]);me++){
                        if (obj_ini.race[co][me]=1) and (obj_ini.role[co][me]!=""){
                            unit = fetch_unit([co,me]);
                            unit.add_corruption(irandom_range(3, 18));
                        }
                    }
                }
                alert_text=$"Any Fallen that may have been on {planet_numeral_name(i)} ";
                alert_text+="have been given sufficient time to escape.  Morale within your chapter has plummeted; some of your battle brothers have become restless and speak among eachother in hushed tones.";
                scr_popup("Hunt the Fallen Failed",alert_text,"fallen","");
                obj_controller.loyalty-=30;
                obj_controller.loyalty_hidden-=30;
                remove_planet_problem(i,"fallen"); 
                scr_event_log("red",$"Mission Failed: Any Fallen within the {name} system have been given time to escape.");          	
          }
        }
        var garrison_mission = has_problem_planet_and_time(i,"provide_garrison", 0);
        if (garrison_mission>-1){
            try_and_report_loop("complete garrison mission", complete_garrison_mission,true, [i,garrison_mission]);
        }
        var _beast_hunt = has_problem_planet_and_time(i,"hunt_beast", 0);
        if (_beast_hunt>-1){
            try{
                complete_beast_hunt_mission(i,_beast_hunt);
            } catch (_exception){
                handle_exception(_exception);
            }
        }

        var train_forces = has_problem_planet_and_time(i,"train_forces", 0);
        if (train_forces>-1){
            try{
                complete_train_forces_mission(i,train_forces);
            } catch (_exception){
                handle_exception(_exception);
            }
        }             
    
	    if (p_tyranids[i] > 3 && planet_feature_bool(p_feature[i], P_features.Gene_Stealer_Cult) && obj_controller.turn > 120){
	        if (!(has_problem_planet(i, "Hive Fleet"))){
	            var roll=irandom_range(0,300);
	            var cont=0;
        
            
	            if (p_tyranids[i]=3) and (roll<=5) then cont=1;
	            if (p_tyranids[i]=4) and (roll<=8) then cont=1;
            
	            if (cont = 1 && firstest > -1){
                    var _capitals = choose(7,8,9);
                    var _frigates = irandom_range(6,12);
                    var _escorts = irandom_range(12,27);
                    var _fleet = summon_new_hive_fleet(_capitals, _frigates, _escorts);
                    add_new_problem(i, "Hive Fleet", _fleet.action_eta, self, {});
	            }
	        }
    
	    }
        hive_fleet_arrives_from_out_of_system();
	}
	

	if (storm>0){
		storm-=1;
	    if (storm=0){
	        var tr="Warp Storms over "+string(name)+" dissipate.";
	        scr_alert("green","Warp",tr,x,y);scr_event_log("green",tr);
	    }
	}
	if (trader>0){
		trader-=1;
	    if (trader=0){
	        var tr="Rogue Trader fleet departs from "+string(name)+".";
	        scr_alert("green","Warp",tr,x,y);scr_event_log("green",tr);
	    }
	}

	with(obj_star){
        if (x<-10000){
            x+=20000;
            y+=20000;
        }
    }

    var already_enroute = false;
    var cur_star = id;
	with(obj_en_fleet){
	    if (owner = eFACTION.Imperium) and (fleet_has_cargo("colonize")){
	        already_enroute = (action_x == cur_star.x && action_y == cur_star.y);
	    }
	};

    if (!already_enroute){
        var pop_doner_options = [];
        //this stops needless repeats of searches
        if (!struct_exists(obj_controller.end_turn_insights, "population_doners")){
            pop_doner_options = find_population_doners();
        }
        obj_controller.end_turn_insights.population_doners = pop_doner_options;
        pop_doner_options = obj_controller.end_turn_insights.population_doners;
    
        var deletion=-1;
        for (var i=0;i<array_length(pop_doner_options);i++){
            if (pop_doner_options[i][0]==id){
                deletion = i;
                break;
            }
        }
        if (deletion > -1){
            array_delete(pop_doner_options, deletion, 1);
        }
    
        var priority_requests = [];
        var non_priority_requests = [];
    
        var r=0,yep=0;
        for (r=1;r<=planets;r++){// temp5: new hive, temp4: new planet
            if (!scr_planet_owned_by_group(r,fetch_faction_group())) then continue;
            if ((p_population[r]>0) || (p_type[r]=="")) then continue;
            if (!space_hulk) and (!craftworld) and (p_type[r]!="Dead"){
    
                var priority_imperium = ["Hive", "Temperate","Shrine"];
                if (p_owner[r]=eFACTION.Imperium) && (array_contains(priority_imperium, p_type[r]) ) {
                    array_push(priority_requests, r);
                    break;
                }
    
                if (p_owner[r]==eFACTION.Mechanicus) && (p_type[r]=="Forge"){
                    array_push(priority_requests, r);
                    break;
                }
                // Count player planets as HIVE PLANETS so that they are prioritized
                if (p_owner[r]=eFACTION.Player) {
                    array_push(priority_requests, r);
                    break;
                }
    
                if ((p_owner[r]==eFACTION.Imperium) or (p_owner[r]==eFACTION.Ecclesiarchy))   and (p_type[r]!="Lava") and (p_type[r]!="Hive") and (p_type[r]!="Temperate")  then array_push(non_priority_requests, r);
            }
        }
    
        if (array_length(pop_doner_options)>0 && array_length(non_priority_requests) && array_length(priority_requests)){
            var onceh=0;
            var random_chance=floor(random(100))+1;
            var doner_index = 0;
            for(var i=1;i<array_length(pop_doner_options); i++){
                if (star_distace_calc(pop_doner_options[i]) < star_distace_calc(pop_doner_options[doner_index])){
                    doner_index = i;
                }
            }
            var doner_star=pop_doner_options[doner_index][0];
            var doner_planet = pop_doner_options[doner_index][1];   
    
            if (array_length(priority_requests))  and (random_chance<=2){// A hive is requesting repopulation
    
                new_colony_fleet(doner_star.id, doner_planet, self.id, priority_requests[0]);
            }
            else if (array_length(non_priority_requests))  and (random_chance<=2){// Some other world is requesting repopulation
    
                new_colony_fleet(doner_star.id, doner_planet, self.id, non_priority_requests[0]);
            }
        }
    
        instance_activate_all();
        with(obj_star){
            if (x<-10000){x+=20000;y+=20000;}
            if (x<-10000){x+=20000;y+=20000;}
        }
    }

	// Local problems will go here
	var planet;
	for (var i=0;i<=planets;i++){
		planet=i+1;
		if (i < array_length(system_garrison)){
			var garrison = system_garrison[i];
			if (garrison.garrison_force){
				if (garrison.garrison_disposition_change(self,planet)!="none"){
					dispo[planet]+=garrison.dispo_change;
				}
			}
		}
	}
}
