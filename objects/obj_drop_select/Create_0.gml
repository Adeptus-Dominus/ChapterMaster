if !(variable_instance_exists(self, "attack")){
    attack = 0;
}
set_zoom_to_default(); //bandaid the purge screen flying off screen if zoomed out 

once_only=0;

raid_tact=1;
raid_vet=1;
raid_assa=1;
raid_deva=1;
raid_scou=1;
raid_term=1;
raid_spec=1;
raid_wounded=obj_controller.select_wounded;
refresh_raid=0;
remove_local=1;

// 

main_slate = new DataSlate();
draw = drop_select_draw;
main_slate.inside_method = draw;
roster_slate = new DataSlate();
local_content_slate = new DataSlate();
var i=-1;
formation_current=-1;
via =  array_create(100, 0);
formation_possible = [];
force_present = array_create(51, 0);

r_master=0;
r_honor=0;
r_capts=0;
r_mahreens=0;
r_veterans=0;
r_terminators=0;
r_dreads=0;
r_chaplains=0;
r_champions=0;
r_psykers=0;
r_apothecaries=0;
r_techmarines=0;
// Attack
r_bikes=0;


if (action_if_number(obj_saveload, 0, 0)){

    ship_names="";
    max_ships=0;
    ships_selected=0;

    purge_method=0;
    purge_score=0;
    purge_a=0;
    purge_b=0;
    purge_c=0;
    purge_d=0;
    tooltip="";
    tooltip2="";
    all_sel=0;


    var i=-1;
    var _ship_index = array_length(obj_ini.ship);
    ship=array_create(_ship_index, "");
    ship_size=array_create(_ship_index, 0);
    ship_all=array_create(_ship_index, 0);
    ship_use=array_create(_ship_index, 0);
    ship_max=array_create(_ship_index, 0);
    ship_ide=array_create(_ship_index, -1);

    i=500;
    ship[i]="Local";
    ship_size[i]=0;
    ship_all[i]=0;
    ship_use[i]=0;
    ship_max[i]=0;
    ship_ide[i]=-42;


    menu=0;



    roster = new Roster();
    if (instance_exists(p_target)){
        roster.roster_location = p_target.name;
    }

    roster.roster_planet = planet_number;
    roster.attack_type = attack;
    roster.determine_full_roster();


    // These should be set to a negative value; that is, effectively, how much when it is selected (i.e. *-1)

    attacking=0;
    sisters=0;
    eldar=0;
    ork=0;
    tau=0;
    traitors=0;
    tyranids=0;
    csm=0;
    necrons=0;
    demons=0;

    // Formation check
    var i=0,is=0,arright=false;
    var _formations = obj_controller.bat_formation;
    var _formation_types = obj_controller.bat_formation_type;

    for (var i=0;i<array_length(_formations);i++){
        if (_formations[i]!="") and (attack=1) and (_formation_types[i]==1){
            array_push(formation_possible, i);
        }
        if (_formations[i]!="") and (attack=0) and (_formation_types[i]==2){
            array_push(formation_possible, i);
        }
    }


    if (attack=0){
        formation_current=obj_controller.last_raid_form;
       for (var i=0;i<array_length(formation_possible);i++){
            if (formation_possible[i]=formation_current){
                formation_current=i;
                break;
            }
        }
    }
    else if (attack=1){
        formation_current=obj_controller.last_attack_form;
         for (var i=0;i<array_length(formation_possible);i++){
            if (formation_possible[i]=formation_current){
                formation_current=i;
                break;
            }
        }
    }
    if (formation_current==-1){
        formation_current=0;
    }

    fighting = array_create(11, array_create(501));
    veh_fighting = array_create(11, array_create(501));
}
camera_width = camera_get_view_width(view_camera[0]);
camera_height = camera_get_view_height(view_camera[0]);

w = 0;
h = 0;
x1 = 0;
y1 = 0;
x2 = 0;
y2 = 0;

formation = new InteractiveButton();
target = new InteractiveButton();

btn_attack = new InteractiveButton();
btn_attack.text_color = CM_GREEN_COLOR;
btn_attack.button_color = CM_GREEN_COLOR;
btn_attack.width = 90;
btn_back = new InteractiveButton();
btn_back.str1 = "BACK";
btn_back.text_color = CM_GREEN_COLOR;
btn_back.button_color = CM_GREEN_COLOR;
btn_back.width = 90;

if (purge ==0){
    sisters=p_target.p_sisters[planet_number];
    eldar=p_target.p_eldar[planet_number];
    ork=p_target.p_orks[planet_number];
    tau=p_target.p_tau[planet_number];
    tyranids=p_target.p_tyranids[planet_number];
    csm=p_target.p_chaos[planet_number];
    traitors=p_target.p_traitors[planet_number];
    necrons=p_target.p_necrons[planet_number];
    demons=p_target.p_demons[planet_number];

    if (p_target.p_player[planet_number]>0) then max_ships+=1;

    var bes=0,bes_score=0;
    if (sisters>0) and (obj_controller.faction_status[eFACTION.Ecclesiarchy]="War"){bes=5;bes_score=sisters;}
    if (eldar>bes_score){bes=6;bes_score=eldar;}
    if (ork>bes_score){bes=7;bes_score=ork;}
    if (tau>bes_score){bes=8;bes_score=tau;}
    if (tyranids>bes_score){bes=9;bes_score=tyranids;}
    if (traitors>bes_score){bes=10;bes_score=traitors;}
    if (csm>bes_score){bes=11;bes_score=csm;}
    if (necrons>bes_score){bes=13;bes_score=necrons;}
    if (demons>0){bes=12;bes_score=demons;}
    if (bes_score>0) then attacking=bes;

    var spesh=false;
    if (planet_feature_bool(p_target.p_feature[planet_number],P_features.Warlord10)==1) and (obj_controller.faction_defeated[10]=0) and (obj_controller.faction_gender[10]=1) and (obj_controller.known[eFACTION.Chaos]>0) and (obj_controller.turn>=obj_controller.chaos_turn) then spesh=true;
        

    if (has_problem_planet(planet_number, "tyranid_org", p_target)){
        tyranids=2;
        attacking=9;
    }

    var forces,t_attack;forces=0;t_attack=0;
    if (sisters>0){forces+=1;force_present[forces]=5;}
    if (eldar>0){forces+=1;force_present[forces]=6;}
    if (ork>0){forces+=1;force_present[forces]=7;}
    if (tau>0){forces+=1;force_present[forces]=8;}
    if (tyranids>0){
        forces+=1;
        force_present[forces]=9;
    }
    if (traitors>0) or ((traitors=0) and (spesh=true)){
        forces+=1;
        force_present[forces]=10;
    }
    if (csm>0){
        forces+=1;
        force_present[forces]=11;
    }
    if (demons>0){
        forces+=1;
        force_present[forces]=12;
    }
    if (necrons>0){
        forces+=1;
        force_present[forces]=13;
    }   
} else {
    var _viable_ground_forces = roster.marines_total();
    bombard_purge = new PurgeButton(4, 631,231,DropType.PurgeBombard);
    bombard_purge.active = roster.purge_bombard_score() ? 1:0;
    bombard_purge.description = "The final sanction for worlds where there is no other economic means for rooting out heresy corruption or the xenos, Your chapters reputation amoung the planets populace may will be damaged, any residing governor (providing they are fit to rule and survive) will be displeased, collaterals will be huge but it's effects will surely be great";

    fire_purge = new PurgeButton(5,631,304,DropType.PurgeFire);
    fire_purge.active = _viable_ground_forces;
    fire_purge.description = "Large swathes of the worst affected areas will be put to the torch the heretics and xenos will be found, the planets populace will not thanks you but most governors will be content to allow the work they were to weak to do to be done";

    selective_purge = new PurgeButton(6,631,377,DropType.PurgeSelective);
    selective_purge.active = _viable_ground_forces;
    selective_purge.description = "The nodes of corruption will be saught out and killed, often in such cases the rot resides in the higher reaches of society such methids are perfect for these instances, cut the head off the snake and the rest will wither, the populations of the oppressed planets are generaly pleased even if the nobles and governors chaffe at the censorship or if neccassary execution";

    assasinate_purge = new PurgeButton(7,631,450,DropType.PurgeAssassinate);
    assasinate_purge.active = _viable_ground_forces;
    assasinate_purge.description = "Often the simplest solution is a single bolt shell or the swift knife the heart. Kill the Leader.";

    purge_options = [bombard_purge, fire_purge, selective_purge, assasinate_purge];
}

