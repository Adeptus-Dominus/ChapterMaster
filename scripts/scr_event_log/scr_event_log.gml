function scr_event_log(event_colour, event_text, target = "none") {
	log_message($"Adding event to log: {event_text}")
	if (instance_exists(obj_event_log)){
	    var yf;yf="";
	    if (obj_controller.year_fraction<10) then yf="00"+string(obj_controller.year_fraction);
	    if (obj_controller.year_fraction>=10) and (obj_controller.year_fraction<100) then yf="0"+string(obj_controller.year_fraction);
	    if (obj_controller.year_fraction>=100) then yf=string(obj_controller.year_fraction);

		var new_event = {
			colour :event_colour, // takes green, yellow, red, purple, default GM colorcodes(with c_ prefix), decimal, hexadecimal(with $ prefix, 6 or 8 digits) and CSS(with # prefix)
			turn : obj_controller.turn,
	    	date:string(obj_controller.check_number)+" "+string(yf)+" "+string(obj_controller.year)+".M"+string(obj_controller.millenium),
	   	 	text:event_text,
	   	 	event_target :target
		}
    	array_insert(obj_event_log.event, 0, new_event);
   
	}
}
