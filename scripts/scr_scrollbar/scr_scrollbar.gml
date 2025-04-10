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
	        if (obj_creation.mouse_left=0) and (obj_creation.scrollbar_engaged=1) then obj_creation.scrollbar_engaged=0;
	        if (obj_creation.mouse_left=1) and (mouse_x>=xx+argument0) and (mouse_y>=yy+argument1) and (mouse_x<xx+argument2) and (mouse_y<yy+argument3) then obj_creation.scrollbar_engaged=1;
        
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
	        if (obj_controller.mouse_left=0) and (obj_controller.scrollbar_engaged=1) then obj_controller.scrollbar_engaged=0;
	        if (obj_controller.mouse_left=1) and (mouse_x>=xx+argument0) and (mouse_y>=yy+argument1) and (mouse_x<xx+argument2) and (mouse_y<yy+argument3) then obj_controller.scrollbar_engaged=1;
        
        
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
