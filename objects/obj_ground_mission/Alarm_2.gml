
scr_return_ship(loc,self,num);

var man_size,_ship_UUID,comp,plan,i;
i=0;_ship_UUID="";man_size=0;comp=0;plan=0;
_ship_UUID = get_valid_player_ship(loc);
plan=instance_nearest(x,y,obj_star);
last_artifact = scr_add_artifact("random", "random", 4, fetch_ship(_ship_UUID).name, _ship_UUID);

var pop=instance_create(0,0,obj_popup);
pop.image="artifact_recovered";
pop.title="Artifact Recovered!";
pop.text=$"The Artifact has been safely stowed away upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
with(obj_star_select){instance_destroy();}
with(obj_fleet_select){instance_destroy();}
delete_features(plan.p_feature[num], P_features.Artifact);
scr_event_log("","Artifact recovered.");

corrupt_artifact_collectors(last_artifact);

obj_controller.trading_artifact=0;
var h=0;
repeat(4){
    h+=1;
    obj_controller.diplo_option[h]="";
    obj_controller.diplo_goto[h]="";
}
instance_destroy();

