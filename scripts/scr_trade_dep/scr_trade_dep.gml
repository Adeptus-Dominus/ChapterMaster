function scr_trade_dep() {

	var  _goods = cargo_data.player_goods;

	if (struct_exists(_goods, "mercenaries"){
		var _mercs = struct_get_names(_goods.mercenaries);
	    for (var m=0;m<array_length(_mercs);m++)
	    	var _merc_type = _mercs[m];
	        repeat(_goods.mercenaries[$_merc_type]){
	            scr_add_man(_merc_type,0,"","",0,true,"default");
	        }
	    }
	}

	if (struct_exists(_goods, "requisition"){
		obj_controller.requisition+=_goods.requisition;
	}

	if (struct_exists(_goods, "items")){
		var _items = struct_get_names(_goods.items);
		 for (var m=0;m<array_length(_items);m++){
		 	var _item_type = _mercs[m];
		 	var _item_data = _goods.items[$ _item_type];
		 	scr_add_item(_item_type,_item_data.number, _item_data.quality);
		 }

	}

	if (struct_exists(_goods, "Minor Artifact")){
        if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random_nodemon","minor",0,obj_ini.home_name,2);
        if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random_nodemon","minor",0,obj_ini.ship[0],501);
	}

}

function remove_trade_items_from_inventory(){
    for (var i=0;i<array_length(trade_give);i++){
        if (trade_give[i]="Requisition"){
        	requisition-=trade_mnum[i];
        }
        if (trade_give[i]="Gene-Seed") and (trade_mnum[i]>0){
            gene_seed-=trade_mnum[i];
        
            if (diplomacy<=5) and (diplomacy!=4) then gene_sold+=trade_mnum[i];
            if (diplomacy>=6) then gene_xeno+=trade_mnum[i];
        }
        if (trade_give[i]="Info Chip") and (trade_mnum[i]>0){
        	info_chips-=trade_mnum[i];
        }
        if (trade_give[i]="STC Fragment") and (trade_mnum[i]>0){
            var remov=0,p=0;
            repeat(100){
                if (remov=0){p=choose(1,2,3);
                    if (p=1) and (stc_wargear_un>0){
                    	stc_wargear_un-=1;
                    	remov=1;
                    }
                    else if (p=2) and (stc_vehicles_un>0){
                    	stc_vehicles_un-=1;
                    	remov=1;}
                    else if (p=3) and
                     (stc_ships_un>0){
                    	stc_ships_un-=1;
                    	remov=1;
                    }
                }
            }
        }
        if (trade_take[i]!="") then goods+=string(trade_take[i])+"!"+string(trade_tnum[i])+"!|";
    }	
}

function setup_ai_trade_fleet(){
    var flit=instance_create(targ.x,targ.y,obj_en_fleet);

    flit.owner=diplomacy;
    flit.home_x=targ.x;
    flit.home_y=targ.y;

    if (diplomacy=5) then flit.owner = eFACTION.Imperium;

    if (diplomacy=2) then flit.sprite_index=spr_fleet_imperial;
    if (diplomacy=3) then flit.sprite_index=spr_fleet_mechanicus;
    if (diplomacy=4){flit.sprite_index=spr_fleet_inquisition;flit.owner  = eFACTION.Inquisition;}
    // if (diplomacy=4){flit.sprite_index=spr_fleet_imperial;flit.owner = eFACTION.Imperium;}
    if (diplomacy=6){
        flit.action_spd=6400;
        flit.action_eta=1;
        flit.sprite_index=spr_fleet_eldar;
    }
    if (diplomacy=7) then flit.sprite_index=spr_fleet_ork;
    if (diplomacy=8) then flit.sprite_index=spr_fleet_tau;

    flit.image_index=0;
	flit.capital_number=1;
	return flit
}

function set_up_trade_cargo_struct(fleet){
     for (var i=0;i<array_length(trade_take);i++){
     	
     }	
}
