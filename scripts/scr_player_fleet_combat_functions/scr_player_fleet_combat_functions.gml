// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_fleet_ships_to_combat(fleet, combat){
	var capital_count = array_length(fleet.capital);
	var _ship_id;
	var _ships = fleet_full_ship_array(fleet);
	var _ship_array_length = array_length(_ships);
	show_debug_message($"{_ships}")
	for (var i=0;i<_ship_array_length;i++){
		try{
			if (i>=array_length(_ships)) then break;
			_ship_id = _ships[i];
			var _ship_d = obj_ini.ship_data[i];
			if (_ship_d.hp<=0){
				continue;
			}
	        if (_ship_d.size>=3) then combat.capital++;
	        if (_ship_d.size==2) then combat.frigate++;
	        if (_ship_d.size==1) then combat.escort++;

	        array_push(combat.ship_data , _ship_d);
	        
	        array_push(combat.ship_id, _ship_id);
	        
        } catch (_exception){
        	handle_exception(_exception);
        }		
	}
}

function add_ai_fleet_to_combat(en_fleet, fleet_battle, status = -1){
	array_push(fleet_battle.enemy, en_fleet.owner);
	array_push(fleet_battle.enemy_status, status);

	array_push(fleet_battle.en_capital, en_fleet.capital_number);
	array_push(fleet_battle.en_frigate, en_fleet.frigate_number);
	array_push(fleet_battle.en_escort, en_fleet.escort_number);

    if (fleet_has_cargo("warband", en_fleet)){
    	fleet_battle.csm_exp+=2;
    }
    if (fleet_has_cargo("csm", en_fleet)){
        fleet_battle.csm_exp++;
    }
}

function setup_fleet_battle(combating, star){

	obj_controller.combat=combating;
	var _p_fleet = get_nearest_player_fleet(x,y,true);
	var good = (_p_fleet!="none" and instance_exists(star));
	if (!good){
		obj_controller.combat = 0;
		exit;
	}
	show_debug_message($"create combat {combating}");
    instance_create(0,0,obj_fleet);
    obj_fleet.target_enemy = combating;
    instance_activate_object(obj_en_fleet);
    for (var e=2;e<12;e++){
        var _fleets = get_orbiting_fleets(e, star);
        show_debug_message($"fleet : {_fleets}");
        if (!array_length(_fleets)){
            continue;
        }
        if (e == combating || obj_controller.faction_status[e]=="War"){
        	show_debug_message("target combat fleet");
            for (var f=0;f<array_length(_fleets);f++){
                add_ai_fleet_to_combat(_fleets[f], obj_fleet);
            }
        } else if (obj_controller.faction_status[e]!="War" && e != combating){
            for (var f=0;f<array_length(_fleets);f++){
                add_ai_fleet_to_combat(_fleets[f], obj_fleet, 1);
            }                   
        }
    }
    obj_fleet.pla_fleet = _p_fleet;
    add_fleet_ships_to_combat(_p_fleet, obj_fleet);

    for (var i=0;i<star.planets;i++){
         if (planet_feature_bool(star.p_feature[i], P_features.Monastery) == 1){
         	obj_fleet.player_lasers=target.p_lasers[i];
        }
    }

    obj_fleet.battle_system=star;
}

function start_fleet_battle(){    
    obj_controller.combat=1;
    obj_fleet.player_started=1;
    instance_deactivate_all(true);
    instance_activate_object(obj_controller);
    instance_activate_object(obj_ini);
    instance_activate_object(obj_fleet);
    instance_activate_object(obj_cursor);
    instance_activate_object(obj_en_ship);
    instance_activate_object(obj_p_ship);
    instance_activate_object(obj_al_ship);
    instance_deactivate_object(obj_star);
}

function sort_ships_into_columns(combat){
	var col = 5;
	with (combat){
	    for (var k = 0;k<array_length(ship_data);k++){// This determines the number of ships in each column
	    	var _ship = combat.ship_data[k];
	    	for (var col = 5;col>0;col--){
	    		 if ((combat.column[col]="capital" &&  _ship.size>=3)){
	    		 	combat.column_num[col]++;
	    		 }
	    		 else if (combat.column[col]=="frigate"&& _ship.size==2){
	    		 	combat.column_num[col]++;
	    		 }
				else if ((combat.column[col]=="escort" && _ship.size==1)){
					combat.column_num[col]++;
				}
	    	}
	    }		
	}

}


function player_fleet_ship_spawner(){
	var x2 = 224;
	var hei=0,sizz=0;
	for (var col=5;col>0;col--){// Start repeat
	    temp1=0;
	    temp2=0;

	    if (col<5) then x2-=column_width[col];

		if (column_num[col]>0){// Start ship creation
		    if (column[col] == "capital" || column[col] == "Battle Barge"){
		    	hei=160;
		    	sizz=3;
		    }
		    // if (column[col]="Slaughtersong"){hei=200;sizz=3;}
		    if (column[col]=="Strike Cruiser" || column[col]=="frigate"){
		    	hei=96;
		    	sizz=2;
		    }
		    else if (column[col]=="Gladius"){
		    	hei=64;
		    	sizz=1;
		    }else if (column[col]=="Hunter"){
		    	hei=64;
		    	sizz=1;
		    }
		    else if (column[col]=="escort"){
		    	hei=64;
		    	sizz=1;
		    }

		    temp1 = max(column_num[col],1) * hei;
		    temp2 = ((room_height/2)-(temp1/2))+64;
		    if (column_num[col]=1) then temp2+=20;
		    
		    // show_message(string(column_num[col])+" "+string(column[col])+" X:"+string(x2));
		    for (var k = 0;k<array_length(ship_id);k++){
		    	var _ship = ship_data[k];
		        if (_ship.class==column[col] || (player_ships_class(ship_id[k])==column[col])){
		        	man=-1;
		            if (sizz>=3 && _ship.class!="") {
		            	man=instance_create(x2,temp2,obj_p_capital);
		            	man.ship_id=ship_id[k];
		            	temp2 += hei;
		            }
		            if (sizz=2 && _ship.class!="") {
		            	man=instance_create(x2,temp2,obj_p_cruiser);
		            	man.ship_id=ship_id[k];
		            	temp2 += hei;
		            }
		            if (sizz=1 && _ship.class!="") {
		            	man=instance_create(x2,temp2,obj_p_escort);
		            	man.ship_id=ship_id[k];
		            	temp2 += hei;
		            }
		            if (instance_exists(man)){
			            with (man){
			            	setup_player_combat_ship();
			            }
			        }
		        }
		    }
		    

		}// End ship creation

	}// End repeat		
}

function draw_ellipse_rotated(){

}
//data must have keys, shields, recharge, and reboot
function ShipShieldGenerator(data) constructor{
	move_data_to_current_scope(data);
	destroyed = false;
	disabled = false;
	disabled_timer = 0;
	x_scale = 1;
	y_scale = 1;
	shield_sprite = spr_ship_shields;
	var _ship_sprite = ship.sprite_index;
	x_scale = sprite_get_width(_ship_sprite) / sprite_get_width(shield_sprite);
	y_scale = sprite_get_height(_ship_sprite) / sprite_get_height(shield_sprite);


	static draw = function(){
		if (shields > 0 && !destroyed && !disabled){
			draw_sprite_ext(shield_sprite, 0, ship.x, ship.y, x_scale, y_scale, ship.direction, c_white, 1);

	        draw_set_color(c_white);
	        var shield_percent = $"{(shields/maxshields)*100}%"
	        
	        draw_text_transformed(ship.x,ship.y-ship.sprite_height,shield_percent,x_scale*obj_controller.scale_mod,y_scale*obj_controller.scale_mod,0);
		
		}
	}

	static active = function(){
		return (shields && !destroyed && !disabled);
	}

	static step = function(){
		if (destroyed){
			exit;
		}
		if (disabled){
			disabled_timer++;
			if (disabled_timer >= shields_reboot_time){
				disabled_timer = 0;
				disabled = false;
			} else {
				exit;
			}
		}

		if (!disabled){
			if (shields<maxshields){
				shields += recharge_rate;
			}
		}
	}
}

function setup_player_combat_ship(){
	action="";
	direction=0;

	ship_data = obj_ini.ship_data[ship_id];
	weapons = ship_data.weapons;

	name=ship_data.name;
	class=ship_data.class;
	hp=ship_data.hp;
	size = ship_data.size;
	maxhp=ship_data.max_hp;
	shields=ship_data.shields*100;
	maxshields=shields;
	armour_front = ship_data.front_armour;
	side_armour=ship_data.side_armour;
	rear_armour = ship_data.rear_armour;
	turrets=array_length(ship_data.turrets);
	ship_colour=obj_controller.body_colour_replace;
	max_speed = ship_data.max_speed;
	sprite_index = ship_data.sprite_index;
	
    for (var i=0;i<array_length(weapons);i++){
    	weapons[i].ship = id;
    }
	shields = new ShipShieldGenerator({shields, maxshields, recharge_rate:ship_data.shields_recharge_rate, shields_reboot:ship_data.shields_reboot_time, ship:id})


	// STC Bonuses
	if (obj_controller.stc_bonus[5]=5){
		armour_front=round(armour_front*1.1);
		side_armour=round(side_armour*1.1);
	}
	if (obj_controller.stc_bonus[6]=2){
		armour_front=round(armour_front*1.1);
		side_armour=round(side_armour*1.1);
	}


	var i=0, unit, b=0;

	boarders = 0;
	for (var co=0;co<=obj_ini.companies;co++){
	    for (i=0;i<array_length(obj_ini.name[co]);i++){
	        if (obj_ini.name[co][i]=="") then continue;
	        unit=fetch_unit([co,i]);
	        if (unit.ship_location==ship_id){
	            if (unit.is_boarder && unit.hp()>(unit.max_health()/10)){
	            	array_push(board_co, co);
	            	array_push(board_id, i);
	            	array_push(board_location, 0);
	            	array_push(board_raft, 0);
	                boarders+=1;
	            }
	            // Loc 0: on origin ship
	            // Loc 1: in transit
	            // Loc >1: (instance_id), on enemy vessel 
	            if (co==0 && master_present==0 && i<100){
	                if (unit.role()==obj_ini.role[100][eROLE.ChapterMaster] && unit.ship_location==ship_id){
	                    master_present=1;
	                    obj_fleet.control=1;
	                }            
	            }            
	        }
	    }
	}

	if (boarders>0){
	    if (obj_controller.command_set[25]=1) then board_capital=true;
	    if (obj_controller.command_set[26]=1) then board_frigate=true;
	}

	if (hp<=0){
	    x=-1000;
	    y=room_height/2;
	}

}


