// TODO script description: This is the turn management in general 
// TODO refactor

try_and_report_loop("final end turn alarm 5",function(){
var recruit_count=0;
var random_marine, marine_position;
var eq1=1,eq2=1,eq3=1,t=0,r=0;
var marine_company=0;
var warn="",w5=0;
var g1=0,g2=0;
var onceh=0,stahp=0;
var disc=0,droll=0;
var rund=0;
var spikky=0;
var roll=0;
var novice_type="";
var unit;


try_and_report_loop("chaos_spread", function(){
    var times=max(1,round(turn/150));
    if (known[eFACTION.Chaos]==2) and (faction_defeated[eFACTION.Chaos]==0) then times+=1;
    var xx3, yy3, plani, _star;
    xx3=irandom(room_width)+1;
    yy3=irandom(room_height)+1;
    _star=instance_nearest(xx3,yy3,obj_star);
    plani=floor(random(_star.planets))+1;

    // ** Chaos influence / corruption **
    if (faction_gender[eFACTION.Chaos]==1) and (faction_defeated[eFACTION.Chaos]==0) and (turn>=chaos_turn) then repeat(times){
        if (_star.p_type[plani]!="Dead") and (_star.planets>0) and (turn>=20){
            var cathedral=0;
            if (planet_feature_bool(_star.p_feature[plani], P_features.Sororitas_Cathedral)==1) then cathedral=choose(0,1,1);
        
            if (cathedral=0){
                if (_star.p_heresy[plani]>=0) and (_star.p_heresy[plani]<10){
                    _star.p_heresy[plani]+=choose(0,0,0,0,0,0,0,0,5);
                }else if (_star.p_heresy[plani]>=10) and (_star.p_heresy[plani]<20){
                    _star.p_heresy[plani]+=choose(-2,-2,-2,5,10,15);
                }else if(_star.p_heresy[plani]>=20) and (_star.p_heresy[plani]<40){
                    _star.p_heresy[plani]+=choose(-2,-1,0,0,0,0,0,0,5,10);
                }else if(_star.p_heresy[plani]>=40) and (_star.p_heresy[plani]<60){
                    _star.p_heresy[plani]+=choose(-2,-1,0,0,0,0,0,0,5,10,15);
                }else if(_star.p_heresy[plani]>=60) and (_star.p_heresy[plani]<100){
                    _star.p_heresy[plani]+=choose(-1,0,0,0,0,5,10,15);
                }
            }
            if (_star.p_heresy[plani]<0) then _star.p_heresy[plani]=0;
        }
    }

    instance_activate_object(obj_star);
});

// ** Build new Imperial Ships **
try_and_report_loop("imperial ship build", function(){
    imp_ships=0;
    with(obj_en_fleet){
        if (owner==eFACTION.Imperium){
            obj_controller.imp_ships+=capital_number;
            obj_controller.imp_ships+=frigate_number/2;
            obj_controller.imp_ships+=escort_number/4;
        }
    }
    var imperium_worlds=[];
    var mechanicus_worlds=[];

    with(obj_star){
        //empty object simply acts as a counter for the number of imperial systems
        if (owner == eFACTION.Imperium){
            array_push(imperium_worlds, id);
        }else if (owner == eFACTION.Mechanicus){
            array_push(mechanicus_worlds, id);
        }
        //unknown function of temp5 same as temp6 but for mechanicus worlds
        if (space_hulk==1) or (craftworld==1){x-=20000;y-=20000;}
    }
    // Former: var sha;sha=instance_number(obj_temp6)*1.3;
    var mechanicus_world_total = array_length(mechanicus_worlds);

    var ship_allowance=array_length(imperium_worlds)*(0.65+(mechanicus_world_total*3));// new

            /*in order for new ships to spawn the number of total imperial ships must be smaller than 
             one third of the total imperial star systems*/
    if (mechanicus_world_total>0) and (imp_ships<ship_allowance){
        var rando=irandom(100)+1, rando2=choose(1,2,2,3,3,3);
        var forge=array_random_element(mechanicus_worlds);
        
        //the less mechanicus forge worlds the less likely to spawn a new fleet
        if (rando<=(12)*mechanicus_world_total){
            var new_defense_fleet=instance_create(forge.x,forge.y,obj_en_fleet);
            new_defense_fleet.owner= eFACTION.Imperium;
            new_defense_fleet.sprite_index=spr_fleet_imperial;
            switch(rando2){
                case 1:
                    new_defense_fleet.capital_number=1;
                    break;
                case 2:
                    new_defense_fleet.frigate_number=1;
                    break;
                case 3:
                    new_defense_fleet.escort_number=1;
                break;
            }
            new_defense_fleet.trade_goods="merge";
    		
    		var system_4 = [];
    		var system_3 = [];
    		var system_other = [];
    		
            with(obj_star) {
                if (x>10) and (y>10) and ((owner==eFACTION.Imperium) or (owner==eFACTION.Mechanicus)){
                    var system_fleet_elements=0;
    				
    				var fleet_types = [
    					eFACTION.Player,
    					eFACTION.Imperium,
    					eFACTION.Mechanicus,
    					eFACTION.Inquisition,
    					eFACTION.Ecclesiarchy,
    					eFACTION.Eldar,
    					eFACTION.Ork,
    					eFACTION.Tau,
    					eFACTION.Tyranids,
    					eFACTION.Chaos,
    					eFACTION.Necrons
    				];
    				
                    system_fleet_elements = array_sum(present_fleet)

    				var coords = [x,y];
    				
                    if (system_fleet_elements==0) {
                        switch(planets){
                            case 4:
                                array_push(system_4, coords);
                                break;
                            case 3:
                                array_push(system_3, coords);
                                break;
    						default:
    							if (p_type[1]!="Dead") {
    								array_push(system_other, coords);
    							}
                                break;
                        }
                    };
                }
            }
    		
            var targeted=false;
            var target;
    		//shuffle the contents, if any
    		array_shuffle_ext(system_4);
    		array_shuffle_ext(system_3);
    		array_shuffle_ext(system_other);

            if (targeted) {
    			target = array_pop(system_4)
                targeted=true;
    		}
    		if (targeted) {
    			target = array_pop(system_3)
                targeted=true;
    		}
    		if (targeted) {
    			target = array_pop(system_other)
                targeted=true;
    		}

            if (targeted){ 
                new_defense_fleet.action_x=target[0];
                new_defense_fleet.action_y=target[1];
                with (new_defense_fleet){
                    set_fleet_movement();
                }
            }
        }
    }

    instance_activate_object(obj_star);
    with(obj_star){
        if (x<-10000){x+=20000;y+=20000;}
        if (x<-10000){x+=20000;y+=20000;}
    }

});
apothecary_training();
chaplain_training();
librarian_training();
techmarine_training();


if (obj_ini.fleet_type!=1){
    with(obj_temp5){instance_destroy();}
    with(obj_p_fleet){
        if (action!="") then instance_create(x,y,obj_temp5);
        if (x<0) or (x>room_width) or (y<0) or (y>room_height) then instance_create(x,y,obj_temp5);
    }
    if (instance_number(obj_temp5)>=instance_number(obj_p_fleet)) then stahp=1;
    with(obj_temp5){instance_destroy();}
}

var recruits_finished=0,recruit_first="";

var total_recruits = 0;
var i=0;
while (i<array_length(recruit_name)){
    if (recruit_name[i]==""){
        i++; 
        continue;
    };
    if  (recruit_distance[i]<=0) then recruit_training[i]-=1;
    if (recruit_training[i]<=0){
        scr_add_man(obj_ini.role[100][12],10,recruit_exp[i],recruit_name[i],recruit_corruption[i],false,"default",recruit_data[i]);
        if (recruit_first=="") then recruit_first=recruit_name[i];
        recruits_finished+=1;
        array_delete(recruit_name,i,1);
        array_delete(recruit_corruption,i,1);
        array_delete(recruit_distance,i,1);
        array_delete(recruit_training,i,1);
        array_delete(recruit_exp,i,1);
        array_delete(recruit_data,i,1);
        continue;
    } else {
        total_recruits++;
    }
    i++;
}
with(obj_ini){
    scr_company_order(10);
}
if (recruits_finished==1){
    scr_alert("green","recruitment",$"{obj_ini.role[100][12]} {recruit_first} has joined X Company.",0,0);
}else if  (recruits_finished>1){
    scr_alert("green","recruitment",$"{recruits_finished}x {obj_ini.role[100][12]} have joined X Company.",0,0);
}


recruits=total_recruits;

/* TODO implement Lamenters get Black Rage and story
if (turn=240) and (global.chapter_name="Lamenters"){
    obj_ini.strin2+="Black Rage";
    scr_popup("Geneseed Mutation","Your Chapter has begun to have visions and nightmares of Sanguinius' fall.  The less mentally disciplined of your battle-brothers no longer are able to sleep soundly, waking from sleep in a screaming, frothing rage.  It appears the Black Rage has returned.","black_rage","");    
}
*/
// ** Battlefield Loot **
if (scr_has_adv("Tech-Scavengers")){
    var lroll1,lroll2,loot="";
    lroll1=floor(random(100))+1;
    lroll2=floor(random(100))+1;
    if (scr_has_disadv("Shitty Luck")){
        lroll1+=2;
        lroll2+=25;
    }
    if (lroll1<=5){
        loot=choose("Chainsword","Bolt Pistol","Combat Knife","Narthecium");
        if (lroll2<=80) then loot=choose("Power Sword","Storm Bolter");
        if (lroll2<=60) then loot=choose("Plasma Pistol","Chainfist","Lascannon","Heavy Bolter","Assault Cannon","Bike");
        if (lroll2<=30) then loot=choose("Artificer Armour","Plasma Gun","Chainfist","Rosarius","Psychic Hood");
        if (lroll2<=10) then loot=choose("Terminator Armour","Artificer Armour","Dreadnought","Plasma Gun","Power Fist","Thunder Hammer","Iron Halo");
        var tix="A "+string(loot)+" has been gifted to the Chapter.";
        tix=string_replace(tix,"A A","An A");
        tix=string_replace(tix,"A E","An E");
        tix=string_replace(tix,"A I","An I");
        tix=string_replace(tix,"A O","An O");
        scr_add_item(string(loot),1);
        scr_alert("","loot",tix,0,0);
    }
}
imperial_navy_fleet_construction();

// ** Adeptus Mechanicus Geneseed Tithe **
if (gene_tithe==0) and (faction_status[eFACTION.Imperium]!="War"){
    gene_tithe=24;

    var expected,txt="",mech_mad=false;
    var onceh=0;
    expected=max(1,round(obj_controller.gene_seed/20));
    if (obj_controller.faction_status[eFACTION.Mechanicus]=="War") then mech_mad=true;

    if (obj_controller.gene_seed<=0) or (mech_mad==true){
        onceh=2;
        gene_iou+=1;
        loyalty-=2;
        loyalty_hidden-=2;
        txt="No Gene-Seed for Adeptus Mechanicus tithe.  High Lords of Terra IOU increased to "+string(gene_iou)+".";
    }
    if (mech_mad==false){
        if (obj_controller.gene_seed>0) and (und_gene_vaults==0) and (onceh==0){
            obj_controller.gene_seed-=expected;
            onceh=1;
            if (obj_controller.gene_seed>=gene_iou) and (gene_iou>0){
                expected+=gene_iou;
                obj_controller.gene_seed-=gene_iou;
                gene_iou=0;
                onceh=3;
            }
            for(var i=0; i<50; i++){
                if (obj_controller.gene_seed<gene_iou) and (obj_controller.gene_seed>0) and (gene_iou>0){
                    expected+=1;
                    obj_controller.gene_seed-=1;
                    gene_iou-=1;
                    if (gene_iou==0) then onceh=3;
                }
            }

            if (gene_iou<0) then gene_iou=0;

            txt=string(expected)+" Gene-Seed sent to Adeptus Mechanicus for tithe.";
            if (gene_iou>0) then txt+="  IOU remains at "+string(gene_iou)+".";
            if (onceh==3) then txt+="  IOU has been payed off.";
        }

        if (obj_controller.gene_seed>0) and (und_gene_vaults>0) and (onceh==0){
            expected=1;
            obj_controller.gene_seed-=expected;
            onceh=1;

            if (obj_controller.gene_seed<gene_iou) and (obj_controller.gene_seed>0) and (gene_iou>0){
                expected+=1;
                obj_controller.gene_seed-=1;
                gene_iou-=1;
                if (gene_iou==0) then onceh=3;
            }

            if (gene_iou<0) then gene_iou=0;

            txt=string(expected)+" Gene-Seed sent to Adeptus Mechanicus for tithe.";
            if (gene_iou>0) then txt+="  IOU remains at "+string(gene_iou)+".";
            if (onceh==3) then txt+="  IOU has been payed off.";
        }

        if (onceh!=2){
            scr_alert("green","tithes",txt,0,0);
            scr_event_log("",txt);
        }
        if (onceh==2){
            scr_alert("red","tithes",txt,0,0);
            scr_event_log("red",txt);
        }
    }
}
if (gene_sold>0){
    disc=0;
    droll=0;
    gene_sold=floor(gene_sold*75)/100;

    if (gene_sold<1) then gene_sold=0;
    if (gene_sold>=50){
        disc=round(gene_sold/7);
        droll=floor(random(100))+1;

        // Inquisition takes notice
        if (droll<=disc) and (obj_controller.known[eFACTION.Inquisition]!=0){
            var disp_change=-3;
            if (gene_sold>=100) then disp_change=-5;
            if (gene_sold>=200) then disp_change=-7;
            if (gene_sold>=400) then disp_change=-10;
            gene_sold=0;
            scr_audience(4,"gene_trade",disp_change,"",2,0);
        }
    }
}
if (gene_xeno>0){
    disc=0;
    droll=0;
    gene_xeno=floor(gene_xeno*90)/100;

    if (gene_xeno<1) then gene_xeno=0;
    if (gene_xeno>=5){
        disc=round(gene_xeno/5);
        droll=floor(random(100))+1;

        // Inquisition takes notice
        if (droll<=disc) and (obj_controller.known[eFACTION.Inquisition]!=0){
            gene_xeno=99999;
            alarm[8]=1;
        }
    }
}
var p=0,penitorium=0, unit;
for(var c=0; c<11; c++){
    for(var e=1; e<=array_length(obj_ini.god); e++){
        if (obj_ini.god[c,e]>=10){
            unit=fetch_unit([c,e]);
            p+=1;
            penit_co[p]=c;
            penit_id[p]=e;
            penitorium+=1;
            unit.loyalty--;
            if (unit.corruption<90) and (unit.corruption>0){
                var heresy_old=0,heresy_new=0;
                heresy_old=round((unit.corruption*unit.corruption)/50)-0.5;
                heresy_new=(heresy_old*50)/unit.corruption;
                unit.corruption=max(0,heresy_new);
            }
        }
    }
}
// STC Bonuses
if (obj_controller.stc_ships>=6){
    //self healing ships logic
    for (var v=0; v<array_length(obj_ini.ship_hp); v++){
        if (obj_ini.ship[v]=="" || obj_ini.ship_hp[v]<0) then continue;
        if (obj_ini.ship_hp[v]<obj_ini.ship_maxhp[v]){
            var _max = obj_ini.ship_maxhp[v];
            obj_ini.ship_hp[v] = min(_max,obj_ini.ship_hp[v]+round(_max*0.06));
        }
    }
}

try_and_report_loop("Secret Chaos Warlord spawn", function(){
    if (turn==5) and (faction_gender[eFACTION.Chaos]==1) {// show_message("Turn 100");

        var _star_found = false;
        var _choice_star = noone;
        var _stars = scr_get_stars(true);
        for (var i=0;i<array_length(_stars);i++){
            if (is_dead_star(_stars[i])) then continue;
            with (_stars[i]){
                if (owner==eFACTION.Imperium && planets){
                    if (scr_orbiting_fleet(eFACTION.Imperium) != "none"){
                        _star_found=true;
                        _choice_star = self.id;
                        break;
                    }
                } 
            }
            if (_star_found){
                break;
            }
        }
        if (_star_found){
            var _planet = array_random_element(planets_without_type("Dead",_choice_star));
            _choice_star.warlord[_planet]=1;
            array_push(_choice_star.p_feature[_planet], new NewPlanetFeature(P_features.Warlord10));

            var _heresy_inc = _choice_star.p_type[_planet]=="Hive" ? 25 : 10;

            _choice_star.p_heresy[_planet] += _heresy_inc;

            if (_choice_star.p_heresy[_planet]<50) then _choice_star.p_heresy_secret[_planet]=10;        
        }
    }
});
// * Blood debt end *
if (blood_debt==1) and (penitent==1){
    penitent_turn+=1;
    // was -60
    penitent_turnly=((penitent_turn*penitent_turn)-512)*-1;
    if (penitent_turnly>0) then penitent_turnly=0;
    penitent_current+=penitent_turnly;
    if (penitent_current<=0){
        penitent=0;
        alarm[8]=1;
    }
    if (penitent_end<30000) then penitent_end+=41000;
    if (penitent_current>=penitent_max) or (((obj_controller.millenium*1000)+obj_controller.year)>=penitent_end){
        penitent=0;
        if (known[eFACTION.Inquisition]==2) or (known[eFACTION.Inquisition]>=4) then scr_audience(4,"penitent_end",0,"",0,0);
        if (known[eFACTION.Ecclesiarchy]>=2) then scr_audience(5,"penitent_end",0,"",0,0);
        disposition[eFACTION.Imperium]+=20;
        disposition[eFACTION.Mechanicus]+=15;
        disposition[eFACTION.Inquisition]+=20;
        disposition[eFACTION.Ecclesiarchy]+=20;
        var o=0;
        if (scr_has_adv("Reverent Guardians")) then o=500;
        if (o>100) then obj_controller.disposition[eFACTION.Ecclesiarchy]+=10;
        scr_event_log("","Blood Debt payed off.  You may once more recruit Astartes.");
    }
}
// * Penitent Crusade end *
if (penitent==1) and (blood_debt==0){
    penitent_turn+=1;
    penitent_current+=1;
    penitent_turnly=0;

    if (penitent_current<=0){
        penitent=0;
        alarm[8]=1;
    }
    if (penitent_current>=penitent_max){
        penitent=0;
        if (known[eFACTION.Inquisition]==2) or (known[eFACTION.Inquisition]>=4) then scr_audience(4,"penitent_end",0,"",0,0);
        if (known[eFACTION.Ecclesiarchy]>=2) then scr_audience(5,"penitent_end",0,"",0,0);
        disposition[eFACTION.Imperium]+=20;
        disposition[eFACTION.Mechanicus]+=15;
        disposition[eFACTION.Imperium]+=20;
        disposition[eFACTION.Ecclesiarchy]+=20;
        var o=0;
        if (scr_has_adv("Reverent Guardians")) then o=500;
        if (o>100) then obj_controller.disposition[eFACTION.Ecclesiarchy]+=10;
        scr_event_log("","Penitent Crusade ends.  You may once more recruit Astartes.");
    }
}
// ** Ork WAAAAGH **
if ((turn>=irandom(200)+100) or (obj_ini.fleet_type==eFACTION.Mechanicus)) and (faction_defeated[eFACTION.Ork]==0){
    var waaagh=floor(random(100))+1;
    with(obj_star){
        if (owner==eFACTION.Ork) then instance_create(x,y,obj_temp2);
    }
    if ((instance_number(obj_temp2)>=5) and (waaagh<=instance_number(obj_temp2)) and (obj_controller.known[eFACTION.Ork]==0))/* or (obj_controller.is_test_map=true)*/{
        obj_controller.known[eFACTION.Ork]=0.5;
		//set an alarm for all ork controlled planets
        with(obj_star){
            if (owner==eFACTION.Ork) then alarm[4]=1;
        }

        if (!instance_exists(obj_turn_end)) then scr_popup("WAAAAGH!","The greenskins have swelled in activity, their numbers increasing seemingly without relent.  A massive Warboss has risen to take control, leading most of the sector's Orks on a massive WAAAGH!","waaagh","");
		
        if (instance_exists(obj_turn_end)){
            obj_turn_end.popups+=1;
            obj_turn_end.popup[obj_turn_end.popups]=1;
            obj_turn_end.popup_type[obj_turn_end.popups]="WAAAAGH!";
            obj_turn_end.popup_text[obj_turn_end.popups]="The greenskins have swelled in activity, their numbers increasing seemingly without relent.  A massive Warboss has risen to take control, leading most of the sector's Orks on a massive WAAAGH!";
            obj_turn_end.popup_image[obj_turn_end.popups]="waaagh";
            scr_event_log("red","Ork WAAAAGH! begins.");

            with(obj_star){
                if (owner==eFACTION.Ork){
                    rund=floor(random(planets))+1;
                    if (p_owner[rund]==eFACTION.Ork) and (p_pdf[rund]==0) and (p_guardsmen[rund]==0) and (p_orks[rund]>=2) then instance_create(x,y,obj_temp6);
                }
            }
            if (instance_exists(obj_temp6)){
                var you2,you;
                rund=0;
                you2=instance_nearest(random(room_width),random(room_height),obj_temp6);
                you=instance_nearest(you2.x,you2.y,obj_star);

                with(obj_temp2){instance_destroy();}
                for(var i=0; i<10; i++){
                    if (!instance_exists(obj_temp2)){
                        rund=round(random(you.planets));
						if (rund>0) and(rund<5){
							if	(you.p_owner[rund]==eFACTION.Ork) and (you.p_pdf[rund]+you.p_guardsmen[rund]==0) and (you.p_orks[rund]>=2) then array_push( you.p_feature[rund], new NewPlanetFeature(P_features.OrkWarboss));
						}
                        if (you.p_orks[rund]<4) then you.p_orks[rund]=4;
                        if (planet_feature_bool(you.p_feature[rund], P_features.OrkWarboss)==1) then instance_create(x,y,obj_temp2);
                    }
                }
            }
            with(obj_temp6){instance_destroy();}
            with(obj_temp2){instance_destroy();}
        }
    }
    with(obj_temp2){instance_destroy();}
}

// if (known[eFACTION.Ecclesiarchy]=1){var spikky;spikky=choose(0,0,0,1,1);if (spikky=1) then with(obj_turn_end){audiences+=1;audien[audiences]=5;audien_topic[audiences]="intro";}}
if (known[eFACTION.Ecclesiarchy]==1){
    spikky=choose(0,1,1);
    if (spikky==1) then with(obj_turn_end){
        audiences+=1;
        audien[audiences]=eFACTION.Ecclesiarchy;
        known[eFACTION.Ecclesiarchy] = 2;
        audien_topic[audiences]="intro";
        if (obj_controller.faction_status[eFACTION.Ecclesiarchy]=="War") then audien_topic[audiences]="declare_war";
    }
}
if (known[eFACTION.Eldar]==1) and (faction_defeated[eFACTION.Eldar]==0){
    spikky=choose(0,1);
    if (spikky==1) then with(obj_turn_end){
        audiences+=1;
        audien[audiences]= eFACTION.Eldar;
        audien_topic[audiences]="intro1";
    }
}
if (known[eFACTION.Ork]==0.5) and (faction_defeated[eFACTION.Ork]==0){
    spikky=floor(random(7));
    if (spikky==1) then with(obj_turn_end){
        audiences+=1;
        audien[audiences]=eFACTION.Ork;
        audien_topic[audiences]="intro";
    }
}
if (known[eFACTION.Tau]==1) and (faction_defeated[eFACTION.Tau]==0){
    with(obj_turn_end){
        audiences+=1;
        audien[audiences]=8;
        audien_topic[audiences]="intro";
    }
}
// ** Quests here **
// 135 ; quests
for(var i=1; i<=40; i++){
    if (quest_end[i]<=turn) and (quest[i]!=""){
        scr_quest(1,quest[i],quest_faction[i],0);
        quest[i]="";
    }
    if (quest[i]=="") and (quest[i+1]!=""){
        quest[i]=quest[i+1];
        quest_faction[i]=quest_faction[i+1];
        quest_end[i]=quest_end[i+1];
        quest[i+1]+="";
        quest_faction[i+1]=0;
        quest_end[i+1]=0;
    }
}
// ** Inquisition stuff here **
if (disposition[eFACTION.Eldar]>=60) then scr_loyalty("Xeno Associate","+");
if (disposition[eFACTION.Ork]>=60) then scr_loyalty("Xeno Associate","+");
if (disposition[eFACTION.Tau]>=60) then scr_loyalty("Xeno Associate","+");

var loyalty_counter=0;
loyalty_counter=scr_role_count(obj_ini.role[100][15],"");
if (loyalty_counter==0) then scr_loyalty("Lack of Apothecary","+");

loyalty_counter=scr_role_count(obj_ini.role[100][14],"");
if (loyalty_counter==0) then scr_loyalty("Undevout","+");
// TODO in another PR rework how Non-Codex Size is determined, perhaps the inquisition needs to pass some checks or do an investigation event 
// which you could eventually interrupt (kill the team) and cover it up?
if (marines>=1050) then scr_loyalty("Non-Codex Size","+");

var last_inquisitor_inspection=0;
if (obj_ini.fleet_type=ePlayerBase.home_world) then last_inquisitor_inspection=last_world_inspection;
if (obj_ini.fleet_type != ePlayerBase.home_world) then last_inquisitor_inspection=last_fleet_inspection;

var inspec=false;
if (loyalty>=85) and ((last_inquisitor_inspection+59)<turn) then inspec=true;
if (loyalty>=70) and (loyalty<85) and ((last_inquisitor_inspection+47)<turn) then inspec=true;
if (loyalty>=50) and (loyalty<70) and ((last_inquisitor_inspection+35)<turn) then inspec=true;
if (loyalty<50) and ((last_inquisitor_inspection+11+choose(1,2,3,4))<turn) then inspec=true;

if (obj_ini.fleet_type != ePlayerBase.home_world){
    if (instance_number(obj_p_fleet)==1) and (obj_ini.fleet_type = ePlayerBase.home_world){// Might be crusading, right?
        if (obj_p_fleet.x<0) or (obj_p_fleet.x>room_width) or (obj_p_fleet.y<0) or (obj_p_fleet.y>room_height) then inspec=false;
    }
    if (instance_number(obj_p_fleet)==0) then inspec=false;
}
instance_activate_object(obj_p_fleet);

//setup inquisitor inspections
var inquisitor_fleet_count = 0;
with(obj_fleet){if (owner==eFACTION.Inquisition) then inquisitor_fleet_count++}

inspec = (inspec && faction_status[eFACTION.Inquisition]!="War" &&inquisitor_fleet_count==0);
if (inspec)  {
    new_inquisitor_inspection();
}

with(obj_temp6){instance_destroy();}

for(var i=1; i<=10; i++){
    if (turns_ignored[i]==0) and (annoyed[i]>0) then annoyed[i]-=1;
}
// ** Various checks for imperium and faction relations **
for(var i=1; i<=99; i++){
    if (event[i]!="") and (event_duration[i]>0){
        event_duration[i]-=1;
        if (event_duration[i]==0){

            if (event[i]=="game_over_man") then obj_controller.alarm[8]=1;
            // Removes planetary governor installed by the chapter
            if (string_count("remove_serf",event[i])>0){
                explode_script(event[i],"|");
                var ta=string(explode[0]);
                var star_name=string(explode[1]);
                var planet=real(explode[2]);
                var event_star = star_by_name(star_name);
                if (event_star!="none"){
                    event_star.dispo[planet]=-10;// Resets
                    var twix=$"Inquisition executes Chapter Serf in control of {star_name} {planet} and installs a new Planetary Governor.";
                    if (event_star.p_owner[planet]=eFACTION.Player) then event_star.p_owner[planet]=event_star.p_first[planet];
                    scr_alert("","",twix,0,0);
                    scr_event_log("",twix, star_name);
                }
            }
            // Changes relation to good
            if (event[i]=="enemy_imperium"){
                scr_alert("green","enemy","You have made amends with your enemy in the Imperium.",0,0);
                disposition[eFACTION.Imperium]+=20;
                scr_event_log("","Amends made with Imperium.");
            }
            if (event[i]=="enemy_mechanicus"){
                scr_alert("green","enemy","You have made amends with your Mechanicus enemy.",0,0);
                disposition[eFACTION.Mechanicus]+=20;
                scr_event_log("","Amends made with Mechanicus enemy.");
            }
            if (event[i]=="enemy_inquisition"){
                scr_alert("green","enemy","You have made amends with your enemy in the Inquisition.",0,0);
                disposition[eFACTION.Inquisition]+=20;
                scr_event_log("","Amends made with Inquisition enemy.");
            }
            if (event[i]=="enemy_ecclesiarchy"){
                scr_alert("green","enemy","You have made amends with your enemy in the Ecclesiarchy.",0,0);
                disposition[eFACTION.Ecclesiarchy]+=20;
                scr_event_log("","Amends made with Ecclesiarchy enemy.");
            }
            // Sector commander losses its mind
            if (event[i]=="imperium_daemon"){
                var alert_string = $"Sector Commander {faction_leader[eFACTION.Imperium]} has gone insane."
                scr_alert("red","lol",alert_string,0,0);
                faction_defeated[eFACTION.Imperium]=1;
                scr_event_log("red",alert_string);
            }
            // Starts chaos invasion
		    if (event[i]=="chaos_invasion"){ 
				var xx=0,yy=0,flee=0,dirr=0;
                var star_id = scr_random_find(1,true,"","");
				if(star_id != undefined){
                    scr_event_log("purple","Chaos Fleets exit the warp near the "+string(star_id.name)+" system.", star_id.name);
                    for(var j=0; j<4; j++){
                        dirr+=irandom_range(50,100);
                        xx=star_id.x+lengthdir_x(72,dirr);
						yy=star_id.y+lengthdir_y(72,dirr);
                        flee=instance_create(xx,yy,obj_en_fleet);
						flee.owner=eFACTION.Chaos;
                        flee.sprite_index=spr_fleet_chaos;
						flee.image_index=4;
                        flee.capital_number=choose(0,1);
						flee.frigate_number=choose(2,3);
						flee.escort_number=choose(4,5,6);
                        flee.trade_goods="csm";
						obj_controller.chaos_fleets+=1;
                        flee.action_x=star_id.x;
						flee.action_y=star_id.y;
						flee.alarm[4]=1;
                    }	
				}
            }
            // Ships construction
            if (string_count("new_",event[i])>0){
                var new_ship_event=event[i];
                var active_forges = [];
                var chosen_star = false;
                with(obj_star){
                    if (owner==eFACTION.Mechanicus){
                        for (i=1;i<=planets;i++){
                            if (p_type[i]=="Forge") and (p_owner[i]==eFACTION.Mechanicus){
                                array_push(active_forges,new PlanetData(i, self));
                            }
                        }
                    }
                }
                if (array_length(active_forges)>0){
                    var ship_spawn = active_forges[irandom(array_length(active_forges)-1)];
                    var _new_player_fleet=instance_create(ship_spawn.system.x,ship_spawn.system.y,obj_p_fleet);

                    // Creates the ship
                    var last_ship = new_player_ship(new_ship_event, ship_spawn.system.name);

                    add_ship_to_fleet(last_ship, _new_player_fleet)

                    // show_message(string(obj_ini.ship_class[last_ship])+":"+string(obj_ini.ship[last_ship]));

                    if (obj_ini.ship_size[last_ship]!=1) then scr_popup("Ship Constructed",$"Your new {obj_ini.ship_class[last_ship]} '{obj_ini.ship[last_ship]}' has finished being constructed.  It is orbiting {ship_spawn.system.name} and awaits its maiden voyage.","shipyard","");
                    if (obj_ini.ship_size[last_ship]==1) then scr_popup("Ship Constructed",$"Your new {obj_ini.ship_class[last_ship]} Escort '{obj_ini.ship[last_ship]}' has finished being constructed.  It is orbiting {ship_spawn.system.name} and awaits its maiden voyage.","shipyard","");
                    var bob=instance_create(ship_spawn.system.x+16,ship_spawn.system.y-24,obj_star_event);
                    bob.image_alpha=1;
                    bob.image_speed=1;
                }
                if (array_length(active_forges)==0){
                    event_duration[i]=2;
                    scr_popup("Ship Construction halted",$"A lack of suitable forge worlds in the system has halted construction of your requested ship","shipyard","");
                }
                event[i]="";
                event_duration[i]-=1;
            }
            // Spare the inquisitor
            if (string_count("inquisitor_spared",event[i])>0){
                var diceh=floor(random(100))+1;

                if (scr_has_disadv("Shitty Luck")) then diceh-=25;

                if (diceh<=25){
                    alarm[8]=1;
                    scr_loyalty("Crossing the Inquisition","+");
                }
                if (diceh>25) and (diceh<=50){scr_loyalty("Crossing the Inquisition","+");}
                if (diceh>50) and (diceh<=85){}
                if (diceh>85) and (event[i]="inquisitor_spared2"){
                    scr_popup("Anonymous Message","You recieve an anonymous letter of thanks.  It mentions that motions are underway to destroy any local forces of Chaos.","","");
                    with(obj_star){
                        for(var o=1; o<=planets; o++){
                            p_heresy[o]=max(0,p_heresy[o]-10);
                        }
                    }
                }
            }

            if (string_count("strange_building",event[i])>0){
                var b_event="",marine_name="",comp=0,marine_num=0,item="",unit;
                explode_script(event[i],"|");
                b_event=string(explode[0]);
                marine_name=string(explode[1]);
                comp=real(explode[2]);
                marine_num=real(explode[3]);
                unit=obj_ini.TTRPG[comp][marine_num];
                item=string(explode[4]);

                var killy=0,tixt=string(obj_ini.role[100][16])+" "+string(marine_name)+" has finished his work- ";

                if (item=="Icon"){
                    tixt+="it is a "+string(global.chapter_name)+" Icon wrought in metal, finely decorated.  Pride for his chapter seems to have overtaken him.  There are no corrections to be made and the item is placed where many may view it.";
                }
                if (item=="Statue"){
                    tixt+="it is a small, finely crafted statue wrought in metal.  The "+string(obj_ini.role[100][16])+" is scolded for the waste of material, but none daresay the quality of the piece.";
                }
                if (item=="Bike"){
                    scr_add_item("Bike",1);
                    tixt+="it is a finely crafted Bike, conforming mostly to STC standards.  The other "+string(obj_ini.role[100][16])+" are surprised at the rapid pace of his work.";
                }
                if (item=="Rhino"){
                    scr_add_vehicle("Rhino",0,"Storm Bolter","Storm Bolter","","Artificer Hull","Dozer Blades");
                    tixt+="it is a finely crafted Rhino, conforming to STC standards.  The other "+string(obj_ini.role[100][16])+" are surprised at the rapid pace of his work.";
                }
                if (item=="Artifact"){
                    var last_artifact=0;
                    scr_event_log("",string(obj_ini.role[100][16])+" "+string(marine_name)+" constructs an Artifact.");
                    if (obj_ini.fleet_type==ePlayerBase.home_world){
                        last_artifact =  scr_add_artifact("random_nodemon","",0,obj_ini.home_name,2);
                    } else {
                        if (obj_ini.fleet_type != ePlayerBase.home_world){
                            last_artifact = scr_add_artifact("random_nodemon","",0,obj_ini.ship_location[0],501);
                        }
                    }

                    tixt+=$"some form of divine inspiration has seemed to have taken hold of him.  An artifact {obj_ini.artifact[last_artifact]} has been crafted.";
                }
                if (item=="baby"){
                    unit.edit_corruption(choose(8,12,16,20))
                    tixt+="some form of horrendous statue.  A weird amalgram of limbs and tentacles, the sheer atrocity of it is made worse by the tiny, baby-like form, the once natural shape of a human child twisted nearly beyond recognition.";
                }
                else if (item=="robot"){
                    unit.edit_corruption(choose(2,4,6,8,10));
                    tixt+=$"some form of small, box-like robot.  It seems to teeter around haphazardly, nearly falling over with each step. {unit.name()} maintains that it has no AI, though the other "+string(obj_ini.role[100][16])+" express skepticism.";
                    unit.add_trait("tech_heretic");
                }
                else if (item=="demon"){
                    unit.edit_corruption(choose(8,12,16,20));
                    tixt+="some form of horrendous statue.  What was meant to be some sort of angel, or primarch, instead has a mishappen face that is hardly human in nature.  Between the fetid, ragged feathers and empty sockets it is truly blasphemous.";
                    unit.add_trait("tech_heretic");
                }
                else if (item=="fusion"){
                    //TODO if tech heretic chosen don't kill the dude
                    // unit.corruption+=choose(70);
                    tixt+=$"some kind of ill-mannered ascension.  One of your battle-brothers enters the armamentarium to find {marine_name} fused to a vehicle, his flesh twisted and submerged into the frame.  Mechendrites and weapons fire upon the marine without warning, a windy scream eminating from the abomination.  It takes several battle-brothers to take out what was once a "+string(obj_ini.role[100][16])+".";

                    // This is causing the problem

                    scr_kill_unit(comp,marine_num)
                    with(obj_ini){scr_company_order(0);}
                }
                scr_popup("He Built It",tixt,"tech_build","target_marine|"+string(marine_name)+"|"+string(comp)+"|"+string(marine_num)+"|");
            }
            if (event_duration[i]<=0) then event[i]="";
        }
    }
}
for(var i=1; i<=99; i++){
    if (event[i]!="") and (event_duration[i]<=0) then event[i]="";
    if (event[i]=="") and (event_duration[i]==0) and (event[i+1]!=""){
        event[i]=event[i+1];
        event_duration[i]=event_duration[i+1];
        event[i+1]="";
        event_duration[i+1]=0;
    }
}
// Right here need to sort the battles within the obj_turn_end
with(obj_turn_end){scr_battle_sort();}

for(var i=1; i<=10; i++){
    if (turns_ignored[i]>0) and (turns_ignored[i]<500) then turns_ignored[i]-=1;
}
if (known[eFACTION.Eldar]>=2) and (faction_gender[6]==2) and (turn%10==0) then turns_ignored[6]+=floor(random_range(0,6));

with(obj_ground_mission){instance_destroy();}
scr_random_event(true);

// ** Random events here **
if (hurssy_time>0) and (hurssy>0) then hurssy_time-=1;
if (hurssy_time==0) and (hurssy>0){hurssy_time=-1;hurssy=0;}
with(obj_p_fleet){
    if (hurssy_time>0) and (hurssy>0) then hurssy_time-=1;
    if (hurssy_time==0) and (hurssy>0){hurssy_time=-1;hurssy=0;}
}
with(obj_star){
    if (p_hurssy_time[1]>0) and (p_hurssy[1]>0) then p_hurssy_time[1]-=1;
    if (p_hurssy_time[1]==0) and (p_hurssy[1]>0){
        p_hurssy_time[1]=-1;
        p_hurssy[1]=0;
    }
    if (p_hurssy_time[2]>0) and (p_hurssy[2]>0) then p_hurssy_time[2]-=1;
    if (p_hurssy_time[2]==0) and (p_hurssy[2]>0){
        p_hurssy_time[2]=-1;
        p_hurssy[2]=0;
    }
    if (p_hurssy_time[3]>0) and (p_hurssy[3]>0) then p_hurssy_time[3]-=1;
    if (p_hurssy_time[3]=0) and (p_hurssy[3]>0){
        p_hurssy_time[3]=-1;
        p_hurssy[3]=0;
    }
    if (p_hurssy_time[4]>0) and (p_hurssy[4]>0) then p_hurssy_time[4]-=1;
    if (p_hurssy_time[4]==0) and (p_hurssy[4]>0){
        p_hurssy_time[4]=-1;
        p_hurssy[4]=0;
    }
}

if (turn==2){
    if (obj_ini.master_name=="Zakis Randi") or (global.chapter_name=="Knights Inductor") and (obj_controller.faction_status[eFACTION.Imperium]!="War") then alarm[8]=1;
}
// ** Player-set events **
if (fest_scheduled>0) and (fest_repeats>0){
    var lock="",cm_present=false;
    fest_repeats-=1;
    lock=scr_master_loc();

    if (fest_sid>0) and (obj_ini.ship[fest_sid]=lock) then cm_present=true;
    if (fest_wid>0) and (string(fest_star)+"."+string(fest_wid)=lock) then cm_present=true;

    if (cm_present==true){
        var imag="";

        if (fest_type=="Great Feast") then imag="event_feast";
        if (fest_type=="Tournament") then imag="event_tournament";
        if (fest_type=="Deathmatch") then imag="event_deathmatch";
        if (fest_type=="Imperial Mass") then imag="event_mass";
        if (fest_type=="Cult Sermon") then imag="event_ccult";
        if (fest_type=="Chapter Relic") then imag="event_ccrelic";
        if (fest_type=="Triumphal March") then imag="event_march";

        if (fest_wid>0) then scr_popup("Scheduled Event","Your "+string(fest_type)+" takes place on "+string(fest_star)+" "+scr_roman(fest_wid)+".  Would you like to spectate the event?",imag,"");
        if (fest_sid>0) then scr_popup("Scheduled Event","Your "+string(fest_type)+" takes place on the ship '"+string(obj_ini.ship[fest_sid])+".  Would you like to spectate the event?",imag,"");
    }
}

// ** Income **
// if (income_controlled_planets>0){

//     var tithe_string = income_controlled_planets==1? $"-{income_tribute} Requisition granted by tithes from 1 planet.": $"-{income_tribute} Requisition granted by tithes from {income_controlled_planets} planets.";
//     scr_alert("yellow", "planet_tithe", tithe_string);
//     instance_activate_object(obj_p_fleet);

//     with(obj_star){
//         if (x<-10000){
//             x+=20000;
//             y+=20000;
//         }
//     }
// }

//research and forge related actions

research_end();
merge_ork_fleets();
//complex route plotting for player fleets
return_lost_ships_chance();
with (obj_p_fleet){
    if (array_length(complex_route)>0  && action == ""){
        set_new_player_fleet_course(complex_route);
    }
}

});
