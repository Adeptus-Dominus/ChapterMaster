function scr_battle_allies() {
	// Fun* here, for eating allies

	// Find object
	var that_star,plant;plant=0;
	with(obj_temp3){instance_destroy();}
	instance_activate_object(obj_star);

	with(obj_star){
		if (name=obj_ncombat.battle_loc) then instance_create(x,y,obj_temp3);
	}
	that_star=instance_nearest(x,y,obj_star);
	plant=obj_ncombat.battle_id;

	if (obj_controller.faction_status[eFACTION.Imperium]!="War") and (that_star.p_pdf[plant]>0) then obj_ncombat.allies=1;
	if (obj_controller.faction_status[eFACTION.Imperium]!="War") and (that_star.p_guardsmen[plant]>0) then obj_ncombat.allies=2;

	instance_activate_object(obj_en_fleet);

	with(obj_en_fleet){
	    if (owner  = eFACTION.Inquisition) and (string_count("Inqis",trade_goods)>0) and (action="") and (point_distance(x,y,obj_temp3.x,obj_temp3.y)<=40){
	        obj_ncombat.present_inquisitor=1;
	        obj_ncombat.inquisitor_ship=id;
	    }
	}

	/*show_message(string(instance_number(obj_temp6)));

	if (instance_exists(obj_temp6)){
	    var da1,da2;da1=instance_nearest(that_star.x,that_star.y,obj_temp6);
	    da2=point_distance(that_star.x,that_star.y,obj_temp6.x,obj_temp6.y);
	    show_message(string(da2));
	    if (da2<=40) then obj_ncombat.present_inquisitor=1;
	    show_message(string(obj_ncombat.present_inquisitor));
	}*/

	// show_message(string(obj_ncombat.inquisitor_ship));

	with(obj_temp3){instance_destroy();}with(obj_temp6){instance_destroy();}
	instance_deactivate_object(obj_en_fleet);
	instance_deactivate_object(obj_star);


}
