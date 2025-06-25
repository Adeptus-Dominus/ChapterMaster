function scr_trade_dep() {

	var  _goods = cargo_data.player_goods;

	show_debug_message($"trade goods : {_goods}");
	if (struct_exists(_goods, "mercenaries")){
		var _mercs = struct_get_names(_goods.mercenaries);
	    for (var m=0;m<array_length(_mercs);m++){
	    	var _merc_type = _mercs[m];
	        repeat(_goods.mercenaries[$_merc_type]){
	            scr_add_man(_merc_type,0,"","",0,true,"default");
	        }
	    }
	}

	if (struct_exists(_goods, "requisition")){
		obj_controller.requisition+=_goods.requisition;
	}

	if (struct_exists(_goods, "items")){
		var _items = struct_get_names(_goods.items);
		 for (var m=0;m<array_length(_items);m++){
		 	var _item_type = _items[m];
		 	var _item_data = _goods.items[$ _item_type];
		 	scr_add_item(_item_type,_item_data.number, _item_data.quality);
		 }

	}

	if (struct_exists(_goods, "Minor Artifact")){
        if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random_nodemon","minor",0,obj_ini.home_name,2);
        if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random_nodemon","minor",0,obj_ini.ship[0],501);
	}

	struct_remove(cargo_data, "player_goods");

}

function setup_ai_trade_fleet(start_place, faction){
    var flit=instance_create(start_place.x,start_place.y,obj_en_fleet);

    flit.owner=faction;
    flit.home_x=start_place.x;
    flit.home_y=start_place.y;

    //pretty sure this sprite setting has a dedicated function somewhere but i've forgotten where atm
    if (faction=5) then flit.owner = eFACTION.Imperium;

    if (faction=2) then flit.sprite_index=spr_fleet_imperial;
    if (faction=3) then flit.sprite_index=spr_fleet_mechanicus;
    if (faction=4){flit.sprite_index=spr_fleet_inquisition;flit.owner  = eFACTION.Inquisition;}
    // if (diplomacy=4){flit.sprite_index=spr_fleet_imperial;flit.owner = eFACTION.Imperium;}
    if (faction=6){
        flit.action_spd=6400;
        flit.action_eta=1;
        flit.sprite_index=spr_fleet_eldar;
    }
    if (faction=7) then flit.sprite_index=spr_fleet_ork;
    if (faction=8) then flit.sprite_index=spr_fleet_tau;

    flit.image_index=0;
	flit.capital_number=1;
	return flit
}
