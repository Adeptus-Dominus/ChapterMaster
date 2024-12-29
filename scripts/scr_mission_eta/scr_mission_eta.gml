function scr_mission_eta(argument0, argument1, argument2) {

	// argument0: x
	// argument1: y
	// argument2: type              1: fly to       2: marines      3: requires a couple of turns + marines

	// round(point_distance(flit.x,flit.y,you2.x,you2.y)/48)+2

	var eta1,n1,n2;
	eta1=99;n1=0;n2=0;

	if (instance_exists(obj_p_fleet)){
	    if (argument2=1){
	        n1=instance_nearest(x,y,obj_p_fleet);
	        with(n1){y-=3000;}
	        n2=instance_nearest(x,y,obj_p_fleet);
	        with(n1){y+=3000;}
        
	        eta1=((point_distance(argument0,argument1,n1.x,n1.y)+point_distance(argument0,argument1,n2.x,n2.y))/2)/48;
	        eta1+=2+choose(-1,0,0,0,1,2);
	    }
	    if (argument2>1){
	        with(obj_p_fleet){
	            var good,i;good=0;i=0;
            	
	            repeat(50){
	            	i+=1;
	                if (i<=20){if (capital[i]!="") and (obj_ini.ship_carrying[capital_num[i]]>0) then good=1;}
	                if (frigate[i]!="") and (obj_ini.ship_carrying[frigate_num[i]]>0) then good=1;
	                if (escort[i]!="") and (obj_ini.ship_carrying[escort_num[i]]>0) then good=1;
	            }
	            if (good>0) then instance_create(x,y,obj_temp_inq);
	        }
        
	        if (instance_exists(obj_temp_inq)){
	            n1=instance_nearest(x,y,obj_temp_inq);
	            with(n1){y-=3000;}
	            n2=instance_nearest(x,y,obj_temp_inq);
	            with(n1){y+=3000;}
            
	            eta1=((point_distance(argument0,argument1,n1.x,n1.y)+point_distance(argument0,argument1,n2.x,n2.y))/2)/48;
	            eta1+=2+choose(-1,0,0,0,1,2);
	            if (argument2=3) then eta1+=choose(1,2,3);
	            with(obj_temp_inq){instance_destroy();}
	        }
	        if (!instance_exists(obj_temp_inq)) then eta1=floor(random_range(12,26))+1;
	    }
	}
	if (!instance_exists(obj_p_fleet)) then eta1=floor(random_range(12,26))+1;

	return(eta1);


}
