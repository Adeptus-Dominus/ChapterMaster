// Resets vars and also checks if target can be bombarded
ship_names="";
p_target=0;
max_ships=0;
ships_selected=0;
target=0;
target_score=0;
targets=0;
all_sel=0;

bomb=0;
bomb_score=0;
bomb_a=0;
bomb_b=0;
bomb_c=0;

for(var i=0; i<31; i++){
    ship[i]="";
    ship_all[i]=0;
    ship_use[i]=0;
    ship_max[i]=0;
    ship_ide[i]=-1;
}

menu=0;

attacking=0;
eldar=0;
ork=0;
tau=0;
chaos=0;
tyranids=0;
traitors=0;
imp=0;
pdf=0;
sisters=0;
mechanicus=0;
necrons=0;


with(obj_en_fleet){
    if (owner == eFACTION.Imperium) or (owner == eFACTION.Mechanicus) or (owner  == eFACTION.Inquisition) or (action!="") then instance_deactivate_object(id);
}
var _select_x = obj_star_select.target.x;
var _select_y = obj_star_select.target.y;
with(obj_fleet){
    if (point_distance(x,y,_select_x,_select_y)>20) then instance_deactivate_object(id);
}

var bib=instance_nearest(_select_x,_select_y,obj_en_fleet);
if (instance_exists(bib)){
    if (point_distance(_select_x,_select_y,bib.x,bib.y)<=35){
        
        scr_popup("Cannot Bombard","Enemy fleets are preventing bombardment!","","");
        
        instance_activate_object(obj_en_fleet);
        instance_destroy();
        exit;
    }
}
instance_activate_object(obj_en_fleet);

alarm[1]=1;

bomb_window = {};
ship_buttons = [];