


function broadside_movement(){
	var _target_direction = target.direction;
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
	var _normal_target = false;
    if (target!=0 && action=="flank"){
    	if (!under_fire){
    		var _rel_direction = point_direction(target.x, target.y, x, y) - target.direction;
    		if (abs(_rel_direction) < 105){
    			var _attack_angle = target.direction + ((_rel_direction > 0) ? 105 : -105);
    			if (_attack_angle > 360){
    				_attack_angle -= 360;
    			} else if (_attack_angle< 0){
    				_attack_angle = 360 -_attack_angle;
    			}
    			var _flank_margin = closing_distance*2
	    		var _target_lock = [target.x + lengthdir_x(_flank_margin, _attack_angle), target.y + lengthdir_y(_flank_margin, _attack_angle)]
    			draw_targets = _target_lock;
    		    direction = turn_towards_point(direction, x,y,_target_lock[0],_target_lock[1],turning_speed);
    		    closing_distance = 0;
    		} else {
    			_normal_target = true;
    		}
    	} else {
    		_normal_target = true;
	    }
    }
    if (_normal_target ){
        if (y>=target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction-90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y<target.y) then target_distance=point_distance(x,y,target.x+lengthdir_x(64,target.direction-180),target.y+lengthdir_y(128,target.direction+90))-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        if (y>target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);
        if (y<target.y) and (target_distance>closing_distance) then direction=turn_towards_point(direction,x,y,target.x,target.y,turning_speed);    	
    }
}

function start_slowing_telemetry(distance_to_target, deceleration){
	var _start_slowing = false;
    if (speed>0){
        var _time_to_stop = (speed/deceleration);
        var _distance_traveled_while_slowing = speed*_time_to_stop+ ((1/2) * deceleration * sqr(_time_to_stop));
        
        if (distance_to_target - _distance_traveled_while_slowing < closing_distance){
            _start_slowing = true;
        }
    }

    return 	_start_slowing;

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
function draw_arc(x1,y1,x2,y2,x3,y3,x4,y4,precision=24){
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
			break;
		case "left":
			_direct_-=90;
			break;
		default:
			break;
	}
	return _direct_;
}

function point_on_circle(start_x, start_y, radius, angle){
	var _angle_radians = degtorad(angle);
	var _final_x = start_x + (radius * cos(_angle_radians));
	var _final_y = start_y + (radius * sin(_angle_radians));
	return [_final_x, _final_y];
}

function draw_weapon_firing_arc(wep_id){
    var _tangent_direction  = facing_weapon_angle(weapon_facing[wep_id]);
    var _max_distance = weapon_range[wep_id];

    var _left = x - _max_distance;
    var _top  = y - _max_distance;
    var _right = x + _max_distance;
    var _bottom = y + _max_distance;

    var _start_x = x + lengthdir_x(_max_distance, _tangent_direction - 20);
    var _start_y = y + lengthdir_y(_max_distance, _tangent_direction - 20);
    var _end_x   = x + lengthdir_x(_max_distance, _tangent_direction + 20);
    var _end_y   = y + lengthdir_y(_max_distance, _tangent_direction + 20);

    draw_arc(_left, _top, _right, _bottom, _start_x, _start_y, _end_x, _end_y);
    draw_line(x, y, _start_x, _start_y);
    draw_line(x, y, _end_x, _end_y);
}

function is_targeted(){
	var bullets = array_length(bullets_for);
	under_fire = false;
	for (var i=bullets-1;i>-1;i--){
		var _bullet = bullets_for[i];
		if (!instance_exists(_bullet)){
			array_delete(bullets_for, i, 1);
		} else {
			under_fire = true;
			break;
		}
	}
}

function create_ship_projectile(wep_id){
	var wep = weapon[wep_id];
	var facing=weapon_facing[wep_id],ammo=weapon_ammo[wep_id],range=weapon_range[wep_id];
	var dam=weapon_dam[wep_id];
	var bull = -1;
	if (string_count("orpedo",wep)=0) and (string_count("Interceptor",wep)=0) and (string_count("ommerz",wep)=0) and (string_count("Claws",wep)=0) and (string_count("endrils",wep)=0) && (owner != eFACTION.Necrons){
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
    if (string_count("orpedo",wep)=1)  and (owner != eFACTION.Necrons){
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
    if (wep="Star Pulse Generator") and (instance_exists(target)){
        bull=instance_create(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),obj_en_pulse);
        bull.speed=20;
        if (targe=target) then bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
        if (facing!="front"){
        	bull.direction=point_direction(x+lengthdir_x(32,direction),y+lengthdir_y(32,direction),target.x,target.y);
        }
        bull.target_x=target.x;
        bull.target_y=target.y;
    }
    
    
    
    if ((string_count("Claws",wep)=1) or (string_count("endrils",wep)=1)) {
        if (target.shields<=0) then target.hp-=weapon_dam[wep_id];
        if (target.shields>0) then target.shields-=weapon_dam[wep_id];
    }
    if ((string_count("Interceptor",wep)=1) or (string_count("ommerz",wep)=1) or (string_count("Manta",wep)=1) or (string_count("Glands",wep)=1) or (string_count("Eldar Launch",wep)=1)){
        bull=instance_create(x,y+lengthdir_y(-30,direction+90),obj_en_in);
        bull.direction=self.direction;
        bull.owner=self.owner;
    }
    if (instance_exists(bull)){
    	array_push(target.bullets_for, bull.id);
    }	
}


function fire_ship_weapon(wep_id){
	draw_set_alpha(1);
	draw_set_color(c_red); 
	var wep = weapon[wep_id];
	var facing=weapon_facing[wep_id],ammo=weapon_ammo[wep_id],range=weapon_range[wep_id];
	var dam=weapon_dam[wep_id];

    //weapon[wep_id]=0;weapon_ammo[wep_id]=0;weapon_range[wep_id]=0;
    facing = weapon_facing[wep_id];
    var ok = false;
    if (cooldown[wep_id]<=0 && weapon[wep_id]!="" && weapon_ammo[wep_id]>0) then ok=1;
     if (!ok) {
     	return 0;
     }
     front = true;
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
        
        create_ship_projectile(wep_id);
    }
}

global.ship_weapons_stats = {
	"Lance Battery" : {
		range : 300,
		dam : 14, 
		facing : "front",
		firing_arc : 12.5
	}
	"Nova Cannon": {
		range : 1500,
		dam : 34, 
		facing : "front",
		minrange : 300,
		cooldown : 120,	
		minrange : 300,
	},
	"Weapons Battery" : {
		facing : "most",
		cooldown : 20,
		dam : 20,
		firing_arc : 5,
	},
	"Light Weapons Battery" : {
		facing : "most",
		range : 300,
		cooldown : 30,
		dam : 8,
		firing_arc : 8,
	},
	"Gunz Battery" : {
		facing : "front",
		range : 300,
		cooldown : 30,
		dam : 8,
		firing_arc : 15,
	},
	"Heavy Gunz" : {
		weapon_facing : "most",
		dam : 12,
		range : 200,
		cooldown : 40,
	},
	"Bombardment Cannon"{
		facing : "front",
		dam : 12,
		range : 450,
		cooldown : 120,
		firing_arc : 4,
	},

	"Torpedoes" :{
		dam : 12,
		range : 450, 
		cooldown : 90,
	},

	"Interceptor Launch Bays" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 6,
		cooldown , 120,
	},
	"Fighta Bommerz":{
		facing : "special",
		weapon_range : 9999,
		ammo : 8,
		cooldown , 90,		
	}
	"Eldar Launch Bay" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 4,
		cooldown , 90,
	},
	"Pulsar Lances":{
		facing : "most",
		dam : 10,
		weapon_cooldown : 10,
	},
	"Pyro-acid Battery" : {
		facing : "most",
		dam : 8,
		range : 300,
	},
	"Feeder Tendrils" : {
		facing : "most",
		dam : 8,
		range : 100,
		firing_arc : 50,
	},
	"Bio-Plasma Discharge":{
		range : 200,
		cooldown : 60,
		dam : 6,
	},
	"Massive Claws" : {
		facing :"most",
		dam : 20,
		range : 64,
		cooldown : 60,
	}
	"Launch Glands" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 6,
		cooldown , 120,		
	}
}

global.ship_defualts  = {
	range : 600,
	facing : "front",
	cooldown : 30,
	minrange : 0,
	dam : 0,
	firing_arc : 12.5,
	ship : 0,
	ammo : -1,

}
function move_data_to_current_scope(struct, overide=true){
	var _data_names = struct_get_names(struct);
	for (var i=0;i<array_length(_data_names);i++){
		if (overide){
			self[$_data_names[i]] = struct[$ _data_names[i]];
		} else {
			if (!struct_exists(self, _data_names[i])){
				self[$_data_names[i]] = struct[$ _data_names[i]];
			}
		}
	}
}
function ShipWeapon(weapon_name, overide_data={}) constructor{
	if (struct_exists(ship_weapons_stats, weapon_name)){
		var _wep_data = ship_weapons_stats[$ weapon_name];
		move_data_to_current_scope(_wep_data);
	}
	move_data_to_current_scope(overide_data);
	move_data_to_current_scope(global.ship_defualts, false);
	name = weapon_name;
	cooldown_timer = 0;
}

function add_weapon_to_ship(weapon_name, overide_data={}){
	overide_data.ship = id;
	array_push(weapons, new ShipWeapon(weapon_name, overide_data));
}


function assign_ship_stats(){
	if (class="Apocalypse Class Battleship"){
	    sprite_index=spr_ship_apoc;
	    ship_size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=90;
	    armour_front=6;
	    armour_other=5;
	    weapons=4;
	    turrets=4;
	    capacity=150;
	    carrying=0;

	    add_weapon_to_ship("Lance Battery", {facing:"left"});
	    add_weapon_to_ship("Lance Battery", {facing:"right"});
	    add_weapon_to_ship("Nova Cannon");
	    add_weapon_to_ship("Weapons Battery");
	    
	}

	if (class="Nemesis Class Fleet Carrier"){sprite_index=spr_ship_nem;
	    sprite_index=spr_ship_nem;
	    ship_size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=85;
	    armour_front=5;
	    armour_other=5;
	    weapons=3;
	    turrets=5;
	    capacity=100;
	    carrying=24;
	    add_weapon_to_ship("Interceptor Launch Bays");
	    add_weapon_to_ship("Interceptor Launch Bays");
	    add_weapon_to_ship("Lance Battery");
	    
	}

	if (class="Avenger Class Grand Cruiser"){sprite_index=spr_ship_aven;
	    sprite_index=spr_ship_aven;
	    ship_size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    armour_other=5;
	    weapons=2;
	    turrets=3;
	    capacity=50;
	    add_weapon_to_ship("Lance Battery", {cooldown:30});
	    add_weapon_to_ship("Lance Battery", {cooldown:25, direction:"left"});
	    add_weapon_to_ship("Lance Battery", {cooldown:25, direction:"right"});
	    
	}

	if (class="Sword Class Frigate"){sprite_index=spr_ship_sword;
	    sprite_index=spr_ship_sword;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    armour_other=5;
	    weapons=1;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Weapons Battery", {weapon_range:300});
	    
	}



	// Eldar

	if (class="Void Stalker"){sprite_index=spr_ship_void;
	    ship_size=3;

	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=4;
	    weapons=3;
	    turrets=4;
	    capacity=150;
	    carrying=0;
	    
	    weapon[1]="Eldar Launch Bay";
	    weapon_facing[1]="special";
	    weapon_dam[1]=0;
	    weapon_range[1]=9999;
	    weapon_cooldown[1]=90;
	    weapon_ammo[1]=4;
	    
	    weapon[2]="Weapons Battery";
	    weapon_facing[2]="most";
	    weapon_dam[2]=14;
	    weapon_range[2]=600;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Pulsar Lances";
	    weapon_facing[3]="most";
	    weapon_dam[3]=10;
	    weapon_range[3]=600;
	    weapon_cooldown[3]=10;
	    
	    // weapon[4]="Torpedoes";
	    weapon_facing[4]="front";
	    weapon_dam[4]=12;
	    weapon_range[4]=450;
	    weapon_cooldown[4]=90;
	    
	}

	if (class="Shadow Class"){sprite_index=spr_ship_shadow;
	    ship_size=3;

	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    
	    armour_front=5;
	    armour_other=4;
	    weapons=2;
	    turrets=3;
	    capacity=100;
	    carrying=0;
	    
	    weapon[1]="Torpedoes";
	    weapon_facing[1]="front";
	    weapon_dam[1]=12;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=90;
	    
	    weapon[2]="Weapons Battery";
	    weapon_facing[2]="front";
	    weapon_dam[2]=10;
	    weapon_range[2]=450;
	    weapon_cooldown[2]=30;
	    
	}

	if (class="Hellebore"){sprite_index=spr_ship_hellebore;
	    ship_size=1;

	    name="";
	    hp=200;
	    maxhp=200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    
	    armour_front=5;
	    armour_other=4;
	    weapons=3;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Pulsar Lances";
	    weapon_facing[1]="front";
	    weapon_dam[1]=10;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=20;
	    
	    weapon[2]="Weapons Battery";
	    weapon_facing[2]="front";
	    weapon_dam[2]=8;
	    weapon_range[2]=450;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Eldar Launch Bay";
	    weapon_facing[3]="special";
	    weapon_dam[3]=0;
	    weapon_range[3]=9999;
	    weapon_cooldown[3]=90;
	    weapon_ammo[1]=1;
	    
	}

	if (class="Aconite"){sprite_index=spr_ship_aconite;
	    ship_size=1;

	    name="";
	    hp=200;
	    maxhp=200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    
	    armour_front=5;
	    armour_other=4;
	    weapons=3;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Weapons Battery";
	    weapon_facing[1]="front";
	    weapon_dam[1]=8;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=30;
	    
	}




	// Orks

	if (class="Dethdeala"){sprite_index=spr_ship_deth;
	    ship_size=3;

	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    
	    weapon[1]="Gunz Battery";
	    weapon_facing[1]="left";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Gunz Battery";
	    weapon_facing[2]="right";
	    weapon_dam[2]=8;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Bombardment Cannon";
	    weapon_facing[3]="front";
	    weapon_dam[3]=12;
	    weapon_range[3]=450;
	    weapon_cooldown[3]=120;
	    
	    weapon[4]="Heavy Gunz";
	    weapon_facing[4]="most";
	    weapon_dam[4]=12;
	    weapon_range[4]=200;
	    weapon_cooldown[4]=40;
	    
	    weapon[5]="Fighta Bommerz";
	    weapon_facing[5]="special";
	    weapon_dam[5]=0;
	    weapon_range[5]=9999;
	    weapon_cooldown[5]=90;
	        
	}

	if (class="Gorbag's Revenge"){sprite_index=spr_ship_gorbag;
	    ship_size=3;

	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    
	    weapon[1]="Gunz Battery";
	    weapon_facing[1]="front";
	    weapon_dam[1]=8;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Torpedoes";
	    weapon_facing[2]="front";
	    weapon_dam[2]=12;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=120;
	    
	    weapon[3]="Heavy Gunz";
	    weapon_facing[3]="most";
	    weapon_dam[3]=12;
	    weapon_range[3]=200;
	    weapon_cooldown[3]=40;
	    
	    weapon[4]="Fighta Bommerz";
	    weapon_facing[4]="special";
	    weapon_dam[4]=0;
	    weapon_ammo[4]=3;
	    weapon_range[4]=9999;
	    weapon_cooldown[4]=90;
	    
	    weapon[5]="Fighta Bommerz";
	    weapon_facing[5]="special";
	    weapon_dam[5]=0;
	    weapon_ammo[5]=3;
	    weapon_range[5]=9999;
	    weapon_cooldown[5]=90;
	    cooldown[5]=30;
	    
	}

	if (class="Kroolboy") or (class="Slamblasta"){ship_size=3;
	    sprite_index=spr_ship_krool;

	    if (class="Kroolboy") then sprite_index=spr_ship_krool;
	    
	    if (class="Slamblasta") then sprite_index=spr_ship_slam;
	    
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=3;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    
	    weapon[1]="Fighta Bommerz";
	    weapon_facing[1]="special";
	    weapon_dam[1]=0;
	    weapon_ammo[1]=3;
	    weapon_range[1]=9999;
	    weapon_cooldown[1]=120;
	    
	    weapon[2]="Gunz Battery";
	    weapon_facing[2]="most";
	    weapon_dam[2]=8;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Heavy Gunz";
	    weapon_facing[3]="most";
	    weapon_dam[3]=12;
	    weapon_range[3]=200;
	    weapon_cooldown[3]=40;
	    
	}

	if (class="Battlekroozer"){sprite_index=spr_ship_kroozer;
	    ship_size=3;

	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    
	    weapon[1]="Gunz Battery";
	    weapon_facing[1]="most";
	    weapon_dam[1]=8;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Heavy Gunz";
	    weapon_facing[2]="left";
	    weapon_dam[2]=12;
	    weapon_range[2]=200;
	    weapon_cooldown[2]=40;
	    
	    weapon[3]="Heavy Gunz";
	    weapon_facing[3]="right";
	    weapon_dam[3]=12;
	    weapon_range[3]=200;
	    weapon_cooldown[3]=40;
	    
	    weapon[4]="Fighta Bommerz";
	    weapon_facing[4]="special";
	    weapon_dam[4]=0;
	    weapon_ammo[4]=3;
	    weapon_range[4]=9999;
	    weapon_cooldown[4]=90;
	    
	    weapon[5]="Fighta Bommerz";
	    weapon_facing[5]="special";
	    weapon_dam[5]=0;
	    weapon_ammo[5]=3;
	    weapon_range[5]=9999;
	    weapon_cooldown[5]=90;
	    cooldown[5]=30;
	    
	}

	if (class="Ravager"){sprite_index=spr_ship_ravager;
	    ship_size=1;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    
	    armour_front=6;
	    armour_other=4;
	    weapons=2;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Gunz Battery";
	    weapon_facing[1]="front";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Torpedoes";
	    weapon_facing[2]="front";
	    weapon_dam[2]=12;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=120;
	    
	}

	// Tau

	if (class="Custodian"){sprite_index=spr_ship_custodian;
	    ship_size=3;

	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=4;
	    turrets=5;
	    capacity=1000;
	    carrying=0;
	    
	    weapon[1]="Gravitic launcher";
	    weapon_facing[1]="front";
	    weapon_dam[1]=12;
	    weapon_range[1]=400;
	    weapon_minrange[1]=200;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Railgun Battery";
	    weapon_facing[2]="most";
	    weapon_dam[2]=12;
	    weapon_range[2]=450;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Ion Cannons";
	    weapon_facing[3]="most";
	    weapon_dam[3]=8;
	    weapon_range[3]=300;
	    weapon_cooldown[3]=15;
	    
	    weapon[4]="Manta Launch Bay";
	    weapon_facing[4]="special";
	    weapon_dam[4]=0;
	    weapon_range[4]=9999;
	    weapon_cooldown[4]=90;
	    weapon_ammo[4]=4;
	    
	}

	if (class="Protector"){sprite_index=spr_ship_protector;
	    ship_size=2;

	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=4;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    
	    weapon[1]="Gravitic launcher";
	    weapon_facing[1]="front";
	    weapon_dam[1]=12;
	    weapon_range[1]=400;
	    weapon_minrange[1]=200;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Railgun Battery";
	    weapon_facing[2]="most";
	    weapon_dam[2]=10;
	    weapon_range[2]=450;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Ion Cannons";
	    weapon_facing[3]="most";
	    weapon_dam[3]=8;
	    weapon_range[3]=300;
	    weapon_cooldown[3]=15;
	    
	    weapon[4]="Manta Launch Bay";
	    weapon_facing[4]="special";
	    weapon_dam[4]=0;
	    weapon_range[4]=9999;
	    weapon_cooldown[4]=90;
	    weapon_ammo[4]=2;
	    
	}

	if (class="Emissary"){sprite_index=spr_ship_emissary;
	    ship_size=2;

	    name="";
	    hp=400;
	    maxhp=400;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=6;
	    armour_other=5;
	    weapons=4;
	    turrets=2;
	    capacity=100;
	    carrying=0;
	    
	    weapon[1]="Gravitic launcher";
	    weapon_facing[1]="front";
	    weapon_dam[1]=12;
	    weapon_range[1]=400;
	    weapon_minrange[1]=200;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Railgun Battery";
	    weapon_facing[2]="most";
	    weapon_dam[2]=10;
	    weapon_range[2]=450;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Ion Cannons";
	    weapon_facing[3]="most";
	    weapon_dam[3]=8;
	    weapon_range[3]=300;
	    weapon_cooldown[3]=15;
	    
	    weapon[4]="Manta Launch Bay";
	    weapon_facing[4]="special";
	    weapon_dam[4]=0;
	    weapon_range[4]=9999;
	    weapon_cooldown[4]=90;
	    weapon_ammo[4]=1;
	    
	}

	if (class="Warden"){sprite_index=spr_ship_warden;
	    ship_size=1;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    
	    armour_front=5;
	    armour_other=4;
	    weapons=2;
	    turrets=1;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Ion Cannon";
	    weapon_facing[1]="most";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=50;
	    
	    weapon[2]="Railgun Battery";
	    weapon_facing[2]="front";
	    weapon_dam[2]=10;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=60;
	    
	}

	if (class="Castellan"){sprite_index=spr_ship_castellan;
	    ship_size=1;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    
	    armour_front=5;
	    armour_other=4;
	    weapons=2;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Gravitic launcher";
	    weapon_facing[1]="front";
	    weapon_dam[1]=12;
	    weapon_range[1]=400;
	    weapon_minrange[1]=200;
	    weapon_cooldown[1]=40;
	    
	    weapon[2]="Railgun Battery";
	    weapon_facing[2]="front";
	    weapon_dam[2]=10;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=40;
	    
	}

	// Chaos

	if (class="Desecrator"){sprite_index=spr_ship_dese;
	    ship_size=3;

	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=90;
	    
	    armour_front=7;
	    armour_other=5;
	    weapons=5;
	    turrets=4;
	    capacity=150;
	    carrying=0;
	    
	    weapon[1]="Lance Battery";
	    weapon_facing[1]="left";
	    weapon_dam[1]=12;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Lance Battery";
	    weapon_facing[2]="right";
	    weapon_dam[2]=12;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=30;
	    
	    weapon[3]="Weapons Battery";
	    weapon_facing[3]="front";
	    weapon_dam[3]=18;
	    weapon_range[3]=600;
	    weapon_cooldown[3]=60;
	    
	    weapon[4]="Torpedoes";
	    weapon_facing[4]="front";
	    weapon_dam[4]=18;
	    weapon_range[4]=450;
	    weapon_cooldown[4]=120;
	    
	    weapon[5]="Fighta Bommerz";
	    weapon_facing[5]="special";
	    weapon_dam[5]=0;
	    weapon_range[5]=9999;
	    weapon_cooldown[5]=90;
	        
	}

	if (class="Avenger"){sprite_index=spr_ship_veng;
	    ship_size=2;

	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    
	    armour_front=5;
	    armour_other=5;
	    weapons=2;
	    turrets=3;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Lance Battery";
	    weapon_facing[1]="left";
	    weapon_dam[1]=12;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Lance Battery";
	    weapon_facing[2]="right";
	    weapon_dam[2]=12;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=30;
	    
	}

	if (class="Carnage") or (class="Daemon"){sprite_index=spr_ship_carnage;
	    ship_size=2;

	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    
	    armour_front=5;
	    armour_other=5;
	    weapons=3;
	    turrets=3;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Lance Battery";
	    weapon_facing[1]="most";
	    weapon_dam[1]=12;
	    weapon_range[1]=450;
	    weapon_cooldown[1]=30;
	    
	    weapon[2]="Weapons Battery";
	    weapon_facing[2]="left";
	    weapon_dam[2]=12;
	    weapon_range[2]=300;
	    weapon_cooldown[2]=45;
	    
	    weapon[3]="Weapons Battery";
	    weapon_facing[3]="right";
	    weapon_dam[3]=12;
	    weapon_range[3]=300;
	    weapon_cooldown[3]=45;
	    
	    if (class="Daemon"){sprite_index=spr_ship_daemon;
	        image_alpha=0.1;
	}
	}

	if (class="Iconoclast"){sprite_index=spr_ship_icono;
	    ship_size=1;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    
	    armour_front=7;
	    armour_other=4;
	    weapons=1;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    
	    weapon[1]="Weapons Battery";
	    weapon_facing[1]="most";
	    weapon_dam[1]=8;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=30;
	    
	}

	// Tyranids
	if (owner = eFACTION.Tyranids){
	    set_nid_ships();
	}

	// Necrons
	if (class="Cairn Class"){sprite_index=spr_ship_cairn;
	    ship_size=3;

	    name="";
	    hp=1100;
	    maxhp=1100;
	    conditions="";
	    shields=550;
	    maxshields=550;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=5;
	    weapons=3;
	    turrets=5;
	    capacity=800;
	    carrying=0;
	    
	    weapon[1]="Lightning Arc";
	    weapon_facing[1]="most";
	    weapon_dam[1]=0;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=15;
	    
	    weapon[2]="Star Pulse Generator";
	    weapon_facing[2]="front";
	    weapon_dam[2]=0;
	    weapon_range[2]=220;
	    weapon_cooldown[2]=210;
	    
	    weapon[3]="Gauss Particle Whip";
	    weapon_facing[3]="front";
	    weapon_dam[3]=30;
	    weapon_range[3]=450;
	    weapon_cooldown[3]=90;
	     
	}

	if (class="Reaper Class"){sprite_index=spr_ship_reaper;
	    ship_size=3;

	    name="";
	    hp=900;
	    maxhp=900;
	    conditions="";
	    shields=450;
	    maxshields=450;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=5;
	    weapons=3;
	    turrets=4;
	    capacity=500;
	    carrying=0;
	    
	    weapon[1]="Lightning Arc";
	    weapon_facing[1]="most";
	    weapon_dam[1]=0;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=15;
	    
	    weapon[2]="Star Pulse Generator";
	    weapon_facing[2]="front";
	    weapon_dam[2]=0;
	    weapon_range[2]=220;
	    weapon_cooldown[2]=210;
	    
	    weapon[3]="Gauss Particle Whip";
	    weapon_facing[3]="front";
	    weapon_dam[3]=30;
	    weapon_range[3]=450;
	    weapon_cooldown[3]=90;
	     
	}

	if (class="Shroud Class"){ship_size=2;
	    sprite_index=spr_ship_shroud;

	    name="";
	    hp=400;
	    maxhp=400;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=5;
	    weapons=1;
	    turrets=2;
	    capacity=250;
	    carrying=0;
	    
	    weapon[1]="Lightning Arc";
	    weapon_facing[1]="most";
	    weapon_dam[1]=0;
	    weapon_range[1]=300;
	    weapon_cooldown[1]=15;
	    
	}

	if (class="Jackal Class"){ship_size=2;
	    sprite_index=spr_ship_jackal;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=4;
	    armour_other=4;
	    weapons=1;
	    turrets=2;
	    capacity=25;
	    carrying=0;
	    
	    weapon[1]="Lightning Arc";
	    weapon_facing[1]="most";
	    weapon_dam[1]=0;
	    weapon_range[1]=250;
	    weapon_cooldown[1]=15;
	    
	}

	if (class="Dirge Class"){ship_size=2;
	    sprite_index=spr_ship_dirge;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=4;
	    armour_other=4;
	    weapons=1;
	    turrets=2;
	    capacity=25;
	    carrying=0;
	    
	    weapon[1]="Lightning Arc";
	    weapon_facing[1]="most";
	    weapon_dam[1]=0;
	    weapon_range[1]=250;
	    weapon_cooldown[1]=15;
	    
	}













	if (owner != eFACTION.Eldar) and (owner != eFACTION.Necrons){
	    hp=hp/2;
	    maxhp=hp;
	    shields=shields/2;
	    maxshields=shields;
	    
	}

	bridge=maxhp;

	/* 
	if (obj_fleet.enemy == 2) {
		hp = hp * 0.75;
		maxhp = hp;
		shields = shields * 0.75;
		maxshields = shields;
	}
	 */
	// hp=1;
	shields=1;



	// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();

	name="sdagdsagdasg";



	// show_message(string(class));	
}



