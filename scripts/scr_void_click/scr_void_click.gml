function scr_void_click() {

	var good=true;

	var xx=__view_get( e__VW.XView, 0 )+0;
	var yy=__view_get( e__VW.YView, 0 )+0;

	var scale = obj_controller.scale_mod;
	if (obj_controller.cooldown>0) return  false;
	if (obj_controller.menu!=0) return  false;
	if (!obj_controller.zoomed){
		if (mouse_y<__view_get( e__VW.YView, 0 )+(62*scale)) return  false;
		if (mouse_y>__view_get( e__VW.YView, 0 )+(830*scale)) return  false;
	}



    if (instance_exists(obj_fleet_select)){
         if (obj_fleet_select.currently_entered) then good=false;
    }


	else if (instance_exists(obj_star_select)){
	    if (obj_controller.selecting_planet>0){// This prevents clicking onto a new star by pressing the buttons or planet panel
	        if (scr_hit(xx+(27*scale),yy+(166*scale),xx+(727*scale),yy+(458*scale))){if (obj_star_select.button1!="") then good=false;}
	        if (scr_hit(xx+(348*scale),yy+(461*scale),xx+(348*scale)+(246*scale),yy+(461*scale)+(26*scale))){if (obj_star_select.button1!="") then good=false;}
	        if (scr_hit(xx+(348*scale),yy+(489*scale),xx+(348*scale)+(246*scale),yy+(489*scale)+(26*scale))){if (obj_star_select.button2!="") then good=false;}
	        if (scr_hit(xx+(348*scale),yy+(517*scale),xx+(348*scale)+(246*scale),yy+(517*scale)+(26*scale))){if (obj_star_select.button3!="") then good=false;}
	        if (scr_hit(xx+(348*scale),yy+(545*scale),xx+(348*scale)+(246*scale),yy+(545*scale)+(26*scale))){if (obj_star_select.button4!="") then good=false;}
	    }
	} else {
		if (obj_controller.helpful_places!=false){
			if (!instances_exist_any([obj_turn_end,obj_ncombat,obj_fleet,obj_fleet_select,obj_popup,obj_star_select])){
				if (obj_controller.helpful_places.entered()){
					good=false;
				}
			}
		}
	}

	if (obj_controller.popup=3){// Prevent hitting through the planet select
	    if (scr_hit(xx+(27*scale),yy+(165*scale),xx+(347*scale),yy+(459*scale))=true) then good=false;
	    if (obj_controller.selecting_planet>0){
	        if (scr_hit(xx+(27*scale),yy+(165*scale),xx+(728*scale),yy+(459*scale))=true) then good=false;// The area with the planetary info
	    }
	}

	if (obj_controller.menu=60) and (scr_hit(xx+(27*scale),yy+(165*scale),xx+(651*scale),yy+(597*scale))) then good=false;// Build menu


	return(good);


}
