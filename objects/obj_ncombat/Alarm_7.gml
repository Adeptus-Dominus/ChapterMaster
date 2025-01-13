try {
    // show_debug_message("alarm 7 start");
    audio_stop_sound(snd_battle);
    audio_play_sound(snd_royal,0,true);
    audio_sound_gain(snd_royal, 0, 0);
    var nope=0;if (obj_controller.master_volume=0) or (obj_controller.music_volume=0) then nope=1;
    if (nope!=1){
        audio_sound_gain(snd_royal,0.25*obj_controller.master_volume*obj_controller.music_volume,2000);
    }
    
    // scr_dead_marines(1);
    
    // Execute the cleaning scripts
    // Check for any more battles
    
    obj_controller.cooldown=10;
    
    
    debugl($"Ground Combat - {defeat ? "Defeat" : "Victory"}Victory - Enemy:{enemy} ({battle_special})");
    
    
    // If battling own dudes, then remove the loyalists after the fact
    
    
    if (enemy=1){
    
        var j=-1
        var cleann = array_create(11,false)
        with(obj_enunit){var q=0;
            repeat(700){
                q+=1;
                if (dude_id[q]>0){
                    var commandy=false;
                    var nco=dude_co[q];
                    var nid=dude_id[q];
                    cleann[nco]=true;
                    
                    // show_message("dude ID:"+string(q)+" ("+string(obj_ini.name[nco,nid])+") is being removed from the array");
                    
                    commandy=is_specialist(obj_ini.role[nco,nid]);
                    if (commandy=true) then obj_controller.command-=1;
                    if (commandy=false) then obj_controller.marines-=1;
    
                    obj_ncombat.world_size+=scr_unit_size(obj_ini.armour[nco][nid],obj_ini.role[nco][nid],true, obj_ini.mobi[nco][nid]);
    
                    var recover = !obj_ncombat.defeat
                    kill_and_recover(nco,nid, recover, recover);
                }
            }
        }
        
       for (j=0;j<=10;j++){
            if (cleann[j]) then with(obj_ini){
                scr_company_order(j);
            }
        }
    }
    if (string_count("cs_meeting",battle_special)>0){
        with(obj_temp_meeting){instance_destroy();}
        
        with(obj_star){
            if (name=obj_ncombat.battle_loc){
                instance_create(x,y,obj_temp_meeting);
                var i=0,ii=0,otm,good=0,master_present=0;
                var run=0,s=0,chaos_meeting=0;
                
                var master_index = array_get_index(obj_ini.role[0], "Chapter Master");
                chaos_meeting=fetch_unit([0,master_index]).planet_location;            
                
                // show_message("meeting planet:"+string(chaos_meeting));
                for (var co=0;co<=10;co++){
                    for (var i=0;i<array_length(obj_ini.TTRPG[co]);i++){
                        good=0;
                        unit = fetch_unit([co,i]);
                        if (unit.role()=="" || obj_ini.loc[co][i]!=name) then continue;
                        if (unit.planet_location==floor(chaos_meeting)) then good+=1;
                        if (obj_ini.role[co][i]!=obj_ini.role[100][6]) and (obj_ini.role[co][i]!="Venerable "+string(obj_ini.role[100][6])) then good+=1;
                        if (string_count("Dread",obj_ini.armour[co][i])=0) or (obj_ini.role[co][i]="Chapter Master") then good+=1;
                        
                        // if (good>=3) then show_message(string(obj_ini.role[co][i])+": "+string(co)+"."+string(i));
                        
                        if (good>=3){
                            obj_temp_meeting.dudes+=1;
                            otm=obj_temp_meeting.dudes;
                            obj_temp_meeting.present[otm]=1;
                            obj_temp_meeting.co[otm]=co;
                            obj_temp_meeting.ide[otm]=i;
                            if (obj_ini.role[co][i]="Chapter Master") then master_present=1;
                        }
                    }
                }
                // show_message("obj_temp_meeting.dudes:"+string(obj_temp_meeting.dudes));
                
            }
        }
    }
    
    
    
    
    that = array_get_index(post_equipment_lost,"Company Standard");
    if (that!=-1){
        repeat(post_equipments_lost[that]){
            scr_loyalty("Lost Standard","+");
        }
    }
    
    if (battle_special="ruins" || battle_special="ruins_eldar"){
        obj_ground_mission.defeat=defeat;
        obj_ground_mission.explore_feature.ruins_combat_end();
    }
    
    else if (battle_special="WL10_reveal") or (battle_special="WL10_later"){var moar,ox,oy;
        with(obj_temp8){instance_destroy();}
        
        if (chaos_angry>=5){
            if (string_count("|CPF|",obj_controller.useful_info)=0) then obj_controller.useful_info+="|CPF|";
        }
        
        if (battle_special="WL10_reveal"){
            instance_create(battle_object.x,battle_object.y,obj_temp8);
            ox=battle_object.x;oy=battle_object.y;// battle_object.owner = eFACTION.Chaos;
            battle_object.p_traitors[battle_id]=6;
            battle_object.p_chaos[battle_id]=4;
            battle_object.p_pdf[battle_id]=0;
            battle_object.p_owner[battle_id]=10;
            
            var corro;corro=0;
            
            repeat(100){var ii;ii=0;
                if (corro<=5){
                    moar=instance_nearest(ox,oy,obj_star);
                    
                    if (moar.owner<=3){corro+=1;
                        repeat(4){ii+=1;
                            if (moar.p_owner[ii]<=3) moar.p_heresy[ii]=min(100,moar.p_heresy[ii]+floor(random_range(30,50)));
                        }
                    }
                    moar.y-=20000;
                }
            }
            with(obj_star){if (y<-12000) then y+=20000;}
            
            if (battle_object.present_fleet[2]>0){
                with(obj_en_fleet){
                    if (navy=0) and (owner = eFACTION.Imperium) and (point_distance(x,y,obj_temp8.x,obj_temp8.y)<40){
                        owner = eFACTION.Chaos;sprite_index=spr_fleet_chaos;
                        if (image_index<=2){escort_number+=3;frigate_number+=1;}
                        if (capital_number=0) then capital_number+=1;
                    }
                }
                battle_object.present_fleet[2]-=1;
                battle_object.present_fleet[10]+=1;
            }
            with(obj_temp8){instance_destroy();}
        }
        
        if (defeat=1) and (battle_special="WL10_reveal"){
            obj_controller.audience=10;
            obj_controller.menu=20;
            obj_controller.diplomacy=10;
            obj_controller.known[eFACTION.Chaos]=2;
            with(obj_controller){scr_dialogue("intro2");}
        }
        if (defeat=0){
            obj_controller.known[eFACTION.Chaos]=2;
            obj_controller.faction_defeated[10]=1;
            
            if (instance_exists(obj_turn_end)){
                scr_event_log("","Enemy Leader Assassinated: Chaos Lord");
                scr_alert("","ass","Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" has been killed.",0,0);
                scr_popup("Chaos Lord Killed","Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" has been slain in combat.  Without his leadership the various forces of Chaos in the sector will crumble apart and disintegrate from infighting.  Sector "+string(obj_ini.sector_name)+" is no longer as threatened by the forces of Chaos.","","");
            }
            if (!instance_exists(obj_turn_end)){
                scr_event_log("","Enemy Leader Assassinated: Chaos Lord");
                var pop=instance_create(0,0,obj_popup);
                pop.image="";
                pop.title="Chaos Lord Killed";
                pop.text="Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" has been slain in combat.  Without his leadership the various forces of Chaos in the sector will crumble apart and disintegrate from infighting.  Sector "+string(obj_ini.sector_name)+" is no longer as threatened by the forces of Chaos.";
            }
            
        }
    }
    
    
    
    
    if (battle_special="study2a") or (battle_special="study2b"){
        if (defeat=1){
            var ii=0,good=0;
    
            if (remove_planet_problem(battle_id, "mech_tomb", battle_object)){
                obj_controller.disposition[3]-=10;
                
                if (battle_special="study2a"){
                    scr_popup("Mechanicus Mission Failed","All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust, and the Adeptus Mechanicus is furious with your chapter for not providing enough security.  Relations with them are worse than before.","","");
                }
                if (battle_special="study2b"){
                    battle_object.p_necrons[battle_id]=5;
    				 awaken_tomb_world( battle_object.p_feature[battle_id])
                    obj_controller.disposition[3]-=15;obj_controller.disposition[4]-=5;
                    scr_popup("Mechanicus Mission Failed","All of your Astartes and the Mechanicus Research party have been killed down to the last man.  The research is a bust.  To make matters worse the Necron Tomb has fully awakened- countless numbers of the souless machines are now pouring out of the tomb.  The Adeptus Mechanicus are furious with your chapter.","necron_army","");
                    scr_alert("","inqi","The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb",0,0);
                    scr_event_log("","The Inquisition is displeased with your Chapter for tampering with and awakening a Necron Tomb");
                }
                
                scr_event_log("","Mechanicus Mission Failed: Necron Tomb Research Party and present astartes have been killed.");
            }
        }
    }
    
    
    
    
    if (enemy=5) and (obj_controller.faction_status[eFACTION.Ecclesiarchy]!="War"){
        obj_controller.loyalty-=50;obj_controller.loyalty_hidden-=50;
        obj_controller.disposition[2]-=50;obj_controller.disposition[3]-=80;
        obj_controller.disposition[4]-=40;obj_controller.disposition[5]-=30;
        
        obj_controller.faction_status[eFACTION.Imperium]="War";obj_controller.faction_status[eFACTION.Mechanicus]="War";
        obj_controller.faction_status[eFACTION.Inquisition]="War";obj_controller.faction_status[eFACTION.Ecclesiarchy]="War";
        
        if (!instance_exists(obj_turn_end)){
            obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=5;obj_controller.audien_topic[obj_controller.audiences]="declare_war";
            if (obj_controller.known[eFACTION.Inquisition]>1){obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=4;obj_controller.audien_topic[obj_controller.audiences]="declare_war";}
            obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=2;obj_controller.audien_topic[obj_controller.audiences]="declare_war";
        }else{
            obj_turn_end.audiences+=1;obj_turn_end.audien[obj_turn_end.audiences]=5;obj_turn_end.audien_topic[obj_turn_end.audiences]="declare_war";
            if (obj_turn_end.known[eFACTION.Inquisition]>1){obj_turn_end.audiences+=1;obj_turn_end.audien[obj_turn_end.audiences]=4;obj_turn_end.audien_topic[obj_turn_end.audiences]="declare_war";}
            obj_turn_end.audiences+=1;obj_turn_end.audien[obj_turn_end.audiences]=2;obj_turn_end.audien_topic[obj_turn_end.audiences]="declare_war";
        }
    }
    
    
    
    
    if (exterminatus>0) and (dropping!=0) and (string_count("mech",battle_special)=0){
        scr_destroy_planet(1);
    }
    
    if (string_count("mech",battle_special)>0) and (defeat=0) then with(obj_ground_mission){
        var comp,plan,i;i=0;comp=0;plan=0;
        plan=instance_nearest(x,y,obj_star);
        scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
        with(obj_ground_mission){instance_destroy();}
    }
    
    with(obj_ini){
        for (var i=0;i<=10;i++){
            scr_company_order(i);
            scr_vehicle_order(i);
        }
    }
    
    obj_controller.x=view_x;
    obj_controller.y=view_y;
    obj_controller.combat=0;
    obj_controller.marines-=final_deaths;
    obj_controller.command-=final_command_deaths;
    
    instance_activate_all();
    
    if (scr_role_count("Chapter Master","")=0){
        obj_controller.alarm[7]=1;
        if (global.defeat<=1) then global.defeat=1;
        if (enemy=1) or (enemy=2) or (enemy=5) then global.defeat=3;
    }
    
    
    if (turn_count < 20){
        if (defeat=0) and (threat>=4) then scr_recent("battle_victory", $"{battle_loc} {scr_roman(battle_id)}",enemy);
    
    
    
        if (defeat=1) and (final_deaths+final_command_deaths>=10) then scr_recent("battle_defeat", $"{enemy}, {final_deaths+final_command_deaths}");
    } else {
        scr_recent("battle_defeat",$"{enemy}, {final_deaths+final_command_deaths}");
    }
    
    
    
    if ((dropping=1) or (attacking=1)) and (string_count("_attack",battle_special)=0) and (string_count("mech",battle_special)=0) and (string_count("ruins",battle_special)=0) and (battle_special!="ship_demon"){
        obj_controller.combat=0;
        with(obj_drop_select){
            instance_destroy()
        };
    }
    if ((dropping+attacking=0)) and (string_count("_attack",battle_special)=0) and (string_count("mech",battle_special)=0) and (string_count("ruins",battle_special)=0) and (battle_special!="ship_demon") and (string_count("cs_meeting",battle_special)=0){
        
        if (instance_exists(obj_turn_end)){
            var _battle_index = obj_turn_end.current_battle;
            if (_battle_index<array_length(obj_turn_end.battle_object)){
                var _battle_object=obj_turn_end.battle_object[_battle_index];

                var _planet = obj_turn_end.battle_world[_battle_index];
                
                _battle_object.p_player[_planet]-=world_size;

                if (defeat=1){
                    _battle_object.p_player[_planet]=0;
                };
            }
            obj_controller.combat=0;
            with(obj_turn_end){
                alarm[4]=1;
            }
        }
    }
    if (string_count("ruins",battle_special)>0) and (defeat=1){
        //TODO this logic is wrong assumes all player units died in ruins
        var _combat_star = star_by_name(obj_ncombat.battle_loc);
        if (_combat_star!="none"){
            _combat_star.p_player[obj_ncombat.battle_id]-=obj_ncombat.world_size;
        }
    }
    
    
    
    if (string_count("_attack",battle_special)>0) and (string_count("mech",battle_special)=0) and (string_count("ruins",battle_special)=0) and (string_count("cs_meeting",battle_special)=0){
        if (string_count("wake",battle_special)>0){
            var pip=instance_create(0,0,obj_popup);
            with(pip){
                title="Necron Tomb Awakens";
                image="necron_army";
                if (obj_ncombat.defeat=0) then text="Your marines make a tactical retreat back to the surface, hounded by Necrons all the way.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
                if (obj_ncombat.defeat=1) then text="Your marines are killed down to the last man.  The Inquisition mission is a failure- you were to blow up the Necron Tomb World stealthily, not wake it up.  The Inquisition is not pleased with your conduct.";
            }
            
            instance_activate_object(obj_star);
            with(obj_star){if (name!=obj_ncombat.battle_loc) then instance_deactivate_object(id);}
            with(obj_star){
                var planet = obj_ncombat.battle_id;
                if (remove_planet_problem(planet,"bomb")){
                    p_necrons[planet]=4;
                }
                if (awake_tomb_world(p_feature[planet])==0) then awaken_tomb_world(p_feature[planet])
            }
            with(obj_temp7){instance_destroy();}
            instance_activate_object(obj_star);
            
            pip.number=obj_temp8.popup
            pip.loc=obj_temp8.loc;
            pip.planet=battle_id;
            obj_controller.combat=0;
            obj_controller.disposition[4]-=5;
            obj_controller.cooldown=10;
            with(obj_temp8){instance_destroy();}
            // obj_turn_end.alarm[1]=4;
        }
    
    
        if (defeat=1) and (string_count("wake",battle_special)=0){
            with(obj_temp8){instance_destroy();}
            obj_controller.combat=0;
            obj_controller.cooldown=10;
            obj_turn_end.alarm[1]=4;
        }
        
        if (defeat=0) and (string_count("wake",battle_special)=0){
            obj_temp8.stage+=1;
            obj_controller.combat=0;
            var pip=instance_create(0,0,obj_popup);
            
            with(pip){
                title="Necron Tunnels : "+string(obj_temp8.stage);
                if (obj_temp8.stage=2){
                    image="necron_tunnels_2";
                    text="The energy readings are much stronger, now that your marines are deep inside the tunnels.  What was once cramped is now luxuriously large, the tunnel ceiling far overhead decorated by stalactites.";
                }
                if (obj_temp8.stage=3){
                    image="necron_tunnels_3";
                    text="After several hours of descent the entrance to the Necron Tomb finally looms ahead- dancing, sickly green light shining free.  Your marine confirms that the Plasma Bomb is ready.";
                }
                if (obj_temp8.stage=4){
                    if (obj_temp8.stage>=4){
                        instance_activate_object(obj_star);
                        image="";
                        title="Inquisition Mission Completed";
                        text="Your marines finally enter the deepest catacombs of the Necron Tomb.  There they place the Plasma Bomb and arm it.  All around are signs of increasing Necron activity.  With half an hour set, your men escape back to the surface.  There is a brief rumble as the charge goes off, your mission a success.";
                        option1="";option2="";option3="";
                        
                        if (obj_controller.demanding=0) then obj_controller.disposition[4]+=1;
                        if (obj_controller.demanding=1) then obj_controller.disposition[4]+=choose(0,0,1);
                        
                        // show_message(string(obj_temp8.loc)+"."+string(obj_temp8.wid));
                        // obj_controller.temp[200]=obj_temp8.loc;
                        with(obj_star){if (name!=obj_temp8.loc) then instance_deactivate_object(id);}
                        with(obj_star){if (name=obj_temp8.loc) then instance_create(x,y,obj_temp5);}
                        
                        you=instance_nearest(obj_temp5.x,obj_temp5.y,obj_star);onceh=0;
                        
                        // show_message(you.name);
                        
                        // show_message("TEMP5: "+string(instance_number(obj_temp5))+"#Star: "+string(you));
                        
                        var ppp;ppp=0;
                        remove_planet_problem(obj_temp8.wid, "bomb", you);
    
                        pip.option1="";pip.option2="";pip.option3="";
                        scr_event_log("","Inquisition Mission Completed: Your Astartes have sealed the Necron Tomb on "+string(you.name)+" "+string(scr_roman(obj_temp8.wid))+".");
                        scr_gov_disp(you.name,obj_temp8.wid,choose(1,2,3,4,5));
                        
                        if (!instance_exists(obj_temp8)){
                            pip.loc=battle_loc;
                            pip.planet=battle_id;
                        }
                        if (instance_exists(obj_temp8)){
                            pip.number=obj_temp8.popup;
                            pip.loc=obj_temp8.loc;
                            pip.planet=obj_temp8.wid;
                        }
                        
                        // show_message("Battle Closing: "+string(pip.loc)+"."+string(pip.planet));
                        
                        with(obj_temp5){instance_destroy();}
                        instance_activate_object(obj_star);
                        var have_bomb;have_bomb=scr_check_equip("Plasma Bomb",obj_temp8.loc,obj_temp8.wid,1);
                    }
                }
            }
            
            if (instance_exists(obj_temp8)) and (pip.planet=0){
                pip.number=obj_temp8.popup
                pip.loc=obj_temp8.loc;
                pip.planet=battle_id;
            }
        }
    }
    
    
    if ((string_count("spyrer",battle_special)>0))/* and (string_count("demon",battle_special)>0))*/ and (defeat=0){
        instance_activate_object(obj_star);
        // show_message(obj_turn_end.current_battle);
        // show_message(obj_turn_end.battle_world[obj_turn_end.current_battle]);
        // title / text / image / speshul
        var cur_star = obj_turn_end.battle_object[obj_turn_end.current_battle];
        var planet = obj_turn_end.battle_world[obj_turn_end.current_battle]
        var planet_string = scr_roman_numerals()[planet-1];
            
        remove_planet_problem(planet ,"spyrer",cur_star)
        
        var tixt=$"The Spyrer on {cur_star.name} {planet_string} has been removed.  The citizens and craftsman may sleep more soundly, the Inquisition likely pleased."
    
        scr_popup("Inquisition Mission Completed",tixt,"spyrer","");
        
        if (obj_controller.demanding=0) then obj_controller.disposition[4]+=2;
        if (obj_controller.demanding=1) then obj_controller.disposition[4]+=choose(0,0,1);
    
        scr_event_log("","Inquisition Mission Completed: The Spyrer on {cur_star.name} {planet} has been removed.", cur_star.name);
        scr_gov_disp(cur_star.name,planet,choose(1,2,3,4));
        
        instance_deactivate_object(obj_star);
    }
    
    if ((string_count("fallen",battle_special)>0)) and (defeat=0){
        var fallen=0;
        with (obj_turn_end){
            remove_planet_problem(battle_world[current_battle], "fallen", battle_object[current_battle])
            var tixt="The Fallen on "+ battle_object[current_battle].name;
            tixt+=scr_roman(battle_world[current_battle]);
            scr_event_log("",$"Mission Succesful: {tixt} have been captured or purged.");
            tixt+=$" have been captured or purged.  They shall be brought to the Chapter {obj_ini.role[100][14]}s posthaste, in order to account for their sins.  ";
            var ran;ran=choose(1,1,2,3);
            if (ran=1) then tixt+="Suffering is the beginning to penance.";
            if (ran=2) then tixt+="Their screams shall be the harbringer of their contrition.";
            if (ran=3) then tixt+="The shame they inflicted upon us shall be written in their flesh.";
            scr_popup("Hunt the Fallen Completed",tixt,"fallen","");        
        }
    }
    
    if (defeat=0) and (enemy=9) and (battle_special="tyranid_org"){
        if (captured_gaunt>1){
            pop=instance_create(0,0,obj_popup);
            pop.image="inquisition";
            pop.title="Inquisition Mission Completed";
            pop.text="You have captured several Gaunt organisms.  The Inquisitor is pleased with your work, though she notes that only one is needed- the rest are to be purged.  It will be stored until it may be retrieved.  The mission is a success.";
        }
        if (captured_gaunt=1){
            pop=instance_create(0,0,obj_popup);
            pop.image="inquisition";
            pop.title="Inquisition Mission Completed";
            pop.text="You have captured a Gaunt organism- the Inquisitor is pleased with your work.  The Tyranid will be stored until it may be retrieved.  The mission is a success.";
        }
    }
    
    
    
    if (enemy=1) and (on_ship=true) and (defeat=0){
        var diceh=floor(random(100))+1;
        
        if(scr_has_disadv("Shitty Luck")) then diceh-=15;
        
        if (diceh<=15){
            var ship,ship_hp,i=-1;
            for (var i=0;i<array_length(obj_ini.ship);i++){
                ship[i]=obj_ini.ship[i];
                ship_hp[i]=obj_ini.ship_hp[i];
                if (i=battle_id){
                    obj_ini.ship_hp[i]=-50;
                    scr_recent("ship_destroyed",obj_ini.ship[i],i);
                }
            }
            var pop=instance_create(0,0,obj_popup);
            pop.image="";
            pop.title="Ship Destroyed";
            pop.text="A handful of loyalist "+string(global.chapter_name)+" make a fighting retreat to the engine of the vessel, '"+string(obj_ini.ship[battle_id])+"', and then overload the main reactor.  Your ship explodes in a brilliant cloud of fire.";
            scr_event_log("red","A handful of loyalist "+string(global.chapter_name)+" overload the main reactor of your vessel '"+string(obj_ini.ship[battle_id])+"'.");
            pop.mission="loyalist_destroy_ship";

            scr_ini_ship_cleanup();
        }
    }
    
    
    
    
    if (enemy=1){
        if (battle_special="cs_meeting_battle1") or (battle_special="cs_meeting_battle2"){
            obj_controller.diplomacy=10;obj_controller.menu=20;
            with(obj_controller){scr_dialogue("cs_meeting21");}
        }
        
        // Chapter Master just murdered absolutely everyone
        if (battle_special="cs_meeting_battle7") and (defeat=0){
            if (obj_controller.chaos_rating<1) then obj_controller.chaos_rating+=1;
            obj_controller.complex_event=false;obj_controller.diplomacy=0;obj_controller.menu=0;
            obj_controller.force_goodbye=0;obj_controller.cooldown=20;
            obj_controller.current_eventing="chaos_meeting_end";
            with(obj_temp_meeting){instance_destroy();}with(obj_popup){instance_destroy();}
            if (instance_exists(obj_turn_end)){
                obj_turn_end.combating=0;// obj_turn_end.alarm[1]=1;
            }
            var pip;pip=instance_create(0,0,obj_popup);
            pip.title="Enemies Vanquished";pip.text="Not only have you killed the Chaos Lord, "+string(obj_controller.faction_leader[eFACTION.Chaos])+", but also all of your battle brothers that questioned your rule.  As you stand, alone, among the broken corpses of your enemies you begin to question what exactly it is that you accomplished.  No matter the results, you feel as though your actions have been noticed.";
        }
    }
    
    if (enemy=10){
        if ((battle_special="cs_meeting_battle10")) and (defeat=0){
            obj_controller.complex_event=false;obj_controller.diplomacy=0;obj_controller.menu=0;
            obj_controller.force_goodbye=0;obj_controller.cooldown=20;
            obj_controller.current_eventing="chaos_meeting_end";
            with(obj_temp_meeting){instance_destroy();}with(obj_popup){instance_destroy();}
            if (instance_exists(obj_turn_end)){
                obj_turn_end.combating=0;// obj_turn_end.alarm[1]=1;
            }
            var pip=instance_create(0,0,obj_popup);
            pip.title="Survived";
            pip.text="You and the rest of your battle brothers fight your way out of the catacombs, back through the tunnel where you first entered.  By the time you manage it your forces are battered and bloodied and in desperate need of pickup.  The whole meeting was a bust- Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" clearly intended to kill you and simply be done with it.";
        }
    
        if ((battle_special="cs_meeting_battle5") or (battle_special="cs_meeting_battle6")) and (defeat=0){
            var mos;mos=false;
            
            with(obj_ground_mission){instance_destroy();}
            with(obj_pnunit){
                var j;j=0;
                repeat(300){j+=1;
                    if (marine_type[j]="Master of Sanctity") then instance_create(0,0,obj_ground_mission);
                }
            }
            // Master of Sanctity present, wishes to take in the player
            if (instance_exists(obj_ground_mission)) and (string_count("CRMOS|",obj_controller.useful_info)=0){
                obj_controller.menu=20;
                with(obj_controller){
                    scr_dialogue("cs_meeting_m5");
                }
            }
            
            // Master of Sanctity not present, just get told that you have defeated the Chaos Lord
            if (!instance_exists(obj_ground_mission)) or (string_count("CRMOS|",obj_controller.useful_info)>0){
                // Some kind of popup based on what you were going after
                
                obj_controller.complex_event=false;obj_controller.diplomacy=0;obj_controller.menu=0;
                obj_controller.force_goodbye=0;obj_controller.cooldown=20;
                obj_controller.current_eventing="chaos_meeting_end";
                with(obj_temp_meeting){instance_destroy();}with(obj_popup){instance_destroy();}
                if (instance_exists(obj_turn_end)){
                    obj_turn_end.combating=0;// obj_turn_end.alarm[1]=1;
                }
                var pip;pip=instance_create(0,0,obj_popup);
                pip.title="Chaos Lord Killed";pip.text="(Not completed yet- variable reward based on what chosen)";
            }
            with(obj_ground_mission){instance_destroy();}
        }
    }
    
    
    
    if (battle_special="ship_demon"){
        if (defeat=1){
            var ship,ship_hp,i;i=-1;
            repeat(51){i+=1;
                ship[i]=obj_ini.ship[i];ship_hp[i]=obj_ini.ship_hp[i];
                if (i=battle_id){obj_ini.ship_hp[i]=-50;scr_recent("ship_destroyed",obj_ini.ship[i],i);}
            }
            var pop;pop=instance_create(0,0,obj_popup);
            pop.image="";
            pop.title="Ship Destroyed";
            pop.text="The daemon has slayed all of your marines onboard.  It works its way to the engine of the vessel, '"+string(obj_ini.ship[battle_id])+"', and then tears into the main reactor.  Your ship explodes in a brilliant cloud of fire.";
            scr_event_log("red","A daemon unbound from an Artifact wreaks havoc upon and destroys your vessel '"+string(obj_ini.ship[battle_id])+"'.");
            
            scr_ini_ship_cleanup();
        }
    }
    
    if (battle_special="space_hulk") and (defeat=0) and (hulk_treasure>0){
        var shi=0,loc="";

        var shiyp=instance_nearest(battle_object.x,battle_object.y,obj_p_fleet);
        if (shiyp.x == battle_object.x && shiyp.y ==battle_object.y){
            shi = fleet_full_ship_array(shiyp)[0];
            loc = obj_ini.ship[shi];
        }
        
        if (hulk_treasure=1){// Requisition
            var reqi=round(random_range(30,60)+1)*10;
            obj_controller.requisition+=reqi;
            
            var pop;pop=instance_create(0,0,obj_popup);
            pop.image="space_hulk_done";
            pop.title="Space Hulk: Resources";
            pop.text="Your battle brothers have located several luxury goods and coginators within the Space Hulk.  They are salvaged and returned to the ship, granting "+string(reqi)+" Requisition.";
        }else if (hulk_treasure=2){// Artifact
            //TODO this will eeroniously put artifacts in the wrong place but will resolve crashes
            var last_artifact = scr_add_artifact("random","random",4,loc,shi+500);
            var i=0;

            var pop=instance_create(0,0,obj_popup);
            pop.image="space_hulk_done";
            pop.title="Space Hulk: Artifact";
            pop.text=$"An Artifact has been retrieved from the Space Hulk and stowed upon {loc}.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought home and identified posthaste.";
            scr_event_log("","Artifact recovered from the Space Hulk.");
        }else if (hulk_treasure=3){// STC
            scr_add_stc_fragment();// STC here
            var pop;pop=instance_create(0,0,obj_popup);
            pop.image="space_hulk_done";
            pop.title="Space Hulk: STC Fragment";
            pop.text="An STC Fragment has been retrieved from the Space Hulk and safely stowed away.  It is ready to be decrypted or gifted at your convenience.";
            scr_event_log("","STC Fragment recovered from the Space Hulk.");
        }else if (hulk_treasure=4){// Termie Armour
            var termi=choose(2,2,2,3);
            scr_add_item("Terminator Armour",termi);
            var pop;pop=instance_create(0,0,obj_popup);
            pop.image="space_hulk_done";
            pop.title="Space Hulk: Terminator Armour";
            pop.text="The fallen heretics wore several suits of Terminator Armour- a handful of them were found to be cleansible and worthy of use.  "+string(termi)+" Terminator Armour has been added to the Armamentarium.";
        }
    }
    
    
    
    if ((leader=1) or (battle_special="world_eaters")) and (obj_controller.faction_defeated[10]=0) and (defeat=0) and (battle_special!="WL10_reveal") and (battle_special!="WL10_later"){
        if (battle_special!="WL10_reveal") and (battle_special!="WL10_later"){
        // prolly schedule a popup congratulating
        obj_controller.faction_defeated[enemy]=1;
        if (obj_controller.known[enemy]=0) then obj_controller.known[enemy]=1;
        
        if (battle_special!="world_eaters") then with(obj_star){
            if (string_count("WL"+string(obj_ncombat.enemy),p_feature[obj_ncombat.battle_id])>0){
                p_feature[obj_ncombat.battle_id]=string_replace(p_feature[obj_ncombat.battle_id],"WL"+string(obj_ncombat.enemy)+"|","");
            }
        }
        if (battle_special="world_eaters"){
            obj_controller.faction_defeated[10]=1;// show_message("WL10 defeated");
            if (instance_exists(obj_turn_end)){
                scr_event_log("","Enemy Leader Assassinated: Chaos Lord");
                scr_alert("","ass","Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" has been killed.",0,0);
                scr_popup("Black Crusade Ended","The Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" has been slain in combat.  Without his leadership the Black Crusade is destined to crumble apart and disintegrate from infighting.  Sector "+string(obj_ini.sector_name)+" is no longer at threat by the forces of Chaos.","","");
            }
            if (!instance_exists(obj_turn_end)){
                scr_event_log("","Enemy Leader Assassinated: Chaos Lord");
                var pop;pop=instance_create(0,0,obj_popup);
                pop.image="";pop.title="Black Crusade Ended";
                pop.text="The Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+" has been slain in combat.  Without his leadership the Black Crusade is destined to crumble apart and disintegrate from infighting.  Sector "+string(obj_ini.sector_name)+" is no longer at threat by the forces of Chaos.";
            }
        }
    }}
    
    
    
    instance_activate_all();
    with(obj_pnunit){instance_destroy();}
    with(obj_enunit){instance_destroy();}
    with(obj_nfort){instance_destroy();}
    with(obj_centerline){instance_destroy();}
    obj_controller.new_buttons_hide=0;
    
    
    if (instance_exists(obj_cursor)){
        obj_cursor.image_index=0;
    }
    
    instance_destroy();
    
    /* */
    /*  */
    
} catch(_exception) {
    handle_exception(_exception);
}