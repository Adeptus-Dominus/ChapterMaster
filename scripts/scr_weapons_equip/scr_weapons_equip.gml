function scr_weapons_equip() {

	// gets the weapons for the particular slot
	// dude=6 is dreadnought I think

	var tc,tb,dude;
	tc=0;tb=0;dude=0;

	var i=-1;
	repeat(50){i+=1;item_name[i]="";}

	if (instance_exists(obj_controller)) and (instance_exists(obj_popup)) and (!instance_exists(obj_mass_equip)){
	    tc=target_comp;
	    tb=tab;
	    dude=obj_popup.vehicle_equipment; // This is for equipping the selected marines in management

	}
	if (instance_exists(obj_creation)){
	    tc=target_gear;tb=tab;
	    dude=obj_creation_popup.type-100;
	}
	if (instance_exists(obj_mass_equip)){
	    // tc=tab;tb=1;
	    tb=tab;tc=tab;
	    dude=obj_controller.settings;
	}
	var standard_equip = (instance_exists(obj_controller)) and (!instance_exists(obj_mass_equip)) and (instance_exists(obj_popup));

	if (dude<50) and (dude!=6) then dude=1

// dude=1 for normal infantry gear
// dude=6 for dread
// dude=50 for Land Raider
// dude=51 for Rhino
// dude=52 for Predator
// dude=53 for Land Speeder
// dude=54 for Whirlwind
	var equip_data;
	if (tc<3) and (dude=1){
		if(tb=1){
			if (standard_equip){ // Infantry Ranged
				item_name[1]="(None)";
				item_name[2]="(any)";
				var valid=3;
				for (i=0;i<array_length(obj_ini.equipment);i++){
					if (obj_popup.master_crafted==1){
						if (!array_contains(obj_ini.equipment_quality[i],"master_crafted")){
							continue;
						}
					}				
					equip_data = gear_weapon_data("weapon", obj_ini.equipment[i]);
					if (is_struct(equip_data) && obj_ini.equipment_number[i]>0){
						if (equip_data.range>1.1 && !equip_data.has_tag("vehicle")){
							item_name[valid]=equip_data.name;
							valid++;
						}
					}
				}
			} else {
				i=0
			    i+=1;item_name[i]="(None)";
			    i+=1;item_name[i]="Archeotech Laspistol";
		      i+=1;item_name[i]="Assault Cannon";
			   	i+=1;item_name[i]="Bolt Pistol";
			    i+=1;item_name[i]="Bolter";
				i+=1;item_name[i]="Stalker Pattern Bolter";
			  	i+=1;item_name[i]="Combiflamer";
			    i+=1;item_name[i]="Flamer";
					i+=1;item_name[i]="Heavy Bolter";
			    i+=1;item_name[i]="Heavy Flamer";
					i+=1;item_name[i]="Hellrifle";
			    i+=1;item_name[i]="Incinerator";
			    i+=1;item_name[i]="Integrated Bolter";
					i+=1;item_name[i]="Lascannon";
			    i+=1;item_name[i]="Lascutter";
			    i+=1;item_name[i]="Meltagun";
			    i+=1;item_name[i]="Missile Launcher";
			    i+=1;item_name[i]="Multi-Melta";
					i+=1;item_name[i]="Autocannon";
					i+=1;item_name[i]="Plasma Gun";
					i+=1;item_name[i]="Plasma Pistol";
					i+=1;item_name[i]="Sniper Rifle";
					i+=1;item_name[i]="Storm Bolter";
					i+=1;item_name[i]="Webber";				
			}
		}else if (tb=2){
			if (standard_equip){
				item_name[1]="(None)";
				item_name[2]="(any)";
				var valid=3;				
				for (i=0;i<array_length(obj_ini.equipment);i++){
					if (obj_popup.master_crafted==1){
						if (!array_contains(obj_ini.equipment_quality[i],"master_crafted")){
							continue;
						}
					}				
					equip_data = gear_weapon_data("weapon", obj_ini.equipment[i]);
					if (is_struct(equip_data) && obj_ini.equipment_number[i]>0){
						if (equip_data.range<=1.1  && !equip_data.has_tag("vehicle")){
							item_name[valid]=equip_data.name;
							valid++;
						}
					}
				}
				if (instance_exists(obj_mass_equip)){
					item_name[valid]="Company Standard";
					valid++;
				}		
			} else {
				i=0;
				i+=1;item_name[i]="Combat Knife";
				i+=1;item_name[i]="Chainsword";
				i+=1;item_name[i]="Chainaxe";
				i+=1;item_name[i]="Eviscerator";
				i+=1;item_name[i]="Power Sword";
				i+=1;item_name[i]="Power Axe";
				i+=1;item_name[i]="Power Fist";
				i+=1;item_name[i]="Chainfist";
				i+=1;item_name[i]="Lightning Claw";
				i+=1;item_name[i]="Force Staff";
				i+=1;item_name[i]="Thunder Hammer";
				i+=1;item_name[i]="Boarding Shield";
				i+=1;item_name[i]="Storm Shield";
				i+=1;item_name[i]="Bolt Pistol";
				i+=1;item_name[i]="Bolter";				
			}
		}
	}

	if (tc<3) and (tb=1) and (dude=6){
		var i=0; // Dreadnought Ranged
			item_name[1]="(None)";
			item_name[2]="(any)";
			var valid=3;
			if (standard_equip){
				for (i=0;i<array_length(obj_ini.equipment);i++){
					if (obj_popup.master_crafted==1){
						if (!array_contains(obj_ini.equipment_quality[i],"master_crafted")){
							continue;
						}
					}
					equip_data = gear_weapon_data("weapon", obj_ini.equipment[i]);
					if (is_struct(equip_data) && obj_ini.equipment_number[i]>0){
						if (equip_data.has_tag("dreadnought") && equip_data.range>1.1){
							item_name[valid]=equip_data.name;
							valid++;
						}
					}
				}
			} else {
				i+=1;
				item_name[i]="Multi-Melta";
				i+=1;
				item_name[i]="Twin Linked Heavy Flamer Sponsons";
				i+=1;
				item_name[i]="Plasma Cannon";
				i+=1;
				item_name[i]="Assault Cannon";
				i+=1;
				item_name[i]="Autocannon";	
				i+=1;
				item_name[i]="Missile Launcher";
				i+=1;
				item_name[i]="Twin Linked Lascannon";
				i+=1;
				item_name[i]="Twin Linked Assault Cannon Mount";
				i+=1;
				item_name[i]="Twin Linked Heavy Bolter";	
				i+=1;
				item_name[i]="Heavy Conversion Beam Projector";
			}
	}

	if (tc<3) and (tb=2) and (dude=6){
		var i=0; // Dreadnought Melee
		if (standard_equip){
			item_name[1]="(None)";
			item_name[2]="(any)";
			var valid=3;		
			for (i=0;i<array_length(obj_ini.equipment);i++){
				if (obj_popup.master_crafted==1){
					if (!array_contains(obj_ini.equipment_quality[i],"master_crafted")){
						continue;
					}
				}				
				equip_data = gear_weapon_data("weapon", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i]>0){
					if (equip_data.has_tag("dreadnought") && equip_data.range<=1.1){
						item_name[valid]=equip_data.name;
						valid++;
					}
				}
			}
		} else {
			i+=1;
			item_name[i]="Close Combat Weapon";
			i+=1;
			item_name[i]="Dreadnought Power Claw";
			i+=1;
			item_name[i]="Dreadnought Lightning Claw";
		}
	}

	if (tc=1) and (tb=1) and (dude=50){var i;i=0; // Land Raider Regular Front Weapon
	    i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Twin Linked Heavy Bolter Mount";
			i+=1;item_name[i]="Twin Linked Lascannon Mount";
			i+=1;item_name[i]="Twin Linked Assault Cannon Mount";
			i+=1;item_name[i]="Whirlwind Missiles";
	}

	if (tc=1) and (tb=2) and (dude=50){
			i=0; // Land Raider Relic Front Weapon
			i+=1;item_name[i]="(None)";
			//i+=1;item_name[i]="Thunderfire Cannon Mount";
			i+=1;item_name[i]="Neutron Blaster Turret";
			i+=1;item_name[i]="Reaper Autocannon Mount";
			//i+=1;item_name[i]="Twin Linked Helfrost Cannon Mount";
			//i+=1;item_name[i]="Graviton Cannon Mount";
	}

	if (tc=2) and (tb=1) and (dude=50){var i;i=0; // Land Raider Regular Sponsons
			i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Twin Linked Lascannon Sponsons";
			i+=1;item_name[i]="Hurricane Bolter Sponsons";
			i+=1;item_name[i]="Flamestorm Cannon Sponsons";
	}

	if (tc=2) and (tb=2) and (dude=50){var i;i=0; // Land Raider Relic Sponsons
			i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Quad Linked Heavy Bolter Sponsons";
			i+=1;item_name[i]="Twin Linked Heavy Flamer Sponsons";
			i+=1;item_name[i]="Twin Linked Multi-Melta Sponsons";
			i+=1;item_name[i]="Twin Linked Volkite Culverin Sponsons";
	}

	if (tc=3) and (tb=1) and (dude=50){var i;i=0; // Land Raider Pintle
			i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Bolter";
			i+=1;item_name[i]="Combiflamer";
			i+=1;item_name[i]="Twin Linked Bolters";
			i+=1;item_name[i]="Storm Bolter";
			i+=1;item_name[i]="HK Missile";
	}

	if (tc<3) and (tb=1) and (dude=51){var i;i=0; // Rhino Weapons
	    i+=1;item_name[i]="(None)";
		  i+=1;item_name[i]="Bolter";
			i+=1;item_name[i]="Combiflamer";
			i+=1;item_name[i]="Twin Linked Bolters";
			i+=1;item_name[i]="Storm Bolter";
			i+=1;item_name[i]="HK Missile";
	}

	if (tc=1) and (tb=1) and (dude=52){var i;i=0; // Predator Turret
			i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Autocannon Turret";
			i+=1;item_name[i]="Twin Linked Lascannon Turret";
			i+=1;item_name[i]="Flamestorm Cannon Turret";
			i+=1;item_name[i]="Twin Linked Assault Cannon Turret";
			i+=1;item_name[i]="Magna-Melta Turret";
			i+=1;item_name[i]="Plasma Destroyer Turret";
			i+=1;item_name[i]="Heavy Conversion Beam Projector";
			i+=1;item_name[i]="Neutron Blaster Turret";
			i+=1;item_name[i]="Volkite Saker Turret";
			//i+=1;item_name[i]="Graviton Cannon Turret";
	}
	if (tc=2) and (tb=1) and (dude=52){var i;i=0; // Predator Sponsons
			i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Heavy Bolter Sponsons";
			i+=1;item_name[i]="Lascannon Sponsons";
			i+=1;item_name[i]="Heavy Flamer Sponsons";
			i+=1;item_name[i]="Volkite Culverin Sponsons";
	}
	if (tc=3) and (tb=1) and (dude=52){var i;i=0; // Predator Pintle
			i+=1;item_name[i]="(None)";
			i+=1;item_name[i]="Bolter";
			i+=1;item_name[i]="Combiflamer";
			i+=1;item_name[i]="Twin Linked Bolters";
			i+=1;item_name[i]="Storm Bolter";
			i+=1;item_name[i]="HK Missile";
	}
	if (tc=1) and (tb=1) and (dude=53){var i;i=0; // Land Speeder Primary
			i+=1;item_name[i]="(None)";
	    i+=1;item_name[i]="Multi-Melta";
			i+=1;item_name[i]="Heavy Bolter";
	}

	if (tc=2) and (tb=1) and (dude=53){var i;i=0; // Land Speeder Secondary
			i+=1;item_name[i]="(None)";
	    i+=1;item_name[i]="Assault Cannon";
			i+=1;item_name[i]="Heavy Flamer";
	}

	if (tc=1) and (tb=1) and (dude=54){var i;i=0; // Whirlwind Missiles
			i+=1;item_name[i]="(None)";
	    i+=1;item_name[i]="Whirlwind Missiles";
	}

	if (tc=2) and (tb=1) and (dude=54){var i;i=0; // Whirlwind Pintle
		i+=1;item_name[i]="(None)";
		i+=1;item_name[i]="Bolter";
		i+=1;item_name[i]="Combiflamer";
		i+=1;item_name[i]="Twin Linked Bolters";
		i+=1;item_name[i]="Storm Bolter";
		i+=1;item_name[i]="HK Missile";
	}

	if (tc=4) and (tb=1) and ((dude=50) or (dude=51) or (dude=52) or (dude=54)){var i=0; // Tank Upgrade
			i+=1;item_name[i]="(None)";
	    i+=1;item_name[i]="Armoured Ceramite";
	    i+=1;item_name[i]="Artificer Hull";
	    i+=1;item_name[i]="Heavy Armour";
			if dude=50{i+=1;item_name[i]="Void Shield";} //only for Land Raiders
	}
	if (tc=5) and (tb=1) and ((dude=50) or (dude=51) or (dude=52) or (dude=54) or (dude=6)){var i;i=0; // Tank Accessory
			i+=1;item_name[i]="(None)";
	    if dude!=6 {i+=1;item_name[i]="Dozer Blades"};
	    i+=1;item_name[i]="Searchlight";
	    i+=1;item_name[i]="Smoke Launchers";
		i+=1;item_name[i]="Frag Assault Launchers";
		if dude!=50 and dude!=6{i+=1;item_name[i]="Lucifer Pattern Engine"}; //not available for Land Raiders
	}

	if (tc=3) and (dude=1){ // dude=1 for normal infantry gear
	    var i=0;

	    if (!instance_exists(obj_creation)) and (!instance_exists(obj_mass_equip)){
			item_name[1]="(None)";
			item_name[2]="(any)";
			var valid=3;		
			for (i=0;i<array_length(obj_ini.equipment);i++){
				equip_data = gear_weapon_data("armour", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i]>0){
					item_name[valid]=equip_data.name;
					valid++;
				}
			}
	    }else if (instance_exists(obj_creation)) or (instance_exists(obj_mass_equip)){
	    	var i=0
	        var bub=0;
	        if (instance_exists(obj_creation)){if (type=112) then bub=1;}
	        if (instance_exists(obj_mass_equip)){if (obj_controller.settings=12) then bub=1;}
	        i+=1;item_name[i]="(None)";
	        i+=1;item_name[i]="Scout Armour";
	        i+=1;item_name[i]="Power Armour";
	        i+=1;item_name[i]="MK3 Iron Armour";
	        i+=1;item_name[i]="MK4 Maximus";
	        i+=1;item_name[i]="MK5 Heresy";
	        i+=1;item_name[i]="MK6 Corvus";
	        i+=1;item_name[i]="MK7 Aquila";
	        i+=1;item_name[i]="MK8 Errant";
	        i+=1;item_name[i]="Artificer Armour";
	        i+=1;item_name[i]="Terminator Armour";
	        i+=1;item_name[i]="Tartaros";
	    }

	    else i+=1;

	    // var bad;bad=0;if (instance_exists(obj_creation_popup)){if ((obj_creation_popup.type-100)!=6) then bad=1;}
	    // if (bad=0){item_name[i]="Dreadnought";}
	}
	if (tc=4) and (dude=1){ // dude=1 for normal infantry gear
		if (!instance_exists(obj_creation)) and (!instance_exists(obj_mass_equip)){
			item_name[1]="(None)";
			item_name[2]="(any)";
			var valid=3;		
			for (i=0;i<array_length(obj_ini.equipment);i++){
				equip_data=gear_weapon_data("gear", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i]>0  && !equip_data.has_tag("vehicle")){
					item_name[valid]=equip_data.name;
					valid++;
				}
			}
		} else {
		    var i=0;
		    i+=1;item_name[i]="(None)";
		    // i+=1;item_name[i]="Bionics";
		    i+=1;item_name[i]="Iron Halo";
		    i+=1;item_name[i]="Narthecium";
		    i+=1;item_name[i]="Psychic Hood";
		    i+=1;item_name[i]="Rosarius";

		}	
	}
	if (tc=5) and (dude=1){ // dude=1 for normal infantry gear
		if (!instance_exists(obj_creation)) and (!instance_exists(obj_mass_equip)){		
			item_name[1]="(None)";
			item_name[2]="(any)";
			var valid=3;		
			for (i=0;i<array_length(obj_ini.equipment);i++){
				equip_data=gear_weapon_data("mobility", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i]>0  && !equip_data.has_tag("vehicle")){
					item_name[valid]=equip_data.name;
					valid++;
				}
			}
		} else {
	    var i;i=0;
		    i+=1;item_name[i]="(None)";
		    i+=1;item_name[i]="Bike";
		    i+=1;item_name[i]="Jump Pack";	
			i+=1;item_name[i]="Servo-arm";	
			i+=1;item_name[i]="Servo-harness";
	    }	
	}


}
