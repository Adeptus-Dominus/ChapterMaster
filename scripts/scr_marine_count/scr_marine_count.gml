function scr_marine_count(argument0, argument1, argument2) {

	// argument0: star object
	// argument1: planet number
	// argument2: stop check at

	var com,ide,check,sca,unit;com=-1;ide=0;check=0;sca=9999;
	if (argument2>0) then sca=argument2;

	repeat(11){
	    if (check<sca){com+=1;ide=0;
	        repeat(300){
	        	if (obj_ini.name[com][ide] == "") then continue;
	        	unit=obj_ini.TTRPG[com][ide]
	            if (check<sca){ide+=1;
	                if (unit.role()!="") and (obj_ini.race[com][ide]<=5) and (unit.location_string=argument0.name) and (unit.planet_location=argument1) then check+=1;
	            }
	        }
	    }
	}

	return(check);



}
