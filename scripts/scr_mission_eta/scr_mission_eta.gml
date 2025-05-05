/// @description returns the estimated time to complete a mission based on how far away it is and what the mission type is
/// @param {Real} star_x x coord where the mission is
/// @param {Real} star_y y coord where the mission is	
/// @param {Real} type 1: fly to, 2: marines, 3: marines + stay for some turns
/// @param {Real} leeway number of turns to add on top of the eta.
function scr_mission_eta(star_x, star_y, type=1, leeway = 10) {

	// argument0: x
	// argument1: y
	// argument2: type              1: fly to       2: marines      3: requires a couple of turns + marines

	// round(point_distance(flit.x,flit.y,you2.x,you2.y)/48)+2



	var eta1=99;

	if (instance_exists(obj_p_fleet)){
	    if (type=1){
			var nearest_fleet = get_nearest_player_fleet(star_x, star_y);
			if (nearest_fleet != "none"){
				eta1 = get_viable_travel_time(leeway, nearest_fleet.x, nearest_fleet.y, star_x, star_y, nearest_fleet, false);
			}
	        // n1=instance_nearest(x,y,obj_p_fleet);
	        // with(n1){y-=3000;}
	        // n2=instance_nearest(x,y,obj_p_fleet);
	        // with(n1){y+=3000;}
        
	        // eta1=((point_distance(star_x,star_y,n1.x,n1.y)+point_distance(star_x,star_y,n2.x,n2.y))/2)/48;
	        // eta1+=2+choose(-1,0,0,0,1,2);
	    }

		/// None of this is used anywhere it seems
	    // if (type>1){
	    //     with(obj_p_fleet){
	    //         var good,i;good=0;i=0;
            	
	    //         repeat(50){
	    //         	i+=1;
	    //             if (i<=20){if (capital[i]!="") and (obj_ini.ship_carrying[capital_num[i]]>0) then good=1;}
	    //             if (frigate[i]!="") and (obj_ini.ship_carrying[frigate_num[i]]>0) then good=1;
	    //             if (escort[i]!="") and (obj_ini.ship_carrying[escort_num[i]]>0) then good=1;
	    //         }
	    //         if (good>0) then instance_create(x,y,obj_temp_inq);
	    //     }
        
	    //     if (instance_exists(obj_temp_inq)){
	    //         n1=instance_nearest(x,y,obj_temp_inq);
	    //         with(n1){y-=3000;}
	    //         n2=instance_nearest(x,y,obj_temp_inq);
	    //         with(n1){y+=3000;}
            
	    //         eta1=((point_distance(star_x,star_y,n1.x,n1.y)+point_distance(star_x,star_y,n2.x,n2.y))/2)/48;
	    //         eta1+=2+choose(-1,0,0,0,1,2);
	    //         if (type=3) then eta1+=choose(1,2,3);
	    //         with(obj_temp_inq){instance_destroy();}
	    //     }
	    //     if (!instance_exists(obj_temp_inq)) then eta1=floor(random_range(12,26))+1;
	    // }
	}
	if (!instance_exists(obj_p_fleet)) then eta1=floor(random_range(12,26))+1;

	return(eta1);


}
