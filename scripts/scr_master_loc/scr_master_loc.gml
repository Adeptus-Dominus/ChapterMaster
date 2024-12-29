function scr_master_loc() {

	var lick,good;lick="";good=true;

	var co, v, unit;
	co=0;v=0;

	repeat(3600){
	    if (good=true){
	        if (co<11){v+=1;
	            if (v>300){co+=1;v=1;/*show_message("mahreens at the start of company "+string(co)+" is equal to "+string(info_mahreens));*/}
	            if (co>10) then good=false;
	            if (good=true){
	            	if (obj_ini.name[co][v] == "") then continue;
	            	unit = fetch_unit([co, v]);
	                if (unit.role()="Chapter Master"){
	                    if (unit.planet_location>0) and (unit.ship_location<0) then lick=string(obj_ini.loc[co][v])+"."+string(unit.planet_location);
	                    if (unit.planet_location<=0) and (unit.ship_location>-1) then lick=string(obj_ini.ship[unit.ship_location]);
	                    if (lick!=""){return(lick);good=false;}
	                }
	            }
	        }
	    }
	}





}
