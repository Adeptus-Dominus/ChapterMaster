function scr_scrollbar(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	// argument0 : x1
	// argument1: y1
	// argument2: x2
	// argument3: y2
	// argument4: see_size
	// argument5: total maximum value
	// argument6: current_position


	if (argument5!=0) and (argument5>argument4){










	var xx,yy,x1,x2,y1,y2;
	var siz1, siz2, siz3;
	// draw_set_color(38144);
	xx=0;yy=0;x1=0;x2=0;y1=0;y2=0;temp1=0;temp2=0;
	siz1=0;siz2=0;siz3=0;

	xx=__view_get( e__VW.XView, 0 )+0;
	yy=__view_get( e__VW.YView, 0 )+0;

	siz1=argument3-argument1;// know the size of the total scroll area
	siz2=(argument4/argument5)*siz1;// know the relative size of the bar
	siz3=(argument6/argument5)*siz1;// know the pre-space before the bar is drawn






	    if (!instance_exists(obj_controller)) and (instance_exists(obj_creation)){
        
	        var checka=0;
	        if (!mouse_button_held(mb_left)) and (obj_creation.scrollbar_engaged=1) then obj_creation.scrollbar_engaged=0;
	        if (mouse_button_held(mb_left)) and (mouse_x>=xx+argument0) and (mouse_y>=yy+argument1) and (mouse_x<xx+argument2) and (mouse_y<yy+argument3) then obj_creation.scrollbar_engaged=1;
        
	        checka=1;
        
	        if (obj_creation.scrollbar_engaged=1) and (checka>0){
	            var click_y,center,ratio,ss,tmv,cp;
	            ratio=0;ss=0;tmv=0;cp=0;
            
	            click_y=window_mouse_get_y();
            
	            center=click_y-(siz2/2);
            
	            if (center<argument1) then center=argument1;
	            if (center>argument3-(siz2)) then center=argument3-(siz2);
            
	            ratio=(center-argument1)/(argument3-argument1);
            
	            draw_rectangle(xx+argument0,yy+center,xx+argument2,yy+center+siz2,0);
	            exit;
	        }
    
    
	        if (argument5<argument4){siz3=0;siz2=siz1;}
        
	        draw_rectangle(xx+argument0,yy+argument1+siz3,xx+argument2,yy+argument1+siz3+siz2,0);
    
	    }
    
    
    


	    if (instance_exists(obj_controller)){
        
	        var checka=0;
	        if (!mouse_button_held(mb_left)) and (obj_controller.scrollbar_engaged=1) then obj_controller.scrollbar_engaged=0;
	        if (mouse_button_held(mb_left)) and (mouse_x>=xx+argument0) and (mouse_y>=yy+argument1) and (mouse_x<xx+argument2) and (mouse_y<yy+argument3) then obj_controller.scrollbar_engaged=1;
        
        
	        if (obj_controller.managing>0 || obj_controller.managing=-1) and (obj_controller.menu!=30) and (obj_controller.man_max-MANAGE_MAN_SEE>-1){checka=1;}
	        if (instance_exists(obj_popup)){if (obj_popup.type=8) and (obj_popup.target_comp>=0){if (obj_controller.man_max-MANAGE_MAN_SEE>-1){checka=1;}}}
        
        
	        if (obj_controller.scrollbar_engaged=1) and (checka>0){
	            var click_y,center,ratio,ss,tmv,cp;
	            ratio=0;ss=0;tmv=0;cp=0;

	            click_y=window_mouse_get_y();
            
	            center=click_y-(siz2/2);
            
	            if (center<argument1) then center=argument1;
	            if (center>argument3-(siz2)) then center=argument3-(siz2);
            
	            ratio=(center-argument1)/(argument3-argument1);
            
	            // draw_set_font(fnt_large);draw_set_color(c_red);draw_text(view_xview[0]+320,view_yview[0]+240,ratio);
	            // draw_set_color(38144);
            
	            if (checka=1){
	                obj_controller.man_current=floor((obj_controller.man_max)*ratio);
                
	                if (obj_controller.man_current>(obj_controller.man_max-MANAGE_MAN_SEE)) then obj_controller.man_current=(obj_controller.man_max-MANAGE_MAN_SEE);
                
	                if (obj_controller.man_current<0) then obj_controller.man_current=0;
	            }
            
	            draw_rectangle(xx+argument0,yy+center,xx+argument2,yy+center+siz2,0);
	            exit;
	        }
    
    
	        if (argument5<argument4){
	        	siz3=0;
	        	siz2=siz1;
	        }
    
	        draw_rectangle(xx+argument0,yy+argument1+siz3,xx+argument2,yy+argument1+siz3+siz2,0);
    
	    }


	}


}


function ScrollableContainer(_width, _height) constructor {
    surface = -1;
    surface_width = 0;
    surface_height = 0;
    
    width = _width;
    height = _height;

    scroll_offset = 0;
    scrollbar_width = 20;
    dragging = false;
    drag_offset = 0;
    
    pos_x = 0;
    pos_y = 0;
    
    static start_draw_to_surface = function(_height) {
        if (!surface_exists(surface)) {
            surface = surface_create(width, _height);
			surface_width = surface_get_width(surface);
            surface_height = surface_get_height(surface);
        }
		surface_set_target(surface);
        draw_clear_alpha(c_white, 0);
    };

	static stop_draw_to_surface = function() {
        surface_reset_target();
    };

	static cleanup = function() {
        if (!surface_exists(surface)) {
			return;
		}
		surface_clear_and_free(surface);
    };

    static resize = function(_width, _height) {
		width = _width;
		height = _height;
    };
    
    static update = function() {
        if (!surface_exists(surface)) {
			return;
		}
        
        var grip_height = max((height / surface_height) * height, 32);
        var scroll_area = height - grip_height;
        var grip_y = (scroll_offset / (surface_height - height)) * scroll_area;
        
        var grip_x1 = pos_x + width - scrollbar_width;
        var grip_x2 = pos_x + width;
        var grip_y1 = pos_y + grip_y;
        var grip_y2 = grip_y1 + grip_height;
        
        var _mouse_y = return_mouse_consts()[1];
        
        // Dragging
        if (mouse_check_button(mb_left)) {
            if (dragging) {
                var new_grip_y = clamp(_mouse_y - pos_y - drag_offset, 0, scroll_area);
                scroll_offset = (new_grip_y / scroll_area) * (surface_height - height);
            } 
            else if (scr_hit(grip_x1, grip_y1, grip_x2, grip_y2)) {
                dragging = true;
                drag_offset = _mouse_y - grip_y1;
            }
        } else {
            dragging = false;
        }
        
        // Mouse wheel (scroll up / down)
		var _scroll_speed = surface_height * 0.05;
        if (mouse_wheel_up()) {
			scroll_offset -= _scroll_speed;
		} else if (mouse_wheel_down()) {
			scroll_offset += _scroll_speed;
		}
        
        scroll_offset = clamp(scroll_offset, 0, surface_height - height);
    };
    
    static draw = function(_x, _y) {
        pos_x = _x;
        pos_y = _y;
        
        if (!surface_exists(surface)) {
			return;
		}

        update(); // Self-manages mouse & scroll logic
        
        var grip_height = max((height / surface_height) * height, 32);
        var scroll_area = height - grip_height;
        var grip_y = (scroll_offset / (surface_height - height)) * scroll_area;
        
        // Draw content
        draw_surface_part(surface, 0, scroll_offset, width - scrollbar_width, height, pos_x, pos_y);
        
        // Draw scrollbar background
        draw_set_color(c_black);
        draw_rectangle(pos_x + width - scrollbar_width, pos_y, pos_x + width, pos_y + height, false);
        
        // Draw scrollbar grip
        draw_set_color(CM_GREEN_COLOR);
        draw_rectangle(pos_x + width - scrollbar_width, pos_y + grip_y, pos_x + width, pos_y + grip_y + grip_height, false);
        
        draw_set_color(c_white); // Reset color after
    };
    
    static get_scroll_offset = function() {
        return scroll_offset;
    };

	static reset_scroll_offset = function() {
        scroll_offset = 0;
    };
}
