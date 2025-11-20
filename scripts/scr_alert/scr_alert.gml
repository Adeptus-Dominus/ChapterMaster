function set_alert_draw_colour(alert_colour) {
    static default_colour = CM_GREEN_COLOR;
    static colour_map = {"red": c_red, "yellow": 57586, "purple": c_purple, "green": CM_GREEN_COLOR}; //TODO set constants for colours
    if (alert_colour != "") {
        if (struct_exists(colour_map, alert_colour)) {
            draw_set_color(colour_map[$ alert_colour]);
        } else {
            try {
                draw_set_color(alert_colour);
            } catch (_exception) {
                draw_set_color(default_colour);
            }
        }
    } else {
        draw_set_color(default_colour);
    }
}

function EndTurnAlert(type, text,colour)constructor{
    self.type=type;
    self.text=text;
    char=0;
    alpha=1;
    txt="";
    self.color=colour;
    static turn = 0

    static alert_count = 0
    if (turn != obj_controller.turn){
    	turn = obj_controller.turn;
    	alert_count = 0;
    }

    alert_id = alert_count;

    alert_count++;


    static draw = function(){
    	add_draw_return_values();
    	var _fast = obj_turn_end.fast;
        if (_fast>=alert_id) and (string_length(txt)<string_length(text)){
            char+=1;
            txt=string_copy(text,0,char);
        }
        if (_fast>=alert_id) and (alpha<1){
        	alpha+=0.03;
        }
        if (obj_turn_end.fadeout){
			alpha-=0.05;     	
        }
        set_alert_draw_colour(color);
        draw_set_alpha(min(1,alpha));
        
        if (obj_controller.zoomed=0){
            draw_text(32,+66+(alert_id*20),string_hash_to_newline(txt));
            // draw_text(view_xview[0]+16.5,view_yview[0]+40.5+(i*12),string(alert_txt[i]));
        }
        /*if (obj_controller.zoomed=1){
            draw_text_transformed(80,80+(i*24),string(alert_txt[i]),2,2,0);
            draw_text_transformed(81,81+(i*24),string(alert_txt[i]),2,2,0);
        }*/
        
        if (obj_controller.zoomed=1){
            draw_text_transformed(32,232+(alert_id*40),string_hash_to_newline(txt),2,2,0);
            // draw_text_transformed(122,122+(i*36),string(alert_txt[i]),3,3,0);
        }
        pop_draw_return_values();
    }
}

function scr_alert(colour, alert_type, alert_text, xx=00, yy=00) {

	// color / type / text /x/y

	// Quenes up one of the ALERT lines of text to be displayed by the obj_turn_end object
	// If the Y argument is >0 then the exclamation popup (obj_alert) is also created on the map



	// if (obj_turn_end.alerts>0){
	if (instance_exists(obj_turn_end) && (alert_type!="blank" && colour!="blank")){
		var _new_alert = new EndTurnAlert(alert_type,alert_text,colour);
		array_push(obj_turn_end.alert, _new_alert);
	}


	if (yy>0) or (yy<-10000){
	    var new_obj
    
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
	    if (xx<-15000){xx+=20000;yy+=20000;}
    
	    new_obj=instance_create(xx+16,yy-24,obj_star_event);
	    new_obj.col=colour;
	}


}
