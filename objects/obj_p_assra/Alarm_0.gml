
var co=0,i=0,o=0, unit;

for (o=0;o<array_length(origin.board_co);o++){
    co=origin.board_co[o];
    i=origin.board_id[o];
    unit = fetch_unit([co, i]);
    if (unit.hp()<=-15) and (obj_ini.race[co][i]=1) and (unit.name()!=""){
        var seed_lost=0;
        if (apothecary<=0){
            if (unit.IsSpecialist(SPECIALISTS_STANDARD)){
                obj_fleet.fallen_command+=1;
            }else {
                obj_fleet.fallen+=1;
            }
            
            if (apothecary_had>0){
                if (unit.base_group=="astartes"){
                    var age=obj_ini.age[co][i];
                    if (age<=((obj_controller.millenium*1000)+obj_controller.year)-10) and (obj_ini.zygote=0) then seed_lost+=1;
                    if (age<=((obj_controller.millenium*1000)+obj_controller.year)-5) then seed_lost+=1;
                }
            }
            
            // obj_fleet.marines_lost+=1;
            if (unit.role()=="Chapter Master"){
                obj_controller.alarm[7]=1;
                if (global.defeat<=1) then global.defeat=1;
            }
            if (unit.weapon_one()=="Company Standard" || unit.weapon_two()=="Company Standard") then scr_loyalty("Lost Standard","+");
            
            scr_kill_unit(co,i)
            
            if (obj_fleet.capital+obj_fleet.frigate+obj_fleet.escort>0) then obj_controller.gene_seed+=seed_lost;
        }else if (apothecary>0){
            unit.add_or_sub_health(irandom_range(9,14));
            apothecary-=0.5;
        }
    }
}


/* */
/*  */
