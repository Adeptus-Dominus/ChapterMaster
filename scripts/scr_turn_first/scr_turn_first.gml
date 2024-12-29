function scr_turn_first() {
	try{
	// I believe this is ran at the start of the end of the turn.  That would make sense, right?

	var identifiable=0;
	var unload=0;
	var cur_arti;
	for (var i=0;i<array_length(obj_ini.artifact);i++){
		identifiable=0;
		unload=i;
		if (obj_ini.artifact[unload]=="") then continue;
		cur_arti = obj_ini.artifact_struct[unload];
		if (cur_arti.loc()==""){
			var valid_ship = get_valid_player_ship();
			if (valid_ship >-1){
				obj_ini.artifact_loc[unload] = obj_ini.ship[valid_ship];
				obj_ini.artifact_sid[unload] = 500+valid_ship;
			}
		}
	    if (cur_arti.identified()>0){
	    	var _identifiable = cur_arti.is_identifiable()
        
	        if (instance_exists(obj_p_fleet)) and (!_identifiable){
	        	var _arti_fleet = find_ships_fleet(cur_arti.ship_id());
	        	if (_arti_fleet!="none"){
	        		if (array_length(_arti_fleet.capital_num)){
	        			_identifiable = true;
	        			cur_arti.set_ship_id(_arti_fleet.capital_num[0]);
	        		}
	        	}
	        }
        
            if (_identifiable) then obj_ini.artifact_identified[unload]-=1;
            if (obj_ini.artifact_identified[unload]=0) then scr_alert("green","artifact","Artifact ("+string(obj_ini.artifact[unload])+") has been identified.",0,0);
	    }
	    _identifiable=false;
	}
	unload=0;


	var peace_check,host_p,ox,oy,x5,y5,fdir;
	peace_check=0;ox=0;oy=0;x5=0;y5=0;fdir=0;
	if (floor(turn/90)==turn/90) then peace_check=1;
	// peace_check=1;// Testing
	host_p=0;

	if (peace_check>0){
	    with(obj_temp3){instance_destroy();}
		var baddy, total;
		total = 0;
	    with(obj_star){
	        if (owner>5){
				baddy = 0;
				o = 0;
	            repeat(planets){
					o+=1;
					if (p_orks[o]+p_tyranids[o]+p_chaos[o]+p_traitors[o]+p_necrons[o]>=3) then baddy+=1;
				}
	            if (baddy>0) {
					total++;
				}
	        }
	    }
	    if (total<=3) then peace_check=2;
    
	    // More Testing
	    // peace_check=2;
    
	    if (peace_check=2){
	        var did_so;did_so=false;
	        if (turn>=150) and (faction_defeated[10]=0) and (known[eFACTION.Chaos]=0) and (faction_gender[10]=2){
	        // if (turn>=100000) and (faction_defeated[10]=0) and (known[eFACTION.Chaos]=0){faction_gender[10]=2;
	        	spawn_chaos_warlord();
            
	        }
	        if (did_so=false) and (faction_defeated[7]=1){
	            with(obj_turn_end){audiences+=1;audien[audiences]=7;known[eFACTION.Chaos]=2;audien_topic[audiences]="new_warboss";did_so=true;}
            
	            faction_defeated[7]=-1;known[eFACTION.Ork]=0;
	            faction_leader[eFACTION.Ork]=global.name_generator.generate_ork_name();
	            faction_title[7]="Warboss";
	            faction_status[eFACTION.Ork]="War";
	            disposition[7]=-40;
            
	            var gold,gnew,starf;gold=faction_gender[7];if (gold=0) then gold=1;gnew=0;
	            repeat(20){if (gnew=0) or (gnew=gold) then gnew=choose(1,2,3,4);}
	            faction_gender[7]=gnew;starf=0;
            
	            var x3,y3,fnum;fnum=0;
	            x3=0;y3=0;
	            var side=choose("left","right","up","down");
	            if (side="left") then y3=floor(random_range(0,room_height))+1;
	            if (side="right"){y3=floor(random_range(0,room_height))+1;x3=room_width;}
	            if (side="up") then x3=floor(random_range(0,room_width))+1;
	            if (side="down"){x3=floor(random_range(0,room_width))+1;y3=room_height;}
            
				//lots of this can be wrapped into a single with
	            with(obj_star){if (owner = eFACTION.Eldar) then x-=20000;}
	            with(obj_star){if (planets=1) and (p_type[1]="Dead"){x-=20000;y-=20000;}}
	            with(obj_star){if (planets=2) and (p_type[1]="Dead")and (p_type[2]="Dead"){x-=20000;y-=20000;}}
				
	            repeat(8){fnum+=1;
	                var x4,y4,dire;x4=0;y4=0;dire=0;
	                if (fnum=1){
	                    dire=point_direction(x4,y4,room_width/2,room_height/2);
	                    x4=x3+lengthdir_x(60,dire);y4=y3+lengthdir_y(60,dire);
	                }
	                if (fnum>1){
	                    dire=point_direction(x4,y4,room_width/2,room_height/2);
	                    x4=x3+choose(round(random_range(30,50)),round(random_range(-30,-50)));
	                    y4=y3+choose(round(random_range(30,50)),round(random_range(-30,-50)));
	                }
                
	                var nfleet,tplan;nfleet=instance_create(x4,y4,obj_en_fleet);
	                nfleet = new_ork_fleet(x4,y4);
	                tplan=instance_nearest(nfleet.x,nfleet.y,obj_star);
	                nfleet.action_x=tplan.x;
	                nfleet.action_y=tplan.y;
	                if (fnum=1){
	                	starf=tplan;
	                	nfleet.cargo_data.ork_warboss=new NewPlanetFeature(OrkWarboss);
	                }	                
	                with (nfleet){
	                	frigate_number=10;
	                	capital_number=4;
	                	set_fleet_movement();
	                }
                
                
	                nfleet.x-=20000;
	                nfleet.y-=20000;
	                tplan.x-=20000;
	                tplan.y-=20000;
	            }
            
	            with(obj_en_fleet){if (x<-14000) and (y<-14000) and (owner = eFACTION.Ork){x+=20000;y+=20000;}}
	            with(obj_star){if (x<-14000) and (y<-14000){x+=20000;y+=20000;}}
	            with(obj_star){if (x<-14000) and (y<-14000){x+=20000;y+=20000;}}
	            with(obj_star){if (x<-14000) and (y<-14000){x+=20000;y+=20000;}}
	            with(obj_star){if (x<-14000) and (y<-14000){x+=20000;y+=20000;}}
	            with(obj_star){if (x<-14000) and (y<-14000){x+=20000;y+=20000;}}
            	
            	var _ork_leader = obj_controller.faction_leader[eFACTION.Ork];
	            var tix=$"Warboss {_ork_leader} leads a WAAAGH! into Sector "+string(obj_ini.sector_name)+".";
	            scr_alert("red","lol",string(tix),starf.x,starf.y);
	            scr_event_log("red",tix);
	            scr_popup("WAAAAGH!",$"A WAAAGH! led by the Warboss {_ork_leader} has arrived in "+string(obj_ini.sector_name)+".  With him is a massive Ork fleet.  Numbering in the dozens of battleships, they carry with them countless greenskins.  The forefront of the WAAAGH! is destined for the "+string(starf.name)+" system.","waaagh","");
	        }
	    }
	}
	}catch(_exception) {
    	handle_exception(_exception);
	}


}
