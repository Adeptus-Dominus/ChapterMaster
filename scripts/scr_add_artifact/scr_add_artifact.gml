function find_open_artifact_slot(){
	var i=0,last_artifact=-1;
	for (var i=0;i<array_length(obj_ini.artifact);i++){
		if (last_artifact=-1){
			if (obj_ini.artifact[i]==""){
				last_artifact=i;
				break;
			}
		}
	}
	return last_artifact;
}

function scr_add_artifact(artifact_type, artifact_tags, is_identified, artifact_location, ship_id) {

	last_artifact = find_open_artifact_slot();
	if (last_artifact==-1) then exit;
	var tags = [];
	var good=true, new_tags;
	var rand1=floor(random(100))+1;
	var rand2=floor(random(100))+1;

	var base_type="",base_type_detail="",t3="",t4="",t5="";

	if (artifact_type="random") or (artifact_type="random_nodemon"){
		if (good){
		    if (rand1<=45){base_type="Weapon";}
		    else if (rand1<=80){base_type="Armour";}
		    else if (rand1<=90){base_type="Gear";}
		    else if (rand1<=100){base_type="Device";}
		    good=false;
		}
	}
	if (base_type==""){
		if (array_contains(["Weapon","Armour","Gear","Device"],artifact_type)) then base_type=artifact_type ;
	
		    if (artifact_type="Robot"){
		    	base_type="Device";
		    	base_type_detail="Robot";
		    }
		    else if (artifact_type="Tome"){
		    	base_type="Device";
		    	base_type_detail="Tome";
		    }
		if (artifact_type="chaos_gift"){
			base_type="Device";
			base_type_detail=choose("Casket","Chalice","Statue");
		}
	}

	if (base_type="Weapon") and (base_type_detail==""){
	    if (rand2<=30){
	    	base_type_detail="Bolter";
	    	good=false;
	    }
	    else if (rand2<=40){base_type_detail="Plasma Pistol";}
	    else if (rand2<=50 ){base_type_detail="Plasma Gun";}
	    else if (rand2<=70){base_type_detail=choose("Power Sword","Power Axe","Power Spear","Lightning Claw");}
	    else if (rand2<=90 ){base_type_detail=choose("Power Fist","Power Fist","Lightning Claw");}
	    else if (rand2<=100 ){base_type_detail=choose("Relic Blade","Thunder Hammer");}
	}

	if (base_type="Armour") and (base_type_detail=""){
	    if (rand2<=70){
			var _power_armour = ARR_power_armour;
	    	base_type_detail=_power_armour[irandom(array_length(_power_armour)-1)];
	    }
	    else if (rand2<=80){base_type_detail=choose("Terminator Armour","Tartaros");}
	    else if (rand2<=90){base_type_detail="Dreadnought Armour";}
	    else if (rand2<=100){base_type_detail="Artificer Armour";}
	}

	if (base_type="Gear") and (base_type_detail=""){good=0;
	    if (rand2<=20){base_type_detail="Rosarius";}
	    else if (rand2<=45){base_type_detail="Psychic Hood";}
	    else if (rand2<=80){base_type_detail="Jump Pack";}
	    else if (rand2<=100){base_type_detail="Servo-arm";}
	}

	if (base_type="Device") and (base_type_detail=""){good=0;
	    if (rand2<=30){base_type_detail="Casket";}
	    else if (rand2<=50){base_type_detail="Chalice";}
	    else if (rand2<=70){base_type_detail="Statue";}
	    else if (rand2<=90){base_type_detail="Tome";}
	    else if (rand2<=100){base_type_detail="Robot";}
	}

	if (artifact_type="good"){
	    var haha;haha=choose(1,2,3,4);
	    if (haha=1){base_type="Weapon";base_type_detail="Relic Blade";}
	    else if (haha=2){base_type="Weapon";base_type_detail="Plasma Gun";}
	    else if (haha=3){base_type="Gear";base_type_detail="Rosarius";}
	    else if (haha=4){base_type="Armour";base_type_detail="Terminator Armour";}
	}



	rand2=floor(random(100))+1;good=0;
	if (scr_has_disadv("Shitty Luck")){rand2=min(rand2+20,100);}
	if (rand2<=70){t3="";}
	else if (rand2<=90 && artifact_type!="random_nodemon"){
		array_push(tags, "chaos");
	}
	else if (rand2<=100 && artifact_type!="random_nodemon"){
		array_push(tags, "daemonic");
	}

	if (base_type="Weapon"){
	    // gold, glowing, underslung bolter, underslung flamer
	    t5=choose("GOLD","GLOW","UBOLT","UFL");
	    // Runes, scope, adamantium, void
	    t4=choose("RUNE","SCOPE","ADAMANTINE","VOI");
	    if ((base_type_detail="Power Sword") or (base_type_detail="Power Axe") or (base_type_detail="Power Spear")) and (t4="SCOPE") then t4="CHB";// chainblade
	    if ((base_type_detail="Power Fist") or (base_type_detail="Power Claw")) and (t4="SCOPE") then t4="DUB";// doubled up
		if (base_type_detail="Thunder Hammer") and (t4="RUNE") then t4="GLOW";//glowing runed
	    if (base_type_detail="Relic Blade") and (t4="SCOPE") then t4="UFL";// underslung flamer
	    array_push(tags, t4);
	}else if (base_type="Armour"){
	    // golden filigree, glowing optics, purity seals
	    t5=choose("GOLD","GLOW","PUR");
	    array_push(tags, t5);
	    // articulated plates, spikes, runes, drake scales
	    t4=choose("ART","SPIKES","RUNE","DRA");
	    array_push(tags, t4);
	}else if (base_type="Gear"){
	    // supreme construction, adamantium, gold
	    t4=choose("SUP","ADAMANTINE","GOLD");// bur = ever burning
	    if (base_type_detail="Rosarius") then t5=choose("GOLD","GLOW","BIG","BUR");
	    if (base_type_detail="Bionics") then t5=choose("GOLD","GLOW","RUNE","SOO");// Soothing appearance
	    if (base_type_detail="Psychic Hood") then t5=choose("FIN","GOLD","BUR","MASK");// fine cloth, gold, ever burning, mask
	    if (base_type_detail="Jump Pack") then t5=choose("SPIKES","SKRE","WHI","SILENT");// spikes, screaming, white flame, silent
	    if (base_type_detail="Servo-arm" || base_type_detail="Servo-harness") then t5=choose("GOLD","TENTACLES","GOR","SOO");// gold, tentacles, gorilla build, soothing appearance
	    array_push(tags, t5);
	}else if (base_type="Device") and (base_type_detail!="Robot"){
	    t4=choose("GOLD","CRU","GLOW","ADAMANTINE");// skulls, falling angel, thin, tentacle, mindfuck
	    if (base_type_detail!="Statue") then t5=choose("SKU","FAL","THI","TENTACLES","MIN");
	    // goat, speechless, dying angel, jumping into magma, cheshire grunx
	    if (base_type_detail="Statue") then t5=choose("GOAT","SPE","DYI","JUM","CHE");
	    // Gold, glowing, preserved flesh, adamantium
	    if (base_type_detail="Tome") then t4=choose("GOLD","GLOW","PRE","ADAMANTINE","SAL","BUR");
	    if (t4="PRE") and (t3="") then t3=choose("","chaos","daemonic");
	     array_push(tags, t4);
	     array_push(tags, t3);
	     array_push(tags, t5);
	}else if (base_type="Device") and (base_type_detail="Robot"){// human/robutt/shivarah
	    t4=choose("HU","RO","SHI");
	    t5=choose("ADAMANTINE","JAD","BRO","RUNE");
	    array_push(tags, t5);
	    array_push(tags, t4);
	}

	var big=choose(1,2);
	// if (big=1 || artifact_tags="minor") then t5="";
	if (artifact_tags="minor"){
		t4="";t5="";t3="MINOR";
		 array_push(tags, t3);
	}
	if (artifact_tags="inquisition") then  array_push(tags, "inq");
	if ((artifact_tags="daemonic"||artifact_tags="daemonic")) and (base_type_detail!="Tome"){
		t3="daemonic"+choose("1a","2a","3a","4a");
		 array_push(tags, t3);
	}
	if ((artifact_tags="daemonic" || artifact_tags="daemonic")) and (base_type_detail="Tome"){
		t3="daemonic"+choose("2a","3a","4a");
		array_push(tags, t3);
	}
	if (artifact_type="chaos_gift"){
		array_push(tags, "daemonic");
		array_push(tags, "chaos_gift");
	}
	// show_message(string(t3));

	if (artifact_location == ""){
		if (obj_ini.fleet_type=ePlayerBase.home_world){
			artifact_location = obj_ini.home_name;
			ship_id = 2;
		} else {
			artifact_location = obj_ini.ship[0];
			ship_id = 501;
		}
	}
	obj_ini.artifact[last_artifact]=base_type_detail;
	obj_ini.artifact_tags[last_artifact]=tags;

	// show_message(string(obj_ini.artifact_tags[last_artifact]));

	obj_ini.artifact_identified[last_artifact] = is_identified;
	obj_ini.artifact_condition[last_artifact] = 100;
	obj_ini.artifact_loc[last_artifact] = artifact_location;
	obj_ini.artifact_sid[last_artifact] = ship_id;
	obj_ini.artifact_quality[last_artifact] = "artifact";
	obj_ini.artifact_equipped[last_artifact]=  false;
	obj_ini.artifact_struct[last_artifact] = new ArtifactStruct(last_artifact);

	obj_controller.artifacts+=1;

	scr_recent("artifact_acquired",string(obj_ini.artifact_tags[last_artifact]),last_artifact);

	return last_artifact;

}

function artifact_has_tag(index, wanted_tag){
	return array_contains(obj_ini.artifact_tags[index], wanted_tag);
}
//TODO make a proper artifact struct
function ArtifactStruct(Index) constructor{
	index = Index
	static type = function(){
		return obj_ini.artifact[index];
	}
	static condition = function(){
		return obj_ini.artifact_condition[index];
	}
	static loc = function(){
		return obj_ini.artifact_loc[index];
	}

	//combination of what is normally lid and wid
	static sid = function(){
		return obj_ini.artifact_sid[index];
	}

	static can_equip = function(){
		_can_equip = true;
		var none_equips = ["Statue", "Casket",  "Chalice", "Robot"]
		if (array_contains(none_equips, type())){
			_can_equip = false;
		}
		return _can_equip;
	}

	static ship_id =  function (){
		return obj_ini.artifact_sid[index]-500;
	}

	static set_ship_id = function(ship_id){
		obj_ini.artifact_sid[index] = ship_id+500;
	}
	static location_string = function(){
		if (sid()>=500){
			return obj_ini.ship[ship_id()];
		} else {
			return $"{loc()} {sid()}";
		}
	}

	static is_identifiable = function(){
		var identifiable = false;
        if (loc() == obj_ini.home_name) then identifiable = 1;
        if (sid() >= 500) {
            if (obj_ini.ship_location[ship_id()] = obj_ini.home_name) then identifiable = 1;
            if (obj_ini.ship_class[ship_id()]=="Battle Barge") then identifiable = 1;
        }
        return identifiable;		
	}
	static quality = function(){
		return obj_ini.artifact_quality[index];
	}
	static tags = function(){
		return obj_ini.artifact_tags[index];
	}
	static equipped = function(){
		return obj_ini.artifact_equipped[index];
	}

	static identified = function(){
		return obj_ini.artifact_identified[index];
	}

	static has_tag = function(wanted_tag){
		return array_contains(tags(), wanted_tag);
	}
	static has_tags = function(wanted_tags){
		var wanted_tag;
		for (var i=0;i<array_length(wanted_tags);i++){
			wanted_tag = wanted_tags[i];
			if (array_contains(tags(), wanted_tag)){
				return true;
			}
		}
		return false;
	}	

	static inquisition_disprove = function(){
		var inquis_tags = ["daemonic","chaos_gift", "chaos"];
		if (has_tag("inq")){
			return false;
		} else {
			return has_tags(inquis_tags);
		}

	}

	static destroy_arti = function(){
        if (has_tag("daemonic")){
            if (ship_id()){
                var demonSummonChance=irandom(100)+1;

                if (demonSummonChance<=60) and (obj_ini.ship_carrying[ship_id]>0){
                    instance_create(0,0,obj_ncombat);
                    obj_ncombat.battle_special="ship_demon";
                    obj_ncombat.formation_set=1;
                    obj_ncombat.enemy=10;
                    obj_ncombat.battle_id=obj_ini.artifact_sid[i]-500;
                    scr_ship_battle(obj_ini.artifact_sid[i]-500,999);
                }
            }
        }
	}

	static load_json_data = function(data){
		 var names = variable_struct_get_names(data);
		 for (var i = 0; i < array_length(names); i++) {
            variable_struct_set(self, names[i], variable_struct_get(data, names[i]))
        }
	}

	static determine_base_type = function(){
		var item_type = "device";
	    if struct_exists(global.gear[$ "armour"],type()){
            item_type = "armour";
        }
        else if struct_exists(global.gear[$ "mobility"],type()){
            item_type = "mobility";
        }
        else if struct_exists(global.gear[$ "gear"],type()){
            item_type = "gear";
        }
        else if struct_exists(global.weapons,type()){
            item_type = "weapon";
        }
		else if (type()=="Casket") { item_type="device";}
		else if (type()=="Chalice") { item_type="device";}
		else if (type()=="Statue") { item_type="device";}
		else if (type()=="Tome") { item_type="device";}
		else if (type()=="Robot") { item_type="device";}      
        return (item_type);
	};

	static unequip_from_unit = function(){
		try{
		if (equipped() && is_array(bearer)){
			var _b_type = determine_base_type();
			var unit = fetch_unit(bearer);
			if (_b_type=="weapon"){
				if (unit.weapon_one(true) == index){
					unit.update_weapon_one("", false, false);
				} else if (unit.weapon_two(true) == index){
					unit.update_weapon_two("", false, false);
				} 
			} else if (_b_type=="gear"){
				unit.update_gear("", false, false);
			} else if (_b_type=="armour"){
				unit.update_armour("", false, false);
			} else if (_b_type=="mobility"){
				unit.update_mobility_item("", false, false);
			}
			bearer = false;
			obj_ini.artifact_equipped[index] = false;
		} else if (equipped()){
			var _b_type = determine_base_type();
			var _bearer = false;
			var _bearer_found = false;
			var _unit;
			if (_b_type=="weapon"){
				for (var co=0;co<obj_ini.companies;co++){
					for (var i=0;i<array_length(obj_ini.role[co]);i++){
						_unit = fetch_unit([co,i]);
						if (_unit.weapon_one(true) == index){
							_unit.update_weapon_one("", false, false);
							_bearer_found = true
						} else if (_unit.weapon_two(true) == index){
							_unit.update_weapon_two("", false, false);
							_bearer_found = true
						}
						if (_bearer_found){
							break;
						}
					}
					if (_bearer_found){
						break;
					}					
				}
			} else {
				var _find_function = "";
				if (_b_type=="gear"){
					var _update_function = "update_gear";
					_find_function = "gear";
				} else if (_b_type=="armour"){
					var _update_function = "update_armour";
					_find_function = "armour";
				} else if (_b_type=="mobility"){
					var _update_function = "update_mobility_item";
					_find_function = "mobility_item";
				}
				if (_find_function!=""){
					for (var co=0;co<obj_ini.companies;co++){
						for (var i=0;i<array_length(obj_ini.role[co]);i++){
							var _unit = fetch_unit([co,i]);
							if (_unit[$_find_function](true) == index){
								_unit[$_update_function]("", false, false);
								_bearer_found = true
							}
							if (_bearer_found){
								break;
							}						
						}
						if (_bearer_found){
							break;
						}					
					}
				}								
			}
		}
		}catch(_exception){
        	handle_exception(_exception);
   		}
		bearer = false;
		obj_ini.artifact_equipped[index] = false;
	}
	custom_data = {};
	name = "";
	custom_description="";
	bearer=false;

	static description = scr_arti_descr;
}


function corrupt_artifact_collectors(last_artifact){
	try{
		var arti = obj_ini.artifact_struct[last_artifact];
		if (arti.inquisition_disprove()){
		    for (var i=0;i<array_length(obj_controller.display_unit);i++){
		        if (obj_controller.man_sel[i]=1){
		            if (obj_controller.man[i]="man"){
		            	if (is_struct(obj_controller.display_unit[i])) then obj_controller.display_unit[i].edit_corruption(choose(0,2,4,6,8));
		            }
		            else if (obj_controller.man[i]="vehicle" && is_array(obj_controller.display_unit[i])){
		                obj_ini.veh_chaos[obj_controller.display_unit[i][0]][obj_controller.display_unit[i][1]]+=choose(0,2,4,6,8);
		            }
		        }
		    }
		}
	}
	catch( _exception){
        handle_exception(_exception);
	}
}

function delete_artifact(index){
	if ((index<array_length(obj_ini.artifact))){
		with (obj_ini){
			artifact_struct[index].unequip_from_unit();
	        artifact[index]="";
	        artifact_tags[index]=[];
	        artifact_identified[index]=0;
	        artifact_condition[index]=0;
	        artifact_loc[index]="";
	        artifact_sid[index]=0;
	        artifact_equipped[index] = false;
	        artifact_struct[index]=new ArtifactStruct(index);
		}
		obj_controller.artifacts-=1;
		with (obj_controller) {
            set_chapter_arti_data();
        }
	}
}
