// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function new_ork_fleet(xx,yy){
    fleet=instance_create(xx,yy,obj_en_fleet);
    fleet.owner = eFACTION.Ork;
    fleet.sprite_index=spr_fleet_ork;
    fleet.image_index=1;
    fleet.capital_number=1;
    present_fleet[7] = 1;
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

    var _imperial_ship = scr_orbiting_fleet([eFACTION.Player, eFACTION.Imperium]);
    if (_imperial_ship == "none" && _ork_fleet!="none" && planets>0){
        var _allow_landing=true,ork_attack_planet=0,l=0;
    
        repeat(planets){
            l+=1;
            if (ork_attack_planet=0) and (p_tyranids[l]>0) then ork_attack_planet=l;
        }
        if (ork_attack_planet>0) then p_tyranids[ork_attack_planet]-=_ork_fleet.capital_number+(_ork_fleet.frigate_number/2);

        var _pdata = new PlanetData(ork_attack_planet, self);

        //generate refugee ships to spread tyranids
        if (p_tyranids[ork_attack_planet]<=0){
            if (planet_feature_bool(p_feature[ork_attack_planet], P_features.Gene_Stealer_Cult)){
                _pdata.delete_feature(P_features.Gene_Stealer_Cult);
                adjust_influence(eFACTION.Tyranids, -25, ork_attack_planet);
                var nearest_imperial = nearest_star_with_ownership(x,y,eFACTION.Imperium, self.id);
                if (nearest_imperial != "none"){
                    var targ_planet = scr_get_planet_with_owner(nearest_imperial,eFACTION.Imperium);
                    if (targ_planet==-1) then targ_planet = irandom_range(1, nearest_imperial.planets);
                    _pdata.send_colony_ship(nearest_imperial.id, targ_planet, "refugee");
                }
            }
        }
        
        _allow_landing = !is_dead_star();
        if (_allow_landing){
            for (var i=1;i<=planets;i++){
                if ((p_guardsmen[i]+p_pdf[i]+p_player[i]+p_traitors[i]+p_tau[i]>0) or ((p_owner[i]!=7) and (p_orks[i]<=0))){
                    if (p_type[i]!="Dead") and (p_orks[i]<4) and (i<=planets) and (instance_exists(_ork_fleet)){
                        p_orks[i]+=max(2,floor(_ork_fleet.image_index*0.8));
                    

                        if (fleet_has_cargo("ork_warboss",_ork_fleet)){
                            array_push(p_feature[i], _ork_fleet.cargo_data.ork_warboss);
                            p_orks[i]=6;
                        }

                    
                        if (p_orks[i]>6) then p_orks[i]=6;
                        with(_ork_fleet){
                            instance_destroy();
                        }
                        aler=1;
                    }                    
                }
            }
        }
    
        if (aler>0){
            scr_alert("green","owner",$"Ork ships have crashed across the {name} system.",x,y);
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


//TOSO provide logic for fleets to attack each other
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

function init_ork_waagh(overide = false){
    var waaagh=roll_dice(1,100);

    var _ork_stars = scr_get_stars(false,[eFACTION.Ork]);

    var _ork_star_count = array_length(_ork_stars);
    if (_ork_star_count>=5 && (waaagh<=_ork_star_count || overide) && obj_controller.known[eFACTION.Ork]==0)/* or (obj_controller.is_test_map=true)*/{
        obj_controller.known[eFACTION.Ork]=0.5;
        //set an alarm for all ork controlled planets


        scr_popup("WAAAAGH!","The greenskins have swelled in activity, their numbers increasing seemingly without relent.  A massive Warboss has risen to take control, leading most of the sector's Orks on a massive WAAAGH!","waaagh","");
        scr_event_log("red","Ork WAAAAGH! begins.");
        
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

        if (array_length(ork_waagh_activity)){

            var _waaagh_star = array_random_element(ork_waagh_activity);

        } else {
            var _waaagh_star = array_random_element(_any_ork_star);
        }
        var _pdata = new PlanetData(_waaagh_star[1], _waaagh_star[0]);
        var _boss = _pdata.add_feature(P_features.OrkWarboss);
        if (overide){
            _boss.player_hidden = false;
            scr_event_log("red","boss on {_pdata.name()}", _pdata.system.name);
        }

        if (_pdata.planet_forces[eFACTION.Ork] < 4) {
            _pdata.add_forces(eFACTION.Ork, 2);
        }

    }
}

