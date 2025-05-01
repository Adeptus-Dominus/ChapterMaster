


function broadside_movement(){
    if (target!=0) and (action="broadside") and (target_distance>closing_distance){
        if (y>=target.y){
        	target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        }
        if (y<target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y>target.y) and (target_distance>closing_distance){
        	direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2);
        }
        if (y<target.y) and (target_distance>closing_distance){
        	direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction+90),.2);
        }
        if (turn_bonus>1){
            if (y<target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x+lengthdir_x(64,target.direction-180),y,target.x,target.y+lengthdir_y(128,target.direction+90),.2);
        }
    }	
}

function flank_movement(){
    if (target!=0) and (action="flank") and (target_distance>closing_distance){
        if (y>=target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y<target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y>target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);
        if (y<target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);
    }	
}

function calculate_closing_distance_and_base_attack(){

}

function cooldown_ship_weapons(){
	for (var i=0;i<array_length(cooldown);i++){
        if (cooldown[i]>0){
            cooldown[i]--;
        }
    }
}


function destroy_ship_and_leave_husk(){
    image_alpha=0.5;
    
    if (owner != eFACTION.Tyranids){
        husk=instance_create(x,y,obj_en_husk);
        husk.sprite_index=sprite_index;
        husk.direction=direction;
        husk.image_angle=image_angle;
        husk.depth=depth;
        husk.image_speed=0;
        for(var i=0; i<choose(4,5,6); i++){
            explo=instance_create(x,y,obj_explosion);
            explo.image_xscale=0.5;
            explo.image_yscale=0.5;
            explo.x+=random_range(sprite_width*0.25,sprite_width*-0.25);
            explo.y+=random_range(sprite_width*0.25,sprite_width*-0.25);
        }
    }
    if (owner == eFACTION.Tyranids) then effect_create_above(ef_firework,x,y,1,c_purple);
    instance_destroy();	
}

/// draw_arc(x1,y1,x2,y2,x3,y3,x4,y4,precision)
//
//  Draws an arc of an ellipse mimicking draw_arc() from GM5. It also mimics
//  draw_ellipse() from GM6 in that it uses a primitive drawn with limited
//  resolution. The arc is drawn following the perimeter of the ellipse, 
//  counterclockwise, from the starting point to the ending point.
//  The starting point is the intersection of the ellipse with the ray 
//  extending from the center point and passing through the point (x3,y3).
//  The ending point is the intersection of the ellipse with the ray
//  extending from the center through the point (x4,y4).
//
//      x1,y1       1st corner of bounding rectangle, real
//      x2,y2       2nd corner of bounding rectangle, real
//      x3,y3       determines starting point, real
//      x4,y4       determines ending point, real
//      precision   number of segments a full ellipse would be drawn with,
//                  [4..64] divisible by 4, default 24, real (optional)
//
/// GMLscripts.com/license
function draw_arc(x1,y1,x2,y2,x3,y3,x4,y4,precision){
    if (precision == 0) precision = 24;
    var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
    res = 360 / min(max(4,4*(precision div 4)),64);
    xm = (x1+x2)/2;
    ym = (y1+y2)/2;
    xr = abs(x2-x1)/2;
    yr = abs(y2-y1)/2;
    if (xr > 0) r = yr/xr;
    else r = 0;
    a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
    a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
    if (a2<a1) a2 += 360;
    draw_primitive_begin(pr_linestrip);
    sx = xm+lengthdir_x(xr,a1);
    sy = ym+lengthdir_y(yr,a1);
    draw_vertex(sx,sy);
    for (a=res*(a1 div res + 1); a<a2; a+=res) {
        sx = xm+lengthdir_x(xr,a);
        sy = ym+lengthdir_y(yr,a);
        draw_vertex(sx,sy);
    }
    sx = xm+lengthdir_x(xr,a2);
    sy = ym+lengthdir_y(yr,a2);
    draw_vertex(sx,sy);
    draw_primitive_end();
    return 0;
}

function facing_weapon_angle(facing){
	var _direct_ = direction;
	switch (facing){
		case "right":
			_direct_+=90;
		case "left":
			_direct_-=90;
		default:
			break;
	}
}

function radians(deg){
	return deg * pi/180;
}
function
function draw_weapon_firing_arc(wep_id){
	var _tangent_direction  = facing_weapon_angle(weapon_facing[wep_id]);
	var max_distance = weapon_range[wep_id];
	var _angle_radians = radians(_tangent_direction);
	var _final_x = x + (max_distance * cos(_angle_radians));
	var _final_y = y + (max_distance * sin(_angle_radians));

	var _start_draw_rad = 
	var _start_x = 
	draw_arc(x, y, _final_x,_final_y )
}
function create_ship_projectile(wep_id){
	var wep = weapon[wep_id];
	var facing=weapon_facing[wep_id],ammo=weapon_ammo[wep_id],range=weapon_range[wep_id];
	var dam=weapon_dam[wep_id];
	if (string_count("orpedo",wep)=0) and (string_count("Interceptor",wep)=0) and (string_count("ommerz",wep)=0) and (string_count("Claws",wep)=0) and (string_count("endrils",wep)=0) and (ok=3) and (owner != eFACTION.Necrons){
        bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_en_round);
        bull.speed=20;
        bull.dam=dam;
        if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
        if (facing!="front"){
        	bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
        }
        if (string_count("ova",wep)=1){
        	bull.image_xscale=2;
        	bull.image_yscale=2;
        }
        else if (string_count("eavy Gunz",wep)=1){
        	bull.image_xscale=1.5;
        	bull.image_yscale=1.5;
        }
        else if (string_count("Lance",wep)=1){
        	bull.sprite_index=spr_ground_las;
        	bull.image_xscale=1.5;
        	bull.image_yscale=1.5;
        }
        else if (string_count("Ion",wep)=1){
        	bull.sprite_index=spr_pulse;
        	bull.image_xscale=1.5;
        	bull.image_yscale=1.5;
        }
        else if (string_count("Rail",wep)=1){
        	bull.sprite_index=spr_railgun;
        	bull.image_xscale=1.5;
        	bull.image_yscale=1.5;
        }
        else if (string_count("Gravitic",wep)=1){
        	bull.image_xscale=2;
        	bull.image_yscale=2;
        }
        else if (string_count("Plasma",wep)=1){
        	bull.sprite_index=spr_ground_plasma;
        	bull.image_xscale=2;
        	bullimage_yscale=2;
        	bull.speed=15;
        }
        else if (string_count("Pyro-Acid",wep)=1){
        	bull.sprite_index=spr_glob;
        	bull.image_xscale=2;
        	bullimage_yscale=2;
        }
        
        if (string_count("Weapons",wep)=1) and (owner = eFACTION.Eldar){
        	bull.sprite_index=spr_ground_las;
        	bull.image_xscale=2;
        	bull.image_yscale=2;
        }
        if (string_count("Pulse",wep)=1) and (owner = eFACTION.Eldar){
        	bull.sprite_index=spr_pulse;
        	bull.image_xscale=1.5;
        	bull.image_yscale=1.5;
        }
        
    }
    if (string_count("orpedo",wep)=1) and (ok=3) and (owner != eFACTION.Necrons){
        if (class!="Ravager"){
            bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_round);
            bull.speed=10;
            bull.direction=direction;
            bull.sprite_index=spr_torpedo;
            bull.dam=dam;
        }
        bull=instance_create(x,y+lengthdir_y(-10,direction+90),obj_en_round);
        bull.speed=10;
        bull.direction=direction;
        bull.sprite_index=spr_torpedo;
        bull.dam=dam;
        bull=instance_create(x,y+lengthdir_y(10,direction+90),obj_en_round);
        bull.speed=10;
        bull.direction=direction;
        bull.sprite_index=spr_torpedo;
        bull.dam=dam;
        
        if (class!="Ravager"){
            bull=instance_create(x,y+lengthdir_y(30,direction+90),obj_en_round);
            bull.speed=10;
            bull.direction=direction;
            bull.sprite_index=spr_torpedo;
            bull.dam=dam;
        }
        
    }
    
    if (wep="Lightning Arc"){lightning=10;
        if (target.shields>0){
            if (class="Cairn Class") or (class="Reaper Class") then target.shields-=20;
            else{target.shields-=20;
            }
        }
        if (target.shields<=0){
            if (class="Cairn Class") or (class="Reaper Class") then target.hp-=10;
            else{target.hp-=10;
            }
        }
    }
    if (wep="Gauss Particle Whip"){whip=15;
        if (target.shields>0) then target.shields-=dam;
        if (target.shields<=0) then target.hp-=dam;
    }
    if (wep="Star Pulse Generator") and (ok=3) and (instance_exists(target)){
        bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_en_pulse);
        bull.speed=20;
        if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
        if (facing!="front"){
        	bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
        }
        bull.target_x=target.x;
        bull.target_y=target.y;
    }
    
    
    
    if ((string_count("Claws",wep)=1) or (string_count("endrils",wep)=1)) and (ok=3){
        if (target.shields<=0) then target.hp-=weapon_dam[wep_id];
        if (target.shields>0) then target.shields-=weapon_dam[wep_id];
    }
    if ((string_count("Interceptor",wep)=1) or (string_count("ommerz",wep)=1) or (string_count("Manta",wep)=1) or (string_count("Glands",wep)=1) or (string_count("Eldar Launch",wep)=1)) and (ok=3){
        bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_in);
        bull.direction=self.direction;
        bull.owner=self.owner;
    }	
}


function fire_ship_weapon(wep_id){
	var wep = weapon[wep_id];
	var facing=weapon_facing[wep_id],ammo=weapon_ammo[wep_id],range=weapon_range[wep_id];
	var dam=weapon_dam[wep_id];

    //weapon[wep_id]=0;weapon_ammo[wep_id]=0;weapon_range[wep_id]=0;
    facing = weapon_facing[wep_id];
    if (cooldown[wep_id]<=0) and (weapon[wep_id]!="") and (weapon_ammo[wep_id]>0) then ok=1;
     if (!ok) {
     	return 0;
     }
    targe=target;
    if (facing="front") and (front=1) then ok=2;
    if (facing="most") then ok=2;
    
    
    /*
    if (facing="right") then targe=target_r;
    if (facing="left") then targe=target_l;    
    if ((facing="front") or (facing="most")) and (front=1) then ok=2;
    if (facing="right") or (facing="most") and (right=1) then ok=2;
    if (facing="left") or (facing="most") and (left=1) then ok=2;
    */
    if (facing="special") then ok=2;
    if (!instance_exists(targe)) then exit;
    dist=point_distance(x,y,targe.x,targe.y);

    if (facing="right") and (point_direction(x,y,target_r.x,target_r.y)<337) and (point_direction(x,y,target_r.x,target_r.y)>203) then ok=2;
    if (facing="left") and (point_direction(x,y,target_r.x,target_r.y)>22) and (point_direction(x,y,target_r.x,target_r.y)<157) then ok=2;
    
    /*var re_deh;re_deh=relative_direction(direction,target.direction);
    if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
    */
        
    
    
    if (ok=2) and (dist<(range+(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index))))){
        if (ammo>0) and (ammo<900) then ammo-=1;
        weapon_ammo[wep_id]=ammo;
        cooldown[wep_id]=weapon_cooldown[wep_id];
        wep=weapon[wep_id];
        dam=weapon_dam[wep_id];
        
        // if (f=3) and (ship_id=2) then show_message("ammo: "+string(ammo)+" | range: "+string(range));
        
        if (ammo<0) then ok=0;
        ok=3;
        
        create_ship_projectile(wep_id);
    }
}





