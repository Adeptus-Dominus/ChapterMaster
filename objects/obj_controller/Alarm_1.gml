// Sets up the sector spawn and assigns spawned enemies to the sector
instance_activate_object(obj_star);
instance_activate_all();

// Should determine here, randomly what sort of enemy planets there are
// One of the following:
// Lots of damn orks
// Lots of damn tyranids
// Some damn orks and a few genestealer cults

var field=""

field="both"//("orks","tyranids","both"); 
if (global.chapter_name="Lamenters") then field="both"; 
if (is_test_map=true) then field="orks"; 

good_log=1;

var xx,yy,ok=0,did=0,_current_system=0,px=0,py=0,rando=0;
// Set player set
_current_system = find_player_spawn_star();

instance_activate_object(obj_star);
var _player_star;
// Set player homeworld
did = instance_exists(_current_system);
if (did){
    _player_star = _current_system.id;
    if (obj_ini.fleet_type==ePlayerBase.home_world){
        set_player_homeworld_star(_current_system);
    }
    // Crusade and fleet based
    if (obj_ini.fleet_type!=ePlayerBase.home_world){
        with (_current_system){
            set_player_recruit_planet(irandom_range(1, _current_system.planets));
        }
    }
    with(_current_system){
        for(var f=1; f<=4; f++){
			if (array_length( search_planet_features(p_feature[f], P_features.Monastery)) >0)and (array_length( search_planet_features(p_feature[f], P_features.Recruiting_World)) >0){
                if (p_owner[f]==eFACTION.Player) then p_owner[f]=eFACTION.Imperium;
            }
			if (array_length( search_planet_features(p_feature[f], P_features.Monastery)) >0){
                if (p_owner[f]!=eFACTION.Player) then p_owner[f]=eFACTION.Player;
                owner  = eFACTION.Player;
            }
        }
    }
    if (obj_ini.veh_loc[1,1]=="random") or (obj_ini.veh_loc[1,1]=="Random"){
        for(var coh=0; coh<11; coh++){
            for(var iy=1; iy<=60; iy++){
                obj_ini.veh_loc[coh,iy]=_current_system.name;
            }
        }
        _current_system.p_player[2]+=obj_ini.man_size;
    }
    
    var fleet=instance_create(_current_system.x,_current_system.y,obj_p_fleet);
    fleet.owner  = eFACTION.Player;
    
    for(var f=0; f<array_length(obj_ini.ship); f++){
        add_ship_to_fleet(f, fleet);
    }
    
    with (fleet){
        set_player_fleet_image();
    }
    
    if (obj_ini.load_to_ships[0]>0){
        scr_start_load(fleet,_current_system,obj_ini.load_to_ships);
        with(obj_p_fleet){
            instance_create(x,y,obj_fleet_show);
        }
    }

    // End player homeworld
    px = _current_system.x;
    py = _current_system.y;
    xx = px;
    yy = py;
    instance_activate_object(obj_star);
    instance_deactivate_object(_current_system);
    with (obj_star){
        if (system_feature_bool(p_feature, P_features.Recruiting_World)){
            instance_deactivate_object(id);
            break;
        }
    }
    
    _current_system=instance_nearest(px,py,obj_star);
    _current_system.star="white2";
    _current_system.planet[1]=1;
    _current_system.planet[2]=1;
    _current_system.image_index=4;
    _current_system.p_type[1]="Forge";
    _current_system.p_type[2]="Ice";
	/*
    _current_system.p_owner[1]=3;
	_current_system.p_owner[2]=3;
    _current_system.p_owner[3]=3;
    _current_system.p_owner[4]=3;
    _current_system.p_first[1]=3;
	_current_system.p_first[2]=3;
    _current_system.p_first[3]=3;
    _current_system.p_first[4]=3;
	*/
    _current_system.owner = eFACTION.Mechanicus;
	_current_system.p_owner = array_create(5, _current_system.owner)
	_current_system.p_first = array_create(5, _current_system.owner)

	if (_current_system.planets<2) then _current_system.planets=2;
    
    with(_current_system){// with _current_system
        var a=99,b=99,c=99,d=99,e="",f=0;
        for(var i=0; i<10; i++){
            e = p_type[1];
            switch (e) {
                case "Lava":
                    a = 1;
                    break;
                case "Desert":
                    a = 2;
                    break;
                case "Hive":
                    a = 3;
                    break;
                case "Death":
                    a = 4;
                    break;
                case "Agri":
                    a = 5;
                    break;
                case "Temperate":
                    a = 6;
                    break;
                case "Ice":
                    a = 7;
                    break;
                case "Dead":
                    a = 1;
                    break;
                case "Forge":
                    a = 1.5;
                    break;
            }
            e = p_type[2];
            switch (e) {
                case "Lava":
                    b = 1;
                    break;
                case "Desert":
                    b = 2;
                    break;
                case "Hive":
                    b = 3;
                    break;
                case "Death":
                    b = 4;
                    break;
                case "Agri":
                    b = 5;
                    break;
                case "Temperate":
                    b = 6;
                    break;
                case "Ice":
                    b = 7;
                    break;
                case "Dead":
                    b = 2.5;
                    break;
                case "Forge":
                    b = 1.5;
                    break;
            }
            e = p_type[3];
            switch (e) {
                case "Lava":
                    c = 1;
                    break;
                case "Desert":
                    c = 2;
                    break;
                case "Hive":
                    c = 3;
                    break;
                case "Death":
                    c = 4;
                    break;
                case "Agri":
                    c = 5;
                    break;
                case "Temperate":
                    c = 6;
                    break;
                case "Ice":
                    c = 7;
                    break;
                case "Dead":
                    c = 3.5;
                    break;
                case "Forge":
                    c = 1.5;
                    break;
            }
            e = p_type[4];
            switch (e) {
                case "Lava":
                    d = 1;
                    break;
                case "Desert":
                    d = 2;
                    break;
                case "Hive":
                    d = 3;
                    break;
                case "Death":
                    d = 4;
                    break;
                case "Agri":
                    d = 5;
                    break;
                case "Temperate":
                    d = 6;
                    break;
                case "Ice":
                    d = 7;
                    break;
                case "Dead":
                    d = 4.5;
                    break;
                case "Forge":
                    d = 1.5;
                    break;
            }

            if (d<c){
                f=c;
                e=p_type[3];
                c=d;
                p_type[3]=p_type[4];
                p_type[4]=e;
                d=f;
            }
            if (c<b){
                f=b;
                e=p_type[2];
                b=c;
                p_type[2]=p_type[3];
                p_type[3]=e;
                c=f;
            }
            if (b<a){
                f=a;
                e=p_type[1];
                a=b;
                p_type[1]=p_type[2];
                p_type[2]=e;
                b=f;
            }
        }// end repeat

        // important later on for having other chapters homeworlds or civil war imperiums
        for (var p=1;p<=planets;p++){
            if (p_type[p]!="Forge") and (p_type[p]!="Ice"){
                p_owner[p] = eFACTION.Imperium;
                p_first[p] = p_owner[p];
            } 
        }
    }// end with _current_system
    
    // _current_system.explored=1;
    
    repeat(6){
        instance_deactivate_object(instance_nearest(xx,yy,obj_star));
    }

    
    if (tau==1){
        _current_system=instance_furthest(px,py,obj_star);
        
        with(obj_star){
            if (planets==0) then instance_deactivate_object(id);
        }
        
        var stop=0;
        for(var i=0; i<100; i++){
            if (stop!=5){
                if (_current_system.planets==1) and (_current_system.p_type[1]=="Dead"){
                    stop=1;
                    with(_current_system){
                        instance_deactivate_object(instance_id_get( 0 ));
                    }
                }
                if (_current_system.planets>=1) or (_current_system.p_type[1]!="Dead"){
                    stop=0;
                }
                if (stop==0) then stop=5;
            }
        }
        
        with (_current_system){
            planet[1]=1;
            p_owner[1]= eFACTION.Tau;
            p_type[1]="Desert";
            xx=x;
            yy=y;
            tau[1]=choose(3,4);
            p_influence[1][eFACTION.Tau]=70;
        }
        instance_deactivate_object(_current_system);
        
        var tau_start_size = irandom(4)+5;
        for (var i=0;i<=tau_start_size;i++){
            rando=1;
            _current_system=instance_nearest(xx,yy,obj_star);
            with (_current_system){
                if  (planets>0) and (_current_system.p_type[1]!="Dead") and (_current_system.owner == eFACTION.Imperium){
                    p_owner[1] = eFACTION.Tau;
                    owner = eFACTION.Tau;
                    p_influence[1][eFACTION.Tau]=70;
                }
            }
            instance_deactivate_object(_current_system);
        }
        
        instance_activate_object(obj_star);
    }
    // Chaos
    repeat(2+irandom(4)){
        xx=floor(random(1152))+64;
        yy=floor(random(748))+64;
        _current_system=instance_nearest(xx,yy,obj_star);
        with (_current_system){
            if (planets>0) and (owner == eFACTION.Imperium){
                planet[1]=1;
                p_owner[1]=10;
                owner = eFACTION.Chaos;
            }
        }
        instance_deactivate_object(_current_system);
    }
    // More sneaky this way; you have to be noted of rising heresy or something, or have a ship in the system
    var hell_holes = ["Badab", "Hellsiris","Vraks","Isstvan","Stygies","Stygia","Nostromo","Jhanna","Gangrenous Rot"];
    with(obj_star){
        if (array_contains(hell_holes, name)){
            rando=choose(1,1); // make 1's 0's if you want less chaos
            if (rando==1){
				
                owner = eFACTION.Chaos;
				p_owner = array_create(5, owner);
                for (var i=1;i<=planets;i++){
                    p_heresy[i]=floor(random_range(75,100));
                    if (p_type[i]=="Dead") then p_type[i]=choose("Hive","Temperate","Desert","Ice");

                    if (p_type[i]!="Dead") then p_traitors[i]=6;
                    // give them big defences
                    if (p_type[i]!="Dead") then p_fortified[i]=choose(4,5,5,4,4,3,6);
                }
            }
        }
    }
    
    // Ork planets here

    var _imperial_planets = [];
    var _non_xenos_chaos = [];
    with(obj_star){
        if (is_dead_star() || planets==0){
            continue;
        }
        if  (owner == eFACTION.Imperium){
            //this object simply acts as a counter of imperium owned planets
            array_push(_imperial_planets, id);
        }
      
    }
    
    var ed2,n,i,orkz=choose(4,5,6)+5;
    if (field=="orks") then orkz+=20;
    if (field=="both") then orkz+=15;
   /*if (obj_ini.fleet_type==ePlayerBase.penitent) then orkz+=2;*/
    if (is_test_map==true) then orkz=4;

    n=array_length(_imperial_planets);
    for(var j=0; j<orkz && j<n; j++){
        i = array_random_index(_imperial_planets);
        _current_system=_imperial_planets[i];
        
        _current_system.planet[1]=1;
        _current_system.owner = eFACTION.Ork;
		_current_system.p_owner = array_create(5, _current_system.owner)
        array_delete(_imperial_planets, i, 1);
    }

    if (field=="tyranids"){
        orkz=(choose(3,4,6)+7);
        if (obj_ini.fleet_type==ePlayerBase.penitent) then orkz+=2;
        
        for(var j=0; j<orkz; j++){
            n=array_length(_imperial_planets);
            i = array_random_index(_imperial_planets);
            _current_system=_imperial_planets[i];

            _current_system.planet[1]=1;
            _current_system.p_owner[1]=9;
            _current_system.owner = eFACTION.Tyranids;

            array_delete(_imperial_planets, i, 1);
        }
    }
    
    with(obj_star){
        if (is_dead_star() || planets==0){
            continue;
        }        
        if (owner<=5) {
            array_push(_non_xenos_chaos, id);
        } 
    }


    if (field=="both"){
        if (obj_ini.fleet_type==ePlayerBase.penitent) then orkz+=3;
        orkz+=3;
        n=array_length(_non_xenos_chaos);
        for (var j=0; j<orkz && j<n; j++){
            
            _current_system=array_random_element(_non_xenos_chaos);

            _current_system.planet[1]=1;
            _current_system.p_owner[1]=90;
            _current_system.owner=90;
            array_delete(_non_xenos_chaos, i, 1);
        }
    }
    
    // Another mechanicus
    repeat(choose(3,4,5)){
        xx=floor(random(1152+640))+64;
        yy=floor(random(748+480))+64;
        _current_system=instance_nearest(xx,yy,obj_star);
        if (_current_system.planets>0) and (_current_system.owner == eFACTION.Imperium){
            var forge_planet = irandom(_current_system.planets-1)+1;
            _current_system.plant[forge_planet]=1;
            _current_system.p_type[forge_planet]="Forge";
            _current_system.owner = eFACTION.Mechanicus;
            _current_system.p_owner[forge_planet] = _current_system.owner;
            _current_system.p_first[forge_planet] = _current_system.owner;
        }
        instance_deactivate_object(_current_system);
    }
}


x=px;
y=py;

instance_activate_object(obj_star);

if (did==0) then alarm[1]=5;
if (did!=0) then obj_star.alarm[1]=1;

// Eldar craftworld here

var go=0,xx=0,yy=0;

craftworld=1;

for(var i=0; i<100; i++){
    if (go==0){
        xx=floor(random(1152+600))+104;
        yy=floor(random(748+440))+104;
        if (point_distance(room_width/2,room_height/2,xx,yy)>=50) then go=1;
        me=instance_nearest(xx,yy,obj_star);
        if (go==1) and (point_distance(me.x,me.y,xx,yy)>=150) then go=2;
        if (go==1) then go=0;
        if (xx>=1050+640) or (yy<=300+480) then go=0;
    }
    if (go==2){
        var craft=instance_create(xx,yy,obj_star);
        craft.craftworld=1;
        go=999;
		array_push(craft.p_feature[1],new NewPlanetFeature(P_features.Warlord6));
        
        var elforce=instance_create(xx,yy,obj_en_fleet);
        elforce.sprite_index=spr_fleet_eldar;
        elforce.owner = eFACTION.Eldar;
        elforce.capital_number=choose(2,3);
        elforce.frigate_number=choose(4,5,6);
        elforce.escort_number=floor(random_range(7,11))+1;
        elforce.image_alpha=0;
        elforce.orbiting=craft;
    }
}
// End craftworld

if (!instance_exists(obj_saveload)) and (instance_exists(obj_creation)) and (global.load==-1){
    for(var i=1; i<=10; i++){
        if (obj_creation.world[i]!=""){
            var _wanted_worlds = [];
            with(obj_star){
                for(var run=1; run<=4; run++){
                    if (p_type[run]=obj_creation.world_type[i]){
                        array_push(_wanted_worlds, id);
                    }
                }
            }
            
            var _chosen_world=array_random_element(_wanted_worlds);
            
            if (instance_exists(_chosen_world)){
                for(var run=1; run<=4; run++){
                    if (_chosen_world.p_type[run]=obj_creation.world_type[i]){
                        _chosen_world.name=obj_creation.world[i];
                        if (obj_creation.world_feature[i]!="") then _chosen_world.p_feature[run]=[];
                        obj_creation.world[i]="";
                        obj_creation.world_type[i]="";
                        obj_creation.world_feature[i]="";
                    }
                }
                instance_deactivate_object(_chosen_world);
            }
        }
    }
}

instance_activate_all();
with(obj_creation){
    instance_destroy();
}


create_complex_star_routes(_player_star.id);

/* //135 testing crusade object
instance_create(x,y,obj_crusade);
obj_crusade.placing=1;scr_zoom();*/

// 135 ; testing artifacts with combat
// argument0 : type
// argument1 : tags
// argument2 : identified
// argument3: location
// argument4: sid

// scr_add_artifact("Weapon","",4,obj_ini.home_name,1);

/*scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);
scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);
scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);
scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);
scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);
scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);
scr_add_artifact("good","daemonic",0,obj_ini.ship[0],501);*/

// scr_add_item("Cyclonic Torpedo",5);
// scr_add_item("Exterminatus",5);
    
if (is_test_map==true){
    // scr_add_item("Exterminatus",5);
    /*scr_add_artifact("good","",0,obj_ini.ship[0],501);
    scr_add_artifact("good","",0,obj_ini.ship[0],501);
    scr_add_artifact("good","",0,obj_ini.ship[0],501);
    scr_add_artifact("good","",0,obj_ini.ship[0],501);
    scr_add_artifact("good","",0,obj_ini.ship[0],501);
    scr_add_artifact("good","",0,obj_ini.ship[0],501);
    scr_add_artifact("good","",0,obj_ini.ship[0],501);*/
}

with(obj_temp7){instance_destroy();}
//for tau fleets, if it is stationed on a system it owns, make a temp7 obj
with(obj_en_fleet){
    if (owner == eFACTION.Tau) and (instance_nearest(x,y,obj_star).owner == eFACTION.Tau) then instance_create(x,y,obj_temp7);
}
//if any temp objects exist, find the one nearest to the center of the room and set your direction to
//the angle to the room center
if (instance_exists(obj_temp7)){
    var t1=instance_nearest(room_width/2,room_height/2,obj_temp7);
	with(t1) {
		other.terra_direction = point_direction(x,y,room_width/2,room_height/2)	
	}
}

/*with(obj_star){
    scr_star_ownership(false);
}*/

// x=0;y=0;
