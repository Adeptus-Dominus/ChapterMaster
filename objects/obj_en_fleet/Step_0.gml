
if (global.load>=0) or (instance_exists(obj_saveload)) then exit;

if (action!="") and (orbiting!=0){
    if (instance_exists(orbiting)){
        if (variable_instance_exists(orbiting, "present_fleet")){
            orbiting.present_fleet[owner]-=1;
            orbiting=0;
        } else {
            orbiting = instance_nearest(x, y , obj_star);
            var cur_owner_fleet = orbiting.present_fleet[owner];
            orbiting.present_fleet[owner] = cur_owner_fleet> 0? cur_owner_fleet-1 : cur_owner_fleet=0;
            orbiting=0;
        }
    }
}

if (capital_number<0) then capital_number=0;
if (frigate_number<0) then frigate_number=0;
if (escort_number<0) then escort_number=0;

if ((owner  != eFACTION.Inquisition) and (capital_number+frigate_number+escort_number<=0) and !fleet_has_cargo("colonize")) then instance_destroy();

if (owner = eFACTION.Tau) and (x<0) or (y<0) then instance_destroy();

if (target>0) and (instance_exists(target)){target_x=target.x;target_y=target.y;}

ii_check-=1;

if (ii_check=0){
    ii_check=10;
    
    if (owner != eFACTION.Eldar) and (owner  != eFACTION.Inquisition){
        var ii=0;
        ii+=capital_number;
        ii+=round((frigate_number/2));
        ii+=round((escort_number/4));
        if (ii<=1) then ii=1;
        image_index=ii;
        image_index=min(image_index,9);
    }
    if (owner = eFACTION.Eldar){
        var ii;ii=0;ii+=capital_number;ii+=round((frigate_number/2));ii+=round((escort_number/4));
        if (ii<=1) then ii=1;image_index=ii;
        image_index=min(image_index,5);
    }
    if (owner  = eFACTION.Inquisition) then image_index=1;

}


if (owner = eFACTION.Tyranids){
    image_alpha=0;
    if (instance_exists(obj_p_fleet)){
        var bundy;bundy=instance_nearest(x,y,obj_p_fleet);
        if (bundy.action="") and (self.action="") and (point_distance(bundy.x,bundy.y,x,y)<90) and (bundy.x>x) and (bundy.y<y) then image_alpha=1;
    }
    if (instance_nearest(x,y-32,obj_star).vision=1) and (action="") then image_alpha=1;
}





if (owner = eFACTION.Tau) and (action_spd!=32) then action_spd=32;
// if (owner = eFACTION.Tau) and (image_index>1)
if (owner = eFACTION.Mechanicus){
    if (action!="") then direction=point_direction(x,y,action_x,action_y);
    image_angle=direction;
}
if (owner = eFACTION.Eldar) and (trade_goods!="") and (action="move") then action_eta=1;


if (owner = eFACTION.Tau) and (action="") and (obj_controller.tau_messenger>=30) and (frigate_number>0) and (escort_number+capital_number>0){
    obj_controller.tau_messenger=0;
    
    var fleet, good, stir, xx, yy;
    stir=0;xx=0;yy=0;good=0;
    
    fleet=instance_nearest(x,y,obj_star);
    fleet.tau_fleets+=1;fleet.present_fleets+=1;
    instance_deactivate_object(fleet);
    
    fleet=instance_create(x,y,obj_en_fleet);
    fleet.owner = eFACTION.Tau;fleet.action_spd=32;fleet.frigate_number=1;fleet.sprite_index=spr_fleet_tau;fleet.image_index=1;
    frigate_number-=1;
    
    repeat(50){
        if (good=0){
            xx=x+round(choose(random(500),random(500)*-1));
            yy=y+round(choose(random(500),random(500)*-1));
            
            stir=instance_nearest(xx,yy,obj_star);
            if (stir.planets!=0) and (stir.owner = eFACTION.Imperium) then good=1;
            if (stir.planets=1) and (stir.p_type[1]="Dead") then good=0;
        }
        
        if (good=1){
            fleet.action_x=stir.x;
            fleet.action_y=stir.y;
            fleet.alarm[4]=1;
        }
    }
    
    instance_activate_object(obj_star);    
}




if (owner = eFACTION.Tyranids) and (trade_goods=""){
    trade_goods=choose("Spore Clouds","Health","Armour","Speed","Turn","Turret");
    trade_goods+="|";
    trade_goods+=choose("Spore Clouds","Health","Armour","Speed","Turn","Turret");
    trade_goods+="|";
}

if (global.load>=0){
    if (owner = eFACTION.Imperium) then sprite_index=spr_fleet_imperial;
    if (owner = eFACTION.Mechanicus) then sprite_index=spr_fleet_mechanicus;
    if (owner  = eFACTION.Inquisition) then sprite_index=spr_fleet_inquisition;
    if (owner = eFACTION.Eldar) then sprite_index=spr_fleet_eldar;
    if (owner = eFACTION.Ork) then sprite_index=spr_fleet_ork;
    if (owner = eFACTION.Tau) then sprite_index=spr_fleet_tau;
    if (owner = eFACTION.Tyranids) then sprite_index=spr_fleet_tyranid;
    if (owner = eFACTION.Chaos) then sprite_index=spr_fleet_chaos;
}
if (image_index=0) then image_index=1;

