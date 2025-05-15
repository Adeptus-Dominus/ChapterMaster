

function destroy_vehicle(co, num){
    obj_ini.veh_race[co][num]=0;
    obj_ini.veh_loc[co][num]="";
    obj_ini.veh_name[co][num]="";
    obj_ini.veh_role[co][num]="";
    obj_ini.veh_wep1[co][num]="";
    obj_ini.veh_wep2[co][num]="";
    obj_ini.veh_wep3[co][num]="";
    obj_ini.veh_upgrade[co][num]="";
    obj_ini.veh_acc[co][num]="";
    obj_ini.veh_hp[co][num]=100;
    obj_ini.veh_chaos[co][num]=0;
    obj_ini.veh_pilots[co][num]=0;
    obj_ini.veh_lid[co][num]=-1;
}
