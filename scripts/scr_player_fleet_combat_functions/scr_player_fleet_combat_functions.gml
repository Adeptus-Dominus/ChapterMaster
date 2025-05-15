// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_fleet_ships_to_combat(fleet, combat){
	var capital_count = array_length(fleet.capital);
	var _ship_id;
	var _ships = fleet_full_ship_array(fleet);
	var _ship_array_length = array_length(_ships);
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
	        
	        array_push(combat.ship_class, player_ships_class(_ship_id));
	        array_push(combat.ship_id, _ship_id);
	        array_push(combat.ship_leadership, 100);
	        array_push(combat.ship_hp, _ship_d.hp);
	        array_push(combat.ship_maxhp, _ship_d.max_hp);
	        array_push(combat.ship_speed, obj_ini.ship_speed[_ship_id]);
	        array_push(combat.ship_front_armour, _ship_d.front_armour);
	        array_push(combat.ship_other_armour, _ship_d.side_armour);
	        
        } catch (_exception){
        	handle_exception(_exception);
        }		
	}
}

function sort_ships_into_columns(combat){
	var col = 5;
	with (combat){
	    for (var k = 0;k<array_length(ship_data);k++){// This determines the number of ships in each column
	    	var _ship = combat.ship_data[k];
            if ((combat.column[col]="capital" && _ship.size[k]>=3)) then combat.column_num[col]+=1;
            if ((combat.column[col-1]="capital" && _ship.size[k]>=3)) then combat.column_num[col-1]+=1;
            if ((combat.column[col-2]="capital" && _ship.size[k]>=3)) then combat.column_num[col-2]+=1;
            if ((combat.column[col-3]="capital" && _ship.size[k]>=3)) then combat.column_num[col-3]+=1;
            if ((combat.column[col-4]="capital" && _ship.size[k]>=3)) then combat.column_num[col-4]+=1;
        
            if (combat.ship_class[k]=combat.column[col]) then combat.column_num[col]+=1;
            if (combat.ship_class[k]=combat.column[col-1]) then combat.column_num[col-1]+=1;
            if (combat.ship_class[k]=combat.column[col-2]) then combat.column_num[col-2]+=1;
            if (combat.ship_class[k]=combat.column[col-3]) then combat.column_num[col-3]+=1;
            if (combat.ship_class[k]=combat.column[col-4]) then combat.column_num[col-4]+=1;
            
            if ((combat.column[col]="escort" && _ship.size[k]=1)) then combat.column_num[col]+=1;
            if ((combat.column[col-1]="escort" && _ship.size[k]=1)) then combat.column_num[col-1]+=1;
            if ((combat.column[col-2]="escort" && _ship.size[k]=1)) then combat.column_num[col-2]+=1;
            if ((combat.column[col-3]="escort" && _ship.size[k]=1)) then combat.column_num[col-3]+=1;
            if ((combat.column[col-4]="escort" && _ship.size[k]=1)) then combat.column_num[col-4]+=1;
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
		    if (column[col]=="capital"){
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
		    else if (column[col]=="escort"){hei=64;sizz=1;}

		    temp1=column_num[col]*hei;
		    temp2=((room_height/2)-(temp1/2))+64;
		    if (column_num[col]=1) then temp2+=20;
		    
		    // show_message(string(column_num[col])+" "+string(column[col])+" X:"+string(x2));
		    for (var k = 0;k<array_length(ship_id);k++){
		        if (ship_class[k]==column[col] || (player_ships_class(ship_id[k])==column[col])){
		        	man=-1;
		            if (sizz>=3 && ship_class[k]!="") {
		            	man=instance_create(x2,temp2,obj_p_capital);
		            	man.ship_id=ship_id[k];
		            	temp2+=hei;
		            }
		            if (sizz=2 && ship_class[k]!="") {
		            	man=instance_create(x2,temp2,obj_p_cruiser);
		            	man.ship_id=ship_id[k];
		            	temp2+=hei;
		            }
		            if (sizz=1 && ship_class[k]!="") {
		            	man=instance_create(x2,temp2,obj_p_escort);
		            	man.ship_id=ship_id[k];
		            	temp2+=hei;
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


function setup_player_combat_ship(){
	action="";
	direction=0;


	cooldown1=0;
	cooldown2=0;
	cooldown3=0;
	cooldown4=0;
	cooldown5=0;

	ship_data = obj_ini.ship_data[ship_id];
	weapons = ship_data.weapons;

	name=ship_data.name;
	class=ship_data.class;
	hp=ship_data.hp
	maxhp=ship_data.max_hp
	shields=obj_ini.ship_shields[ship_id]*100;
	maxshields=shields;
	armour_front = ship_data.front_armour;
	side_armour=ship_data.side_armour;
	turrets=0;
	ship_colour=obj_controller.body_colour_replace;
	max_speed = obj_ini.ship_speed[ship_id];
	
    for (var i=0;i<array_length(weapons);i++){
    	weapons[i].ship = id;
    }

	if (class="Battle Barge"){
	    turrets=3;

	    shield_size=3;
	    sprite_index=spr_ship_bb;
	}

	else if (class=="Slaughtersong" || class=="Gloriana"){
		turrets=3;

		shield_size=3;
		sprite_index=spr_ship_song;
	}


	else if (class="Strike Cruiser"){
		turrets=1;

		shield_size=1;
		sprite_index=spr_ship_stri;
	}

	else if (class="Hunter"){
		turrets=1;

		shield_size=1;
		sprite_index=spr_ship_hunt;
	}

	else if (class="Gladius"){
		turrets=1;

		shield_size=1;
		sprite_index=spr_ship_glad;
	}


	// STC Bonuses
	if (obj_controller.stc_bonus[5]=5){
		armour_front=round(armour_front*1.1);side_armour=round(side_armour*1.1);
	}
	if (obj_controller.stc_bonus[6]=2){
		armour_front=round(armour_front*1.1);side_armour=round(side_armour*1.1);
	}


	var i=0, unit, b=0;

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


