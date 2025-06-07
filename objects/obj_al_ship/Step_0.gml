// Manages space combat, checks if ships are destroyed and does the targeting and pointing of the ship

var __b__;
var bull, ok, targe=0,rdir=0,xx=x,yy=y;
var front=0,right=0,left=0,rear=0;
var f=0,facing="",ammo=0,range=0,wep="",dam=0;
var spid=0;
var gud=0;
var husk;
var explo;
turning_speed=0.2;
__b__ = action_if_variable(owner, 6, 0);
if (!__b__){
    image_angle=direction;

    if (obj_fleet.start!=5) then exit;

    if (class="Daemon") and (image_alpha<1) then image_alpha+=0.006;

    closing_distance=0;
    spid=0;

    if (shields>0) and (shields<maxshields) then shields+=0.02;

    // Need to every couple of seconds check this
    // with obj_en_ship if not big then disable, check nearest, and activate once more
    if (instance_exists(obj_en_ship)) then target=instance_nearest(x,y,obj_en_ship);
    if (!instance_exists(target)) then exit;
    // Check if ship is destroyed
    if (hp<=0){
        gud=0;
        for(var wh=1; wh<=5; wh++){
            if (obj_fleet.enemy[wh]==owner) then gud=wh;
        }
        
        if (class=="Gorbag's Revenge" or (class=="Dethdeala") or (class=="Kroolboy") or (class=="Desecrator")) or (class=="Custodian") then obj_fleet.en_capital_lost[gud]+=1;
        else if (class=="Battlekroozer") or (class=="Daemon") or (class=="Avenger Class Grand Cruiser") or (class=="Carnage") or (class=="Emissary") or (class=="Protector") then obj_fleet.en_frigate_lost[gud]+=1;
        else if (class=="Ravager") or (class=="Iconoclast") or (class=="Warden") or (class=="Castellan") then obj_fleet.en_escort_lost[gud]+=1;
        else if (class=="Leviathan") then obj_fleet.en_capital_lost[gud]+=1;
        else if (class=="Razorfiend") then obj_fleet.en_frigate_lost[gud]+=1;
        else if (class=="Stalker") or (class=="Prowler") or (class=="Sword Class Frigate"){
            obj_fleet.en_escort_lost[gud]+=1;
        }
        
        destroy_ship_and_leave_husk();
    }
    // While ship is alive, attack
    if (hp>0) and (instance_exists(obj_en_ship)){
        is_targeted();
        // TODO on another PR we need to redo how combat works, currently its just "attack" perhaps we can have more precise choise based AI with
        // simpler patterns?
        if (class=="Apocalypse Class Battleship"){
            closing_distance=500;
            action="attack";
            spid=20;
        }
        if (class=="Nemesis Class Fleet Carrier"){
            closing_distance=1000;
            action="attack";
            spid=20;
        }
        if (class=="Leviathan"){
            closing_distance=160;
            action="attack";
            spid=20;
        }
        if (class=="Battle Barge") or (class=="Custodian"){
            closing_distance=300;
            action="attack";
            spid=20;
        }
        if (class=="Desecrator"){
            closing_distance=300;
            action="attack";
            spid=20;
        }
        if (class=="Razorfiend"){
            closing_distance=100;
            action="attack";
            spid=25;
        }
        if (class=="Dethdeala") or (class=="Protector") or (class=="Emissary"){
            closing_distance=200;
            action="attack";
            spid=20;
        }
        if (class=="Gorbag's Revenge"){
            closing_distance=200;
            action="attack";
            spid=20;
        }
        if (class=="Kroolboy") or (class=="Slamblasta"){
            closing_distance=200;
            action="attack";
            spid=25;
        }
        if (class=="Battlekroozer"){
            closing_distance=200;
            action="attack";
            spid=30;
        }
        if (class=="Avenger") or (class=="Carnage") or (class=="Daemon"){
            closing_distance=200;
            action="attack";
            spid=20;
        }        
        if (class=="Ravager") or (class=="Iconoclast") or (class=="Castellan") or (class=="Warden"){
            closing_distance=300;
            action="attack";
            spid=35;
        }
        if (class=="Stalker") or (class=="Sword Class Frigate"){
            closing_distance=100;
            action="attack";
            spid=20;
        }
        if (class=="Prowler"){
            closing_distance=100;
            action="attack";
            spid=35;
        }
        if (class=="Avenger Class Grand Cruiser"){
            closing_distance=48;
            action="broadside";
            spid=20;
        }
        // if (class!="big") then flank!!!!
        closing_distance = closing_distance;
        spid=spid*speed_bonus;
        
        target_distance=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
        target_distance = target_distance;
        // For example here we could improve the options and how ships beheave...
        if (target!=0) and (action=="attack"){
            direction=turn_towards_point(direction,x,y,target.x,target.y,.1);
        }
        broadside_movement();
        flank_behaviour();
        /*if (target!=0) and (action="broadside") and (closing_distance>=target_distance){
            direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
        }*/
        /*if (target!=0) and (action="broadside") and (closing_distance>=target_distance){
            var re_deh;re_deh=relative_direction(direction,target.direction);
            // if (re_deh<45) or (re_deh>315) or ((re_deh>135) and (re_deh<225)) then direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
            var wok;
            wok=0;
            if (!instance_exists(target_l)) then wok=2;
            if (!instance_exists(target_r)) then wok=1;
            if (instance_exists(target_l)) and (instance_exists(target_r)){
                if (point_distance(x,y,target_l.x,target_l.y))<(point_distance(x,y,target_r.x,target_r.y)) then wok=1;
                else{wok=2;}
                
            }
            if (wok=1){
                direction=turn_towards_point(direction,x,y,x+lengthdir_x(256,90),y+lengthdir_y(256,90),.2)
            }
            if (wok=2){
                direction=turn_towards_point(direction,x,y,x+lengthdir_x(256,270),y+lengthdir_y(256,270),.2)
            }
            // direction=turn_towards_point(direction,x+lengthdir_x(128,target.direction-90),y,target.x,target.y+lengthdir_y(128,target.direction-90),.2)
        }*/
        // Controls speed based on action
        speed_down = 0.025;
        combat_acceleration_control();

        if (speed<0) then speed=speed*0.9;
        // Weapon reloads
        if (turret_cool>0) then turret_cool-=1;
        
        targe=0;
        rdir=0;
        target_distance=9999;
        xx=x;
        yy=y;
        // Turret targetting
        if (turrets>0) and (instance_exists(obj_en_in)) and (turret_cool==0){
            targe=instance_nearest(x,y,obj_en_in);
            if (instance_exists(targe)) then target_distance=point_distance(x,y,targe.x,targe.y);
            
            if (target_distance>64) and (target_distance<300){
                bull=instance_create(x,y,obj_al_round);
                bull.direction=point_direction(x,y,targe.x,targe.y);
                if (owner = eFACTION.Tyranids) then bull.sprite_index=spr_glob;
                if (owner = eFACTION.Tau) or (owner = eFACTION.Eldar) then bull.sprite_index=spr_pulse;
                bull.speed=20;
                bull.dam=3;
                bull.image_xscale=0.5;
                bull.image_yscale=0.5;
                turret_cool=floor(60/turrets);
                bull.direction+=choose(random(10),1*-(random(10)));
            }
        }
        ship_shoot_weapons();
        xx=lengthdir_x(64,direction+90);
        yy=lengthdir_y(64,direction+90);
        
        // TODO we could implement facing with stronger shields or other stuff
        front=0;
        right=0;
        left=0;
        rear=0;
        
        targe=instance_nearest(xx,yy,obj_en_ship);
        rdir=point_direction(x,y,target.x,target.y);
        // if (rdir>45) and (rdir<=135) and (targe!=target){target_r=targe;right=1;}
        // if (rdir>225) and (rdir<=315) and (targe!=target) and (targe!=target_r){target_l=targe;left=1;}   
        target_l=instance_nearest(x+lengthdir_x(64,direction+90),y+lengthdir_y(64,direction+90),obj_en_ship);
        target_r=instance_nearest(x+lengthdir_x(64,direction+270),y+lengthdir_y(64,direction+270),obj_en_ship);
        
        if (collision_line(x,y,x+lengthdir_x(2000,direction),y+lengthdir_y(2000,direction),obj_en_ship,0,1)) then front=1;
        
    }
}
// Checks if the enemy fleet is Eldar
__b__ = action_if_variable(owner, 6, 0);
if (__b__){
    image_angle=direction;

    if (obj_fleet.start!=5) then exit;

    closing_distance=0;
    spid=0;

    if (shields>0) and (shields<maxshields) then shields+=0.03;
    // Need to every couple of seconds check this
    // with obj_en_ship if not big then disable, check nearest, and activate once more
    if (instance_exists(obj_en_ship)) then target=instance_nearest(x,y,obj_en_ship);

    if (hp<=0){
        gud=0;
        for(var wh=1; wh<=5; wh++){if (obj_fleet.enemy[wh]==owner) then gud=wh;}

        if (class=="Void Stalker") then obj_fleet.en_capital_lost[gud]+=1;
        if (class=="Shadow Class") then obj_fleet.en_frigate_lost[gud]+=1;
        if (class=="Hellebore") or (class=="Aconite") then obj_fleet.en_escort_lost[gud]+=1;
        
        image_alpha=0.5;
        
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
        instance_destroy();
    }
    if (hp>0) and (instance_exists(obj_en_ship)){
        if (class=="Void Stalker"){
            closing_distance=300;
            action="swoop";
            spid=60;
        }
        if (class=="Shadow Class"){
            closing_distance=200;
            action="swoop";
            spid=80;
        }
        if (class=="Hellebore") or (class=="Aconite"){
            closing_distance=200;
            action="swoop";
            spid=100;
        }
        
        target_distance=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(target.sprite_index),sprite_get_height(sprite_index)));
        
        if (target!=0){
            if (speed<((spid)/10)) then speed+=0.02;
            if (instance_exists(target)){
                target_distance=point_distance(x,y,target.x,target.y);
                
                if (action=="swoop"){
                    direction=turn_towards_point(direction,x,y,target.x,target.y,5-ship_size);
                }
                if (target_distance<=closing_distance) and (collision_line(x,y,x+lengthdir_x(closing_distance,direction),y+lengthdir_y(closing_distance,direction),obj_en_ship,0,1)) then action="attack";
                if (target_distance<300) and (action=="attack") then action="bank";
                if (action=="bank") then direction=turn_towards_point(direction,x,y,room_width,room_height/2,5-ship_size);
                if (action=="bank") and (target_distance>700){
                    action="attack";
                }
            }
        }
        
        if (y<-2000) or (y>room_height+2000) or (x<-2000) or (x>room_width+2000) then hp=-50;
        // Weapon and turret cooldown

        if (turret_cool>0) then turret_cool-=1;

        targe=0;
        target_distance=9999;
        xx=x;
        yy=y;
        
        if (turrets>0) and (instance_exists(obj_en_in)) and (turret_cool==0){
            targe=instance_nearest(x,y,obj_en_in);
            if (instance_exists(targe)) then target_distance=point_distance(x,y,targe.x,targe.y);
            
            if (target_distance>64) and (target_distance<300){
                bull=instance_create(x,y,obj_al_round);
                bull.direction=point_direction(x,y,targe.x,targe.y);
                if (owner = eFACTION.Tyranids) then bull.sprite_index=spr_glob;
                if (owner = eFACTION.Tau) or (owner = eFACTION.Eldar) then bull.sprite_index=spr_pulse;
                bull.speed=20;
                bull.dam=3;
                bull.image_xscale=0.5;
                bull.image_yscale=0.5;
                turret_cool=floor(60/turrets);
                bull.direction+=choose(random(10),1*-(random(10)));
            }
        }
        ship_shoot_weapons();
    }
}
