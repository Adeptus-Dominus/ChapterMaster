// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function new_ork_fleet(xx,yy){
    fleet=instance_create(xx,yy,obj_en_fleet);
    fleet.owner = eFACTION.Ork;
    fleet.sprite_index=spr_fleet_ork;
    fleet.image_index=1;
    fleet.capital_number = 1;
    fleet.frigate_number = 1
    if (!is_struct(self)){
        if (object_index == obj_star){
            present_fleet[7] = 1;
        }
    }
    return fleet;
}

function orks_end_turn_growth(){
    for (i=1;i<=planets;i++){
        var _pdata = new PlanetData(i, self);
        if (!p_orks[i]){
            var _strongholds = _pdata.get_features(P_features.OrkStronghold);
            for (var s=0;s<array_length(_strongholds);s++){
                var _hold = _strongholds[s];
                _hold.tier -= 0.01;
                if (_hold.tier<=0){
                   _pdata.delete_feature(P_features.OrkStronghold);
                }
            }
        };
        _pdata.grow_ork_forces()
    }
}


function ork_fleet_move(){
    

    var hides=choose(1,2,3);
    
    repeat(hides){
        instance_deactivate_object(instance_nearest(x,y,obj_star));
    }
    
    with(obj_star){
        if (is_dead_star() || owner=eFACTION.Ork || scr_orbiting_fleet(eFACTION.Ork) !="none") then instance_deactivate_object(id);
    }
    var nex=instance_nearest(x,y,obj_star);
    action_x=nex.x;
    action_y=nex.y;
    action="";
    set_fleet_movement();

    instance_activate_object(obj_star);
    exit;
  
}

function ork_fleet_arrive_target(){

    instance_activate_object(obj_en_fleet);
    var _ork_fleet=scr_orbiting_fleet(eFACTION.Ork);
    if (_ork_fleet=="none") then return;
    var aler=0;

    var _imperial_ship = scr_orbiting_fleet([eFACTION.Imperium, eFACTION.Mechanicus]);
    if (_imperial_ship == "none" && planets>0 && !has_orbiting_player_fleet()){
        var _allow_landing = true,ork_attack_planet=0,l=0;
        var _planets = shuffled_planet_array();
        for (var i=0;i<array_length(_planets); i++){
            l = _planets[i];
            if (ork_attack_planet=0) and (p_tyranids[l]>0){
                ork_attack_planet=l;
                break;
            }
        }
        if (ork_attack_planet>0){
            p_tyranids[ork_attack_planet] -= floor(_ork_fleet.capital_number+(_ork_fleet.frigate_number/2));

            var _pdata = new PlanetData(ork_attack_planet, self);

            //generate refugee ships to spread tyranids
            if (p_tyranids[ork_attack_planet]<=0){
                if (planet_feature_bool(p_feature[ork_attack_planet], P_features.Gene_Stealer_Cult)){
                    _pdata.delete_feature(P_features.Gene_Stealer_Cult);
                    adjust_influence(eFACTION.Tyranids, -25, ork_attack_planet);
                    var nearest_imperial = nearest_star_with_ownership(x,y,eFACTION.Imperium, self.id);
                    if (nearest_imperial != "none"){
                        var targ_planet = scr_get_planet_with_owner(nearest_imperial,eFACTION.Imperium);
                        if (targ_planet==-1){
                            targ_planet = irandom_range(1, nearest_imperial.planets);
                        }
                        _pdata.send_colony_ship(nearest_imperial.id, targ_planet, "refugee");
                    }
                }
            }
        }
        
        _allow_landing = !is_dead_star();
        if (_allow_landing){
            for (var i=0;i<planets;i++){
                var _planet = _planets[i];
                if ((p_guardsmen[_planet]+p_pdf[_planet]+p_player[_planet]+p_traitors[_planet]+p_tau[_planet]>0) or ((p_owner[_planet]!=7) and (p_orks[_planet]<=0))){
                    if (p_type[_planet]!="Dead") and (p_orks[_planet]<4) and (i<=planets){
                        p_orks[_planet]+=max(2,floor(_ork_fleet.image_index*0.8));
                    
                        var _fleet_persists = false

                        if (fleet_has_cargo("ork_warboss",_ork_fleet)){
                            array_push(p_feature[_planet], _ork_fleet.cargo_data.ork_warboss);
                            p_orks[_planet]=6;
                            struct_remove(_ork_fleet.cargo_data,"ork_warboss");
                            _fleet_persists = true;
                        }

                    
                        if (p_orks[_planet]>6) then p_orks[_planet]=6;
                        if (!_fleet_persists){
                            with (_ork_fleet){
                                instance_destroy();
                            }
                        }
                        aler=1;
                        break;
                    }                    
                }
            }
        }
    
        if (aler>0){
            if (!_fleet_persists){
                scr_alert("green","owner",$"Ork ships have crashed across the {name} system.",x,y);
            } else {
                scr_alert("green","owner",$"Ork ships unload their sizable ork contingent across {name} system, yet sizable fleet remains in orbit.",x,y);
            }
        } else {
            var new_wagh_star = distance_removed_star(x,y, choose(2,3,4,5));
            if (instance_exists(new_wagh_star)){
                with (_ork_fleet){
                    action_x=new_wagh_star.x;
                    action_y=new_wagh_star.y;
                    action = "";
                    set_fleet_movement();
                }
            }                    
        }


    }// End _allow_landingng portion of code

}


//TODO provide logic for fleets to attack each other
function merge_ork_fleets(){

    var _stars_with_ork_fleets = stars_with_faction_fleets(eFACTION.Ork);

    var _star_names = struct_get_names(_stars_with_ork_fleets);
    for (var i =0;i<array_length(_star_names);i++){
        var _fleets = _stars_with_ork_fleets[$_star_names[i]];
        if (array_length(_fleets) <= 1) then continue;
        var _base_fleet = _fleets[0];
        for (var f=1;f<array_length(_fleets);f++){
            merge_fleets(_base_fleet, _fleets[f]);
        }
    }
}

function init_ork_waagh(override = false) {
    var waaagh = irandom(300);
    var waaagh_1 = irandom(3);
    var _ork_stars = scr_get_stars(false, [eFACTION.Ork]);
    var _ork_stars_count = array_length(_ork_stars);

    if ((_ork_stars_count > 45) &&  (waaagh_1 == 3 || override ) && obj_controller.known[eFACTION.Ork] == 0) {
        scr_popup("Green Giant Awakens!", "Orks, in an unusual display of behavior, are going on their so called /WAAAGH!/ in our sector.  Considering that they already are a dominant force, some imperial agents express concerns whether imperium can even maintain influence in this sector, let alone contain the ork menace!", "waaagh", "");
        scr_event_log("red", "Ork WAAAAGH! begins");
        obj_controller.known[eFACTION.Ork] = 0.5;
    } else if ((_ork_stars_count > 0 && _ork_stars_count <= 5) && (waaagh_1 == 3 || override) && obj_controller.known[eFACTION.Ork] == 0) {
        scr_popup("Ork Counter-attack!", "While we have almost succeeded in eliminating the orks from the sector, it seems they are launching a counter-attack with a new Warboss. It might be prudent to deal with this so called /WAAAGH!/ before it can threaten imperium again.", "waaagh", "");
        scr_event_log("red", "Ork WAAAAGH! begins.");
        obj_controller.known[eFACTION.Ork] = 0.5;
    } else if ((_ork_stars_count >= 5 && _ork_stars_count <= 45) && (waaagh == 33 || override) && obj_controller.known[eFACTION.Ork] == 0) {
        scr_popup("Ork Rampage!", "Various sources report that orks exhibit increased activity.  It seems that an ork Warboss has risen and unified orks, leading most of them on their so called /WAAAGH!/.", "waaagh", "");
        scr_event_log("red", "Ork WAAAAGH! begins."); // TODO consider adding flavor texts when trait 'Tolerant' or 'Enemy: Orks' is in effect, also applies to line 343
        obj_controller.known[eFACTION.Ork] = 0.5;
    } else {
        //if no waaagh is triggered
        return;
    }

    var ork_waagh_activity = [];
        var _any_ork_star = [];
        for (var p=0;p<array_length(_ork_stars);p++){
            with(_ork_stars[p]){
                var _rand_planet=irandom_range(1, planets)
                for(var i=1; i<=planets; i++){
                    ork_ship_production(i);
                    if (i == _rand_planet){
                        if (p_owner[i]==eFACTION.Ork) and (p_pdf[i]==0) and (p_guardsmen[i]==0) and (p_orks[i]>=2){
                            array_push(ork_waagh_activity, [id,_rand_planet]);
                        }
                    }
                    if (p_orks[i]>0){
                        array_push(_any_ork_star, [id, i]);
                    }
                }
            }
        }

        var _waaagh_star_found = false;
        if (array_length(ork_waagh_activity)){

            var _waaagh_star = array_random_element(ork_waagh_activity);
            _waaagh_star_found = true;

        } else if (array_length(_any_ork_star) > 0) {
            var _waaagh_star = array_random_element(_any_ork_star);
            _waaagh_star_found = true;
        }

    if (_waaagh_star_found){
        var _pdata = new PlanetData(_waaagh_star[1], _waaagh_star[0]);

        var _boss = _pdata.add_feature(P_features.OrkWarboss);
        if (override) {
            _boss.player_hidden = false;
            scr_event_log("red", $"boss on {_pdata.name()}", _pdata.system.name);
        }

        if (_pdata.planet_forces[eFACTION.Ork] < 4) {
            _pdata.add_forces(eFACTION.Ork, 2);
        }
    } else {
        out_of_system_warboss(true);
    }

    if (_waaagh_star_found) {
        scr_popup("WAAAAGH!","My lord, our Auspex scans indicate that the Ork Warboss is currently within the "+string(_pdata.system.name)+" system.We must strike swiftly before he relocates. ","waaagh","");
        scr_event_log("red",$"boss on {_pdata.name()}", _pdata.system.name);
    }
}


function out_of_system_warboss(overide = false){

    with (obj_controller){
    // More Testing
    // peace_check=2;

    var did_so=false;

    if (did_so=false) && (faction_defeated[7]=1 || known[eFACTION.Ork] == 0 || overide) {
        known[eFACTION.Ork] = 0;
        var _warboss = new NewPlanetFeature(P_features.OrkWarboss);
        if (faction_defeated[7]=1){
            faction_defeated[7] =-1;
            faction_leader[eFACTION.Ork] = _warboss.name;
            faction_title[7]="Warboss";
            faction_status[eFACTION.Ork]="War";
            scr_audience(eFACTION.Ork, "new_warboss", -40,"War", 0, 2);      // TODO change starting disposition when trait 'Tolerant' is in effect
        } else {
            known[eFACTION.Ork] = 0.5;
        }
    
    
        var gold=faction_gender[7];
        if (gold=0) then gold=1;
        var gnew=0;
        repeat(20){
            if (gnew=0 || gnew=gold){
                gnew=choose(1,2,3,4);
            }
        }
        faction_gender[7]=gnew;
        starf=0;
    
        var x3 = 0,y3 = 0,fnum=0;

        var side=choose("left","right","up","down");
        if (side="left") then y3=floor(random_range(0,room_height))+1;
        if (side="right"){
            y3=floor(random_range(0,room_height))+1;x3=room_width;
        }
        if (side="up"){
            x3=floor(random_range(0,room_width))+1;
        }
        if (side="down"){
            x3=floor(random_range(0,room_width))+1;y3=room_height;
        }
    
        //lots of this can be wrapped into a single with
        with(obj_star){
            if (owner = eFACTION.Eldar){
                instance_deactivate_object(id);
                continue
            }
            if (is_dead_star() || planets==0){
                instance_deactivate_object(id);
                continue
            }
        }
        
        repeat(8){
            fnum+=1;
            var x4,y4,dire;x4=0;y4=0;dire=0;
            if (fnum=1){
                dire=point_direction(x4,y4,room_width/2,room_height/2);
                x4=x3+lengthdir_x(60,dire);
                y4=y3+lengthdir_y(60,dire);
            }
            if (fnum>1){
                dire=point_direction(x4,y4,room_width/2,room_height/2);
                x4=x3+choose(round(random_range(30,50)),round(random_range(-30,-50)));
                y4=y3+choose(round(random_range(30,50)),round(random_range(-30,-50)));
            }
        
            var _nfleet = new_ork_fleet(x4,y4);
            var tplan=instance_nearest(_nfleet.x,_nfleet.y,obj_star);
            _nfleet.action_x=tplan.x;
            _nfleet.action_y=tplan.y;
            if (fnum=1){
                starf=tplan;
                _nfleet.cargo_data.ork_warboss=_warboss;
            }                   
            with (_nfleet){
                frigate_number=10;
                capital_number=4;
                set_fleet_movement();
            }
            instance_deactivate_object(tplan.id);
        
        }

        instance_activate_object(obj_star);
        instance_activate_object(obj_en_fleet);
        
        var _ork_leader = obj_controller.faction_leader[eFACTION.Ork];
        var tix=$"Warboss {_ork_leader} leads a WAAAGH! into Sector {obj_ini.sector_name}.";
        scr_alert("red","lol",string(tix),starf.x,starf.y);
        scr_popup("Ork Invasion!",$"A so called /WAAAGH!/ led by the Warboss {_ork_leader} has arrived in {obj_ini.sector_name}.  The forefront of the ork group is headed for the {starf.name} system.","waaagh","");
        scr_event_log("red",tix);
    }
    }
}

