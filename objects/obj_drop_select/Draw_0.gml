set_zoom_to_defualt();

var __b__;
__b__ = action_if_number(obj_ncombat, 0, 0);
if __b__
{
__b__ = action_if_number(obj_popup, 0, 0);
if __b__
{
__b__ = action_if_variable(purge, 0, 0);
if __b__
{


var xx, yy;
xx=__view_get( e__VW.XView, 0 );
yy=__view_get( e__VW.YView, 0 );


draw_sprite(spr_popup_large,1,xx+534,yy+201);
draw_set_halign(fa_center);
draw_set_font(fnt_40k_30b);

// var xx,yy;
// xx=view_xview[0]+545;yy=view_yview[0]+212;
draw_set_halign(fa_left);draw_set_color(c_gray);
var attack_type = attack ? "Attacking" : "Raiding"
draw_text_transformed(xx+545,yy+212,$"{attack_type} ({planet_numeral_name(planet_number, p_target)} )",0.6,0.6,0);


draw_set_color(c_gray);
draw_set_font(fnt_40k_14);
draw_set_halign(fa_left);

// Planet icon here
draw_rectangle(xx+1084,yy+215,xx+1142,yy+273,0);

// Target
var tt1,tt2,fork;tt1="";tt2="";fork=0;
if (attacking=5){fork=sisters;tt1="Ecclesiarchy (";}
if (attacking=6){fork=eldar;tt1="Eldar (";}
if (attacking=7){fork=ork;tt1="Orks (";}
if (attacking=8){fork=tau;tt1="Tau (";}
if (attacking=9){fork=tyranids;tt1="Tyranids (";}
if (attacking=10){fork=traitors;tt1="Heretics (";}
if (attacking=11){fork=csm;tt1="CSMs (";}
if (attacking=12){fork=demons;tt1="Daemons (";}
if (attacking=13){fork=necrons;tt1="Necrons (";}
if (fork=0) then tt2="";
if (fork=1) then tt2="Negligible";
if (fork=2) then tt2="Minor";
if (fork=3) then tt2="Moderate";
if (fork=4) then tt2="High";
if (fork=5) then tt2="Very High";
if (fork>=6) then tt2="Overwhelming";
tt1+=string(tt2)+")";
draw_text(xx+550,yy+245,string_hash_to_newline(string(tt1)));


// Formation
// draw_set_alpha(1);draw_text(xx+872,yy+212,"Formation:");
draw_set_alpha(1);draw_text(xx+873,yy+207,string_hash_to_newline("Formation:"));
var x9,y9;x9=xx+954;y9=yy+214;if (scr_hit(x9,y9,x9+120,y9+16)=true) then draw_set_alpha(0.8);
draw_set_color(c_gray);draw_rectangle(x9,y9,x9+120,y9+16,0);draw_set_alpha(1);// 160
draw_set_color(c_black);draw_text_transformed(x9+2,y9,string_hash_to_newline(obj_controller.bat_formation[formation_possible[formation_current]]),0.8,0.8,0);
if (point_and_click([x9,y9,x9+120,y9+16])) {
    formation_current+=1;
    if (formation_possible[formation_current]=0) then formation_current=1;
}











// Ships Are Up, Fuck Me
draw_text(xx+550,yy+273,string_hash_to_newline("Available Forces:"));



var column,row,e,x8,y8,sigh,sip;e=0;sigh=0;sip=1;
column=1;row=1;x8=xx+552;y8=yy+299;e=500;


var add_ground;add_ground=0;        // Local Forces here

if (ship_max[500]>0) and (attack=1){
    if (ship_all[e]=0) then draw_set_alpha(0.35);
    draw_set_color(c_gray);draw_rectangle(x8,y8,x8+160,y8+16,0);
    draw_set_color(c_black);draw_text(x8+2,y8,string_hash_to_newline("Local ("+string(ship_use[e])+"/"+string(ship_max[e])+")"))
    if (point_and_click([x8, y8, x8+160, y8+16])) {
        var onceh;onceh=0;
        refresh_raid=1;
        if (ship_all[e]=0){add_ground=1;}
        if (ship_all[e]=1){add_ground=-1;}
    }
    y8+=16;sip+=1;
}
e=1;


repeat(50){                                 // Ship Forces here
    if (ship[e]!="") and (ship_max[e]>0){
        draw_set_alpha(1);if (ship_all[e]=0) then draw_set_alpha(0.35);
        draw_set_color(c_gray);draw_rectangle(x8,y8,x8+160,y8+16,0);// 160
        draw_set_color(c_black);draw_text_transformed(x8+2,y8,string_hash_to_newline(string(ship[e])+" ("+string(ship_use[e])+"/"+string(ship_max[e])+")"),0.8,0.8,0);
        if (point_and_click([x8, y8, x8+160, y8+16])) {
            if (ship_all[e]>-1 && ship_all[e]<2){
                 scr_drop_fiddle(ship_ide[e],!ship_all[e],e,attack);
                 refresh_raid=true;
            }
        }
        y8+=18;sip+=1;
        if (y8>=yy+299+180){y8=yy+299;x8+=168;}
    }
    e+=1;
}


draw_set_font(fnt_40k_14);draw_set_color(c_gray);draw_set_alpha(1);



var sel;sel="";
if (master=1) then sel+="Chapter Master "+string(obj_ini.master_name)+", ";
if (honor>1) then sel+=string(honor)+" Honour Guard, ";
if (honor=1) then sel+="1 Honour Guard, ";
if (capts>1) then sel+=string(capts)+" Captains, ";
if (capts=1) then sel+="1 Captain, ";
if (champions>1) then sel+=string(champions)+" Champions, ";
if (champions=1) then sel+="1 Champion, ";
if (chaplains>1) then sel+=string(chaplains)+" Chaplains, ";
if (chaplains=1) then sel+="1 Chaplain, ";
if (apothecaries>1) then sel+=string(apothecaries)+" Apothecaries, ";
if (apothecaries=1) then sel+="1 Apothecary, ";
if (psykers>1) then sel+=string(psykers)+" Psykers, ";
if (psykers=1) then sel+="1 Psyker, ";
if (techmarines>1) then sel+=string(techmarines)+" Techmarines, ";
if (techmarines=1) then sel+="1 Techmarine, ";
if (terminators>1) then sel+=string(terminators)+" Terminators, ";
if (terminators=1) then sel+="1 Terminator, ";
if (veterans>1) then sel+=string(veterans)+" Veteran, ";
if (veterans=1) then sel+="1 Veteran, ";
if (mahreens>1) then sel+=string(mahreens)+" Marines, ";
if (mahreens=1) then sel+="1 Marine, ";
if (dreads>1) then sel+=string(dreads)+" Dreadnought, ";
if (dreads=1) then sel+="1 Dreadnought, ";
// Attacking
if (bikes>1) then sel+=string(bikes)+" Bikes, ";
if (bikes=1) then sel+="1 Bike, ";
if (speeders>1) then sel+=string(speeders)+" Land Speeders, ";
if (speeders=1) then sel+="1 Land Speeder, ";
if (rhinos>1) then sel+=string(rhinos)+" Rhinos, ";
if (rhinos=1) then sel+="1 Rhino, ";
if (whirls>1) then sel+=string(whirls)+" Whirlwinds, ";
if (whirls=1) then sel+="1 Whirlwind, ";
if (predators>1) then sel+=string(predators)+" Predators, ";
if (predators=1) then sel+="1 Predator, ";
if (raiders>1) then sel+=string(raiders)+" Land Raider, ";
if (raiders=1) then sel+="1 Land Raider, ";
draw_text_ext(xx+550,yy+486,string_hash_to_newline(string(sel)),-1,590);



var caption;caption="";e=0;x8=xx+553;y8=yy+555;
draw_set_halign(fa_center);
repeat(8){e+=1;
    if (e=6){x8=xx+553;y8=yy+585;}
    if (e=8) then x8=xx+826;
    
    var onceh;onceh=0;
    draw_set_alpha(1);
    
    if (e=1) and (raid_tact=0) then draw_set_alpha(0.35);if (e=1) then caption="Tacticals";
    if (e=2) and (raid_vet=0) then draw_set_alpha(0.35);if (e=2) then caption="Veterans";
    if (e=3) and (raid_assa=0) then draw_set_alpha(0.35);if (e=3) then caption="Assault Marines";
    if (e=4) and (raid_deva=0) then draw_set_alpha(0.35);if (e=4) then caption="Devastators";
    if (e=5) and (raid_scou=0) then draw_set_alpha(0.35);if (e=5) then caption="Scouts";
    if (e=6) and (raid_term=0) then draw_set_alpha(0.35);if (e=6) then caption="Terminators";
    if (e=7) and (raid_spec=0) then draw_set_alpha(0.35);if (e=7) then caption="Specialists";
    if (e=8) and (raid_wounded=0) then draw_set_alpha(0.35);if (e=8) then caption="Wounded";
    
    draw_set_color(c_gray);draw_rectangle(x8,y8,x8+105,y8+16,0);
    draw_set_alpha(1);draw_set_color(0);draw_text(x8+52,y8,string_hash_to_newline(string(caption)));
    
    if (scr_hit(x8,y8,x8+105,y8+16)=true){
        draw_set_alpha(0.2);draw_rectangle(x8,y8,x8+105,y8+16,0);draw_set_alpha(1);
        if (scr_click_left()){
            if (e=1){if (raid_tact=1) and (onceh=0){onceh=1;raid_tact=0;refresh_raid=1;}if (raid_tact=0) and (onceh=0){onceh=1;raid_tact=1;refresh_raid=1;}}
            if (e=2){if (raid_vet=1) and (onceh=0){onceh=1;raid_vet=0;refresh_raid=1;}if (raid_vet=0) and (onceh=0){onceh=1;raid_vet=1;refresh_raid=1;}}
            if (e=3){if (raid_assa=1) and (onceh=0){onceh=1;raid_assa=0;refresh_raid=1;}if (raid_assa=0) and (onceh=0){onceh=1;raid_assa=1;refresh_raid=1;}}
            if (e=4){if (raid_deva=1) and (onceh=0){onceh=1;raid_deva=0;refresh_raid=1;}if (raid_deva=0) and (onceh=0){onceh=1;raid_deva=1;refresh_raid=1;}}
            if (e=5){if (raid_scou=1) and (onceh=0){onceh=1;raid_scou=0;refresh_raid=1;}if (raid_scou=0) and (onceh=0){onceh=1;raid_scou=1;refresh_raid=1;}}
            if (e=6){if (raid_term=1) and (onceh=0){onceh=1;raid_term=0;refresh_raid=1;}if (raid_term=0) and (onceh=0){onceh=1;raid_term=1;refresh_raid=1;}}
            if (e=7){if (raid_spec=1) and (onceh=0){onceh=1;raid_spec=0;refresh_raid=1;}if (raid_spec=0) and (onceh=0){onceh=1;raid_spec=1;refresh_raid=1;}}
            if (e=8){if (raid_wounded=1) and (onceh=0){onceh=1;raid_wounded=0;refresh_raid=1;}if (raid_wounded=0) and (onceh=0){onceh=1;raid_wounded=1;refresh_raid=1;}}
            
            if (e=8) and (onceh=1) then obj_controller.select_wounded=raid_wounded;
        }
    }
    x8+=117;
}


draw_set_color(c_gray);draw_set_alpha(1);
yar=2;if (all_sel=1) then yar=3;draw_sprite(spr_creation_check,yar,xx+770,yy+270);yar=0;
if (point_and_click([xx+770, yy+270, xx+770+32, yy+270+32])) {
var onceh;onceh=0;
var onceh;once=0;i=0;
if (all_sel=0) and (onceh=0){
    repeat(60){i+=1;
        if (ship[i]!="") and (ship_all[i]=0){ship_all[i]=1;scr_drop_fiddle(ship_ide[i],true,i,attack);}
        if (attack=1){
            if (ship_all[500]=0) then add_ground=1;
            if (ship_all[500]=1) then add_ground=-1;
        }
    }
    onceh=1;all_sel=1;refresh_raid=1;
}
if (all_sel=1) and (onceh=0){
    repeat(60){i+=1;
            if (ship[i]!="") and (ship_all[i]=1){ship_all[i]=0;scr_drop_fiddle(ship_ide[i],false,i,attack);}
            if (attack=1){
                if (ship_all[500]=0) then add_ground=1;
                if (ship_all[500]=1) then add_ground=-1;
            }
        }
        onceh=1;all_sel=0;refresh_raid=1;
    }
}
draw_set_halign(fa_left);
draw_text_transformed(xx+770+30,yy+270+4,string_hash_to_newline("Select All"),1,1,0);






var smin,smax;
var w;w=-1;smin=0;smax=0;

// if (purge=2){repeat(61){w+=1;if (ship[w]!="") and (ship_size[w]>1){smax+=1;if (ship_all[w]>0) then smin+=1;}}}




if (add_ground=1){ships_selected+=1;remove_local=-1;
    /*master+=l_master;honor+=l_honor;
    capts+=l_capts;mahreens+=l_mahreens;
    veterans+=l_veterans;terminators+=l_terminators;
    dreads+=l_dreads;chaplains+=l_chaplains;
    psykers+=l_psykers;apothecaries+=l_apothecaries;
    techmarines+=l_techmarines;champions+=l_champions;*/
    
    bikes+=l_bikes;rhinos+=l_rhinos;
    whirls+=l_whirls;predators+=l_predators;
    raiders+=l_raiders;speeders+=l_speeders;
    
    refresh_raid=1;ship_all[500]=1;ship_use[500]=ship_max[500];
}
if (add_ground=-1){ships_selected-=1;remove_local=1;
    /*master-=l_master;honor-=l_honor;
    capts-=l_capts;mahreens-=l_mahreens;
    veterans-=l_veterans;terminators-=l_terminators;
    dreads-=l_dreads;chaplains-=l_chaplains;
    psykers-=l_psykers;apothecaries-=l_apothecaries;
    techmarines-=l_techmarines;champions-=l_champions;*/
    
    // Fuck me
    
    bikes-=l_bikes;rhinos-=l_rhinos;
    whirls-=l_whirls;predators-=l_predators;
    raiders-=l_raiders;speeders-=l_speeders;
    
    refresh_raid=1;ship_all[500]=0;ship_use[500]=0;
}add_ground=0;







repeat(61){w+=1;if (ship[w]!=""){smax+=ship_max[w];if (ship_all[w]>0) then smin+=ship_use[w];}}
if (ship_max[500]>0) and (ship_all[500]>0){smax+=ship_max[500];smin+=ship_max[500];}







var q;q=0;
repeat(20){q+=1;
    draw_set_alpha(0.4);if (attacking=force_present[q]) and (attacking>0){draw_set_alpha(1);}
    if (force_present[q]>0) then draw_sprite(spr_force_icon,force_present[q],xx+700+(q*50),yy+250);
    if (attacking=force_present[q]) and (attacking>0) then draw_sprite(spr_force_icon,15,xx+700+(q*50),yy+250);
    
    if (scr_hit(xx+700-8+(q*50),yy+250-16,xx+750+8+(q*50),yy+250+16)=true) and (force_present[q]!=0){
        var tt1,tt2,fork;tt1="";tt2="";fork=0;
        
        if (force_present[q]=5){fork=sisters;tt1="Ecclesiarchy ("+string(fork)+")";}
        if (force_present[q]=6){fork=eldar;tt1="Eldar ("+string(fork)+")";}
        if (force_present[q]=7){fork=ork;tt1="Orks ("+string(fork)+")";}
        if (force_present[q]=8){fork=tau;tt1="Tau ("+string(fork)+")";}
        if (force_present[q]=9){fork=tyranids;tt1="Tyranids ("+string(fork)+")";}
        if (force_present[q]=10){fork=traitors;tt1="Heretics ("+string(fork)+")";}
        if (force_present[q]=11){fork=csm;tt1="CSMs ("+string(fork)+")";}
        if (force_present[q]=12){fork=demons;tt1="Daemons ("+string(fork)+")";}
        if (force_present[q]=13){fork=necrons;tt1="Necrons ("+string(fork)+")";}
        
        if (fork=0) then tt2="";
        if (fork=1) then tt2="Negligible";
        if (fork=2) then tt2="Minor";
        if (fork=3) then tt2="Moderate";
        if (fork=4) then tt2="High";
        if (fork=5) then tt2="Very High";
        if (fork>=6) then tt2="Overwhelming";
        tt2+=" Threat Rating";
        
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(0);
        draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tt2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tt2),-1,500),0);
        draw_set_color(c_gray);
        draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(tt2),-1,500)+24,mouse_y+44+string_height_ext(string_hash_to_newline(tt2),-1,500),1);
        draw_set_font(fnt_40k_14b);draw_text(mouse_x+22,mouse_y+22,string_hash_to_newline(string(tt1)));
        draw_set_font(fnt_40k_14);draw_text_ext(mouse_x+22,mouse_y+42,string_hash_to_newline(string(tt2)),-1,500);
        
        if(scr_click_left()){
            if (attacking!=force_present[q]) and (force_present[q]>0){attacking=force_present[q];}
        }
    }
}
draw_set_alpha(1);




// draw_text(xx+14,yy+352,"Selection: "+string(smin)+"/"+string(smax));







// Back / Purge buttons
xx+=100;yy+=38;
draw_set_halign(fa_center);

draw_set_color(c_gray);draw_rectangle(xx+852,yy+556,xx+921,yy+579,0);
draw_set_color(0);draw_text_transformed(xx+887,yy+559,string_hash_to_newline("BACK"),1.25,1.25,0);
if (scr_hit(xx+852,yy+556,xx+921,yy+579)=true){
    draw_set_alpha(0.2);draw_rectangle(xx+852,yy+556,xx+921,yy+579,0);draw_set_alpha(1);
    if (scr_click_left()) {menu=0;purge=0;instance_destroy();}
}

draw_set_color(c_gray);draw_rectangle(xx+952,yy+556,xx+1043,yy+579,0);
draw_set_color(0);
if (attack=0) then draw_text_transformed(xx+999,yy+559,string_hash_to_newline("RAID!"),1.25,1.25,0);
if (attack=1) then draw_text_transformed(xx+999,yy+559,string_hash_to_newline("ATTACK!"),0.7,1.25,0);

if (scr_hit(xx+954,yy+556,xx+1043,yy+579)=true){
    draw_set_alpha(0.2);draw_rectangle(xx+954,yy+556,xx+1043,yy+579,0);draw_set_alpha(1);
    if (scr_click_left()) and (string_length(sel)>1){
        combating=1;// Start battle here
        
        if (attack=1) then obj_controller.last_attack_form=formation_possible[formation_current];
        if (attack=0) then obj_controller.last_raid_form=formation_possible[formation_current];
        
        instance_deactivate_all(true);
        instance_activate_object(obj_controller);
        instance_activate_object(obj_ini);
        instance_activate_object(obj_drop_select);
        
        // 135 ; temporary balancing
        if (sh_target!=-50){sh_target.acted+=1;}
        
        if (attacking==10) or (attacking==11){
            remove_planet_problem(planet_number, "meeting", p_target);
            remove_planet_problem(planet_number, "meeting_trap", p_target);
        }
            
        instance_create(0,0,obj_ncombat);
        obj_ncombat.battle_object=p_target;
        obj_ncombat.battle_loc=p_target.name;
        obj_ncombat.battle_id=planet_number;
        obj_ncombat.dropping=1-attack;
        obj_ncombat.attacking=attack;
        obj_ncombat.enemy=attacking;
        obj_ncombat.formation_set=formation_possible[formation_current];
        obj_ncombat.defending=false;
        if (ship_all[500]=1) then obj_ncombat.local_forces=1;
        var _planet = obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id]
        if (obj_ncombat.battle_object.space_hulk=1) then obj_ncombat.battle_special="space_hulk";
        if (planet_feature_bool(_planet,P_features.Warlord6) == 1) and (obj_ncombat.enemy=6) and (obj_controller.faction_defeated[6]=0) then obj_ncombat.leader=1;
        if (obj_ncombat.enemy=7) and (obj_controller.faction_defeated[7]<=0){

            if ( planet_feature_bool(_planet,P_features.OrkWarboss)==1){
				obj_ncombat.leader=1;
				obj_ncombat.Warlord = _planet[search_planet_features(_planet,P_features.OrkWarboss)[0]]
			}
		}

        
        if (obj_ncombat.enemy=9) and (obj_ncombat.battle_object.space_hulk=0){
            if (has_problem_planet(planet_number, "tyranid_org", p_target)) then obj_ncombat.battle_special="tyranid_org";
        }
        
        if (obj_ncombat.enemy=11){
            if ( planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id],P_features.World_Eaters)==1){
                obj_ncombat.battle_special="world_eaters";obj_ncombat.leader=1;
            }
        }
        
        if (obj_ncombat.enemy=5) then obj_ncombat.threat=sisters;
        if (obj_ncombat.enemy=6) then obj_ncombat.threat=eldar;
        if (obj_ncombat.enemy=7) then obj_ncombat.threat=ork;
        if (obj_ncombat.enemy=8) then obj_ncombat.threat=tau;
        if (obj_ncombat.enemy=9) then obj_ncombat.threat=tyranids;
        if (obj_ncombat.enemy=10) then obj_ncombat.threat=traitors;
        if (obj_ncombat.enemy=11) then obj_ncombat.threat=csm;
        if (obj_ncombat.enemy=12) then obj_ncombat.threat=demons;
        if (obj_ncombat.enemy=13) then obj_ncombat.threat=necrons;
        
        if (obj_ncombat.enemy=8){
            var eth;eth=0;eth=scr_quest(4,"ethereal_capture",8,0);
            if (eth>0) and (obj_ncombat.battle_object.p_owner[obj_ncombat.battle_id]=8){
                var rolli;rolli=floor(random(100))+1;
                if (obj_ncombat.threat=6) and (rolli<=80) then obj_ncombat.ethereal=1;
                if (obj_ncombat.threat=5) and (rolli<=65) then obj_ncombat.ethereal=1;
                if (obj_ncombat.threat=4) and (rolli<=50) then obj_ncombat.ethereal=1;
                if (obj_ncombat.threat=3) and (rolli<=35) then obj_ncombat.ethereal=1;
            }
            // show_message("Ethereal Quest?: "+string(eth)+"#Ethereal?: "+string(obj_ncombat.ethereal));
        }
        
        // if (obj_ncombat.threat>1) and (obj_ncombat.enemy!=13) then obj_ncombat.threat-=1;
        if (obj_ncombat.threat>1) and (obj_ncombat.battle_special!="world_eaters") and (attack=0) then obj_ncombat.threat-=1;
        if (obj_ncombat.threat<1) then obj_ncombat.threat=1;
        if (obj_ncombat.enemy=10) and (obj_ncombat.battle_object.p_type[obj_ncombat.battle_id]="Daemon") then obj_ncombat.threat=7;
        
        
        if ((attacking=0) or (attacking=10) or (attacking=11)) and (obj_ncombat.battle_object.p_traitors[obj_ncombat.battle_id]=0) and (obj_ncombat.battle_object.p_chaos[obj_ncombat.battle_id]=0){
            if ( planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id],P_features.Warlord10)==1) and (obj_controller.known[eFACTION.Chaos]=0) and (obj_controller.faction_gender[10]=1) and (obj_controller.turn>=obj_controller.chaos_turn){
                var pop;pop=instance_create(0,0,obj_popup);
                pop.image="chaos_symbol";
                pop.title="Concealed Heresy";
                pop.text="Your astartes set out and begin to cleanse "+string(obj_ncombat.battle_object.name)+" "+scr_roman(obj_ncombat.battle_id)+" of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";        
                with(obj_pnunit){instance_destroy();}
                with(obj_enunit){instance_destroy();}
                with(obj_nfort){instance_destroy();}
                with(obj_ncombat){instance_destroy();}
                obj_controller.cooldown=8;combating=0;
                instance_activate_all();exit;exit;
            }
            if ( planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id],P_features.Warlord10)==1) and (obj_controller.known[eFACTION.Chaos]>=2) and (obj_controller.faction_gender[10]=1) and (obj_controller.turn>=obj_controller.chaos_turn) then with(obj_drop_select){
                obj_ncombat.enemy=11;obj_ncombat.threat=0;alarm[6]=1;
                with(obj_pnunit){instance_destroy();}
                with(obj_enunit){instance_destroy();}
                with(obj_nfort){instance_destroy();}
                with(obj_ncombat){instance_destroy();}
                obj_controller.cooldown=8;combating=0;
                instance_activate_all();exit;exit;
            }
        }
        
        
        
        
        scr_battle_allies();
        
        var co, v, stop;
        co=0;v=0;stop=0;  
        repeat(3600){
            if (co<11){v+=1;
                if (v>300){co+=1;v=1;}
                if (co>10) then stop=1;
                if (stop=0){
                    if (fighting[co][v]!=0){obj_ncombat.fighting[co][v]=1;}// show_message(string(co)+":"+string(v)+" is fighting");
                    if (attack=1) and (v<=100){
                        if (veh_fighting[co][v]!=0) then obj_ncombat.veh_fighting[co][v]=1;
                    }
                    if (attack=1) and (ship_all[500]=1){
                        if (obj_ini.loc[co][v]=p_target.name) and (obj_ini.TTRPG[co][v].planet_location=planet_number) and (fighting[co][v]=1) then obj_ncombat.fighting[co][v]=1;
                        if (v<=100){if (obj_ini.veh_loc[co][v]=p_target.name) and (obj_ini.veh_wid[co][v]=planet_number) then obj_ncombat.veh_fighting[co][v]=1;}
                    }
                }
            }
        }
        
        // Iterates through all selected "ships" (max 30), including the planet (Local on the drop menu), 
        // and fills the battle roster with any marines found.
        ships_selected=0;
        var ships_len = array_length(ship_all);
        for (var i = 0; i < ships_len; i++) {
            if (ship_all[i]!=0) then scr_battle_roster(ship[i],ship_ide[i],false);
        }
		//ship_all[500] equals "Local" status on the drop menu
		if (ship_all[500]=1) and (attack=1) then scr_battle_roster(p_target.name,planet_number,true);
    }
}



/* */
}
}
}
__b__ = action_if_number(obj_popup, 0, 0);
if __b__
{
__b__ = action_if_number(obj_ncombat, 0, 0);
if __b__
{

var xx, yy;
xx=__view_get( e__VW.XView, 0 );
yy=__view_get( e__VW.YView, 0 );


if (menu=0) and (purge=1){
    draw_sprite(spr_purge_panel,0,xx+535,yy+200);
    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);
    
    draw_set_color(c_gray);
    draw_rectangle(xx + 740, yy + 558, xx + 860, yy + 585, 0);
    draw_set_color(0);
    draw_text_transformed(xx + 800, yy + 559, string_hash_to_newline("Cancel"), 0.75, 0.75, 0);
    if (scr_hit(xx + 740, yy + 558, xx + 860, yy + 585)) {
        draw_set_alpha(0.2);
        draw_set_color(0);
        draw_rectangle(xx + 740, yy + 558, xx + 860, yy + 585, 0);
        draw_set_alpha(1);
        if (scr_click_left()) {
            instance_destroy();
        }
    }
    
    var hih,x5,y5,iy,r,nup;
    hih=0;r=0;iy=0;nup=false;
    
    x5=xx+535;y5=yy+200;
    x5+=89;y5+=31;
    
    if (instance_exists(p_target)){
        if (p_target.p_type[planet_number]="Shrine") then nup=true;
    }
    
    // 89,31
    
    repeat(4){iy+=1;r=0;
        draw_set_alpha(1);
        if (iy=1) and (purge_a<=0) then draw_set_alpha(0.35);
        if (iy=2) and (purge_b<=0) and (purge_d=0) then draw_set_alpha(0.35);
        if (iy=3) and (purge_c<=0) and (purge_d=0) then draw_set_alpha(0.35);
        if (iy=4) and ((purge_d+purge_b=0) or (p_target.dispo[planet_number]<0)) then draw_set_alpha(0.35);
        if (iy=4) and (nup=true) then draw_set_alpha(0.35);
        
        if (scr_hit(x5,y5+((iy-1)*73),x5+351,y5+((iy-1)*73)+63)=true){
            r=4;
            if (scr_click_left()) {
                if (iy=1) and (purge_a>0){
                    purge=2;obj_controller.cooldown=8;alarm[4]=1;
                    purge_score=0;
                    ships_selected=0;
                    all_sel=0;
                }
                if (iy=2) and ((purge_b>0) or (purge_d!=0)){
                    purge=3;obj_controller.cooldown=8;alarm[2]=1;
                    purge_score=0;
                    ships_selected=0;
                    all_sel=0;
                }
                if (iy=3) and ((purge_c>0) or (purge_d!=0)){
                    purge=4;obj_controller.cooldown=8;alarm[2]=1;
                    purge_score=0;
                    ships_selected=0;
                    all_sel=0;
                }
                if (iy=4) and (purge_d+purge_b!=0) and (p_target.dispo[planet_number]>=0) and (nup=false){
                    purge=5;obj_controller.cooldown=8;alarm[2]=1;
                    purge_score=0;
                    ships_selected=0;
                    all_sel=0;
                }
                
            }
        }
        
        // draw_sprite(spr_purge_buttons,(iy-1)+r,x5,y5+((iy-1)*73));
        scr_image("purge",(iy-1)+r,x5,y5+((iy-1)*73),351,63);
    }
}








if (menu=0) and (purge>=2){
    draw_sprite(spr_purge_panel,0,xx+535,yy+200);
    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);
    
    
    // 2 is bombardment
    
    
    
    
    
    var x2,y2;
    x2=__view_get( e__VW.XView, 0 )+535;y2=__view_get( e__VW.YView, 0 )+200;
    draw_set_halign(fa_left);draw_set_color(c_gray);
    if (purge=2) then draw_text_transformed(x2+14,y2+12,string_hash_to_newline("Bombard Purging "+string(p_target.name)+" "+scr_roman(planet_number)),0.6,0.6,0);
    if (purge=3) then draw_text_transformed(x2+14,y2+12,string_hash_to_newline("Fire Cleansing "+string(p_target.name)+" "+scr_roman(planet_number)),0.6,0.6,0);
    if (purge=4) then draw_text_transformed(x2+14,y2+12,string_hash_to_newline("Selective Purging "+string(p_target.name)+" "+scr_roman(planet_number)),0.6,0.6,0);
    if (purge=5) then draw_text_transformed(x2+14,y2+12,string_hash_to_newline("Assassinate Governor ("+string(p_target.name)+" "+scr_roman(planet_number)+")"),0.6,0.6,0);
    
    
    
    // Disposition here
    var succession=0,pp=planet_number

    var succession = has_problem_planet(pp,"succession",p_target);
    
    if ((p_target.dispo[pp]>=0) and (p_target.p_owner[pp]<=5) and (p_target.p_population[pp]>0)) and (succession=0){
        var wack;wack=0;
        draw_set_color(c_blue);
        draw_rectangle(x2+12,y2+53,x2+12+max(0,(min(100,p_target.dispo[pp])*4.37)),y2+71,0);
    }
    draw_set_color(c_gray);
    draw_rectangle(x2+12,y2+53,x2+449,y2+71,1);
    draw_set_color(c_white);
    
    draw_set_font(fnt_40k_14b);draw_set_halign(fa_center);
    if (succession=0){
        if (p_target.dispo[pp]>=0) and (p_target.p_first[pp]<=5) and (p_target.p_owner[pp]<=5) and (p_target.p_population[pp]>0) then draw_text(x2+231,y2+54,string_hash_to_newline("Disposition: "+string(min(100,p_target.dispo[pp]))+"/100"));
        if (p_target.dispo[pp]>-30) and (p_target.dispo[pp]<0) and (p_target.p_owner[pp]<=5) and (p_target.p_population[pp]>0) then draw_text(x2+231,y2+54,string_hash_to_newline("Disposition: ???/100"));
        if ((p_target.dispo[pp]>=0) and (p_target.p_first[pp]<=5) and (p_target.p_owner[pp]>5)) or (p_target.p_population[pp]<=0) then draw_text(x2+231,y2+54,string_hash_to_newline("-------------"));
        if (p_target.dispo[pp]<=-3000) then draw_text(x2+231,y2+54,"Chapter Rule");
    }
    if (succession=1) then draw_text(x2+231,y2+54,string_hash_to_newline("War of Succession"));
    
    draw_set_color(c_gray);
    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);
    
    
    // Planet icon here
    draw_rectangle(x2+459,y2+14,x2+516,y2+71,0);
    
    // Ships Are Up, Fuck Me
    draw_text(x2+13,y2+80,string_hash_to_newline("Available Forces:"));
    
    var column,row,e,x8,y8,sigh,sip;e=0;sigh=0;sip=1;
    column=1;row=1;x8=x2+17;y8=y2+105;e=500;
    
    
    var add_ground;add_ground=0;
    
    if (purge_d>0) and (purge!=2){
        if (ship_all[e]=0) then draw_set_alpha(0.35);
        draw_set_color(c_gray);draw_rectangle(x8,y8,x8+160,y8+16,0);
        draw_set_color(c_black);draw_text(x8+2,y8,string_hash_to_newline("Local ("+string(ship_use[e])+"/"+string(ship_max[e])+")"))
        if (point_and_click([x8, y8, x8+160, y8+16])) {
            var onceh;onceh=0;
            if (ship_all[e]=0) then add_ground=1;
            if (ship_all[e]=1) then add_ground=-1;
        }
        y8+=16;sip+=1;
    }
    e=1;
    
    
    
    if (purge=2){               // Bombard
        repeat(50){
            if (ship[e]!="") and (ship_size[e]>1){
                draw_set_alpha(1);if (ship_all[e]=0) then draw_set_alpha(0.35);
                draw_set_color(c_gray);draw_rectangle(x8,y8,x8+160,y8+16,0);// 160
                draw_set_color(c_black);draw_text_transformed(x8+2,y8,string_hash_to_newline(string(ship[e])+" ("+string(ship_size[e])+")"),0.8,0.8,0);
                if (point_and_click([x8, y8, x8+160, y8+16])) {
                    var onceh;onceh=0;
                    if (onceh=0) and (ship_all[e]=0){onceh=1;ship_all[e]=1;ships_selected+=1;}
                    if (onceh=0) and (ship_all[e]=1){onceh=1;ship_all[e]=0;ships_selected-=1;}
                }
                y8+=18;sip+=1;
                
                if (y8>=y2+105+180){y8=y2+105;x8+=168;}
            }
            e+=1;
        }
    }
    
    
    if (purge>=3){              // Anything not bombardment
        repeat(50){
            if (ship[e]!="") and (ship_max[e]>0){
                draw_set_alpha(1);if (ship_all[e]=0) then draw_set_alpha(0.35);
                draw_set_color(c_gray);draw_rectangle(x8,y8,x8+160,y8+16,0);// 160
                draw_set_color(c_black);draw_text_transformed(x8+2,y8,string_hash_to_newline(string(ship[e])+" ("+string(ship_use[e])+"/"+string(ship_max[e])+")"),0.8,0.8,0);
                if (point_and_click([x8, y8, x8+160, y8+16])) {
                    var onceh;onceh=0;
                    if (onceh=0) and (ship_all[e]=0){onceh=1;scr_drop_fiddle(ship_ide[e],true,e,attack);}
                    if (onceh=0) and (ship_all[e]=1){onceh=1;scr_drop_fiddle(ship_ide[e],false,e,attack);}
                }
                y8+=18;sip+=1;
                
                if (y8>=y2+105+180){y8=y2+105;x8+=168;}
            }
            e+=1;
        }
    }
    
    
    
    
    
    
    draw_set_font(fnt_40k_14);draw_set_color(c_gray);draw_set_alpha(1);
    
    var hers,influ,poppy;
    hers=p_target.p_heresy[planet_number]+p_target.p_heresy_secret[planet_number];
    influ=p_target.p_influence[planet_number];
    if (p_target.p_large[planet_number]=1) then poppy=string(p_target.p_population[planet_number])+"B";
    if (p_target.p_large[planet_number]=0) then poppy=string(scr_display_number(p_target.p_population[planet_number]));
    draw_text(x2+14,y2+312,"Heresy: "+string(max(hers,influ[eFACTION.Tau]))+"%");
    draw_text(x2+14,y2+332,"Population: "+string(poppy));
    
    
    
    
    
    
    if (purge=2){// Bombardment select all
        draw_set_alpha(1);
        yar=2;if (all_sel=1) then yar=3;draw_sprite(spr_creation_check,yar,x2+233,y2+75);yar=0;
        if (point_and_click([x2+233, y2+75, x2+233+32, y2+75+32])) {
            var onceh;onceh=0;
            var onceh;once=0;i=0;
            if (all_sel=0) and (onceh=0){
                repeat(60){i+=1;if (ship[i]!="") and (ship_all[i]=0){ship_all[i]=1;ships_selected+=1;}}
                onceh=1;all_sel=1;
            }
            if (all_sel=1) and (onceh=0){
                repeat(60){i+=1;if (ship[i]!="") and (ship_all[i]=1){ship_all[i]=0;ships_selected-=1;}}
                onceh=1;all_sel=0;
            }
        }
        draw_text_transformed(x2+233+30,y2+75+4,string_hash_to_newline("Select All"),1,1,0);
    }
    
    
    if (purge>=3){// Anything not bombardment, select all
        draw_set_alpha(1);
        yar=2;if (all_sel=1) then yar=3;draw_sprite(spr_creation_check,yar,x2+233,y2+75);yar=0;
        if (point_and_click([x2+233, y2+75, x2+233+32, y2+75+32])) {
            var onceh;onceh=0;
            var onceh;once=0;i=0;
            if (all_sel=0) and (onceh=0){
                repeat(60){i+=1;
                    if (ship[i]!="") and (ship_all[i]=0){ship_all[i]=1;scr_drop_fiddle(ship_ide[i],true,i,attack);}
                    if (ship_all[500]=0) then add_ground=1;
                    if (ship_all[500]=1) then add_ground=-1;
                }
                onceh=1;all_sel=1;
            }
            if (all_sel=1) and (onceh=0){
                repeat(60){i+=1;
                    if (ship[i]!="") and (ship_all[i]=1){ship_all[i]=0;scr_drop_fiddle(ship_ide[i],false,i,attack);}
                    if (ship_all[500]=0) then add_ground=1;
                    if (ship_all[500]=1) then add_ground=-1;
                }
                onceh=1;all_sel=0;
            }
        }
        draw_text_transformed(x2+233+30,y2+75+4,string_hash_to_newline("Select All"),1,1,0);
    }
    
    var smin,smax;
    var w;w=-1;smin=0;smax=0;
    
    if (purge=2){repeat(61){w+=1;if (ship[w]!="") and (ship_size[w]>1){smax+=1;if (ship_all[w]>0) then smin+=1;}}}
    
    if (purge>=3){
        repeat(61){w+=1;if (ship[w]!=""){smax+=ship_max[w];if (ship_all[w]>0) then smin+=ship_use[w];}}
        if (ship_max[500]>0) and (ship_all[500]>0){smax+=ship_max[500];smin+=ship_max[500];}
        
        if (add_ground=1){
            master+=l_master;honor+=l_honor;
            capts+=l_capts;mahreens+=l_mahreens;
            veterans+=l_veterans;terminators+=l_terminators;
            dreads+=l_dreads;chaplains+=l_chaplains;
            psykers+=l_psykers;apothecaries+=l_apothecaries;
            techmarines+=l_techmarines;champions+=l_champions;
        }
        if (add_ground=-1){
            master-=l_master;honor-=l_honor;
            capts-=l_capts;mahreens-=l_mahreens;
            veterans-=l_veterans;terminators-=l_terminators;
            dreads-=l_dreads;chaplains-=l_chaplains;
            psykers-=l_psykers;apothecaries-=l_apothecaries;
            techmarines-=l_techmarines;champions-=l_champions;
        }
    }
    
    
    
    
    
    draw_text(x2+14,y2+352,string_hash_to_newline("Selection: "+string(smin)+"/"+string(smax)));
    
    
    
    
    
    
    var sel;sel="";
    if (purge>2){
        if (master=1) then sel+="Chapter Master "+string(obj_ini.master_name)+", ";
        if (honor>1) then sel+=string(honor)+" "+string(obj_ini.role[100][2])+"s, ";
        if (honor=1) then sel+="1 "+string(obj_ini.role[100][2])+", ";
        if (capts>1) then sel+=string(capts)+" "+string(obj_ini.role[100][5])+"s, ";
        if (champions>1) then sel+=string(capts)+" Champions, ";
        if (champions=1) then sel+="1 Champion, ";
        if (capts=1) then sel+="1 "+string(obj_ini.role[100][5])+", ";
        if (chaplains>1) then sel+=string(chaplains)+" "+string(obj_ini.role[100][14])+"s, ";
        if (chaplains=1) then sel+="1 "+string(obj_ini.role[100][14])+", ";
        if (apothecaries>1) then sel+=string(apothecaries)+" "+string(obj_ini.role[100][15])+"s, ";
        if (apothecaries=1) then sel+="1 "+string(obj_ini.role[100][15])+", ";
        if (psykers>1) then sel+=string(psykers)+" Psykers, ";
        if (psykers=1) then sel+="1 Psyker, ";
        if (techmarines>1) then sel+=string(techmarines)+" "+string(obj_ini.role[100][16])+"s, ";
        if (techmarines=1) then sel+="1 "+string(obj_ini.role[100][16])+", ";
        if (terminators>1) then sel+=string(terminators)+" "+string(obj_ini.role[100][4])+"s, ";
        if (terminators=1) then sel+="1 "+string(obj_ini.role[100][4])+", ";
        if (veterans>1) then sel+=string(veterans)+" "+string(obj_ini.role[100][3])+"s, ";
        if (veterans=1) then sel+="1 "+string(obj_ini.role[100][3])+", ";
        if (mahreens>1) then sel+=string(mahreens)+" Marines, ";
        if (mahreens=1) then sel+="1 Marine, ";
        if (dreads>1) then sel+=string(dreads)+" "+string(obj_ini.role[100][6])+", ";
        if (dreads=1) then sel+="1 "+string(obj_ini.role[100][6])+", ";
        sel=string_delete(sel,string_length(sel)-1,2);
    }
    // draw_text_ext(xx+310,yy+234,string(sel),-1,206);
    
    
    
    
    // Back / Purge buttons
    
    
    draw_set_color(c_gray);draw_rectangle(xx+852,yy+556,xx+921,yy+579,0);
    draw_set_color(0);draw_text_transformed(x2+320,y2+358,string_hash_to_newline("BACK"),1.25,1.25,0);
    if (scr_hit(xx+852,yy+556,xx+921,yy+579)=true){
        draw_set_alpha(0.2);draw_rectangle(xx+852,yy+556,xx+921,yy+579,0);draw_set_alpha(1);
        if (scr_click_left()) {
            purge=1;
        }
    }
    
    draw_set_color(c_gray);
    draw_rectangle(xx+954,yy+556,xx+1043,yy+579,0);
    draw_set_color(0);
    draw_text_transformed(x2+423,y2+358,"PURGE!",1.25,1.25,0);
    if (scr_hit(xx+954,yy+556,xx+1043,yy+579)=true){
        draw_set_alpha(0.2);
        draw_rectangle(xx+954,yy+556,xx+1043,yy+579,0);draw_set_alpha(1);
        if (scr_click_left()) {
            // Start purge here
            if (purge=2){var i;i=0;
                repeat(50){i+=1;
                    if (ship[i]!="") and (ship_all[i]>0){
                        if (obj_ini.ship_class[ship_ide[i]]="Slaughtersong") then purge_score+=3;
                        if (obj_ini.ship_class[ship_ide[i]]="Battle Barge") then purge_score+=3;
                        if (obj_ini.ship_class[ship_ide[i]]="Strike Cruiser") then purge_score+=1;
                    }
                }
            }
            if (purge>=3){
                var i;i=-1;purge_score=0;
                repeat(51){i+=1;
                    if (ship_all[i]!=0) then purge_score+=ship_use[i];
                }
            }
            
            scr_purge_world(p_target,planet_number,purge-1,purge_score);
        }
    }
    
    
    if (scr_hit(x2+14,y2+351,x2+300,y2+373)=true) and (string_length(sel)>0) and (purge>2){
    // if (scr_hit(xx+546,yy+551,xx+680,yy+570)=true){
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);draw_set_halign(fa_left);draw_set_color(0);
        draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(sel),-1,500)+24,mouse_y+24+string_height_ext(string_hash_to_newline(sel),-1,500),0);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_14);draw_text_ext(mouse_x+22,mouse_y+22,string_hash_to_newline(string(sel)),-1,500);
        draw_rectangle(mouse_x+18,mouse_y+20,mouse_x+string_width_ext(string_hash_to_newline(sel),-1,500)+24,mouse_y+24+string_height_ext(string_hash_to_newline(sel),-1,500),1);
    }
    
}



/* */
}
}
/*  */
