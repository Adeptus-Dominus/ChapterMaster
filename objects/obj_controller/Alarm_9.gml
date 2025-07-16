// Create an imperial fleet
with(obj_p_fleet){
    var steh=instance_nearest(x,y,obj_star);
	
	var choices = [
	  eFACTION.Player,
	  eFACTION.Imperium,
	  eFACTION.Mechanicus,
	  eFACTION.Inquisition,
	  eFACTION.Ecclesiarchy
	]

    for(var b=1; b<=4; b++) {
		var is_valid = array_contains(choices, steh.p_first[b])
        if is_valid and (steh.dispo[b]>-30) and (steh.dispo[b]<0) {
			var curr_imp_dispo = obj_controller.disposition[eFACTION.Imperium]
            steh.dispo[b]=min(obj_ini.imperium_disposition,curr_imp_dispo)+choose(-1,-2,-3,-4,0,1,2,3,4);
        }
    }
	if (steh.visited==0) {
		for(var planet_num = 1; planet_num<5; planet_num++) {
		    if (array_length(steh.p_feature[planet_num])!=0) {
				with(steh){
					scr_planetary_feature(planet_num);
				}
			}
		}
		steh.visited = 1
	}
}

with(obj_star){
    var sco=0;
	for(var o=1; o<=4; o++){
        if (p_type[o]="Hive") then sco+=3;
        if (p_type[o]="Temperate") then sco+=1;
    }
    if (sco>=4) then instance_create(x,y,obj_temp_inq);
}

if (instance_number(obj_temp_inq) < target_navy_number){
    with(obj_temp_inq) {
		instance_destroy();
	}
    with(obj_star) {
        var sco=0;
        for(var o=1; o<=planets; o++){
            if (p_type[o]="Hive") then sco+=3;
            if (p_type[o]="Temperate") then sco+=1;
        }
        if (sco>=3) then instance_create(x,y,obj_temp_inq);
    }
}
for(var i=0; i<30; i++){
    if (instance_number(obj_temp_inq) > target_navy_number){
        var kebob= instance_nearest(random(room_width),random(room_height),obj_temp_inq);
        with(kebob) {instance_destroy();}
    }
}

with(obj_temp_inq){
    var ii=0,nav=instance_create(x,y,obj_en_fleet);
    nav.owner=eFACTION.Imperium;
    nav.navy=1;
    
    nav.capital_number=choose(1,2,3);
    nav.frigate_number=(nav.capital_number*2)+3;
    nav.escort_number=12;
    nav.home_x=x;
    nav.home_y=y;
    nav.orbiting=instance_nearest(x,y,obj_star);
    nav.orbiting.present_fleet[eFACTION.Imperium] += 1;
    nav.warp_able=true;
    
    nav.image_speed=0;
    ii+=nav.capital_number-1;
    ii+=round((nav.frigate_number/2));
    ii+=round((nav.escort_number/4));
    if (ii<=1) and (nav.capital_number+nav.frigate_number+nav.escort_number>0) then ii=1;
    nav.image_index=ii;
    instance_destroy();
}

with(obj_en_fleet){
    if (owner== eFACTION.Imperium) and (navy==1){
        for(var i=1; i<=capital_number; i++){
            capital_max_imp[i]=(((floor(random(15))+1)*1000000)+15000000)*2;
            capital_imp[i]=capital_max_imp[i];
        }
        for(var i=1; i<=frigate_number; i++){
            frigate_max_imp[i]=(500000+(floor(random(50))+1)*10000)*2;
            frigate_imp[i]=frigate_max_imp[i];
        }
    }
}
