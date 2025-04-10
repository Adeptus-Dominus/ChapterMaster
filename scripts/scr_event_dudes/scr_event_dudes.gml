function scr_event_dudes(do_action, is_planet, system_name, location_id) {

	/*
	do_action: perform action?          0: nope,    1: pass dudes over to the obj_event object
	is_planet: planet?
	system_name: star name
	location_id: ship or planet ID
	*/

	if (do_action=1){
	    if (obj_ini.progenitor == ePROGENITOR.NONE) {
	        if (obj_controller.fest_feasts<2) then obj_controller.fest_feasts=2;
	    }
	    if ((global.chapter_name="Space Wolves") || (obj_ini.progenitor == ePROGENITOR.SPACE_WOLVES)) {
	        if (obj_controller.fest_feasts<10) then obj_controller.fest_feasts=10;
	        if (obj_controller.fest_boozes<10) then obj_controller.fest_boozes=10;
	    }
	    if ((global.chapter_name="Blood Angels") || (obj_ini.progenitor == ePROGENITOR.BLOOD_ANGELS)) {
	        if (obj_controller.fest_boozes<3) then obj_controller.fest_boozes=3;
	    }
	}


	var coh,ide,oc,ocn,ty,g,good,blur,unit;;
	coh=-1;ide=0;ide=-1;ty=0;g=0;good=0;blur="";
	repeat(200){ide+=1;oc[ide]="";ocn[ide]=0;}

	co=-1;ide=0;
	repeat(11){coh+=1;ide=0;
	    repeat(300){ide+=1;
	        var adding;adding=false;
	        if (obj_ini.name[coh][ide] == "") then continue;
	        unit=obj_ini.TTRPG[coh][ide];
        
	        if (is_planet=0) and (unit.ship_location=location_id){
	            if (obj_ini.race[coh,ide]=1) or (obj_ini.race[coh,ide]=5) then adding=true;
	        }
	        else if (is_planet=1) and (obj_ini.loc[coh,ide]=system_name) and (unit.planet_location==location_id){
	            if (obj_ini.race[coh,ide]=1) or (obj_ini.race[coh,ide]=5) then adding=true;
	        }
        
	        if (obj_ini.role[coh,ide]=obj_ini.role[100][6]) then adding=false;
	        if (obj_ini.role[coh,ide]="Venerable "+string(obj_ini.role[100][6])) then adding=false;
	        if (string_count("Dread",obj_ini.armour[coh,ide])>0) then adding=false;
        
	        // Just compile a list
	        if (adding=true) and (do_action=0){
	            good=0;g=0;
	            repeat(100){g+=1;
	                if (good=0){
	                    if (oc[g]=obj_ini.role[coh,ide]){good=1;ocn[g]+=1;}
	                }
	            }
	            if (good=0){
	                ty+=1;oc[ty]=obj_ini.role[coh,ide];ocn[ty]=1;good=1;
	            }
	        }
        
	        // Don't compile a list and create an array in obj_event instead
	        if (adding=true) and (do_action=1){
	            var speshul=false;
            		if (unit.IsSpecialist(SPECIALISTS_HEADS)) then speshul=true;
                
	                if (speshul=true){
	                    obj_event.avatars+=1;
                    
	                    obj_event.avatar_name[obj_event.avatars]=obj_ini.name[coh,ide];
	                    obj_event.avatar_rank[obj_event.avatars]=obj_ini.role[coh,ide];
	                    if (obj_controller.trim=0) then obj_event.avatar_image[obj_event.avatars]=1;
	                    if (obj_controller.trim=1) then obj_event.avatar_image[obj_event.avatars]=0;
	                    if (obj_controller.trim=2) then obj_event.avatar_image[obj_event.avatars]=2;
	                    if (obj_controller.trim=3) then obj_event.avatar_image[obj_event.avatars]=2;
	                    if (obj_ini.race[coh,ide]=5) then obj_event.avatar_image[obj_event.avatars]=3;
	                    obj_event.avatar_co[obj_event.avatars]=coh;
	                    obj_event.avatar_id[obj_event.avatars]=ide;
	                }
                
	                obj_event.attendants+=1;
	                obj_event.attend_co[obj_event.attendants]=coh;
	                obj_event.attend_id[obj_event.attendants]=ide;
	                obj_event.attend_corruption[obj_event.attendants]=unit.corruption;
	                obj_event.attend_race[obj_event.attendants]=obj_ini.race[coh,ide];
                
	                // Determine attend confused here
                
	                var base_confusion;
	                base_confusion=0;
                
	                if (obj_controller.fest_type="Great Feast"){
	                    base_confusion=choose(1,2,2,3);
	                    base_confusion-=obj_controller.fest_feasts;
	                    if (obj_controller.fest_feature2=1) then base_confusion+=1;
	                    if (obj_controller.fest_feature3=1) and (unit.corruption<50) then base_confusion+=1;
	                    if (unit.corruption>20) then base_confusion-=1;
	                    if (unit.corruption>50) then base_confusion-=2;
	                }
                
	                obj_event.attend_confused[obj_event.attendants]=base_confusion;
                
                
                
	        }
        
	    }
	}


	// Return that list
	if (do_action=0){
	    i=0;good=1;
	    repeat(100){i+=1;
	        if (good=1){
	            if (ocn[i]=1) then blur+=string(ocn[i])+"x "+string(oc[i]);
	            if (ocn[i]>1) then blur+=string(ocn[i])+"x "+string(oc[i])+"s";
	            if (ocn[i+1]>0) then blur+=", ";
	            if (ocn[i+1]=0){blur+=".";good=0;}
	        }
	    }
    
	    return(blur);
	}

	// Yar har har
	if (do_action=1){
	    log_message("Event: Present marines passed to obj_event array");
	    obj_event.time_max=obj_event.attendants*10;
    
	    obj_event.alarm[0]=30;
	    // show_message("The event has "+string(obj_event.avatars)+" important dudes and "+string(obj_event.attendants)+" dudes total");
	}


}
