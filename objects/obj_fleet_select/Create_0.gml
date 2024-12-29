owner = 0;
target = 0;
escort = 0;
frigate = 0;
capital = 0;
selection_window = new DataSlate();
//TODO make this a built in part of the data_slate object
selection_window.currently_entered=false;
currently_entered = false;
fleet_minimized=false;
fleet_all=true;
screen_expansion=20;
star_travel = [];

void_x=0;
void_y=0;
void_wid=0;
void_hei=0;
player_fleet=false;

selection_window.inside_method = function(){
	var mnz=0;
	var xx = selection_window.XX;
	var yy = selection_window.YY;
	draw_set_font(fnt_40k_14);
	var center_draw = xx + (selection_window.width/2);
	var width = selection_window.width;
	var height = selection_window.height;

    // draw_text(view_xview[0]+46,view_yview[0]+117,"Title");
    // draw_text(view_xview[0]+46,view_yview[0]+142,"1#2#3#4#5#6#7#8#9#10#11#1#13#14#15#16#17#18#19#20#21#22#23#24#25");    

    var type="capital",lines=0,posi=-1,colu=1,x3=48,y3=60,escorts,frigates,capitals,ty=0,current_ship=0,current_fleet=0,name="",sal=0,selection_box,scale=1,void_h=122,shew,ship_health=0;
    escorts=escort;
    frigates=frigate;
    capitals=capital;

    current_fleet=instance_nearest(x,y,obj_p_fleet);

    if (escorts>0) then ty++;
    if (frigates>0) then ty++;
    if (capitals>0) then ty++;
	draw_set_halign(fa_center);
	var set = "capitol";
	var fleet_sel = "[X]";
    if (!fleet_all) then fleet_sel = "[ ]";

    var fleet_all_click = false;
    if (!fleet_minimized){
    	if (point_and_click(draw_unit_buttons([xx+width-60, yy+40], fleet_sel,[1,1],c_red))){
    		fleet_all = fleet_all==1?0:1;
    		fleet_all_click=true;  		
    	}
    }
	draw_set_halign(fa_center);	    	
	var ship_type,current_ship, sel_set, full_id;
	if (screen_expansion>0){
	    for(var j=0; j<(escorts+frigates+capitals); j++){
	    	draw_set_color(c_gray);
	        y3+=20;
	        if (y3>height-5) then break;
	        lines++;
	        posi++;
	        scale=1;
	        shew=1;
	        ship_health=100;
	        if (colu==1) then void_h=min(void_h+20,560);
        
	        if (posi==0){
	            if (mnz=0) then draw_text(center_draw,yy+y3,string_hash_to_newline("=Capital Ships="));
	            y3+=20;
	            if (y3>height-50) then break;
	            set = "capitol";
	        }

	        if (posi==capitals) and (frigates>0){
	        	y3+=20;
	        	if (y3>height-50) then break;
	        	if (mnz=0) then draw_text(center_draw,yy+y3,string_hash_to_newline("=Frigates="));
	        	y3+=20;
	        	if (y3>height-50) then break;

	        	set = "frigate";
	        }
	        if (posi==capitals+frigates) and (escorts>0){
	        	y3+=20;
	        	if (y3>height-50) then break;
	        	if (mnz=0) then draw_text(center_draw,yy+y3,string_hash_to_newline("=Escorts="));
	        	y3+=20;
	        	if (y3>height-50) then break;
	        	set = "escort";
	        }
	        switch(set){
	        	case "capitol":
	        		current_ship=posi;
	        		if (current_ship<array_length(current_fleet.capital)){
		        		ship_type = current_fleet.capital;
		        		ship_select = current_fleet.capital_sel[current_ship];
		        		full_id = current_fleet.capital_num[current_ship];
	        		}
	        		break;
	        	case "frigate":
		        	ship_type = current_fleet.frigate;
		        	current_ship=posi-capitals;
		        	if (current_ship<array_length(current_fleet.frigate)){
			        	ship_select = current_fleet.frigate_sel[current_ship];
			        	full_id = current_fleet.frigate_num[current_ship];
		        	}
		        	break;	        		
	        	case "escort":
		        	ship_type = current_fleet.escort;
	        		current_ship=posi-(capitals+frigates);
	        		if (current_ship<array_length(current_fleet.escort)){
		        		ship_select = current_fleet.escort_sel[current_ship];
		        		full_id = current_fleet.escort_num[current_ship];
	        		}
		        	break;					        	
	        }
	        if (fleet_all_click) then ship_select=fleet_all;
        
	        /*if (y3>670) and (posi<=escorts+frigates+capitals){
	            lines=1;
	            y3=30;
	            x3+=223;
	            posi++;
	            colu++;
	        }*/
        
	        if (posi<=escorts+frigates+capitals) && is_array(ship_type){
	            name=ship_type[current_ship];
	            if (string_width(name)*scale>179){
	            	for (var i=0;i<9;i++){
	            		if (string_width(name)*scale>179) then scale-=0.05;
	            	}
	            }
	            if (scr_hit(xx+10,yy+y3,xx+width-10,yy+y3+18)){
	                if (string_width(name)*scale>135){
	                	for (var i=0;i<9;i++){
	                		if (string_width(name)*scale>135) then scale-=0.05;
	                	}
	                }
	                shew=2;
	            }
	            if (point_and_click([xx+10,yy+y3,xx+width-10,yy+y3+18])){
                    if (!(obj_controller.fest_scheduled>0 && obj_controller.fest_sid==full_id)){
	                    if (ship_select==1){
	                        ship_select=0;
	                    }else {
	                        ship_select=1;
	                    }
                	}
	            }
	            if (obj_ini.ship_maxhp[current_ship]>0){
	            	ship_health=round((obj_ini.ship_hp[current_ship]/obj_ini.ship_maxhp[current_ship])*100);
	            }

	            if (ship_select==0){
	            	selection_box="[ ]";
	            }else if (ship_select==1){ 
	            	selection_box="[x] ";
	            }
	            if (mnz==0){
	            	draw_text(xx+width-25,yy+y3,selection_box);
	            	if (shew==2) then draw_text(xx+width-60,yy+y3,$"{ship_health}%");
	            }
	            if (ship_health<=60) and (ship_health>40) then draw_set_color(c_yellow);
	            if (ship_health<=40) and (ship_health>20) then draw_set_color(c_orange);
	            if (ship_health<=20) then draw_set_color(c_red);
	            if (mnz=0) then draw_text_transformed(center_draw,yy+y3,name,scale,1,0);
	            draw_set_color(c_gray);
	        }
	        switch(set){
	        	case "capitol":
	        		current_fleet.capital_sel[current_ship] = ship_select;
	        		break;
	        	case "frigate":
		        	current_fleet.frigate_sel[current_ship] = ship_select;
		        	break;	        		
	        	case "escort":
		        	current_fleet.escort_sel[current_ship] = ship_select;
		        	break;					        	
	        }			        
	    }
	}
    selection_window.currently_entered = scr_hit([xx,yy, xx+width, yy+selection_window.height]);
}
