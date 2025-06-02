function scr_trade_dep() {

	var  _goods = cargo_data.player_goods;

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
