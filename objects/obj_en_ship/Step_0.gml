var __b__;
__b__ = action_if_variable(owner, 6, 0);
if !__b__
{
image_angle=direction;
turning_speed=0.2;
if (obj_fleet.start!=5) then exit;

if (class="Daemon") and (image_alpha<1) then image_alpha+=0.006;

var  ch_rang, ex, spid=0;

target_distance = 9999
// Need to every couple of seconds check this
// with obj_en_ship if not big then disable, check nearest, and activate once more


find_ship_combat_target(obj_p_ship, obj_al_ship);


if (!instance_exists(target)) then exit;

if (hp<=0){
    var wh=0,gud=0;
    for (var wh=0;wh<array_length(obj_fleet.enemy);wh++){
        wh+=1;
        if (obj_fleet.enemy[wh]=owner){
            gud=wh;
        }
    }
    
    if (size>=3) then obj_fleet.en_capital_lost[gud]+=1;
    if (size=2) then obj_fleet.en_frigate_lost[gud]+=1;
    if (size=1) then obj_fleet.en_escort_lost[gud]+=1;
    
    destroy_ship_and_leave_husk();
}

if (hp>0) and (instance_exists(obj_p_ship)){
    is_targeted();

    if (class="Apocalypse Class Battleship"){
        closing_distance=500;
        action="attack";
        spid=20;
    }
    if (class="Nemesis Class Fleet Carrier"){
        closing_distance=1000;action="attack";
        spid=20;
    }
    if (class="Leviathan"){closing_distance=160;action="attack";spid=20;}
    if (class="Battle Barge") or (class="Custodian"){closing_distance=300;action="attack";spid=20;}
    if (class="Desecrator"){closing_distance=300;action="attack";spid=20;}
    if (class="Razorfiend"){closing_distance=100;action="attack";spid=25;}
    if (class="Cairn Class") or (class="Reaper Class"){closing_distance=199;action="attack";spid=25;if (class="Reaper Class") then spid=30;}
    
    if (class="Dethdeala") or (class="Protector") or (class="Emissary"){
        closing_distance=200;
        action="attack";
        spid=20;
    }
    if (class="Gorbag's Revenge"){closing_distance=200;action="attack";spid=20;}
    if (class="Kroolboy") or (class="Slamblasta"){closing_distance=200;action="attack";spid=25;}
    if (class="Battlekroozer"){closing_distance=200;action="attack";spid=30;}
    if (class="Avenger") or (class="Carnage") or (class="Daemon"){closing_distance=200;action="attack";spid=20;}
    
    if (class="Ravager") or (class="Iconoclast") or (class="Castellan") or (class="Warden"){closing_distance=300;action="attack";spid=35;}
    if (class="Shroud Class"){closing_distance=250;action="attack";spid=35;}
    
    if (class="Stalker") or (class="Sword Class Frigate"){closing_distance=100;action="attack";spid=20;}
    if (class="Prowler"){closing_distance=100;action="attack";spid=35;}
    if (class="Avenger Class Grand Cruiser"){closing_distance=48;action="broadside";spid=20;}
    if (class="Jackal Class"){closing_distance=200;action="attack";spid=40;}
    if (class="Dirge Class"){closing_distance=200;action="attack";spid=45;}

    if (size==1){
        action = "flank";
    }
    
    // if (class!="big") then flank!!!!
    
    spid=spid*speed_bonus;
    
    target_distance=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(sprite_index),sprite_get_height(sprite_index)));
    
    if (target!=0) and (action="attack"){
        direction=turn_towards_point(direction,x,y,target.x,target.y,.1);
    }
    broadside_movement();
    flank_behaviour();

    
    speed_down = 0.025;
   combat_acceleration_control();
    

    if (speed<0) then speed=speed*0.9;

    if (turret_cool>0) then turret_cool-=1;

    
    var targe=0,rdir=0,dirr="",target_distance=9999,xx=x,yy=y;
    
    
    if (turrets>0) and (instance_exists(obj_p_small)) and (turret_cool=0){
        targe=instance_nearest(x,y,obj_p_small);
        if (instance_exists(targe)){
            target_distance=point_distance(x,y,targe.x,targe.y);
        }
        
        if (target_distance>64) and (target_distance<300){
            bull=instance_create(x,y,obj_en_round);
            bull.direction=point_direction(x,y,targe.x,targe.y);
            if (owner = eFACTION.Tyranids){
                bull.sprite_index=spr_glob;
            }
            bull.speed=20;
            bull.dam=3;
            bull.image_xscale=0.5;
            bull.image_yscale=0.5;
            turret_cool=floor(60/turrets);
            if (owner = eFACTION.Necrons){
                bull.sprite_index=spr_green_las;
                bull.image_yscale=1;
            }
            bull.direction+=choose(random(10),1*-(random(10)));

            bull.explosion_sprite = spr_explosion;        
        }
    }

    ship_shoot_weapons();
    
}


shields.step();


/* */
}
__b__ = action_if_variable(owner, 6, 0);
if __b__
{
image_angle=direction;

if (obj_fleet.start!=5) then exit;

var ch_rang, ex, spid;spid=0;

if (hp<=0){
    var wh=0,gud=0;
    for (var wh=0;wh<array_length(enemy);wh++){
        wh+=1;
        if (obj_fleet.enemy[wh]=owner) then gud=wh;
    }

    if (size=3) then obj_fleet.en_capital_lost[gud]+=1;
    if (size=2) then obj_fleet.en_frigate_lost[gud]+=1;
    if (size=1) then obj_fleet.en_escort_lost[gud]+=1;
    
    image_alpha=0.5;
    
    // ex=instance_create(x,y,obj_explosion);
    // ex.image_xscale=2;ex.image_yscale=2;ex.image_speed=0.75;
    var husk;husk=instance_create(x,y,obj_en_husk);
    husk.sprite_index=sprite_index;husk.direction=direction;
    husk.image_angle=image_angle;husk.depth=depth;husk.image_speed=0;
    repeat(choose(4,5,6)){
        var explo=instance_create(x,y,obj_explosion);
        explo.image_xscale=0.5;explo.image_yscale=0.5;
        explo.x+=random_range(sprite_width*0.25,sprite_width*-0.25);
        explo.y+=random_range(sprite_width*0.25,sprite_width*-0.25);
    }
    
    instance_destroy();
}

if (hp>0) and (instance_exists(obj_p_ship)){
    if (class="Void Stalker"){
        closing_distance=300;
        action="swoop";spid=60;}
    if (class="Shadow Class"){
        closing_distance=200;
        action="swoop";spid=80;}
    if (class="Hellebore") or (class="Aconite"){
        closing_distance=200;
        action="swoop";
        spid=100;
    }
    
    target_distance=point_distance(x,y,target.x,target.y)-(max(sprite_get_width(target.sprite_index),sprite_get_height(sprite_index)));
    
    
    
    
    
    
    
    if (target!=0){
        if (speed<((spid)/10)) then speed+=0.02;
        
        var range;
        if (instance_exists(target)){
            target_distance=point_distance(x,y,target.x,target.y);
            
            if (action="swoop"){direction=turn_towards_point(direction,x,y,target.x,target.y,5-size);}
            if (target_distance<=closing_distance) and (collision_line(x,y,x+lengthdir_x(closing_distance,direction),y+lengthdir_y(closing_distance,direction),obj_p_ship,0,1)) then action="attack";
            if (target_distance<300) and (action="attack") then action="bank";
            if (action="bank") then direction=turn_towards_point(direction,x,y,room_width,room_height/2,5-size);
            if (action="bank") and (target_distance>700) then action="attack";
        }
    }
    
    
    if (y<-2000) or (y>room_height+2000) or (x<-2000) or (x>room_width+2000) then hp=-50;

    if (turret_cool>0) then turret_cool-=1;

    
    var bull, targe, rdir, dirr, target_distance, xx, yy, ok;
    targe=0;rdir=0;dirr="";target_distance=9999;xx=x;yy=y;
    
    
    if (turrets>0) and (instance_exists(obj_p_small)) and (turret_cool=0){
        targe=instance_nearest(x,y,obj_p_small);
        if (instance_exists(targe)) then target_distance=point_distance(x,y,targe.x,targe.y);
        
        if (target_distance>64) and (target_distance<300){
            bull=instance_create(x,y,obj_en_round);bull.direction=point_direction(x,y,targe.x,targe.y);
            if (owner = eFACTION.Tyranids) then bull.sprite_index=spr_glob;
            if (owner = eFACTION.Tau) or (owner = eFACTION.Eldar) then bull.sprite_index=spr_pulse;
            bull.speed=20;
            bull.dam=3;
            bull.image_xscale=0.5;
            bull.image_yscale=0.5;turret_cool=floor(60/turrets);
            bull.direction+=choose(random(10),1*-(random(10)));
        }
    }

    ship_shoot_weapons();
    
    
}


/* */
}
/*  */
