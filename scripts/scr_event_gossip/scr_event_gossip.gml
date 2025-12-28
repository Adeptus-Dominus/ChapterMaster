function scr_event_gossip(argument0) {

	// argument0: attendant 'ide'

	var possible_gossips,gossip,that,that_type,p,words,him_chaos;
	possible_gossips=0;that=0;that_type="";words="";
	him_chaos=obj_ini.TTRPG[attend_co[argument0],attend_id[argument0]].corruption;

	p=-1;
	repeat(101){p+=1;
	    gossip[p]="";gossip_recent[p]=0;
	}
	p=0;


	if (obj_controller.turn<36){p+=1;gossip[p]="future_battles";}
	if (obj_controller.turn>=36){p+=1;gossip[p]="past_battles";}
	if (string_count("&",obj_ini.armour[attend_co[argument0],attend_id[argument0]])>0){p+=1;gossip[p]="artifact_armour";}
	if (string_count("&",obj_ini.wep1[attend_co[argument0],attend_id[argument0]])>0){p+=1;gossip[p]="artifact_wep";}
	if (string_count("&",obj_ini.wep2[attend_co[argument0],attend_id[argument0]])>0){p+=1;gossip[p]="artifact_wep";}
	// if (string_count("&",obj_ini.gear[attend_co[argument0],attend_id[argument0]])>0){p+=1;gossip[p]="artifact_gear";}
	if (obj_ini.mobi[attend_co[argument0],attend_id[argument0]]="Bike"){p+=1;gossip[p]="mah_bike";}
	if (obj_ini.mobi[attend_co[argument0],attend_id[argument0]]="Jump Pack"){p+=1;gossip[p]="mah_jump";}

	with(obj_ground_mission){instance_destroy();}
	with(obj_star){if (owner = eFACTION.Ork) then instance_create(x,y,obj_ground_mission);}
	if (instance_number(obj_ground_mission)>4) and (obj_controller.known[eFACTION.Ork]>0) and (obj_controller.faction_defeated[7]=0){
	    p+=1;
	    gossip[p]="ork_waaagh";
	}
	with(obj_ground_mission){instance_destroy();}

	if (obj_controller.marines<=400){p+=1;gossip[p]="small_chapter";}
	p+=1;gossip[p]="eager";


	with(obj_ground_mission){instance_destroy();}with(obj_star){if (owner = eFACTION.Ork) then instance_create(x,y,obj_ground_mission);}
	if (instance_number(obj_ground_mission)>=8){p+=1;gossip[p]="ork_numbers";}with(obj_ground_mission){instance_destroy();}

	with(obj_ground_mission){instance_destroy();}with(obj_star){if (owner = eFACTION.Tau) then instance_create(x,y,obj_ground_mission);}
	if (instance_number(obj_ground_mission)>=8){p+=1;gossip[p]="tau_numbers";}with(obj_ground_mission){instance_destroy();}

	with(obj_ground_mission){instance_destroy();}with(obj_star){if (owner = eFACTION.Chaos) then instance_create(x,y,obj_ground_mission);}
	if (instance_number(obj_ground_mission)>=8){p+=1;gossip[p]="chaos_numbers";}with(obj_ground_mission){instance_destroy();}

	if (obj_controller.faction_status[eFACTION.Inquisition]!="War") and (obj_controller.disposition[eFACTION.Inquisition]<=25){p+=1;gossip[p]="low_dispo_inqi";}
	if (obj_controller.faction_status[eFACTION.Imperium]!="War") and (obj_controller.disposition[eFACTION.Imperium]<=25){p+=1;gossip[p]="low_dispo_impe";}
	if (obj_controller.faction_status[eFACTION.Mechanicus]!="War") and (obj_controller.disposition[eFACTION.Mechanicus]<=25){p+=1;gossip[p]="low_dispo_mech";}

	if (obj_controller.known[eFACTION.Eldar]>0) and (obj_controller.faction_defeated[eFACTION.Eldar]=0) and (obj_controller.faction_status[eFACTION.Eldar]!="Allied"){p+=1;gossip[p]="smack_talk_eldar";}
	if (obj_controller.known[eFACTION.Ork]>0) and (obj_controller.faction_defeated[eFACTION.Ork]=0) and (obj_controller.faction_status[eFACTION.Ork]!="Allied"){p+=1;gossip[p]="smack_talk_orks";}
	if (obj_controller.known[eFACTION.Tau]>0) and (obj_controller.faction_defeated[eFACTION.Tau]=0) and (obj_controller.faction_status[eFACTION.Tau]!="Allied"){p+=1;gossip[p]="smack_talk_tau";}
	if (obj_controller.known[eFACTION.Tyranids]>0) and (obj_controller.faction_defeated[eFACTION.Tyranids]=0) and (obj_controller.faction_status[eFACTION.Tyranids]!="Allied"){p+=1;gossip[p]="smack_talk_tyranids";}
	if (obj_controller.known[eFACTION.Chaos]>0) and (obj_controller.faction_defeated[eFACTION.Chaos]=0) and (obj_controller.faction_status[eFACTION.Chaos]!="Allied"){p+=1;gossip[p]="smack_talk_chaos";}

	// All of the custom ones above
	// Recent events below

	var t;t=0;
	repeat(obj_controller.recent_happenings){t+=1;
	    if (obj_controller.recent_type[t]!="") and (obj_controller.recent_turn[t]+12>=obj_controller.turn){
	        p+=1;gossip[p]="recent";gossip_recent[p]=p;
	    }
	}

	possible_gossips=p;


	that=floor(random(possible_gossips))+1;
	that_type=string(gossip[that]);

	var na,ra;
	na=obj_ini.name[attend_co[argument0],attend_id[argument0]];
	ra=obj_ini.role[attend_co[argument0],attend_id[argument0]];


	// Getting there
	words=string(ra)+" "+string(na)+" ";

	if (that_type="future_battles"){
	    words+=choose("recounts","retells","tells","speaks of")+" future glorious battles that the Chapter will partake of, in glory of "+choose("our honor","The Emperor","The Imperium","Primarch")+".";
	}
	if (that_type="past_battles"){
	    words+=choose("recounts","retells","tells","speaks of")+" past glorious battles that the Chapter partook of, in glory of "+choose("our honor","The Emperor","The Imperium","Primarch")+".";
	}
	if (that_type="artifact_armour"){rando=choose(1,2);
	    if (rando=1) then words+="speaks fondly of his Artifact Armour.  Several adjacent Astartes recall the mighty item with envy.";
	    if (rando=2) then words+="speaks of his Artifact Armour in a reverent tone.  May it protect him in many more battles to come.";
	}
	if (that_type="artifact_wep"){rando=choose(1,2);
	    if (rando=1) then words+="speaks fondly of his Artifact weapon.  Several adjacent Astartes recall the mighty item with envy.";
	    if (rando=2) then words+="speaks of his Artifact weapon in a reverent tone.  May he kill hundreds more "+choose("xeno scum","heretics")+" with it.";
	}
	if (that_type="mah_bike"){rando=choose(1,2,3);
	    words+="speaks of his Bike with fondness.  How glorious it is to ";
	    if (rando=1) then words+="crush foes of the Imperium beneath its wheels.";
	    if (rando=2) then words+="rush across battlefields at frightening speeds.";
	    if (rando=3) then words+="unload the foreward-mounted dual bolters on foul heretics.";
	}
	if (that_type="mah_jump"){rando=choose(1,2);
	    words+="speaks of his Jump Pack fondly.  How glorious it is to ";
	    if (rando=1) then words+="crash upon foes from high above and rout them.";
	    if (rando=2) then words+="launch across the battlefield in mighty, burning leaps.";
	}
	if (that_type="ork_waaagh"){
	    words+="expresses concern about the current Ork WAAAGH!.  How many more systems will be overrun before the warboss is purged?";
	}
	if (that_type="small_chapter"){
	    words+="is concerned about the current size of the "+string(global.chapter_name)+".  Only "+string(obj_controller.marines)+" battle brothers remain.";
	}
	if (that_type="eager"){rando=choose(1,2,3);
	    if (rando=1) then words+="is eager to enter the field of battle once more.";
	    if (rando=2) then words+="is eager to purge more xenos scum.";
	    if (rando=3) then words+="is eager to kill more heretics, for Primarch and Emperor.";
	}
	if (that_type="ork_numbers"){
	    words+="curses the Ork menace and their numbers- the greenskins must be met with Bolter and Flamer, sooner than later.";
	}
	if (that_type="tau_numbers"){
	    words+="curses the Tau for their unwant corruption of the Imperium's citizens.  The xenos must be purged, down to the last one.";
	}
	if (that_type="chaos_numbers"){
	    words+="curses the foul traitors for their heresy and corruption of the sector.  Something must be done to end them for good.";
	}
	if (that_type="low_dispo_inqi"){
	    if (him_chaos<50) then words+="is concerned about the Inquisition's view of the "+string(global.chapter_name)+", and the trouble that may entail.";
	    if (him_chaos>=50) then words+="curses the Inquisition for their meddling with the "+string(global.chapter_name)+".  Something has to change.";
	}
	if (that_type="low_disp_impe"){
	    // Couple variants for amount of chaos?
	    if (him_chaos<=30) then words+="is concerned about the Imperium's view of the "+string(global.chapter_name)+".  They should view the chapter with respect and fear, not scorn.";
	    if (him_chaos<=66) and (him_chaos>30) then words+="is displeased with the Imperium's view of the "+string(global.chapter_name)+".  After all the chapter has done for them they are ungrateful.";
	    if (him_chaos<=200) and (him_chaos>66) then words+="curses the Imperium for their view of the "+string(global.chapter_name)+".  The weak, and petty must be corrected by force if needed, before they forget their place in the universe.";
	}
	if (that_type="low_disp_mech"){
	    words+="is concerned with the Mechanicus' low opinion of the "+string(global.chapter_name)+" and the trouble that may entail.";
	}
	if (that_type="smack_talk_eldar"){rando=choose(1,2,3);
	    if (rando=1) then words+="curses the arrogant Eldar and their meddling.  They will be a lot less haughty with a chainsword through the gut.";
	    if (rando=2) then words+="looks forward to when he may purge more Eldar scum.";
	    if (rando=3) then words+="wishes to purge some Eldar.  The arrogant xenos scum must learn their place.";
	}
	if (that_type="smack_talk_orks"){rando=choose(1,2);
	    if (rando=1) then words+="curses the damned greenskins for their wanton destruction of Imperial worlds.";
	    if (rando=2) then words+="wishes to purge some Orks, sooner than later.  Much like weeds, their numbers must be cut down.";
	}
	if (that_type="smack_talk_tau"){rando=choose(1,2,3);
	    if (rando=1) then words+="curses the Tau for their subversive methods and mockery of technology.  Purging some Tau would be cathartic.";
	    if (rando=2) then words+="wishes to purge some Tau, sooner than later.  Watching their armour and vehicles explode in blue flames is enjoyable.";
	    if (rando=3) then words+="boasts he will kill a Tau Ethereal one day.";
	}
	if (that_type="smack_talk_tyranids"){rando=choose(1,2,3);
	    if (rando=1) then words+="curses the Tyranids for the threat they pose to the sector.  They will be defeated, each time, but at what cost?";
	    if (rando=2) then words+="ponders how a Tyranid head would look on one of his pauldrons.  He asks some adjacent battle brothers for their input on the matter.";
	}
	if (that_type="smack_talk_chaos"){rando=choose(1,2);
	    if (rando=1) then words+="seethes and curses the damned traitors for their ongoing heresy.  Their current leader must be purged, with extreme prejudice.";
	    if (rando=2) then words+="wishes to purge more heretics.  Cleaning the homes of the damned with flamer is cathartic for him.";
	}








	if (that_type="recent"){
	    var r_num,cn,blah;
	    r_num=gossip_recent[that];
	    cn=obj_controller;
	    blah=string(cn.recent_type[gossip_recent[that]]);
    
	    if (blah="eldar_mission") and (cn.recent_keyword[gossip_recent[that]]="completed") and (cn.recent_number[gossip_recent[that]]=1){
	        words+="is concerned about the Chapter Master's decision to help the Eldar.  Is it not a Space Marine's duty to cleanse and purge xenos, rather than collaborate with them?"
	    }
	    if (blah="artifact_recovered"){
	        words+="wonders what secrets the newly discovered Artifact may hold.";
	    }
	    if (blah="stc_recovered"){
	        words+="wonders what secrets the newly discovered STC Fragment may hold.";
	    }
	    if (blah="fleet_defeat"){
	        var nba;nba=cn.recent_number[gossip_recent[that]];
	        if (nba<=3) then words+="deplores the loss of the scouting fleet at "+string(cn.recent_keyword[gossip_recent[that]])+".";
	        if (nba>3) and (nba<=7) then words+="laments the loss of the fleet at "+string(cn.recent_keyword[gossip_recent[that]])+".";
	        if (nba>7) and (nba<=11) then words+="laments the destruction of the fleet at "+string(cn.recent_keyword[gossip_recent[that]])+".";
	        if (nba>12) then words+="laments the destruction of the Chapter fleet at "+string(cn.recent_keyword[gossip_recent[that]])+".  Such a massive loss of ships will be felt for decades to come, if the chapter ever recovers.";
	    }
	    if (blah="ship_destroyed"){rando=choose(1,2);
	        words+="laments the destruction of '"+string(cn.recent_keyword[gossip_recent[that]])+"'.  ";
	        if (rando=1) then words+="It was a fine vessel, worthy of any chapter.";
	        if (rando=2) then words+="Many xenos and heretics did it obliterate.";
	    }
	    if (blah="battle_victory"){rando=choose(1,2,3);
	        words+="boasts of the victory at "+string(cn.recent_keyword[gossip_recent[that]])+", where the ";
	        if (cn.recent_number[gossip_recent[that]]=2) then words+="Imperium";
	        if (cn.recent_number[gossip_recent[that]]=3) then words+="Mechancius";
	        if (cn.recent_number[gossip_recent[that]]=5) then words+="Sisters of Battle";
	        if (cn.recent_number[gossip_recent[that]]=6) then words+="Eldar";
	        if (cn.recent_number[gossip_recent[that]]=7) then words+="Orks";
	        if (cn.recent_number[gossip_recent[that]]=8) then words+="Tau";
	        if (cn.recent_number[gossip_recent[that]]=9) then words+="Tyranids";
	        if (cn.recent_number[gossip_recent[that]]=10) then words+="Heretics";
	        if (cn.recent_number[gossip_recent[that]]=11) then words+="Traitor Legions";
	        if (cn.recent_number[gossip_recent[that]]=12) then words+="foul Daemons";
	        if (cn.recent_number[gossip_recent[that]]=13) then words+="Necrons";
        
	        if (rando=1) then words+=" were crushed by the might of the chapter.";
	        if (rando=2) then words+=" were obliterated and torn asunder.";
	        if (rando=3) then words+=" were purged, down to the last fighter.";
	    }
	    if (blah="battle_defeat"){
	        var nba,enemu;
	        nba=cn.recent_number[gossip_recent[that]];
	        if (cn.recent_keyword[gossip_recent[that]]="2") then enemu="Imperium";
	        if (cn.recent_keyword[gossip_recent[that]]="3") then enemu="Mechanicus";
	        if (cn.recent_keyword[gossip_recent[that]]="5") then enemu="Sisters of Battle";
	        if (cn.recent_keyword[gossip_recent[that]]="6") then enemu="Eldar";
	        if (cn.recent_keyword[gossip_recent[that]]="7") then enemu="Orks";
	        if (cn.recent_keyword[gossip_recent[that]]="8") then enemu="Tau";
	        if (cn.recent_keyword[gossip_recent[that]]="9") then enemu="Tyranids";
	        if (cn.recent_keyword[gossip_recent[that]]="10") then enemu="Heretics";
	        if (cn.recent_keyword[gossip_recent[that]]="11") then enemu="Traitor Legions";
	        if (cn.recent_keyword[gossip_recent[that]]="12") then enemu="foul Daemons";
	        if (cn.recent_keyword[gossip_recent[that]]="13") then enemu="Necrons";
        
	        if (nba<=20) then words+="deplores the two squads, and lives lost recently, against the "+string(enemu)+".";
	        if (nba>20) and (nba<=70) then words+="deplores the lives lost recently fighting the "+string(enemu)+".";
	        if (nba>70) and (nba<=150) then words+="mourns the loss of a company against the "+string(enemu)+".  Such a loss is impossible to ignore.";
	        if (nba>150) and (nba<300) then words+="mourns the loss of chapter companies fighting the "+string(enemu)+".  Such a massive loss of battle brothers will be felt for decades to come, if the chapter ever recovers.";
	        if (nba>=300) then words+="laments the huge amount of casualties fighting the "+string(enemu)+".  There are no words to describe such loss.";
	    }
	    if (string_count("death_",blah)>0){rando=choose(1,2,3);
	        if (cn.recent_number[gossip_recent[that]]=attend_co[argument0]){
	            words+="mourns the loss of ";
	            words+=string_replace(blah,"death_","");
	            words+=" "+string(cn.recent_keyword[gossip_recent[that]])+".";
            
	            if (rando=1) then words+="  His contributions to the chapter will never be forgotten.";
	            if (rando=2) then words+="  He fought well for the Emperor, and deserve His peace.";
	            if (rando=3) then words+="  He fought valiantly in life- his soul will find its way to The Emperor.";
	        }
	    }
	    if (blah="artifact_destroyed"){// Need a special chaos if the weapon was chaos or daemonic
	        words+="wonders if destroying that Artifact, recently, was worth it.";
	    }
	    if (blah="artifact_gifted"){// Need a special chaos if the weapon was chaos or daemonic
	        if (cn.recent_number[gossip_recent[that]]<=5) then words+="wonders if giving away an Artifact was worth it.";
	        if (cn.recent_number[gossip_recent[that]]>5) then words+="has concerns about gibing that Artifact away to the enemies of man.  Would it not be better to have given it to the Inquisition?";
	    }
    
	    if (blah="captain_promote") and (cn.recent_number[gossip_recent[that]]=attend_co[argument0]){rando=choose(1,2);
	        words+="gives a cheer to "+string(cn.recent_keyword[gossip_recent[that]])+", for his promotion to "+string(obj_ini.role[100][5])+".";
	        if (rando=1) then words+="  May he lead the company to glory!";
	        if (rando=2) then words+="  May the company benefit from his wisdom!";
	    }
	    if (blah="terminator_promote") and (cn.recent_number[gossip_recent[that]]=attend_co[argument0]){rando=choose(1,2);
	        words+="gives a cheer to "+string(cn.recent_keyword[gossip_recent[that]])+", for his promotion to "+string(obj_ini.role[100][4])+".";
	        if (rando=1) then words+="  Let the enemies of man die at his feet!";
	        if (rando=2) then words+="  He will be a bulwark against the foes of man!";
	    }
	    if (blah="honor_promote") and (cn.recent_number[gossip_recent[that]]=attend_co[argument0]){rando=choose(1,2);
	        words+="gives a cheer to "+string(cn.recent_keyword[gossip_recent[that]])+", for his promotion to "+string(obj_ini.role[100][2])+".";
	        if (rando>=1) then words+="  Let the enemies of man die at his feet!";
	    }
	}



	if (words=string(ra)+" "+string(na)+" "){
	    // show_message("type:"+string(that_type)+" is blank");
	    // if (that_type="recent"){show_message("type:recent, event:"+string(blah));}
	}



	// Fin

	return(string(words));


}
