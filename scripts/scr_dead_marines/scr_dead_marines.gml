function scr_dead_marines(run) {

	// WeeeeeeEEEEEEEEEE~

	// If a ship has been destroyed this kills the fuck out relevant marines
	// Also checks for lost company standards, chapter master, and cleans up
	// the company arrays afterward.

	var i, company, shi, comp_length,clean;
	i=0;shi=999;

	if (run==1){
	    obj_controller.marines=0;
	    obj_controller.command=0;
	}

	i=0;
	var unit, squad;
	if (run == 1){
		for (company=0;company<11;company++){
			comp_length = array_length(obj_ini.name[company]);
			clean = true;
			for (i=0;i<comp_length;i++){
				if (obj_ini.name[company][i]!=""){
		            unit = fetch_unit([company, i]);
		            if (unit.ship_location>-1){
						if ((ship_lost[unit.ship_location]>0) or (obj_ini.ship_hp[unit.ship_location]<=0)){
				            fallen+=1;
				            clean = false;
				            scr_kill_unit(company, i);
			        	}
		        	}
		        }

		        if (obj_ini.name[company,i]!="") and (obj_ini.role[company,i]!="") and (obj_ini.race[company,i]=1){
		            if (is_specialist(obj_ini.role[company][i])=false){
		            	obj_controller.marines+=1
		            }
		            else obj_controller.command+=1;
		        }

		        if (i<120){
		            if (obj_ini.veh_role[company,i]!="") and ((ship_lost[obj_ini.veh_lid[company,i]]>0) or (obj_ini.ship_hp[obj_ini.veh_lid[company,i]]<=0)) and (obj_ini.veh_lid[company,i]>-1){
		            	destroy_vehicle(company,i);
		            }
		        }
			}
			if (clean == false){
				with(obj_ini){scr_company_order(company);scr_vehicle_order(company);}
			}
		}
	}
}


function destroy_vehicle(co, num){
    obj_ini.veh_race[co][num]=0;
    obj_ini.veh_loc[co][num]="";
    obj_ini.veh_name[co][num]="";
    obj_ini.veh_role[co][num]="";
    obj_ini.veh_wep1[co][num]="";
    obj_ini.veh_wep2[co][num]="";
    obj_ini.veh_wep3[co][num]="";
    obj_ini.veh_upgrade[co][num]="";
    obj_ini.veh_acc[co][num]="";
    obj_ini.veh_hp[co][num]=100;
    obj_ini.veh_chaos[co][num]=0;
    obj_ini.veh_pilots[co][num]=0;
    obj_ini.veh_lid[co][num]=-1;
}
