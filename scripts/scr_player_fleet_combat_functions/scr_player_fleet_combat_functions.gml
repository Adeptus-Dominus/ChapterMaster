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
			if (obj_ini.ship_hp[_ship_id]<=0 || obj_ini.ship[_ship_id]==""){
				continue;
			}
	        if (obj_ini.ship_size[_ship_id]>=3) then combat.capital++;
	        if (obj_ini.ship_size[_ship_id]==2) then combat.frigate++;
	        if (obj_ini.ship_size[_ship_id]==1) then combat.escort++;
	        
	        array_push(combat.ship_class, player_ships_class(_ship_id));
	        array_push(combat.ship, obj_ini.ship[_ship_id]);
	        array_push(combat.ship_id, _ship_id);
	        array_push(combat.ship_size, obj_ini.ship_size[_ship_id]);
	        array_push(combat.ship_leadership, 100);
	        array_push(combat.ship_hp, obj_ini.ship_hp[_ship_id]);
	        array_push(combat.ship_maxhp, obj_ini.ship_maxhp[_ship_id]);
	        array_push(combat.ship_conditions, obj_ini.ship_conditions[_ship_id]);
	        array_push(combat.ship_speed, obj_ini.ship_speed[_ship_id]);
	        array_push(combat.ship_turning, obj_ini.ship_turning[_ship_id]);
	        array_push(combat.ship_front_armour, obj_ini.ship_front_armour[_ship_id]);
	        array_push(combat.ship_other_armour, obj_ini.ship_other_armour[_ship_id]);
	        array_push(combat.ship_weapons, obj_ini.ship_weapons[_ship_id]);
	        
	        array_push(combat.ship_wep, obj_ini.ship_wep[_ship_id]);
	        array_push(combat.ship_wep_facing, obj_ini.ship_wep_facing[_ship_id]);
	        array_push(combat.ship_wep_condition, obj_ini.ship_wep_condition[_ship_id]);
	        
	        array_push(combat.ship_capacity, obj_ini.ship_capacity[_ship_id]);
	        array_push(combat.ship_carrying, obj_ini.ship_carrying[_ship_id]);
	        array_push(combat.ship_contents, obj_ini.ship_contents[_ship_id]);
	        array_push(combat.ship_turrets, obj_ini.ship_turrets[_ship_id]);
        } catch (_exception){
        	handle_exception(_exception);
        }		
	}
}

function sort_ships_into_columns(combat){
	var col = 5;
	with (combat){
	    for (var k = 0;k<array_length(combat.ship_size);k++){// This determines the number of ships in each column
            if ((combat.column[col]="capital" && combat.ship_size[k]>=3)) then combat.column_num[col]+=1;
            if ((combat.column[col-1]="capital" && combat.ship_size[k]>=3)) then combat.column_num[col-1]+=1;
            if ((combat.column[col-2]="capital" && combat.ship_size[k]>=3)) then combat.column_num[col-2]+=1;
            if ((combat.column[col-3]="capital" && combat.ship_size[k]>=3)) then combat.column_num[col-3]+=1;
            if ((combat.column[col-4]="capital" && combat.ship_size[k]>=3)) then combat.column_num[col-4]+=1;
        
            if (combat.ship_class[k]=combat.column[col]) then combat.column_num[col]+=1;
            if (combat.ship_class[k]=combat.column[col-1]) then combat.column_num[col-1]+=1;
            if (combat.ship_class[k]=combat.column[col-2]) then combat.column_num[col-2]+=1;
            if (combat.ship_class[k]=combat.column[col-3]) then combat.column_num[col-3]+=1;
            if (combat.ship_class[k]=combat.column[col-4]) then combat.column_num[col-4]+=1;
            
            if ((combat.column[col]="escort" && combat.ship_size[k]=1)) then combat.column_num[col]+=1;
            if ((combat.column[col-1]="escort" && combat.ship_size[k]=1)) then combat.column_num[col-1]+=1;
            if ((combat.column[col-2]="escort" && combat.ship_size[k]=1)) then combat.column_num[col-2]+=1;
            if ((combat.column[col-3]="escort" && combat.ship_size[k]=1)) then combat.column_num[col-3]+=1;
            if ((combat.column[col-4]="escort" && combat.ship_size[k]=1)) then combat.column_num[col-4]+=1;
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


	name=obj_ini.ship[ship_id];
	class=obj_ini.ship_class[ship_id];
	hp=obj_ini.ship_hp[ship_id]*1;
	maxhp=obj_ini.ship_hp[ship_id]*1;
	conditions=obj_ini.ship_conditions[ship_id];
	shields=obj_ini.ship_shields[ship_id]*100;
	maxshields=shields;
	armour_front=obj_ini.ship_front_armour[ship_id];
	armour_other=obj_ini.ship_other_armour[ship_id];
	weapons=obj_ini.ship_weapons[ship_id];
	turrets=0;
	ship_colour=obj_controller.body_colour_replace;
	max_speed = obj_ini.ship_speed[ship_id];
    weapon = obj_ini.ship_wep[ship_id];
    
    weapon_facing[1]="";
    weapon_cooldown[1]=0;
    weapon_hp[1]=hp/4;
    weapon_dam[1]=0;
    weapon_ammo[1]=999;
    weapon_range[1]=0;
    weapon_minrange[1]=0;
    weapon_facing[2]="";
    weapon_cooldown[2]=0;
    weapon_hp[2]=hp/4;
    weapon_dam[2]=0;
    weapon_ammo[2]=999;
    weapon_range[2]=0;
    weapon_minrange[2]=0;

    weapon_facing[3]="";
    weapon_cooldown[3]=0;
    weapon_hp[3]=hp/4;
    weapon_dam[3]=0;
    weapon_ammo[3]=999;
    weapon_range[3]=0;
    weapon_minrange[3]=0;

    weapon_facing[4]="";
    weapon_cooldown[4]=0;
    weapon_hp[4]=hp/4;
    weapon_dam[4]=0;
    weapon_ammo[4]=999;
    weapon_range[4]=0;
    weapon_minrange[4]=0;

    weapon_facing[5]="";
    weapon_cooldown[5]=0;
    weapon_hp[5]=hp/4;
    weapon_dam[5]=0;
    weapon_ammo[5]=999;
    weapon_range[5]=0;
    weapon_minrange[5]=0;





	if (class="Battle Barge"){
	    turrets=3;
	    weapons=5;
	    shield_size=3;
	    sprite_index=spr_ship_bb;
	    weapon_facing[1]="left";
	    weapon_dam[1]=15;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=30;
	    weapon_facing[2]="right";
	    weapon_dam[2]=15;
	    weapon_range[2]=450;
	    weapon_cooldown[2]=30;
	    weapon_facing[3]="special";
	    weapon_cooldown[3]=90;
	    weapon_ammo[3]=3;
	    weapon_range[3]=9999;
	    weapon_facing[4]="front";
	    weapon_dam[4]=12;
	    weapon_range[4]=1000;
	    weapon_cooldown[4]=120;// volley several
	    weapon_facing[5]="most";
	    weapon_dam[5]=16;
	    weapon_range[5]=300;
	    weapon_cooldown[5]=30;
	}

	else if (class="Slaughtersong"){turrets=3;
		weapons=5;shield_size=3;sprite_index=spr_ship_song;
	    weapon_facing[1]="most";
	    weapon_dam[1]=16;
	    weapon_range[1]=550;
	    weapon_cooldown[1]=26;
	    weapon_facing[2]="most";
	    weapon_dam[2]=16;
	    weapon_range[2]=550;
	    weapon_cooldown[2]=26;
	    weapon_facing[3]="most";
	    weapon_dam[3]=16;
	    weapon_range[3]=550;
	    weapon_cooldown[3]=26;
	    weapon_facing[4]="front";
	    weapon_dam[4]=32;
	    weapon_range[4]=1000;
	    weapon_cooldown[4]=90;
	}


	else if (class="Strike Cruiser"){turrets=1;
		weapons=4;shield_size=1;sprite_index=spr_ship_stri;
	    weapon_facing[1]="left";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    weapon_facing[2]="right";
	    weapon_dam[2]=8;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=30;
	    weapon_facing[3]="special";
	    weapon_cooldown[3]=90;
	    weapon_ammo[3]=3;
	    weapon_range[3]=9999;
	    weapon_facing[4]="most";
	    weapon_dam[4]=12;
	    weapon_range[4]=300;
	    weapon_cooldown[4]=30;
	}

	else if (class="Hunter"){turrets=1;
		weapons=2;
		shield_size=1;sprite_index=spr_ship_hunt;
	    weapon_facing[1]="front";
	    weapon_dam[1]=8;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=60;
	    weapon_facing[2]="most";
	    weapon_dam[2]=8;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=60;
	}

	else if (class="Gladius"){
		turrets=1;
		weapons=2;
		shield_size=1;
		sprite_index=spr_ship_glad;
	    weapon_facing[1]="most";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	}


	// STC Bonuses
	if (obj_controller.stc_bonus[5]=5){
		armour_front=round(armour_front*1.1);armour_other=round(armour_other*1.1);
	}
	if (obj_controller.stc_bonus[6]=2){
		armour_front=round(armour_front*1.1);armour_other=round(armour_other*1.1);
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
	                if (unit.role()=="Chapter Master" && unit.ship_location==ship_id){
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


