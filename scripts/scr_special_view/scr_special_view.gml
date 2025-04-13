function scr_special_view(command_group) {

	// Works as COMPANY VIEW but for the subsections of HQ
 
	var mans=0, onceh, company=0, bad=0, oth=0, unit;
	gogogo=0;
	vehicles=0;
	last_man=0;
	last_vehicle=0;

	var squads=0, squad_typ="", squad_loc=0, squad_members=0;

	for (var i=0;i<20;i++){
		sel_uni[i]="";
		sel_veh[i]="";
	}
	for (var i=0;i<501;i++){

	    if (i<=50){
	    	penit_co[i]=0;
	    	penit_id[i]=0;
	    }
	    // if (i<=100){event[i]="";event_duration[i]=0;}
	}
	reset_manage_arrays();

	mans=0;
	vehicles=0;
	b=0;

	// v: check number
	// mans: number of mans that a hit has gotten

	b=0;
	if (command_group==11) or (command_group==0){				//HQ units
		for (var v = 0;v<array_length(obj_ini.TTRPG[0]);v++){
			bad=0;
			if (obj_ini.name[0][v]== ""){continue;}
			if (obj_ini.TTRPG[0][v].ship_location>-1){
			   	var ham=obj_ini.TTRPG[0][v].ship_location;
			   	if (obj_ini.ship_location[ham]=="Lost") then continue;
			}

			unit = obj_ini.TTRPG[0][v];	    	
			var yep=0;
			if (unit.base_group!="astartes") and (unit.base_group!="none"){
				yep=1;
			}
			if ((unit.role()=="Chapter Master") or (unit.role()==obj_ini.role[100][2])){
				yep=1;
			}
			if (yep==1){
		        add_man_to_manage_arrays(unit);
			}
		}
	}

	if (command_group==12) or (command_group==0){// Apothecarion
		var apothecaries = collect_role_group([SPECIALISTS_APOTHECARIES,true]);
		for (var i=0;i<array_length(apothecaries);i++){
			unit = apothecaries[i];
			add_man_to_manage_arrays(apothecaries[i]);
			//if (unit.role()== obj_ini.role[0][v]=obj_ini.role[100][15]) then ma_promote[b]=1;
		}
	}

	v=0;
	if (command_group==13) or (command_group==0){// Librarium
		var libs = collect_role_group([SPECIALISTS_LIBRARIANS,true]);
		for (var i=0;i<array_length(libs);i++){
			unit = libs[i];
			add_man_to_manage_arrays(libs[i]);
		}		
	}

	v=0;
	if (command_group==14) or (command_group==0){// Reclusium
		var chaps = collect_role_group([SPECIALISTS_CHAPLAINS,true]);
		for (var i=0;i<array_length(chaps);i++){
			unit = chaps[i];
			add_man_to_manage_arrays(chaps[i]);
		}	
	}

	v=0;
	squads=0;
	if (command_group==15) or (command_group==0){// Armamentarium
		var techs = collect_role_group([SPECIALISTS_TECHS,true]);
		for (var i=0;i<array_length(techs);i++){
			unit = techs[i];
			add_man_to_manage_arrays(techs[i]);
		}
	}






	// b=last_man;
	last_man=b;
	last_vehicle=0;

	for (var i=1;i<101;i++){// 100
	    if (obj_ini.veh_race[company,i]!=0){
	    	add_vehicle_to_manage_arrays([company,i]);
	    }
	}



	squads=0;
	//TODO unify this data with other_manage_data() method
	for (var i=1;i<array_length(display_unit);i++){
		onceh=0;
	    var ahuh=0;
	    if (man[i]="man"){if (ma_role[i]!="") then ahuh=1;}
	    if (man[i]="vehicle"){if (ma_role[i]!="") then ahuh=1;}

	    if (ahuh=1){
	        // Select All
	        var go=0,op=0,w=0;
	        if (man[i]=="man"){
	            for (w=0;w<20;w++){
	                if (sel_uni[w]=="") and (op==0) then op=w;
	                if (sel_uni[w]==ma_role[i]) then go=1;
	            }
	            if (go==0) then sel_uni[op]=ma_role[i];
	        }
	        go=0;
	        op=0;
	        if (man[i]=="vehicle"){
	            for (w=0;w<20;w++){
	                if (sel_veh[w]=="") and (op==0) then op=w;
	                if (sel_veh[w]==ma_role[i]) then go=1;
	            }
	            if (go==0) then sel_veh[op]=ma_role[i];
	        }


	        // Squads
	        if (squads>0){
	            var n=1;
	            if (squad_typ==obj_ini.role[100][15]) then n=0;
	            if (squad_typ==obj_ini.role[100][14]) then n=0;
	            if (squad_typ==obj_ini.role[100,17]) then n=0;
	            if (squad_typ=obj_ini.role[100][16]) then n=0;
	            if (squad_typ="Codiciery") then n=0;
	            if (squad_typ="Lexicanum") then n=0;
	            if (squad_typ=ma_role[i]) then n=0;
	            if (squad_typ=obj_ini.role[100,17]) and (ma_role[i]="Codiciery") then n=1;
	            if (squad_typ="Codiciery") and (ma_role[i]="Lexicanum") then n=1;

	            if (squad_typ="Master of Sanctity") then n=1;
	            if (squad_typ="Chief "+string(obj_ini.role[100,17])) then n=1;
	            if (squad_typ="Forge Master") then n=1;
	            if (squad_typ="Chapter Master") then n=1;
	            if (squad_typ="Master of the Apothecarion") then n=1;

	            if (squad_members+1>10) then n=1;
	            if ((ma_wid[i]+(ma_lid[i]/100))!=squad_loc) then n=1;
	            if (squad_typ==obj_ini.role[100][6]) then n=2;

	            if (n==0){
	            	squad_members+=1;
	            	squad_typ=ma_role[i];
	            	squad[i]=squads;
	            }else if (n==1){
	                squads+=1;
	            	squad_members=1;
		            squad_typ=ma_role[i];
		            squad[i]=squads;
		            squad_loc=ma_wid[i]+(ma_lid[i]/100);
	        	}else if (n==2){
	        		squad[i]=0;
	        	}
	        }else if (squads==0){
	        	squads+=1;
	        	squad_members=1;
		        squad_typ=ma_role[i];
		        squad[i]=squads;
		        squad_loc=ma_wid[i]+(ma_lid[i]/100);
	    	}
	    }

	}

	man_current=0;
	man_max=MANAGE_MAN_MAX;
	// if (command_group=13) then man_max+=2;


	// Now have the maximum (man_last + vehicle last), the types of each of those slots, and the relevant ID
	// Should be enough to display everything else


}
