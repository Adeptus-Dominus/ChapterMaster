function scr_add_item(item_name, number_of_items=1, quality="any", from_marine=false) {
	if (item_name=="") then exit;
	var i, last_open, match_slot, open_slot=false, matched=false;
	var ok=0;

	var last_slot=array_length(obj_ini.equipment);
    for (i=0;i<last_slot;i++){
        if (obj_ini.equipment[i]=="") and (open_slot==false){
        	last_open=i;
        	open_slot=true;
        }
        if (obj_ini.equipment[i]==item_name) and (obj_ini.equipment_condition[i]>0) and (matched==false){
        	matched=true;
        	match_slot=i;
        	break;
        }
    }

    if (matched){
    	var start_count = obj_ini.equipment_number[match_slot];
    	if (start_count<0){
    		start_count=0;
    		obj_ini.equipment_number[match_slot]=0;
    	}
    	obj_ini.equipment_number[match_slot]+=number_of_items;

    	if (number_of_items>0){
    		if (quality=="any") then quality="standard"
	    	for (var q=start_count;q<obj_ini.equipment_number[match_slot];q++){
	    		obj_ini.equipment_quality[match_slot][q]=quality;
	    	}
	    	// this is to make sure people can't de=equip items to get around maintenance values
	    	if (instance_exists(obj_controller)){
	    		obj_controller.specialist_point_handler.add_to_armoury_repair(item_name, number_of_items);
	    	}
	    } else if (number_of_items<0){
	    	if (start_count==0) then return "no_item";
	    	var end_count = obj_ini.equipment_number[match_slot];
	    	if (end_count<0) then end_count=0;
	    	if (number_of_items==-1){
	    		if (quality=="any"){
	    			if (array_length(obj_ini.equipment_quality[match_slot])>0){
	    				return array_pop(obj_ini.equipment_quality[match_slot]);
	    			} else {
	    				return "standard"
	    			}
	    		}else {
	    			var quality_item_found=false;
	    			for (var q=0;q<array_length(obj_ini.equipment_quality[match_slot]);q++){
	    				if (obj_ini.equipment_quality[match_slot][q]==quality){
	    					array_delete(obj_ini.equipment_quality[match_slot], q, 1);
	    					quality_item_found=true;
	    					break;
	    				}
	    				if(quality_item_found){
	    					return quality;
	    				} else{
	    					obj_ini.equipment_number[match_slot]++;
	    					return "no_item";
	    				}
	    			}
	    		}
	    	} else{
		    	for (var q=start_count-1;q>end_count;q--){
		    		array_delete(obj_ini.equipment_quality[match_slot], q, 1);
		    		if (q==0) then break;
		    	}
	    	}
	    }
    } else if (open_slot){
        obj_ini.equipment[last_open]=item_name;
        obj_ini.equipment_number[last_open]=number_of_items;
        obj_ini.equipment_condition[last_open]=100;
        if (quality == "any"){
        	quality = "standard";
        }
        for (var q=0;q<number_of_items;q++){
        	obj_ini.equipment_quality[last_open][q]=quality;
        }
        if (string_count("MK",item_name)>0) or (string_count("Armour",item_name)>0) or (item_name="Tartaros") then obj_ini.equipment_type[last_open]="armour";
        if (string_count("Bolts",item_name)>0) then obj_ini.equipment_type[last_open]="gear";
    } else {
    	array_set(obj_ini.equipment, last_slot, item_name);
    	array_set(obj_ini.equipment_number, last_slot, number_of_items);
    	array_set(obj_ini.equipment_condition, last_slot, 100);
    	array_set(obj_ini.equipment_quality, last_slot, []);
    	if (quality=="any") then quality="standard";
        for (var q=0;q<number_of_items;q++){
        	obj_ini.equipment_quality[last_slot][q]=quality;
        }	    	
        if (string_count("MK",item_name)>0) or (string_count("Armour",item_name)>0) or (item_name="Tartaros") then obj_ini.equipment_type[last_slot]="armour";
        if (string_count("Bolts",item_name)>0) then obj_ini.equipment_type[last_slot]="gear";	    	
    }   
}
