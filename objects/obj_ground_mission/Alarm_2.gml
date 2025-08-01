
scr_return_ship(loc,self,num);

var man_size,ship_id,comp,plan,i;
i=0;ship_id=0;man_size=0;comp=0;plan=0;
ship_id = get_valid_player_ship("", loc);
plan=instance_nearest(x,y,obj_star);
last_artifact = scr_add_artifact("random","random",4,loc,ship_id+500);

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
clear_diplo_choices();
instance_destroy();

