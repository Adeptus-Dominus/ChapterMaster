

function add_event(event_data){
	var _inserted = false;
	for (var i=0;i<array_length(obj_controller.event);i++){
		var _event = obj_controller.event[i];
		if (_event.duration >= event_data.duration){
			array_insert(obj_controller.event, i, event_data);
			_inserted = true;
		}
	}
	if (!_inserted){
		array_push(obj_controller.event, event_data);
	}
}

function find_event(e_id){
	var _event_found = -1;
	for (var i=0;i<array_length(obj_controller.event);i++){
		var _event = obj_controller.event[i];
		if (_event.e_id == e_id){
			_event_found = i;
			break;
		}
	}
	return _event_found;
}

function event_end_turn_action(){
	var _event_length = array_length(event);
	for (var i=_event_length-1; i >= 0; i--){
	    var _event = event[i];
	    if (_event.e_id=="" || _event.duration<0){
	        array_delete(event, i, 1);
	        continue;
	    }

	    _event.duration-=1;

	    if (_event.duration==0){
	        if (_event.e_id=="game_over_man"){
	            obj_controller.alarm[8]=1;
	        }
	        // Removes planetary governor installed by the chapter
	        if (_event.e_id == "remove_surf">0){

	            var _star_name = _event.system;
	            var _event_star = star_by_name(_event.system);
	            var _planet = _event.planet;
	            if (_event_star!="none"){
	                _event_star.dispo[_planet]=-10;// Resets
	                var twix=$"Inquisition executes Chapter Serf in control of {pllanet_numera_name(planet, _event_star)} and installs a new Planetary Governor.";
	                if (_event_star.p_owner[_planet]=eFACTION.Player){
	                    _event_star.p_owner[_planet]=_event_star.p_first[_planet];
	                }
	                scr_alert("","",twix,0,0);
	                scr_event_log("",twix, _star_name);
	            }
	        }
	        // Changes relation to good
	        if (_event.e_id=="enemy_imperium"){
	            scr_alert("green","enemy","You have made amends with your enemy in the Imperium.",0,0);
	            disposition[eFACTION.Imperium]+=20;
	            scr_event_log("","Amends made with Imperium.");
	        }
	        if (_event.e_id=="enemy_mechanicus"){
	            scr_alert("green","enemy","You have made amends with your Mechanicus enemy.",0,0);
	            disposition[eFACTION.Mechanicus]+=20;
	            scr_event_log("","Amends made with Mechanicus enemy.");
	        }
	        if (_event.e_id=="enemy_inquisition"){
	            scr_alert("green","enemy","You have made amends with your enemy in the Inquisition.",0,0);
	            disposition[eFACTION.Inquisition]+=20;
	            scr_event_log("","Amends made with Inquisition enemy.");
	        }
	        if (_event.e_id=="enemy_ecclesiarchy"){
	            scr_alert("green","enemy","You have made amends with your enemy in the Ecclesiarchy.",0,0);
	            disposition[eFACTION.Ecclesiarchy]+=20;
	            scr_event_log("","Amends made with Ecclesiarchy enemy.");
	        }
	        // Sector commander losses its mind
	        if (_event.e_id=="imperium_daemon"){
	            var alert_string = $"Sector Commander {faction_leader[eFACTION.Imperium]} has gone insane."
	            scr_alert("red","lol",alert_string,0,0);
	            faction_defeated[eFACTION.Imperium]=1;
	            scr_event_log("red",alert_string);
	        }
	        // Starts chaos invasion
		    if (_event.e_id=="chaos_invasion"){ 
				var xx=0,yy=0,flee=0,dirr=0;
	            var star_id = scr_random_find(1,true,"","");
				if(star_id != undefined){
	                scr_event_log("purple",$"Chaos Fleets exit the warp near the {star_id.name} system.", star_id.name);
	                for(var j=0; j<4; j++){
	                    dirr+=irandom_range(50,100);
	                    xx=star_id.x+lengthdir_x(72,dirr);
						yy=star_id.y+lengthdir_y(72,dirr);
	                    flee=instance_create(xx,yy,obj_en_fleet);
						flee.owner=eFACTION.Chaos;
	                    flee.sprite_index=spr_fleet_chaos;
						flee.image_index=4;
	                    flee.capital_number=choose(0,1);
						flee.frigate_number=choose(2,3);
						flee.escort_number=choose(4,5,6);
	                    flee.cargo_data.csm = true;
						obj_controller.chaos_fleets+=1;
	                    flee.action_x=star_id.x;
						flee.action_y=star_id.y;
	                    with(flee){
	                        set_fleet_movement();
	                    }
	                }	
				}
	        }
	        // Ships construction
	        if (_event.e_id == "ship_construction"){
	            var new_ship_event=_event.ship_class;
	            var active_forges = [];
	            var chosen_star = false;
	            with(obj_star){
	                if (owner==eFACTION.Mechanicus){
	                    for (f=1;f<=planets;f++){
	                        if (p_type[f]=="Forge") and (p_owner[f]==eFACTION.Mechanicus){
	                            array_push(active_forges,new PlanetData(f, self));
	                        }
	                    }
	                }
	            }
	            if (array_length(active_forges)>0){
	                var ship_spawn = active_forges[irandom(array_length(active_forges)-1)];
	                var _new_player_fleet=instance_create(ship_spawn.system.x,ship_spawn.system.y,obj_p_fleet);

	                // Creates the ship
	                var last_ship = new_player_ship(new_ship_event, ship_spawn.system.name);

	                add_ship_to_fleet(last_ship, _new_player_fleet)

	                // show_message(string(obj_ini.ship_class[last_ship])+":"+string(obj_ini.ship[last_ship]));

	                if (obj_ini.ship_size[last_ship]!=1) then scr_popup("Ship Constructed",$"Your new {obj_ini.ship_class[last_ship]} '{obj_ini.ship[last_ship]}' has finished being constructed.  It is orbiting {ship_spawn.system.name} and awaits its maiden voyage.","shipyard","");
	                if (obj_ini.ship_size[last_ship]==1) then scr_popup("Ship Constructed",$"Your new {obj_ini.ship_class[last_ship]} Escort '{obj_ini.ship[last_ship]}' has finished being constructed.  It is orbiting {ship_spawn.system.name} and awaits its maiden voyage.","shipyard","");
	                var bob=instance_create(ship_spawn.system.x+16,ship_spawn.system.y-24,obj_star_event);
	                bob.image_alpha=1;
	                bob.image_speed=1;
	            }
	            if (array_length(active_forges)==0){
	                _event.duration=2;
	                scr_popup("Ship Construction halted",$"A lack of suitable forge worlds in the system has halted construction of your requested ship","shipyard","");
	            }
	        }
	        // Spare the inquisitor
	        if (_event.e_id == "inquisitor_spared"){
	            var diceh=roll_dice_chapter(1, 100, "high");

	            if (diceh<=25){
	                alarm[8]=1;
	                scr_loyalty("Crossing the Inquisition","+");
	            }
	            if (diceh>25) and (diceh<=50){
	                scr_loyalty("Crossing the Inquisition","+");
	            }
	            if (diceh>50) and (diceh<=85){

	            }
	            if (diceh>85) and (_event.variation==2){
	                scr_popup("Anonymous Message","You recieve an anonymous letter of thanks.  It mentions that motions are underway to destroy any local forces of Chaos.","","");
	                with(obj_star){
	                    for(var o=1; o<=planets; o++){
	                        p_heresy[o]=max(0,p_heresy[o]-10);
	                    }
	                }
	            }
	        }

	        if (string_count("strange_building",_event.e_id)>0){
	            var b_event="",marine_name="",comp=0,marine_num=0,item="",unit;
	            explode_script(_event.e_id,"|");
	            b_event=string(explode[0]);
	            marine_name=string(explode[1]);
	            comp=real(explode[2]);
	            marine_num=real(explode[3]);
	            unit=obj_ini.TTRPG[comp][marine_num];
	            item=string(explode[4]);

	            var killy=0,tixt=string(obj_ini.role[100][16])+" "+string(marine_name)+" has finished his work- ";

	            if (item=="Icon"){
	                tixt+="it is a "+string(global.chapter_name)+" Icon wrought in metal, finely decorated.  Pride for his chapter seems to have overtaken him.  There are no corrections to be made and the item is placed where many may view it.";
	            }
	            if (item=="Statue"){
	                tixt+="it is a small, finely crafted statue wrought in metal.  The "+string(obj_ini.role[100][16])+" is scolded for the waste of material, but none daresay the quality of the piece.";
	            }
	            if (item=="Bike"){
	                scr_add_item("Bike",1);
	                tixt+="it is a finely crafted Bike, conforming mostly to STC standards.  The other "+string(obj_ini.role[100][16])+" are surprised at the rapid pace of his work.";
	            }
	            if (item=="Rhino"){
	                scr_add_vehicle("Rhino",0,"Storm Bolter","Storm Bolter","","Artificer Hull","Dozer Blades");
	                tixt+="it is a finely crafted Rhino, conforming to STC standards.  The other "+string(obj_ini.role[100][16])+" are surprised at the rapid pace of his work.";
	            }
	            if (item=="Artifact"){
	                var last_artifact=0;
	                scr_event_log("",string(obj_ini.role[100][16])+" "+string(marine_name)+" constructs an Artifact.");
	                scr_add_artifact("random_nodemon","",0);

	                tixt+=$"some form of divine inspiration has seemed to have taken hold of him.  An artifact {obj_ini.artifact[last_artifact]} has been crafted.";
	            }
	            if (item=="baby"){
	                unit.edit_corruption(choose(8,12,16,20))
	                tixt+="some form of horrendous statue.  A weird amalgram of limbs and tentacles, the sheer atrocity of it is made worse by the tiny, baby-like form, the once natural shape of a human child twisted nearly beyond recognition.";
	            }
	            else if (item=="robot"){
	                unit.edit_corruption(choose(2,4,6,8,10));
	                tixt+=$"some form of small, box-like robot.  It seems to teeter around haphazardly, nearly falling over with each step. {unit.name()} maintains that it has no AI, though the other "+string(obj_ini.role[100][16])+" express skepticism.";
	                unit.add_trait("tech_heretic");
	            }
	            else if (item=="demon"){
	                unit.edit_corruption(choose(8,12,16,20));
	                tixt+="some form of horrendous statue.  What was meant to be some sort of angel, or primarch, instead has a mishappen face that is hardly human in nature.  Between the fetid, ragged feathers and empty sockets it is truly blasphemous.";
	                unit.add_trait("tech_heretic");
	            }
	            else if (item=="fusion"){
	                //TODO if tech heretic chosen don't kill the dude
	                // unit.corruption+=choose(70);
	                tixt+=$"some kind of ill-mannered ascension.  One of your battle-brothers enters the armamentarium to find {marine_name} fused to a vehicle, his flesh twisted and submerged into the frame.  Mechendrites and weapons fire upon the marine without warning, a windy scream eminating from the abomination.  It takes several battle-brothers to take out what was once a "+string(obj_ini.role[100][16])+".";

	                // This is causing the problem

	                scr_kill_unit(comp,marine_num)
	                with(obj_ini){scr_company_order(0);}
	            }
	            scr_popup("He Built It",tixt,"tech_build","target_marine|"+string(marine_name)+"|"+string(comp)+"|"+string(marine_num)+"|");
	        }
	        if (_event.duration<=0){
	            array_delete(event, i ,1);
	            continue;
	        }
	    }

	}	
}

function handle_discovered_governor_assasinations(){
	for (var i=0;i<array_length(obj_controller.event);i++){
		var _event = obj_controller.event[i];
		if (_event.duration > 1){
			break;
		}
		if (_event.e_id != "governor_assassination"){
			continue;
		}
		if (_event.duration == 1 && obj_controller.faction_status[eFACTION.Imperium]!="War"){
			var _disp_hit = _event.variant == 1 ? 2 : 4;
            with(obj_star){
                for (var o=1;o<=planets;o++){
                	if (p_owner == eFACTION.Imperium){
	                    if (dispo[o]>0) and (dispo[o]<90){
	                        dispo[o]=max(dispo[o]-_disp_hit,0);
	                    }
	                }
                }
            }
            if (_event.variant == 1){
            	alter_dispositions([
            		[eFACTION.Imperium, -7],
            		[eFACTION.Inquisition, -10],
            		[eFACTION.Ecclesiarchy, -5],
            	]);

	            if (obj_controller.disposition[4]>0 && obj_controller.disposition[2]>0){
	                _event.e_id = "assassination_angryish";
	            }            	
            } else if (_event.variant == 2){
            	alter_disposition(eFACTION.Inquisition, -3);
	            if (obj_controller.disposition[4]>0&& obj_controller.disposition[2]>0){
	            	_event.e_id = "assassination_angry";
	            }
            }

            if (obj_controller.disposition[4]<=0) or (obj_controller.disposition[2]<=0){
                obj_controller.alarm[8]=1;
            } else{
            	scr_audience(4,_event.e_id,0,"",0,0,_event);
            }
		}
	}
}
function make_faction_enemy_event(){
	log_message("RE: Enemy");
		
	var factions = [];
	if(known[eFACTION.Imperium] == 1){
		array_push(factions,2);
	}
	if(known[eFACTION.Mechanicus] == 1){
		array_push(factions,3);
	}
	if(known[eFACTION.Inquisition] == 1){
		array_push(factions,4);
	}
	if(known[eFACTION.Ecclesiarchy] == 1){
		array_push(factions,5);		
	}
	
	if(array_length(factions) == 0){
		log_error("RE: Enemy, no faction could be chosen");
		exit;
	}
	var chosen_faction = factions[irandom(array_length(factions)-1)];
	
	var text = "You have made an enemy within the ";
	var log = "An enemy has been made within the ";
	var _e_name = "";
	switch(chosen_faction) {
		case 2:
			_e_name="enemy_imperium";
			text += "Imperium";
			log += "Imperium";
			break;
		case 3:
			_e_name="enemy_mechanicus";
			text += "Mechanicus";
			log += "Mechanicus";
			break;
		case 4:
			_e_name="enemy_inquisition";
			text += "Inquisition";
			log += "Inquisition";
			break;
		case 5:
			_e_name="enemy_ecclesiarchy";
			text += "Ecclesiarchy";
			log += "Ecclesiarchy";
			break;
		default:
			log_error("RE: Enemy, no faction could be chosen");
			exit;
	}
	if (_e_name != ""){
		add_event({
			duration : irandom_range(12,96),
			e_id : _e_name,
		})
	    alter_disposition(chosen_faction, -20)
	    text +="; relations with them will be soured for the forseable future.";
	    scr_popup("Diplomatic Incident",text,"angry","");
		evented = true;
	    scr_event_log("red",string(log));
	    return true;
	}
	return false;
}