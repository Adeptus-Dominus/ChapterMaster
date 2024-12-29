function scr_role_count(target_role, search_location="", return_type="count") {

	// Take a guess

	var com, count, coom, units=[], unit,match;

	count=0;
	com=0;
	coom=-999;

	if (is_string(search_location)){
		if (search_location="0")  {coom=0;}
		else if (search_location="1")  {coom=1;}
		else if (search_location="2")  {coom=2;}
		else if (search_location="3")  {coom=3;}
		else if (search_location="4")  {coom=4;}
		else if (search_location="5")  {coom=5;}
		else if (search_location="6")  {coom=6;}
		else if (search_location="7")  {coom=7;}
		else if (search_location="8") { coom=8;}
		else if (search_location="9")  {coom=9;}
		else if (search_location="10")  {coom=10;}
	} else {
		coom = search_location;
	}



	if (coom>=0){
	    com=coom;
	    for (var i=0;i<array_length(obj_ini.TTRPG[com]);i++){
			unit=obj_ini.TTRPG[com][i];
			if (unit.name()=="")then continue; 	
	        if (unit.role()==target_role) && (obj_ini.god[com][i]<10){
	        	count+=1;
	        	if (return_type=="units"){
	        		array_push(units, obj_ini.TTRPG[com][i]);
	        	}
	        }
	    }    
	    com+=1;
	}


	if (coom<0) then repeat(11){
	    for (var i=0;i<array_length(obj_ini.TTRPG[com]);i++){
			match=false;
			unit=obj_ini.TTRPG[com][i];
			if (unit.name()=="")then continue;
	        if (unit.role()=target_role) and (search_location="") then match=true;
	        if (unit.role()=target_role) and (obj_ini.loc[com][i]=obj_ini.home_name) and (search_location="home") then match=true;
	        if (unit.role()=target_role) and (search_location="field") and ((obj_ini.loc[com][i]!=obj_ini.home_name) or (unit.ship_location>-1)) then match=true;
        
	        if (search_location!="home") and (search_location!="field"){
	            if (unit.role()=target_role){
	                var t1=string(obj_ini.loc[com][i])+"|"+string(unit.planet_location)+"|";
	                if (search_location=t1) then match=true;
	            }
	        }
	        if (match){
	        	count++;
	        	if (return_type=="units"){
	        		array_push(units, unit);
	        	}	        	
	        }
	    }    
	    com+=1;
	}






	if (return_type=="units"){
		return units;
	}

	return(count);
}
