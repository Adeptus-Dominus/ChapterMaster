	// ** Promoting **
	try{
		if (type == POPUP_TYPE.PROMOTION) {
			draw_popup_promotion();
		} else if (type == 5.1){
			draw_popup_transfer();
		} else if (type == POPUP_TYPE.EQUIP){
			draw_popup_equip();
		}else if (type == POPUP_TYPE.ITEM_GIFT) {
			draw_gift_items_popup();
	    } else if (type == POPUP_TYPE.ARTIFACT_EQUIP){
	    	equip_artifact_popup_draw();
	    } else if (type == POPUP_TYPE.ADD_TAGS){
	    	draw_tag_manager();
	    }
	} catch(_exception){
		instance_destroy();
		handle_exception(_exception);
	}
	