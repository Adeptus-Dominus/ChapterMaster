// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_kill_unit(company, unit_slot){
	if (obj_ini.role[company][unit_slot]=="Forge Master"){
		array_push(obj_ini.previous_forge_masters, obj_ini.name[company][unit_slot]);
	}

    if (obj_ini.role[company][unit_slot]==obj_ini.role[100][eROLE.ChapterMaster]){
        tek="c";
        alarm[7]=5;
        global.defeat=1;
    }
    _unit = fetch_unit([company, unit_slot]);
    if (_unit.weapon_one()=="Company Standard" || _unit.weapon_two()=="Company Standard"){
    	scr_loyalty("Lost Standard","+");
    }
    _unit.remove_from_squad();
	scr_wipe_unit(company, unit_slot)
}

function scr_wipe_unit(company, unit_slot){
	obj_ini.spe[company][unit_slot]="";
	obj_ini.race[company][unit_slot]=0;
	obj_ini.loc[company][unit_slot]="";
	obj_ini.name[company][unit_slot]="";
	obj_ini.wep1[company][unit_slot]="";
	obj_ini.role[company][unit_slot]="";
	obj_ini.wep2[company][unit_slot]="";
	obj_ini.armour[company][unit_slot]="";
	obj_ini.gear[company][unit_slot]="";
	obj_ini.god[company][unit_slot]=0;
	obj_ini.age[company][unit_slot]=0;
	obj_ini.mobi[company][unit_slot]="";
	obj_ini.bio[company][unit_slot]="";
	obj_ini.TTRPG[company][unit_slot].base_group="none";	
}

function kill_and_recover(company, unit_slot, equipment=true, gene_seed_collect=true){
	var unit = obj_ini.TTRPG[company][unit_slot];
	if (equipment){
		var strip = {
			"wep1":"",
			"wep2":"",
			"mobi":"",
			"armour":"",
			"gear":"",
		};
		unit.alter_equipment(strip,false, true);
	} 
	if (gene_seed_collect && unit.base_group=="astartes"){
        if (unit.age() > 30 && !obj_ini.zygote && !obj_ini.doomed) then obj_controller.gene_seed+=1;
        if (unit.age() > 50 && !obj_ini.doomed) then obj_controller.gene_seed+=1;		
	}
    if (obj_ini.race[company][unit_slot]==1){
        if(is_specialist(obj_ini.role[company][unit_slot])){
            obj_controller.command-=1;
        } else{
            obj_controller.marines-=1;
        }
    }	
	scr_kill_unit(company, unit_slot);
}