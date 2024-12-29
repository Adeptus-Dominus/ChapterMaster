function scr_drop_fiddle(argument0, argument1, argument2, argument3) {

	// argument0: ship IDE     argument1: loading?      argument2: ship array number        argument3: vehicles?
	// This script is executed to determine who is eligable to DEEP STRAHK or purge

	var i, comp, idy, good, vgood, assassinate, vehy, para;
	i=0;comp=0;idy=0;good=1;vgood=1;assassinate=false;vehy=argument3;para=true;

	if (instance_exists(obj_drop_select)){
	    if (obj_drop_select.purge=5) then assassinate=true;
	}


	if (attacking=0) then vgood=0;

	if (argument0 > -1 && argument1 == true) { // Adding marines to the drop roster
		ship_all[argument2] = 1;
		var unit;
		for (var i = 0; i <= 3500; i++) {
			if (good == 1) {
				para = true;
				if (i > 300) {
					i = 0;
					comp++;
				}
				if (comp > 10) then good = 0;
			}
	
			if (good == 1 && vgood == 1 && i <= 100 && vehy == 1 && obj_ini.veh_lid[comp][i] == argument0) {
				veh_fighting[comp][i] = 1;
				if (obj_ini.veh_role[comp][i] == "Land Speeder") then speeders++;
				if (obj_ini.veh_role[comp][i] == "Rhino") then rhinos++;
				if (obj_ini.veh_role[comp][i] == "Whirlwind") then whirls++;
				if (obj_ini.veh_role[comp][i] == "Predator") then predators++;
				if (obj_ini.veh_role[comp][i] == "Land Raider") then raiders++;
			}
	
			if (good == 1) {
				unit = fetch_unit([comp, i]);
				if (obj_ini.race[comp][i] != 0 && unit.ship_location == argument0 && obj_ini.god[comp][i] < 10 && 
					(string_count("Bike", obj_ini.mobi[comp][i]) == 0 || vehy == 1) && para == true) { // Man
					ship_use[argument2]++;
					fighting[comp][i] = 1;
	
					if (obj_ini.role[comp][i] == "Chapter Master") {
						master = 1;
						ship_use[argument2]++;
					}
					if (obj_ini.role[comp][i] == obj_ini.role[100][2]) then honor++;
					if (obj_ini.role[comp][i] == "Champion") then champions++;
	
					if (obj_ini.role[comp][i] == obj_ini.role[100][5]) then capts++;
					if (unit.IsSpecialist("chap", true)) then chaplains++;
					if (unit.IsSpecialist("libs", true)) then psykers++;
					if (unit.IsSpecialist("apoth", true)) then apothecaries++;
					if (unit.IsSpecialist("forge", true)) then techmarines++;
	
					if (obj_ini.role[comp][i] == "Death Company" && string_count("Dreadnought", obj_ini.armour[comp][i]) == 0) then mahreens++;
					if (obj_ini.role[comp][i] == obj_ini.role[100][4]) then terminators++;
					if (((obj_ini.role[comp][i] == obj_ini.role[100][6]) || 
						(obj_ini.role[comp][i] == "Venerable " + string(obj_ini.role[100][6])) || 
						string_count("Dreadnought", obj_ini.armour[comp][i]) == 1) && assassinate == false) then dreads++;
	
					if (string_count("Bike", obj_ini.mobi[comp][i]) == 0) {
						if (obj_ini.role[comp][i] == obj_ini.role[100][11]) then mahreens++;
						if (obj_ini.role[comp][i] == obj_ini.role[100][12]) then mahreens++;
						if (obj_ini.role[comp][i] == obj_ini.role[100][8] || 
							obj_ini.role[comp][i] == obj_ini.role[100][10] || 
							obj_ini.role[comp][i] == obj_ini.role[100][9]) then mahreens++;
						if (obj_ini.role[comp][i] == obj_ini.role[100][3]) then veterans++;
					}
					if (string_count("Bike", obj_ini.mobi[comp][i]) > 0 && vehy == 1) {
						if (obj_ini.role[comp][i] == obj_ini.role[100][11]) then bikes++;
						if (obj_ini.role[comp][i] == obj_ini.role[100][12]) then bikes++;
						if (obj_ini.role[comp][i] == obj_ini.role[100][8] || 
							obj_ini.role[comp][i] == obj_ini.role[100][10] || 
							obj_ini.role[comp][i] == obj_ini.role[100][9]) then bikes++;
						if (obj_ini.role[comp][i] == obj_ini.role[100][3]) then bikes++;
					}
				}
			}
		}
	}
	
	if (argument0 > -1 && argument1 == false) { // Removing marines from the drop roster
		ship_all[argument2] = 0;
	
		for (var i = 0; i <= 3500; i++) {
			if (good == 1) {
				if (i > 300) {
					i = 0;
					comp += 1;
				}
				if (comp > 10) then good = 0;
			}
	
			if (good == 1 && i <= 100 && vehy == 1 && obj_ini.veh_lid[comp][i] == argument0) {
				veh_fighting[comp][i] = 0;
				if (obj_ini.veh_role[comp][i] == "Land Speeder") then speeders--;
				if (obj_ini.veh_role[comp][i] == "Rhino") then rhinos--;
				if (obj_ini.veh_role[comp][i] == "Whirlwind") then whirls--;
				if (obj_ini.veh_role[comp][i] == "Predator") then predators--;
				if (obj_ini.veh_role[comp][i] == "Land Raider") then raiders--;
			}

			if (good == 1) {
				unit = fetch_unit([comp, i]);
				if (obj_ini.race[comp][i] != 0 && unit.ship_location == argument0 && obj_ini.god[comp][i] < 10 && 
					(string_count("Bike", obj_ini.mobi[comp][i]) == 0 || vehy == 1)) { // Man
					ship_use[argument2]--;
					fighting[comp][i] = 0;
	
					if (obj_ini.role[comp][i] == "Chapter Master") {
						master = 0;
						ship_use[argument2]--;
					}
					if (obj_ini.role[comp][i] == obj_ini.role[100][2]) then honor--;
					if (obj_ini.role[comp][i] == "Champion") then champions--;
	
					if (obj_ini.role[comp][i] == obj_ini.role[100][5]) then capts--;
					if (unit.IsSpecialist("chap", true)) then chaplains--;
					if (unit.IsSpecialist("libs", true)) then psykers--;
					if (unit.IsSpecialist("apoth", true)) then apothecaries--;
					if (unit.IsSpecialist("forge", true)) then techmarines--;
	
					if (obj_ini.role[comp][i] == "Death Company" && string_count("Dreadnought", obj_ini.armour[comp][i]) == 0) then mahreens--;
					if (obj_ini.role[comp][i] == obj_ini.role[100][4]) then terminators--;
					if (((obj_ini.role[comp][i] == obj_ini.role[100][6]) || 
						(obj_ini.role[comp][i] == "Venerable " + string(obj_ini.role[100][6])) || 
						string_count("Dreadnought", obj_ini.armour[comp][i]) == 1) && assassinate == false) then dreads--;
	
					if (string_count("Bike", obj_ini.mobi[comp][i]) == 0) {
						if (obj_ini.role[comp][i] == obj_ini.role[100][11]) then mahreens--;
						if (obj_ini.role[comp][i] == obj_ini.role[100][12]) then mahreens--;
						if (obj_ini.role[comp][i] == obj_ini.role[100][8] || 
							obj_ini.role[comp][i] == obj_ini.role[100][10] || 
							obj_ini.role[comp][i] == obj_ini.role[100][9]) then mahreens--;
						if (obj_ini.role[comp][i] == obj_ini.role[100][3]) then veterans--;
					}
					if (string_count("Bike", obj_ini.mobi[comp][i]) > 0 && vehy == 1) {
						if (obj_ini.role[comp][i] == obj_ini.role[100][11]) then bikes--;
						if (obj_ini.role[comp][i] == obj_ini.role[100][12]) then bikes--;
						if (obj_ini.role[comp][i] == obj_ini.role[100][8] || 
							obj_ini.role[comp][i] == obj_ini.role[100][10] || 
							obj_ini.role[comp][i] == obj_ini.role[100][9]) then bikes--;
						if (obj_ini.role[comp][i] == obj_ini.role[100][3]) then bikes--;
					}
				}
			}
		}
	}


	// var p;p=0;repeat(50){p+=1;if (ship_all[p]=1) then via[ship_ide[p]]=1;if (ship_all[p]=0) then via[ship_ide[p]]=0;}
	// var p;p=0;repeat(50){p+=1;if (ship_all[p]=1) then via[ship_ide[p]]=1;if (ship_all[p]=0) then via[ship_ide[p]]=0;}
	// var p,p2;
	// p=0;p2=0;

	/*repeat(50){if (p2=0){p+=1;if (ship_ide[p]=argument0) then p2=p;}}
	if (p2>0){if (ship_all[p2]=1) then via[p2]=1;if (ship_all[p2]=0) then via[p2]=0;}*/

	if (ship_all[argument2]=0) then via[argument0]=0;
	if (ship_all[argument2]=1) then via[argument0]=1;


}
