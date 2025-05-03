
ship_id=0;
owner=0;

action="";
direction=180;
// if (instance_exists(obj_p_ship)){target=instance_nearest(x,y,obj_p_ship);}
target_l=0;
target_r=0;
target=0;
hostile=1;
lightning=0;
whip=0;
bridge=0;
draw_targets = false;
bullets_for = [];


cooldown[0]=0;
cooldown[1]=0;
cooldown[2]=0;
cooldown[3]=0;
cooldown[4]=0;
cooldown[5]=0;
turret_cool=0;


name="";
class="";
size=0;
hp=0;
maxhp=0;
conditions="";
shields=1;
maxshields=1;
armour_front=0;
armour_other=0;
weapons=0;
turrets=0;

turn_bonus=1;
speed_bonus=1;


var i;i=-1;
repeat(6){i+=1;
    weapon[i]="";
    weapon_facing[i]="";
    weapon_cooldown[i]=0;
    weapon_hp[i]=0;
    weapon_dam[i]=0;
    weapon_ammo[i]=999;
    weapon_range[i]=0;
    weapon_minrange[i]=0;
}
assign_ship_stats();
