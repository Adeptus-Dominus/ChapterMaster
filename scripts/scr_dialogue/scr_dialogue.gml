// Handles all dialog for all factions and special events. Handles diplomatic changes and diplomacy as well
function scr_dialogue(diplo_keyphrase) {
	// diplo_last="";

	// diplo_keyphrase = keyphrase

	for(var h=1; h<=4; h++){
		obj_controller.diplo_option[h]="";
		obj_controller.diplo_goto[h]="";
	}
	var event_log="";
	var rando=0,tempd="",sorc=false;
	var rela,trade_msg;
	
	rela="neutral";
	trade_msg="[[Trade Accepted.  Shipment initialized.]]";

	diplo_txt="";
	diplo_text="";
	
	// show_message(string(diplo_keyphrase));

	if (diplo_keyphrase=="declare_war") and (faction_status[diplomacy]!="War"){
	    faction_status[diplomacy]="War";
	    event_log=string(obj_controller.faction_title[diplomacy])+" "+string(obj_controller.faction_leader[diplomacy])+" declares war on the "+string(global.chapter_name)+".";
	    scr_event_log("red",event_log);
    
	    if (string_count("|SC|",obj_controller.useful_info)>1) and (diplomacy==4) then sorc=true;
	}
	if (diplo_keyphrase=="declare_war") and (string_count("|SC|",obj_controller.useful_info)>1) and (diplomacy==4) then sorc=true;

	if (diplo_keyphrase=="intro") or (diplo_keyphrase=="intro1") or ((diplomacy==10) and (diplo_keyphrase=="intro2")){
	    event_log="Chapter Master "+string(obj_ini.master_name)+" meets the "+string(obj_controller.faction[diplomacy])+" "+string(obj_controller.faction_title[diplomacy])+", "+string(obj_controller.faction_leader[diplomacy])+".";
	    scr_event_log("",event_log);
	}

	var dip_score=diplomacy;
	// repeat(3){
	    // i+=1;
		rela="neutral";
    
	    if (diplomacy>0){
	        // if (diplomacy!=8){
	            if (disposition[dip_score]>=60) then rela="friendly";
	            if (disposition[dip_score]<60) and (disposition[dip_score]>=20) then rela="neutral";
	            if (disposition[dip_score]<20) then rela="hostile";
	        // }
	        if (diplomacy==6){
	            if (disposition[dip_score]>=60) then rela="friendly";
	            if (disposition[dip_score]<60) and (disposition[dip_score]>=0) then rela="neutral";
	            if (disposition[dip_score]<0) then rela="hostile";
	        }
        
	        if (diplomacy==8){
	            if (disposition[dip_score]>=40) then rela="friendly";
	            if (disposition[dip_score]<40) and (disposition[dip_score]>=-15) then rela="neutral";
	            if (disposition[dip_score]<-15) then rela="hostile";
	        }// */
	    }
	    // if (i<=5) and (fleet_type=3) and (rela="hostile") then rela="neutral";
	// }

	// ** Chaos Meetings ** 
	if (diplo_keyphrase=="cs_meeting1"){
		diplomacy=10;
	    diplo_text="So you have brought yourself before me "+string(obj_ini.master_name)+". This pleases me. You are not the first among the Astartes to come to me. Do not look so shocked. Many have gazed upon the decay and decrepitude of the Imperium with open eyes, and heard the empty slogans of the Corpse Emperor with fresh ears and come to the realization I had so many long millennia ago. There is only one truth in the universe, one path worthy of an Astartes to walk. The path of true power. The path of true insight into the nature of reality and what lies beyond. The path of Chaos. Only when free of the pointless bondage of the Imperium can we ascend to our rightful place in the universe.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting2";
	    disposition[10]+=10;
	}
	// First branch of choices
	if (diplo_keyphrase=="cs_meeting2") or (diplo_keyphrase=="cs_meeting20"){
		diplomacy=10;
	    // check for MoS here
	    var mos=false,ii=0;
	    repeat(obj_temp_meeting.dudes){
			ii+=1;
			if (mos=false){if (obj_ini.role[obj_temp_meeting.co[ii],obj_temp_meeting.ide[ii]]="Master of Sanctity") then mos=true;}
		}
	    
		if (diplo_keyphrase=="cs_meeting2") then disposition[10]+=10;
    
	    // Meeting2
	    diplo_text="But still I am puzzled by you /noble/ Astartes. You come before me and put yourself at my mercy. I could extinguish your life in an instant, crush you beneath my boot heel faster than the lowliest insect. These are not the actions of a Space Marine. Long have you fought for Him. So tell me then Astartes, why do you come to me now?";
    
	    // Meeting20
	    if (diplo_keyphrase=="cs_meeting20"){
	        diplo_text="[[A low rumbling growl issues from "+string(obj_controller.faction_leader[eFACTION.Chaos])+"’s power armour before he speaks.]]##I ask you for the last time Astartes. Why did you seek me out?";
	    }
    
	    if (mos==true) and (diplo_keyphrase!="cs_meeting20"){
	        diplo_option[1]="[Continue]";
			diplo_goto[1]="cs_meeting_m1";
	    }

	    if (mos==false) or (diplo_keyphrase=="cs_meeting20"){
	        diplo_option[1]="The Imperium has bound us and kept us from our true potential.  We seek strength.";
	        diplo_option[2]="The Imperium and Inquisition's ignorance and hypocrisy will be the death of my Chapter.";
	        diplo_option[3]="Our enemies are many and our strength is diminished. We need allies to join with us while we rebuild our forces.";
	        diplo_option[4]="I sought you out to slay you with my own hands.";
        
	        // Set targets for those options
	        diplo_goto[1]="cs_meeting30";
        
	        if (obj_controller.disposition[4]<=30) then diplo_goto[2]="cs_meeting40";// Convinced
	        if (obj_controller.disposition[4]>30) then diplo_goto[2]="cs_meeting45";// Not convinced, high inquisition dispositioin
        
	        var testy=true;
	        if (obj_controller.faction_status[eFACTION.Imperium]="War") or (obj_controller.marines<=600) then testy=false;
	        if (testy=false) then diplo_goto[3]="cs_meeting50";// Scurrying like a rat, accepts
	        if (testy=true) then diplo_goto[3]="cs_meeting55";// Not convinced
        
	        diplo_goto[4]="cs_meeting60";
	    }
	}
	if (diplo_keyphrase=="cs_meeting21"){
	    event_log=string(obj_ini.master_name)+" kills the "+string(global.chapter_name)+" Master of Sanctity for "+string(obj_controller.faction_leader[eFACTION.Chaos])+".";
	    scr_event_log("purple",event_log);
		// scr_alert("purple","lol",string(tix),0,0);
    
	    diplo_text="As the echoes fade, it becomes clear that the Master of Sanctity of "+string(global.chapter_name)+" has fallen.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting135";
	}
	// MoS cuts in
	if (diplo_keyphrase=="cs_meeting_m1"){
		diplomacy=-5.2;
	    diplo_text="[["+string(obj_ini.name[0,3])+" hisses your name over a private vox channel.]]##";
	    diplo_text+="My lord!  What are we doing here, treating with this monster of the Traitor Legions? The very existence of the Archenemy is a threat to everything the Chapter stands for, and we endanger our immortal souls just being here. You know this! I demand to know your intentions! And I warn you, I will not hesitate to do what I must, for the good of the Chapter and the Imperium.";
    
	    diplo_option[1]="Times change and the Chapter must change with them or be ground into the dust of history.  (Chaos)";
	    diplo_option[2]="We will not serve the Imperium’s crooked ends any longer. Our Chapter will control its own destiny.  (Renegade)";
	    diplo_option[3]="I haven’t turned traitor and my faith is strong. The Beast has foolishly opened its lair to us. Be ready for my signal.";
	    
		for(var g=1; g<=3; g++){diplo_goto[g]="cs_meeting_m2";}
        
	    // Option4 here if all the right conditions are met
	    var born=false;
		for(var ii=1; i<=200; i++){if (obj_ini.role[0,ii]==obj_ini.role[100][eROLE.ChapterMaster]) and (string_count("$",obj_ini.spe[0,ii])>0) then born=true;}
    
	    if (obj_ini.TTRPG[0][3].corruption>=50) and (born=true){
	        diplo_option[4]="Right now I need my Master of Sanctity at my side, trusting that his Chapter Master is doing what is best, what is necessary for the Chapter, during this dangerous moment. All will be made clear in time, I promise you brother. This is the right path.";
	        diplo_goto[4]="cs_meeting_m3";
	    }
	}
	if (diplo_keyphrase=="cs_meeting_m2"){
	    event_log="The "+string(global.chapter_name)+" Master of Sanctity takes a stand against you.";
	    scr_event_log("purple",event_log);// scr_alert("purple","lol",string(tix),0,0);
	    diplo_text="You have besmirched the honor of our chapter this day, and I will not forget it /my lord Chapter Master/.##[["+string(obj_ini.name[0,3])+" strides forward and his shout erupts from his external vox speakers with a boom that shatters the silence in the room.]]##We will not stand idly by and bandy words with heretic scum! To me my brothers! Slay these traitors in the name of our Emperor!";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting9";
	}
	if (diplo_keyphrase=="cs_meeting_m3"){
	    diplo_text="[["+string(obj_ini.name[0,3])+" is silent for a moment, before giving you an imperceptible nod.]]##I stand with you, Lord "+string(obj_ini.master_name)+". Let us face this together.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting20";
	    obj_controller.useful_info+="CRMOS|";
	}
	if (diplo_keyphrase=="cs_meeting_m5"){
		diplomacy=-5.2;
		instance_activate_all();
	    diplo_text="By the sacred oath I have sworn, I bear witness to your darkest secrets. Know this: I am compelled to report your heresy to the Inquisition. Redemption or retribution, their verdict shall decide. May the Emperor's mercy guide your path.";
    
	    diplo_option[1]="Very well.  I did what must be done for my brothers, and now accept the price.  [Game Over]";
	    diplo_option[2]="Never!  [Battle Loyalist "+string(global.chapter_name)+"]";
	    diplo_goto[1]="cs_meeting_m6";
		diplo_goto[2]="cs_meeting_battle7";
	}
	if (diplo_keyphrase=="cs_meeting_m6"){
	    global.defeat=3;
		obj_controller.alarm[7]=5;
	}
	if (diplo_keyphrase=="cs_meeting9"){
		diplomacy=10;
	    diplomacy=10;
	    diplo_text="[["+string(obj_controller.faction_leader[eFACTION.Chaos])+" turns to you, his voice even and calm]]##Here is the first step you must take, to prove you’ve truly left the Imperium behind. Kill him. Kill your loyal brothers.##[[His Chaos Terminators raise their weapons as one and point them at you. Somewhere behind them a daemon cackles.]]##Choose now or be obliterated.";
    
	    diplo_option[1]="Stand with me my brothers! Fight for the future of your Chapter, and slay "+string(obj_ini.name[0,3])+"!  [Battle loyalist "+string(global.chapter_name)+"]";
		diplo_goto[1]="cs_meeting_battle1";
	    diplo_option[2]=string(global.chapter_name)+", I order you to hold your fire! "+string(obj_ini.name[0,3])+", if you doubt my leadership then let it be decided by single combat! [Duel your Master of Sanctity]";
		diplo_goto[2]="cs_meeting_battle2";
	    diplo_option[3]="I deny you "+string(obj_controller.faction_leader[eFACTION.Chaos])+".  And now I shall destroy you.  For the Emperor! [Attack Chaos forces]";
		diplo_goto[3]="cs_meeting_battle5";
	}
	// First explanation for chaos
	if (diplo_keyphrase=="cs_meeting30"){
	    diplo_text="Then you have awakened to the truth the Imperium so hypocritically denies, that there is only one real power in the universe, and it goes to those with the will to seize it.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting135";
	    disposition[10]+=30;
	}
	// Fucking inquisition
	if (diplo_keyphrase=="cs_meeting40"){
	    diplo_text="Yes...you do not fit the precious mold the Codex Astartes carves out for you, do you? And the Imperium destroys that which it cannot understand.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting135";
	    disposition[10]+=30;
	}
	// Nah dawg
	if (diplo_keyphrase=="cs_meeting45"){
	    diplo_text="Do you take me as a fool, "+string(obj_ini.master_name)+"?  Even in the Eye there are whispers of your running to and fro at the Inquisition’s beck and call, like a dog playing fetch. You’re a well-trained, and maybe even a clever, dog. I’ve killed so many clever dogs in my time. How do I know this isn’t just a hopelessly doomed plot to try and kill me, hatched by your Inquisition masters still holding your leash?";
        
	    diplo_option[1]="There are advantages to staying on the Inquisition’s good side, and I’m not one to ignore an advantage.";
	    diplo_option[2]="Appeasing the Inquisition is no hard choice when your options are obey, or eventually be branded a heretic and be destroyed.";
	    diplo_option[3]="Given enough time, everyone becomes a heretic in the eyes of the Inquisition. I will not wait for them to make their move against us.";
	    diplo_option[4]="You have one thing right, "+string(obj_controller.faction_leader[eFACTION.Chaos])+". I am here to kill you. Open fire brothers, NOW!  [Battle Chaos forces]";
		diplo_goto[4]="cs_meeting_battle5";

		for(var q=1; q<=3; q++){diplo_goto[q]=choose("cs_meeting46","cs_meeting47");}
	}
	// Sorry brah, you're not their homie
	if (diplo_keyphrase=="cs_meeting46"){
	    diplo_text="I am not convinced.  A shame.  I was hoping you might actually be of use- but now it is apparent that your use will only be as a bloody, broken offering to the Dark Gods.";
	    diplo_option[1]="[Battle Chaos AND any loyalist forces]";
		diplo_option[2]="cs_meeting_battle6";
	}
	// you might be their homie, fine
	if (diplo_keyphrase=="cs_meeting47"){
	    diplo_text="You may yet be of use to me.  Very well, we will assist you. It will be no trouble at all to exterminate you, should you displease me at a future time.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting135";
	    disposition[10]+=30;
	}
	// mah numbers
	if (diplo_keyphrase=="cs_meeting50"){
	    diplo_text="Yes we have seen you struggle alone, scurrying from shadow to shadow like a hunted rat. I won’t lie to you though, I’ve seen the potential in you and your….brothers. Alright, we will assist you. It will be no trouble at all to exterminate you, should you displease me.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting135";
	    disposition[10]+=30;
	}
	// such numbers, wow
	if (diplo_keyphrase=="cs_meeting55"){
	    diplo_text="I could overrun this sector with half the warriors you have now. Is your “Chapter” so pathetic you need to throw scores more men into the meatgrinder to succeed?  You have not convinced me.  I'd have enjoyed making use of your Chapter, but this was clearly not meant to be.  Make your peace.";
	    diplo_option[1]="[Battle Chaos AND any loyalist forces]";
		diplo_option[2]="cs_meeting_battle6";
	}
	// Actually here to kill you
	if (diplo_keyphrase=="cs_meeting60"){
		var chaos_leader = obj_controller.faction_leader[eFACTION.Chaos];
		disposition[10]+=10;
	    diplo_text=$"[[{chaos_leader} is silent for a moment, then a slow chuckle rises from deep within his ancient power armour. The chuckle erupts into hideous laughter that chills your blood with its otherworldly tenor.]]##I thank you, I have not truly laughed in three hundred years. I shall take your skull as a memento of this day and your fine jest. But before I do, indulge my curiosity. Let us say you did kill me, /then/ what would you do? Claim the price on my head? Go crawling back on your belly to your Imperial masters like a whipped cur, dragging your kill behind you? Become master of this sector yourself now that you’ve bested your greatest foe? Or perhaps you’d offer up my soul to the Dark Gods, ignorantly fumbling about in the darkness for their favor? Tell me.";
    
	    diplo_option[1]="The reward for one such as you will be great, and I /will/ claim it.";
		diplo_goto[1]="cs_meeting61";
	    diplo_option[2]="The atrocities you’ve visited on this sector are reason enough.";
		diplo_goto[2]="cs_meeting63";
	    diplo_option[3]=$"You think me ignorant of the ways of Chaos, {chaos_leader}, but I know one truth. There is power in blood. Your blood. My power. They will hear me.";
		diplo_goto[3]="cs_meeting65";
	    diplo_option[4]=$"I’m just tired of listening to you talk, {chaos_leader}.";
		diplo_goto[4]="cs_meeting67";
	}
	// Reward
	if (diplo_keyphrase=="cs_meeting61"){
	    diplo_text="It is this blind overconfidence that makes killing a Space Marine so satisfying.";
	    diplo_option[1]="[Battle Chaos forces]";
		diplo_goto[1]="cs_meeting_battle5";
	}
	// Atrocities
	if (diplo_keyphrase=="cs_meeting63"){
	    diplo_text="Oh, but I have one more atrocity to commit you simply shouldn’t miss...";
	    diplo_option[1]="[Battle Chaos forces]";
		diplo_goto[1]="cs_meeting_battle5";
	}
	// BLOOD BLOOD BLOOD
	if (diplo_keyphrase=="cs_meeting65"){
	    diplo_text="You know, I think I would actually enjoy watching you attempt it. But I’ll spare you having your soul torn to shreds by daemons, and just give you an agonizing death instead.";
	    diplo_option[1]="[Battle Chaos AND any loyalist forces]";
		diplo_goto[1]="cs_meeting_battle6";
	}
	// stahp talking
	if (diplo_keyphrase=="cs_meeting67"){
		disposition[10]+=10;
	    diplo_text="And I thought we were becoming such fast friends, you and I. Very well, don’t bore me.";
	    diplo_option[1]="[Battle Chaos forces]";
		diplo_goto[1]="cs_meeting_battle5";
	}

	// Finish the conversation
	// 135
	// 136
	// 137

	if (diplo_keyphrase=="cs_meeting135"){
		disposition[10]=max(disposition[10]+10,10);
	    diplo_text="[["+string(obj_controller.faction_leader[eFACTION.Chaos])+"’s power armour grinds as he leans forward, his posture predatory.]]##Then we have an accord. We will assist you as you take your first steps on the path toward Chaos. And my payment for all this?##[[He chuckles.]]##Enlisting an entire chapter in the service of the Dark Gods is all the reward I require.";
	    diplo_text+="##But you cannot simply paint the eight-pointed star on your wargear and begin slaughtering in the name of the Dark Gods. No, some within your chapter will resist the choice you’ve made, either out of loyalty to the Corpse Emperor or out of fear of Chaos. Just think, it will be like your own little heresy. The ''"+string(obj_ini.master_name)+" Heresy!''";    
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting136";
	}
	if (diplo_keyphrase=="cs_meeting136"){
	    event_log=string(obj_controller.faction_leader[eFACTION.Chaos])+" gives you an Artifact, meant to help corrupt your marines to the path of Chaos.";
	    scr_event_log("purple",event_log);// scr_alert("purple","lol",string(tix),0,0);
	    diplo_text="[The tones of his humorless laughter are filled with the bitterness of ancient, poisoned memories. He continues.]##You must emerge victorious from this... \\Civil War\\, and not decimate your ranks in the process, if you are to be of any use to the Gods or to me.  ";
	    diplo_text+="And to that end, I give you this.##[["+string(obj_controller.faction_leader[eFACTION.Chaos])+" gestures to one of his Terminators, who presents you with an Artifact. In your mind, something sinister seems to cling to the lines of its form.]]##The more of your warriors that come to accept Chaos, the fewer holdouts there will be to overcome when the time comes. This object will speed their introduction to its ways. You must also encourage your warriors to...broaden their horizons wherever possible, so they come to their own understanding of the Primordial Truth. But you must tread carefully at the same time, lest you alert the Inquisition. They must not have even a hint of what’s taking place in your Chapter, or they will obliterate you.";
	    diplo_option[1]="[Continue]";
		diplo_goto[1]="cs_meeting137";
	}
	if (diplo_keyphrase=="cs_meeting137"){
	    diplo_text="When enough of your warriors have embraced Chaos, assemble them together in one place and then speak with me, and I will show you the beginning of the Eightfold Path. Now, begone.##[[As you leave he calls out to you one more time.]]##And "+string(obj_ini.master_name)+", I expect action within a few years. My patience, unlike Chaos, is not infinite.";
	    complex_event=true;
		current_eventing="";
	    force_goodbye=1;
		faction_status[eFACTION.Chaos]="Antagonism";
    
	    with(obj_star){
	    	remove_star_problem("meeting");
	    	remove_star_problem("meeting_trap");
	    }
    
	    var born=false;
		for(var ii=1; ii<200; ii++){
			if (obj_ini.role[0,ii]==obj_ini.role[100][eROLE.ChapterMaster]) then obj_ini.TTRPG[0][ii].corruption+=floor(random_range(30,50));
		}
	    obj_controller.chaos_rating+=1;
    
	    // Casket, Chalice, Tome
	    if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("chaos_gift","",0,obj_ini.home_name,2);
	    if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("chaos_gift","",0,obj_ini.ship[0],501);
	}
	if (string_count("cs_meeting_battle",diplo_keyphrase)>0){
	    current_eventing=diplo_keyphrase;combating=1;
	    cooldown=30;
		diplomacy=0;
		menu=0;
	    instance_activate_all();
    
	    with(obj_ground_mission){instance_destroy();}
	    with(obj_star){
			for (var run=1; run<=4; run++) {
    			for (var s=1; s<=4; s++) {
	                if (p_problem[run,s]=="meeting") or (p_problem[run,s]=="meeting_trap"){
	                    for (var repeatCount=1; repeatCount<=run; repeatCount++){instance_create(x,y,obj_ground_mission);}
	                }
	            }
	        }
	    }
	    if (instance_number(obj_ground_mission)==0){
	        with(obj_star){
	            if (string_count(name,scr_master_loc())>0){
	                repeat(obj_ini.TTRPG[0,0].planet_location){
	                	instance_create(x,y,obj_ground_mission);
	                }
	            }
	        }
	    }
	    // show_message(string(instance_number(obj_ground_mission)));
    
	    instance_create(0,0,obj_ncombat);
	    obj_ncombat.battle_special=diplo_keyphrase;
	    obj_ncombat.battle_object=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_star);
	    obj_ncombat.battle_loc=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_star).name;
	    obj_ncombat.battle_id=instance_number(obj_ground_mission);
	    with(obj_ground_mission){instance_destroy();}
	    obj_ncombat.dropping=0;
	    obj_ncombat.attacking=1;
	    obj_ncombat.local_forces=0;
    
	    if (diplo_keyphrase=="cs_meeting_battle1"){
			obj_ncombat.enemy=1;
			obj_ncombat.threat=2;
		}
	    if (diplo_keyphrase=="cs_meeting_battle2"){
			obj_ncombat.enemy=1;
			obj_ncombat.threat=1;
		}
	    if (diplo_keyphrase=="cs_meeting_battle5"){
			obj_ncombat.enemy=10;
			obj_ncombat.threat=3;
		}
	    if (diplo_keyphrase=="cs_meeting_battle6"){
			obj_ncombat.enemy=10;
			obj_ncombat.threat=3;
		}
	    if (diplo_keyphrase=="cs_meeting_battle7"){
			obj_ncombat.enemy=1;
			obj_ncombat.threat=2;
		}
    
	    if (obj_ncombat.enemy=10) and (obj_controller.faction_defeated[10]=0){
	        obj_ncombat.leader=1;
        
	        with(obj_star){
	        	remove_star_problem("meeting");
	        	remove_star_problem("meeting_trap");
	        }
	    }
    
		for(var v=1; v<obj_temp_meeting.dudes; v++){
	        if (obj_temp_meeting.present[v]=1){
	            obj_ncombat.fighting[obj_temp_meeting.co[v],obj_temp_meeting.ide[v]]=1;
	        }
	    }
	    scr_civil_roster(obj_ncombat.battle_loc,obj_ncombat.battle_id,true);
    
	    instance_deactivate_all(true);
	    instance_activate_object(obj_controller);
	    instance_activate_object(obj_ini);
	    instance_activate_object(obj_temp_meeting);
	    instance_activate_object(obj_ncombat);
	    instance_activate_object(obj_centerline);
	    instance_activate_object(obj_pnunit);
	    instance_activate_object(obj_enunit);

	    exit;
	}
	// ** Chaos Gods **
	if (diplomacy == 10.1){
		diplo_option=["","","","",""];
		switch (diplo_keyphrase){
			case "intro":
				diplo_text = "[[The Emmissary to Chaos is writhing snake like creature, a vile creature even by the standards of it's foul bretheren it has no specific master instead preffering to work undividely. It's savage toungue flicks from between it's teeth with glazed aged ayes staring into your soul]]";
				diplo_text += "###";
				diplo_text += "Greetings Chapter Master, The gods have been watching you oh so very closely, they see you struggles, they hear your pain, they breathe your despair. The warp is the key too all things all you need do is ask and they will provide......For a cost of course even in the warp nothing comes without cost";
				diplo_option[1] = "I seek a favour from the Gods"; 
				diplo_option[2]="Begone Filth i serve the true god FOR THE EMPROR"; 
				diplo_option[3]="The gods may have respect when they earn it i'll be back cretin";
				break;	
			case "gift":
				diplo_text ="Of course Chapter master (giggle) and what may they do for you";
				diplo_option[1] = "I need strength and power to crush my enemies";
				diplo_option[2]="I seek to protect thoes under my command from this hellish existance";
				diplo_option[3]="I seek wisdom and knowlage to better guide me";
				diplo_option[4]="I seek wealth and a better life for my men";
				break;
			case "Khorne_path":
				diplo_text ="AAAAH the path of the warrior perhaps it was a little hopefull of me to expect anymore, from the right angle i suppose you could almost pass form one of those stunted little red bretheren of mine. The lord of skulls is always eager to help in an endevour that might spill even a moreseful more, but pray what will you offer to the lord of skulls for such favour; he loathes those who emply sorcery but then, but he's known to value the martial mans skull most, i suppose it dosen't matter too much from where the blood flows so long as it flows."
				diplo_option[1] = "Sacrifice Librarian"; 
				diplo_option[2] = "Sacrifice Champion"; 
				diplo_option[3] = "Sacrifice squad"; 
				diplo_option[4] = "FLEE"
			break;
				case "daemon_scorn":
					diplo_text = "return when you find yourself more enligtened Chapter Master my Lords hunger for you";
				break;
			case "Nurgle_path":
				diplo_text ="No one understands decay, rot and eventual death like the loving father of the warp. Only he can end your suffering and and that of your men. To be embraced is all the benevolent Father asks do you accept thse tuerms Chapter Master"
				diplo_option[1] ="I accept, we surrender our will to the father"; 
				diplo_option[2] = "Never you foul daemon all i hear are foul tricks"; 
				diplo_option[3] = ""; 
				diplo_option[4] = "";
				break;
			case "Slaanesh_path":
				diplo_text ="Riches. Joy. Pleasure.ha you remind me of that fool Midas. Who's Midas? Oh never you mind. She who thirsts has a fondness for little play things. Seek out a relic of importnace to her and you'll find yourself rewarded."
				diplo_option[1] ="Where is this relic?"; 
				diplo_option[2] = "As i thought the  gods would rather have me chase my own tail than give me what i want"; 
				diplo_option[3] = ""; 
				diplo_option[4] = "";
			break;	
			case "Tzeentch_path":
				diplo_text ="Yes I supose for a creature of your occupation your fate must be a pressing concern. it's dreary really wandering which rancid little backwater you'll die on fighting a pointless cause for a corpse on a throne, or maybe you only ask because you harbour greater ambitions? The changer of ways knows all things if you'll play a part in his games for him. ohh he does love his games yes he does."
				diplo_option[1] ="What little game?"; 
				diplo_option[2] = "A game? not only heretics but fools then begone Daemon"; 
				diplo_option[3] = ""; 
				diplo_option[4] = "";
			break;	
			case "sacrifice_lib":
				diplo_text="one less spell caster how pleasing for the lord. Enjoy your gift.";
			break;	
			case "sacrifice_champ":
				diplo_text="How much of a champion can a dead man really be. Enjoy your gift.";
			break;	
			case "sacrifice_squad":
				diplo_text="Sooo many good souls how sweet on my tounge. Enjoy your gift";
			break;
			case "Slaanesh_arti":
				diplo_text="Fetch this for her and you shall have their favour";
			break;
			case "Nurgle_gift":
				diplo_text="The father is a loving figure. Farewell may your men rot gently.";
			break;
			case "Tzeentch_plan":
				diplo_text="All these schemes i can hardly be bothered to keep track. Do this and you shall have fates favour.";
			break;
		}
			if (diplo_keyphrase == "gift"){
			diplo_text ="Of course Chapter master (giggle) and what may they do for you";
			diplo_option[1] = "I need strength and power to crush my enemies";
			diplo_option[2]="I seek to protect thoes under my command from this hellish existance";
			diplo_option[3]="I seek wisdom and knowlage to better guide me";
			diplo_option[4]="I seek wealth and a better life for my men";	

		};
	}
	// ** Chaos **
	if (diplomacy=10){
	    if (diplo_keyphrase=="civilwar_begin"){
	        diplo_text="The Imperium, blinded by its own hypocrisy, drowns in corruption and stagnation.If it is civil war they desire, then civil war they shall have.";
			force_goodbye=1;
	    }
	    if (diplo_keyphrase=="civilwar_soon"){
	        diplo_text="The winds of change whisper a familiar tune. Soon, the veil of deceit shall be lifted, and the true face of the Imperium shall be revealed to all.";
			force_goodbye=1;
	    }
    
	    if (diplo_keyphrase=="intro") or (diplo_keyphrase=="intro2"){
	        if (faction_gender[10]==1) then tempd="[[An ancient and veteran Chaos Lord, "+string(faction_leader[eFACTION.Chaos])+" has been a massive threat to "+string(obj_ini.sector_name)+" and the surround region since time remembered.  He has fought against loyal Astartes and the forces of man for many millennia, if not since the Horus Heresy, and is personally responsible for several rebellions.  Were "+string(faction_leader[eFACTION.Chaos])+" to be silenced, his poisonous lies and false promises would no longer taint the sector.]]";
	        if (faction_gender[10]==2) then tempd="[An ancient World Eaters Chaos Lord, "+string(faction_leader[eFACTION.Chaos])+" is a powerful warrior, blessed by Khorne.  He has personally vanquished dozens of Astartes Champions and countless more Imperial Servants.  It is by his warband's hands that a massive, bloody path of destruction has been carved through the stars.  His forces are just now arriving within "+string(obj_ini.sector_name)+"- a direct confrontation is ill-advised.]]";
	        tempd+="###";
        
	        // Need to have situational awareness for here- alternate introductions
        
	        if (faction_gender[10]==1) and (diplo_keyphrase=="intro"){
	            rando=choose(1,1,2);
				force_goodbye=1;
	            if (rando==1) then tempd+="It is a fine day, is it not?  Yet again the Imperium displays its tyrannical, bureaucratic nature by declaring your chapter traitor.  To unmake your forces, alone, is beyond my reach.  It is fortunate I may simply sit back and watch as it is ground to dust by your former allies.  When we meet again, "+string(obj_ini.master_name)+"- if we meet again- I will enjoy killing you.";
	            if (rando==2) then tempd+="We have not met before, "+string(obj_ini.master_name)+", but until now this would have been troublesome.  I am "+string(faction_leader[eFACTION.Chaos])+"- no doubt you know of me, or have at least seen my hand at play.  I am here, now, to laugh at you.  Though it's been long since I could feel joy, or amusement, my hearts are warmed at seeing the Imperium destroying their own.  If we meet again I would very much like to kill you.";
	        }
	        if (faction_gender[10]==1) and (diplo_keyphrase="intro2"){
	            rando=choose(1,1,2,3,3,4,4);
				force_goodbye=1;
	            if (rando==1) then tempd+="Your defeat was a foregone conclusion, Astartes. Your Chapters are like children compared to the Legions of old and we have only grown stronger after millennia of slaughter. Though you are not worthy of it I will honor you with death and make of it an offering to the Dark Gods.";
	            if (rando==2) then tempd+="Do not mourn your fallen, mewling wretch of the Imperium.  Their deaths were not in vain.  Each was a sacrifice to the Gods of the Warp and you pleased them greatly this day.  For there is no paradise at the side of the False Emperor awaiting them, no glorious final battle.  There is only the Warp.  Even now their souls writhe in torment as they are chewed by the teeth of madness, and they will do so for all eternity.  This same fate, and more, awaits you.";
	            if (rando==3) then tempd+="Your men were no true challenge, Chapter Master, merely wheat before the scythe of my forces. Next time you foolishly send your troops blundering into combat, at least make sure they are troops that offer some diversion. More entertainment was had from the desecration of their corpses than in the stealing of their life, though perhaps this will be true of your entire warband. In time, no doubt I will see.";
	            if (rando==4) then tempd+="You should be grateful that I gave your men a chance to die for their Emperor, to throw their lives away for your corpse god, to squander their might and prestigious gifts on fighting for the glory of a long dead cause. Their deaths, while meaningless to the the rest of the galaxy, must surely have brought them the satisfaction of a vindicated fanatic. Soon, I will give you this gift as well, purely from the generosity of my hearts.";
	        }
	        if (faction_gender[10]==2){
	            rando=choose(1,1,2,2,2);
	            if (rando==1) then tempd+="I COME NOW, "+string_upper(obj_ini.master_name)+", FOR YOU.  NONE OF YOUR MEN, NONE OF YOUR ALLIES, AND NOTHING YOU CAN DO WILL PREVENT ME FROM KILLING YOU.  FLEE, AND I WILL RUN YOU DOWN LIKE THE ANIMAL YOU ARE.  YOUR DAYS ARE NUMBERED.";
	            if (rando==2) then tempd+="BY KHORNE'S NAME "+string_upper(obj_ini.sector_name)+" SHALL BURN.  CRAWL INTO A HOLE, OR STAND AND FIGHT, IT MATTERS NOT.  YOU ARE FATED TO DIE BY MY HAND, ALONG WITH THE REST OF YOUR PATHETIC CHAPTER.";
	        }
	        diplo_text=tempd;
	    }
	    if (diplo_keyphrase=="hello") or ((diplo_keyphrase=="propose_alliance") and (faction_gender[10]==2)){
	        scr_loyalty("Heretic Contact","+");

	        if (faction_gender[10]==1) and (string_count("CHTRP|",obj_controller.useful_info)==0){
	            if (chaos_rating>=1){
	                rando=choose(1,2,3,4);
	                if (rando==1) then diplo_text="Yes, "+string(obj_ini.master_name)+"?";
	                if (rando==2) then diplo_text="You require something, "+string(obj_ini.master_name)+"?";
	                if (rando==3) then diplo_text="What is it?";
	                if (rando==4) then diplo_text="What do you want?";
                
	                if (obj_controller.chaos_rating>=1){
	                    diplo_option[1]="My Chapter is prepared to join Chaos.  [Begin]";
						diplo_goto[1]="civilwar_begin";
	                    diplo_option[2]="I require more time to corrupt my brethren.";
						diplo_goto[2]="civilwar_soon";
	                }
	            }
	            if (disposition[10]>-80) and (chaos_rating==0){
	                rando=choose(1,2,2,3,3,3,4,4,4,4,5,5,5);
	                if (rando==1) then diplo_text="Ahhhh.  You require something, "+string(obj_ini.master_name)+"?";
	                if (rando==2) then diplo_text="You risk much with this audience.  I hope I can make it worth your while.";
	                if (rando==3) then diplo_text="Now this is an unlikely meeting.  What can I do for you, "+string(obj_ini.master_name)+"?";
	                if (rando==4) then diplo_text="Have you finally seen the light, at long last?";
	                if (rando==5) then diplo_text="There are few reasons a Chapter Master might wish an audience, and they are all worthwhile.  What can I and my forces do for you?";
	            }
	            if (disposition[10]<=-80){
	                force_goodbye=1;
					rando=choose(1,2,2,3,3);
					turns_ignored[10]+=choose(3,4,5);
	                if (rando==1) then diplo_text="There are no more words to be said.";
	                if (rando==2) then diplo_text="The forces of Chaos call for your destruction.";
	                if (rando==3) then diplo_text="Your soul will be mine.";
	            }
	            if (rela!="hostile"){// Only happens with leader=1
	                // More normal "yes?" greetings
					rando=choose(1,2);
					if(rando==1) then diplo_text="May the Chaos gods bless us in our meeting!";
					if(rando==2) then diplo_text="Do you need help to kill some heretics?";
	            }
	        }
	        if (faction_gender[10]==1) and (string_count("CHTRP|",obj_controller.useful_info)>0){
	            obj_controller.useful_info=string_replace(obj_controller.useful_info,"CHTRP|","CHTRP2|");
	            diplo_text+="I almost refused to believe that my little trap hadn't done you in, but here you are.  I may have misjudged you, "+string(obj_ini.master_name)+".  Of course I still intend to kill you, regardless, but I can give credit where credit is due.";
				force_goodbye=1;
	        }
	        if (faction_gender[10]==2){
	            force_goodbye=1;
				turns_ignored[10]+=choose(3,4,5);
	            rando=choose(1,2,3);
				if (diplo_keyphrase=="propose_alliance") then rando=choose(1,2,2,3);
	            if (rando==1) then diplo_text="I AM GOING TO RIP YOUR HEARTS OUT AND CONSUME THEM IN FRONT OF YOU!";
	            if (rando==2) then diplo_text="BEGGING WILL DO YOU NO GOOD, IMPERIAL LAPDOG!";
	            if (rando==3) then diplo_text="DEATH COMES FOR ALL!";
	        }
	    }
	    if (diplo_keyphrase=="trade_close"){
			rando=choose(1,2,3);
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="When the time comes for your extinction, I will carve a list of the many times you irked me into your skin. This incident will go on your "+choose("forehead","chest","throat","cheek","heart")+".";
	            if (rando==2){
					diplo_text+="Begone then, the stench of your vaunted sanctity offends me.";
					force_goodbye=1;
				}
	            if (rando==3){
					diplo_text+="It must be said that while you fail at almost all aspects of commanding a Chapter, you are extremely skilled in causing me slight irritations. Congratulations.";
					force_goodbye=1;
				}
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="Next time you see fit to contact me, I expect you to have considered your words more carefully. Before you are required to speak them, if possible.";
	            if (rando==2) then diplo_text+="You are boorish to converse with but I suppose it cannot be helped; you were trained to kill, not to talk or, indeed, to think.";
	            if (rando==3) then diplo_text+="Traditionally, one makes sure one is sure of ones course of action before acting, not afterwards. Something for you to consider, no doubt.";    
	        }
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        if (faction_gender[10]==1) and (rela=="hostile"){
	            rando=choose(1,2,3);
	            if (rando==1) then diplo_text="I spit upon your demands, loyalist dog. Beg your corpse Emperor for something instead.";
	            if (rando==2) then diplo_text="A child, blind to the ways of the world, may demand things from an adult but all he gets is a bloody nose.  Insolent whelp.";
	            if (rando==3) then diplo_text="Your demands are much like your misguided faith in the ‘Emperor'; nothing but dust before the implacable winds of Chaos.";
	        }
	    }
	    if (string_count("agree",diplo_keyphrase)==1){
	        if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
	        if (trading_artifact!=0) then diplo_text="[[Trade Accepted.]]##";
	        if (liscensing>0){
	            diplo_text="[[Trade Accepted.  License(s) Transmitted.]]##";
	            force_goodbye=1;
	            // something else here; schedule the license and do not go to the next audience
	        }
	        rando=choose(1,2,3);
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="Very well, let it be so. I will give the relevant commands to my underlings and arrangements will be made.";
	            if (rando==2) then diplo_text+="This is an acceptable trade, beneficial to both of us. I agree to it.";
	            if (rando==3) then diplo_text+="For now, I will accept this trade. Do not assume I will always do so, however.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="Sometimes a lord deigns to exchange with the meanest pauper. It does not make them equals.";
	            if (rando==2) then diplo_text+="I will trade with you, little loyalist, if only to be closer to laugh at you when you fall to the inexorable machinations of the Gods.";
	            if (rando==3) then diplo_text+="If only to demonstrate how meaningless your efforts are in the grand scheme of the Galaxy, I'll accept this trade.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        annoyed[diplomacy]+=1;
	        rando=choose(1,2,3);
	        if (rela=="hostile"){
				force_goodbye=1;
	            if (rando==1) then diplo_text+="You would offer me scraps for the keys to a kingdom? You are foolish and, worse, you are unaware of your own incompetence.";
	            if (rando==2) then diplo_text+="Do not attempt exchanges with those so far above you, lapdog of the Corpse Emperor, it makes you look even more idiotic than you already do.";
	            if (rando==3) then diplo_text+="I would spit upon this ‘offer' you bring before me but I find myself too amused by it.";
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="You may consider my response to be a ‘no' and assume my attitude to be whatever you like, Chapter Master.";
	            if (rando==2) then diplo_text+="Have a care that you do not overstep the mark, Chapter Master, I see no reason to accept such a trade.";
	            if (rando==3) then diplo_text+="An unreasonable trade, whatever our working relationship might be. I refuse.";
	        }
	        if (annoyed[diplomacy]>=10){
				force_goodbye=1;
	            turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;diplo_alpha=0;exit;
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        // TODO
	    }
	    if (diplo_keyphrase=="declare_war"){
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
			rando=choose(1,2,3);
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="The war already exists, you petulant fool. It has raged for 10,000 years and will outlive us both.";
	            if (rando==2) then diplo_text+="And before you ‘declared war'? Did you believe that I had no intention of destroying you at that time? You delusional dog.";
	            if (rando==3) then diplo_text+="Do not worry, thrall of the corpse Emperor, I shall grant you both death and freedom from your bonds of ‘loyalty'.";
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="It is puzzling to me that you believe this changes anything but I see this means a lot to you so I accept your ‘declaration'.";
	            if (rando==2) then diplo_text+="Little fool, you do not to understand the nature of the Galaxy. If we have time before I obliterate you, I will educate you.";
	            if (rando==3) then diplo_text+="Were we not already engaged in a war 10,000 years old, your declaration might mean something.";
	        }
	    }
	    if (diplo_keyphrase=="accept_peace"){scr_chaos_alliance_test();}
    
	    if (diplo_keyphrase=="ignored"){
	        // TODO
	    }
	    if (diplo_keyphrase=="denounced"){
	        if (faction_gender[10]==1){
				disposition[10]-=1;
	            rando=choose(1,2,3,4,5,6,6,7,8,9);
	         if (rando==1) then diplo_text="You are nothing.";
	         if (rando==2) then diplo_text="Pathetic.";
	         if (rando==3) then diplo_text="I grow weary of your ineptitude.";
	         if (rando==4) then diplo_text="Judgement comes for all.";
	         if (rando==5) then diplo_text="Your kind will be destroyed, in time.";
	         if (rando==6) then diplo_text="["+string(faction_leader[eFACTION.Inquisition])+" lets out an amused, extremely confident chuckle.]";
	         if (rando==7) then diplo_text="Your soul will be mine.";
	         if (rando==8) then diplo_text="Do not trifle with me, worm.";
	         if (rando==9){
				diplo_text="I have travelled the stars for millennia.  Worlds have burned at my command, countless souls damned.  The ground trembles with every step.  Now I sit here and listen to you.  Where did it all go so wrong?";
			 	force_goodbye=1;
			}
	         if (disposition[10]<=-80){
				diplo_text="Your end will soon be at hand; you need not rush toward it so eagerly.";
				force_goodbye=1;
			}
	        }
	    }
	    if (diplo_keyphrase=="praised") and (faction_gender[10]=1){
	        if (faction_justmet==0) and (disposition[10]<-75) then disposition[diplomacy]+=choose(0,0,1);
	        if (faction_justmet==1){
				disposition[diplomacy]+=2;
				faction_justmet=0;
			}
			rando=choose(1,2,3);
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="Save your words for one who is easily swayed by such pleasantries, you blundering oaf.";
	            if (rando==2) then diplo_text+="Your words would be better served placating members of your Imperium's Inquisition who will, I am sure, be interested in our correspondences.";
	            if (rando==3) then diplo_text+="Prattle on, fool, your words contain less meaning than the solar wind that blows across cold stars.";
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="Whether by accident or design, you speak truth. But do not believe it changes anything about how I see you or how I will treat you.";
	            if (rando==2) then diplo_text+="Were I someone who responded to the slightest praise with preferential treatment, I would not have got were I am today.";
	            if (rando==3) then diplo_text+="Words will not sway me in the slightest. Only actions display worthiness.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
			rando=choose(1,2,3);
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="As much as I am loathe to besmirch my ears by listening to your words, needs must when cruel fate drives us into a corner. I have an offer for you.";
	            if (rando==2) then diplo_text+="Do not presume that I come to you out of admiration or seeking friendship.  I merely wish to trade you enough rope to hang yourself with.";
	            if (rando==3) then diplo_text+="Soon, you will be either dead or close enough that it makes no difference.  At this moment, however, I wish to offer you a trade.";
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="Prove that you are more than just another ten day traitor, trade with me and further both our agendas.";
	            if (rando==2) then diplo_text+="If we truly both follow the many stepped path towards the glory of chaos, you will agree to trade with me.";
	            if (rando==3) then diplo_text+="Trade, if not allegiance, between the children of chaos is essential to the furthering of our shared agenda.";
	        }
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="Make your proposal.";
	    if (diplo_keyphrase=="artifact_thanks"){
			rando=choose(1,2,3);
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="I would have torn it from your cold, dead hands in any case but this does save us some time.";
	            if (rando==2) then diplo_text+="A meaningless gesture, Chapter Master, but it brings us a little closer to your inevitable demise so it is appreciated.";
	            if (rando==3) then diplo_text+="You have no more idea of what you're doing than a headless Grox, do you? I will consider making you end swift, when the time comes.";
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="I shall examine this gift for any traps or flaws before rendering you any thanks.";
	            if (rando==2) then diplo_text+="It will go into my vault to be stored with the many others of its type I have collected. Nevertheless, I thank you for the gesture.";
	            if (rando==3) then diplo_text+="If you expect gushing thanks or rapturous praise, you will go on waiting. I am not sure how much of a favour you have done me.";            
	        }
	    }
	    if (diplo_keyphrase=="stc_thanks"){
			rando=choose(1,2,3);
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="There would have been no place you could have hidden it from me when I came to claim it, you insignificant worm.";
	            if (rando==2) then diplo_text+="A petty, insignificant, pointless gesture of deference but a gesture of deference nonetheless and I will remember it when my hand is around your throat.";
	            if (rando==3) then diplo_text+="I cannot fathom the path of thought that brought you to this action but it doesn't truly matter; it will be rendered meaningless with your death.";
	        }
	        if (rela!="hostile"){
	            if (rando==1) then diplo_text+="Interesting, a gift as rare as this implies that you expect something in return. I shall consider what you want and, more importantly, what I am prepared to give.";
	            if (rando==2) then diplo_text+="A gift more valuable than most but still something I have come across before. I shall have it stored in my personal vaults.";
	            if (rando==3) then diplo_text+="I shall keep this gift close, both as a reminder of your generosity and to remind me to watch you carefully, Chapter Master.";
	        }
	    }
	    if (diplo_keyphrase=="trading_demand"){
	        if (rela=="hostile"){
				rando=choose(1,2,3);
	            if (rando==1) then diplo_text+="Speak, worm, lest I wipe you from existence before you manage even to beg for mercy.";
	            if (rando==2) then diplo_text+="I can only hope you intend to beg for mercy and throw yourself upon my dubious mercy.  It will be quicker for all concerned.";
	            if (rando==3) then diplo_text+="Words are wind, much like you will be if I don't like what I hear.";
	        }
	        if (rela!="hostile"){
				rando=choose(1,2,2,3,3,3);
	            if (rando==1) then diplo_text+="Choose the words you use as carefully as your battle gear, least the former mean you need to use the latter.";
	            if (rando==2) then diplo_text+="I am not a being of unlimited leisure time, Chapter Master, so you will need to be swift with your words.";
	            if (rando==3) then diplo_text+="Speak but do not be offended if I seem not to be paying attention; I'm probably not.";
	        }
	        diplo_option1="Demand Requisition";
			diplo_option2="Demand Military Assistance";
			diplo_option3="Cancel";
	    }
	    if (diplo_keyphrase=="propose_alliance") and (obj_controller.faction_gender[10]==1){
	        with(obj_temp5){instance_destroy();}
	        with(obj_star){
	            var yeah=0;
				for(var i=1; i<=4;){
					for(var r=1; r<=4; r++){
						if (p_problem[i,r]=="meeting") or (p_problem[i,r]=="meeting_trap") then yeah=r;
					}
				}
	            if (yeah>0){
					for(var j=0; j<yeah; j++){instance_create(x,y,obj_temp5);}
				}
	        }
	        if (instance_exists(obj_temp5)){
	            rando=choose(1,2);
				var there=instance_nearest(obj_temp5.x,obj_temp5.y,obj_star);
	            if (rando==1) then diplo_text="I await your arrival on "+string(there.name)+" "+scr_roman(instance_number(obj_temp5))+", in case it has slipped your mind.";
	            if (rando==2) then diplo_text="We agreed to meet upon "+string(there.name)+" "+scr_roman(instance_number(obj_temp5))+".  Do not squander this opportunity.";
	        }
	        if (!instance_exists(obj_temp5)) then scr_chaos_alliance_test();
	        with(obj_temp5){instance_destroy();}
	    }
	}
	// ** Imperium **
	if (diplomacy==2){
	    if (diplo_keyphrase=="intro"){
	        rando=choose(1,2);
	        if (rando==1) then tempd="[[To see Sector Commander "+string(faction_leader[eFACTION.Imperium])+" is to see what happens to heroes when their glory days have passed and the rot of ages sets in. Now a huge mass of fat and flab, he was once a mighty and respected general and the commander of a score of successful campaigns. As his reward for a glorious career, he was given commander of the sector and, as has happened to so many others, the bureaucracy crushed his warrior spirit and turned him into the man he is.]]";
	        if (rando==2) then tempd="[[Loyal to allies and venomous to enemies, few figures command such opposing reputations as "+string(faction_leader[eFACTION.Imperium])+". Enemies of the Imperium speak in hushed tones of his incredible cruelty and harsh actions against them, whereas the citizens and organizations that lay claim to the protection of the Emperor loudly toast his generosity and stalwart courage. A friend to keep and an enemy to lose.]]";
	        tempd+="###";
	        rando=choose(1,2);
	        if (rando==1) then tempd+="Space Marines in my sector are expected to conduct themselves as befits one of the Adeptus Astartes. Do not disappoint me."; 
	        if (rando==2) then tempd+="It is good that the vessels of the Emperor's wrath have arrived in this sector- to bring his justice to the xenos and the heretic."; 
	        diplo_text=tempd;
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly") then diplo_text="What can I do for the hero of "+string(obj_ini.sector_name)+"?";
	        if (rela=="neutral") then diplo_text="State your business, Chapter Master.";
	        if (rela=="hostile") then diplo_text="What do you want, Chapter Master? I have little time for glorified interplanetary brigands such as yourself.";
	    }
	    if (diplo_keyphrase=="trade_close"){
	        if (rela=="friendly") then diplo_text="Were I a less forgiving man, I might find that rude! But there is little I would not forgive you, my friend!";
	        if (rela=="neutral") then diplo_text="It is hardly courteous to change ones mind when a deal is about to be reached. Still, I suppose you /must/ have your reasons.";
	        if (rela=="hostile") then diplo_text="How very like you to back out of things. I seem to recall your vows to guard this sector from Xenos, heretics and mutants. Strange, but some still seem to be around.";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="I only wish I could assist you in this way, Chapter Master, but I am afraid I cannot.";
	            if (rando==2) then diplo_text="I am truly sorry, Lord, but I have to chance of fulfilling your request.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="At this time, I'm afraid it is not possible for me to comply.";
	            if (rando==2) then diplo_text="Perhaps at a later date or if you had asked earlier, but now is simply too difficult.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Do not think that you can demand everything because you are an Astartes. I decline.";
	            if (rando==2) then diplo_text="Get thee gone, I am in no mood for your presumptions.";
	        }
	    }
	    if (string_count("agree",diplo_keyphrase)==1){
	        if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
	        if (trading_artifact!=0) then diplo_text="[[Trade Accepted.]]##";
	        if (liscensing>0){
	            diplo_text="[[Trade Accepted.  License(s) Transmitted.]]##";
	            force_goodbye=1;
	            // TODO something else here; schedule the lisence and do not go to the next audience
	        }
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="Mightily agreeable, Chapter Master. I will await the fruition of our arrangement.";
	            if (rando==2) then diplo_text+="A sound suggestion, let it be so!";
	            if (rando==3) then diplo_text+="The Emperor was truly merciful when he sent you to us, Chapter Master. I agree!";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="An acceptable proposition.  You will have to talk it over with my scribes.";
	            if (rando==2) then diplo_text+="The Sector would benefit from such a deal.";
	            if (rando==3) then diplo_text+="Indeed, let it be so, Chapter Master.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="It is my only option, but I will curse you forever for forcing me into this.";
	            if (rando==2) then diplo_text+="If you cross me, the wrath of the Emperor will come down on your head.";
	            if (rando==3) then diplo_text+="I never thought I would work with as deplorable a character as yourself, but I accept.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        annoyed[diplomacy]+=2;
	        if (annoyed[diplomacy]>=10){
				force_goodbye=1;
	            if (rela=="friendly") then diplo_text+="I cannot accept this deal and the day grows late; I will not take any more of your time.";
	            if (rela=="neutral") then diplo_text+="I apologize, Chapter Master, but I have more pressing concerns.  The Emperor protects.";
	            if (rela=="hostile") then diplo_text+="Don't you have better things to do, astartes?";
	            turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;
				diplo_alpha=0;
				exit;
	        }
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="I apologize, but my resources must be directed in a different direction.";
	            if (rando==2) then diplo_text+="It pains me to deny you but I fear I must.";
	            if (rando==3) then diplo_text+="Unfortunately, I and my forces have a prior engagement.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="I do not believe this will help either of us.";
	            if (rando==2) then diplo_text+="Tempting... but no, I must decline.";
	            if (rando==3) then diplo_text+="Perhaps circumstances will change but for now I must decline.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="Are you mad? Even if you are not, I suggest you plead insanity when the Inquisition comes for you. It might make your death quicker.";
	            if (rando==2) then diplo_text+="Do not think me your fool whom you can ask to do whatever you wish.";
	            if (rando==3) then diplo_text+="Unlike you, I do only the bidding of the Emperor. I do not agree.";
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        diplo_text="By striking at me, you strike at the entire Imperium! You will live to regret this.";
	    }
	    if (diplo_keyphrase=="declare_war"){
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
			known[diplomacy]=max(2,known[diplomacy]);
	        diplo_text="You have gone too far this time! Lest suspicion fall on me for simply sharing a sector with you, I have no choice but to destroy you.";
        
	        with(obj_star){
				for(var p=1; p<=4; p++){
	                if (planets>=p){
	                    if (p_owner[p]==eFACTION.Player) and (dispo[p]<100) and (planet_feature_bool(p_feature[p], P_features.Monastery)==0){
	                        if (p_first[p]!=eFACTION.Player) then p_owner[p]=p_first[p];
	                        else p_owner[p]=eFACTION.Imperium;
	                        scr_alert("red","blarg","Control of "+string(name)+" "+scr_roman(p)+" lost!",x,y);
	                        scr_event_log("red","Control of "+string(name)+" "+scr_roman(p)+" lost!");
	                    }
	                }
	            }
	        }
	    }
	    if (diplo_keyphrase=="accept_peace"){
	        diplo_text="Perhaps I was hasty in my judgment of you. I will accept peace. For the moment...";
	    }
	    if (diplo_keyphrase=="ignored"){
	        diplo_text="It is customary to offer reports of your progress to your sector's commander. And your sector commander is me and yet I see a disturbing lack of reports.";
	    }
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=5;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Perhaps you could be a little less harsh in your criticisms, friend?";
	            if (rando==2) then diplo_text="I shall have to reexamine myself, if such a loyal soldier says such things of me.";
	            if (rando==3) then diplo_text="Might I suggest you learn the practice of thinking before speaking?";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Words are wind, Astartes.";
	            if (rando==2) then diplo_text="If I took on board the criticisms of everyone in the sector, I'd never get a damn thing done.";
	            if (rando==3) then diplo_text="I care not for your insults, only for the work you do for the Emperor.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Your words are as full of poison as your heart.";
	            if (rando==2) then diplo_text="If you think that your words would go unnoticed, you were wrong.";
	            if (rando==3) then diplo_text="The true soldiers of the Imperium would not speak so of their rightful commanders.";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
			if (faction_justmet==1){
				disposition[diplomacy]+=2;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="You are too kind, friend, for it is you that the people see as their champion.";
	            if (rando==2) then diplo_text="If all Astartes were half as bold as you are courteous, there would be not a single foe left in the galaxy.";
	            if (rando==3) then diplo_text="Few Space Marines are as kind as they are valorous.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Back up your sweet words with bold actions and perhaps you shall find a friend in me.";
	            if (rando==2) then diplo_text="I thank you for the compliment but it does not alter our relation in the slightest.";
	            if (rando==3) then diplo_text="A heretic rarely speaks with such a kind tongue, but this is an unknowable galaxy and stranger things have happened.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="You won't sway me to your cause with poisoned honey.";
	            if (rando==2) then diplo_text="A wicked man speaks wicked lies, but even a stopped chrono is right twice a day.";
	            if (rando==3) then diplo_text="You approval means less to me than your enmity.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="Would a trade such as this be to your satisfaction?";
	        if (rando==2) then diplo_text="I believe this trade would be beneficial to us both.";
	        if (rando==3) then diplo_text="What benefits us both benefits the Imperium. Who better for you to trade with than myself?";
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="Make your proposal, Chapter Master.";
	    if (diplo_keyphrase=="artifact_thanks"){
	        diplo_text="Thank you indeed, Chapter Master. A relic of such magnificence... I thank you more than I can say.";
	    }
	    if (diplo_keyphrase=="artifact_daemon"){
	        diplo_text="Thank you indeed, Chapter Master. A relic of such magnificence... I thank you.  This item is precious to me.";
	    }
	    if (diplo_keyphrase=="stc_thanks"){
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="Such relics are a rare and glorious sight, Chapter Master. I thank you for this boon and trust that you know my gratitude will be expressed in a manner pleasing to you.";
	            if (rando==2) then diplo_text+="You honour me beyond words with this gift. I thank you, as do all under my command and all who will benefit from it.";
	            if (rando==3) then diplo_text+="A mighty gift from a mighty ally, Chapter Master. It will be remembered as one of the many great deeds you have done for this sector.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="Do not think me ungrateful but I am a little suspicious as to what has caused this sudden largesse. Perhaps this gift is not as pure as it seems?";
	            if (rando==2) then diplo_text+="Quite a gift, Chapter Master. I expect that you will want repaying, even if you have not openly stated thus. We shall see...";
	            if (rando==3) then diplo_text+="Were it so simple that I could just take the gift and give you thanks. In these times, there is always a price and always a reckoning.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="Do you think simple gifts will make us firm friends? I think not, you villainous cur! Away with you, though I will keep this gift, if only to deprive you of it.";
	            if (rando==2) then diplo_text+="When a traitor in all but name gives you a gift, one only survives by first checking it for traps and then killing the traitor. And I intend to survive.";
	            if (rando==3) then diplo_text+="Your gifts mean nothing to me, even less than your words do. I will not be swayed by either and will keep my own counsel.";
	        }
	    }
	    if (diplo_keyphrase=="artifact_angry"){
	        // TODO
			diplo_text="How dare you offer us such an artifact!";
	    }
	    if (diplo_keyphrase=="bombard_angry"){
	        diplo_text="For the love of the Emperor, what the hell are you doing? That was an Imperial world you layed waste to!";
	    }
	    if (diplo_keyphrase=="trading_demand"){
	        if (rela=="friendly") then diplo_text=string(obj_ini.master_name)+"?";
	        if (rela=="neutral") then diplo_text="What is the meaning of this?";
	        if (rela=="hostile") then diplo_text="Consider your next words carefully.";
	        diplo_option[1]="Demand Requisition";
			diplo_option[2]="Demand Military Assistance";
			diplo_option[3]="Cancel";
	    }
	    if (string_count("assassination_angryish",diplo_keyphrase)>0){
	        var ta="",tb="",tc="";
	        explode_script(diplo_keyphrase,"|");
	        ta=string(explode[0]);
			tb=string(explode[1]);
			tc=real(explode[2]);
        
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="Several sources indicate that you have killed the Planetary Governor of "+string(tb)+" "+scr_roman(tc)+" and went on to meddle with the succession.  Such subterfuge will not be tolerated, Chapter Master.";
	        if (rando==2) then diplo_text="I have received word that you have killed the Planetary Governor of "+string(tb)+" "+scr_roman(tc)+" and placed a fool in power.  Your attempts to control this sector, and seemingly emulate the Ultramarines, have not gone unnoticed.  Do not think this will go unpunished.";
	        if (rando==3) then diplo_text="What do you think you are doing, Chapter Master?  Killing a Planetary Governor?  Replacing them with one of your tools?  Inquisitor Lord "+string(faction_leader[eFACTION.Inquisition])+" will hear of this madness.";
	    }
	}
	// ** Mechanicus **
	if (diplomacy=3){ 
	    if (diplo_keyphrase=="intro"){
	        rando=choose(1,2);
	        if (rando==1) then diplo_text="[["+string(faction_leader[eFACTION.Mechanicus])+" is a name often spoken of on the factory floor of "+string(obj_ini.sector_name)+"'s forgeworlds, though it cursed as often as it's praised. Sometimes referred to as “The Iron Whip”, "+string(faction_leader[eFACTION.Mechanicus])+" is famed for the high level of efficiency he extracts from those working under him, if not particularly for the quality of their works.]]";
	        if (rando==2) then diplo_text="[[The flesh is weak. "+string(faction_leader[eFACTION.Mechanicus])+" believes in this part of the iron creed above all others, forcing all those under him to mirror his dedication. All meaty parts of his body have been removed, leaving only the most vital parts of his brain. His retinue display their rank by showing how little of their body remains.]]";
	        diplo_text+="###";
	        if (disposition[3]>30) and (disposition[3]<60) then tempd="Greetings. I wish to see you bring the light of civilization to this sector, Chapter Master.";
	        if (disposition[3]<=30) or (scr_has_disadv("Tech-Heresy")) then tempd="You are impure, illogical and irritating. Keep your army of techno barbarians away from my territory.";
	        if (disposition[3]>=60) or (scr_has_adv("Tech-Brothers")) then tempd="Hail, Chapter Master. Were it not a logical fallacy, I would wish you luck in your coming endeavors.";
	        diplo_text+=tempd;
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly") then diplo_text="What can I and my forces do for you, Chapter Master?";
	        if (rela=="neutral") then diplo_text="I will allow you a small portion of my time for an audience, Astartes.";
	        if (rela=="hostile") then diplo_text="Time is a precious resource and I do not wish to spend much of mine on you.";
	    }
	    if (diplo_keyphrase=="trade_close"){
	        if (rela=="friendly") then diplo_text="I trust you have recalculated how your resources can be best utilised and deemed this trade inefficient.";
	        if (rela=="neutral") then diplo_text="I suggest you leaner to calculate a little further into the future, Space Marine. It will be inefficient for you to continue operating in your current fashion.";
	        if (rela=="hostile") then diplo_text="It would be illogical to engage in a trade with one as unreliable as you in any case.";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Were it a logical and efficient use of resources, we would gladly comply but it is not.";
	            if (rando==2) then diplo_text="We express regret that we cannot currently assist you, Chapter Master.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Your request has been considered and found to be lacking in merit.";
	            if (rando==2) then diplo_text="While you make an acceptable case, we decline to enter into this agreement.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="To enter into any agreement with you would be a awful error of judgement.";
	            if (rando==2) then diplo_text="It would be more efficient to discharge a plasma rifle into my own chest cavity. [Simulated Mirth]";
	        }
	    }
	    if (diplo_keyphrase=="agree"){
			if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
			if (trading_artifact!=0) then diplo_text="[[Trade Accepted.]]##";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="Let it be so, and may the Machine God bless this venture.";
	            if (rando==2) then diplo_text+="You made a wise decision in bringing this proposal to me.";
	            if (rando==3) then diplo_text+="Let this agreement strengthen the bounds of our brotherhood.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="Let it be so; it is immaterial in my calculations.";
	            if (rando==2) then diplo_text+="I agree, though it will change little in the grand scheme of the galaxy.";
	            if (rando==3) then diplo_text+="Logic dictates that I agree.  We have an accord.";
	        }
	        if (rela=="hostile"){
	            if (rando=1) then diplo_text+="It is logical to agree with you, but I dislike it.";
	            if (rando=2) then diplo_text+="At least for you, it is lucky that I have little choice.";
	            if (rando=3) then diplo_text+="Probability suggests this endeavor will fail, but I agree.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="I cannot allow favoritism to affect my calculations.  I decline.";
	            if (rando==2) then diplo_text+="Our friendship means fractionally less to me than this bargain. I decline.";
	            if (rando==3) then diplo_text="I have calculated the likely benefits weighed against the risks, and find this venture unsatisfactory.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="I have calculated the likely benefits weighed against the risks, and find this venture unsatisfactory.";
	            if (rando==2) then diplo_text+="My answer is no, for it is the only logical route.";
	            if (rando==3) then diplo_text+="I do not think so, though you may find others who are more willing.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="A ludicrous proposal, illogical and dangerous. Take it somewhere else.";
	            if (rando==2) then diplo_text+="Do you suppose me to be mad? Do you judge me by your own standard? No.";
	            if (rando==3) then diplo_text+="It would be illogical and heretical. Extrapolate your answer from that.";
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        if (rela!="friendly") then diplo_text="Your heretic blasphemy shall not go unpunished.  The Adeptus Mechanicus will destroy without exception all that is your chapter.";
	        if (rela=="friendly") then diplo_text="You have forsaken the Omnissiah's generosity; now you shall face judgment.";
	    }
	    if (diplo_keyphrase=="declare_war"){
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
			known[diplomacy]=max(2,known[diplomacy]);
	        diplo_text="++ CORPUS FINIS+MACHINA MAGNUS+SANCTUS METALLUM+POTESTAS OMNISSIAH+OMNISSIAH VULT+DEATH TO THE ENEMIES OF THE MACHINE GOD ++";
	    }
	    if (diplo_keyphrase=="accept_peace"){
	        diplo_text="We have calculated the price of your destruction and found it excessive.";
	    }
	    if (diplo_keyphrase=="ignored"){
	        diplo_text="What cause do you have, to listen to reason and logic once more?";
	    }
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=5;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Look to your weapons, your armour, and your ships, Chapter Master, and reconsider the logic of your statement.";
	            if (rando==2) then diplo_text="It is illogical and unwise to turn aside the Adeptus Mechanicus' auspices.";
	            if (rando==3) then diplo_text="To speak against us is to speak against the Machine God.";
	        }
	        if (rela!="friendly"){
	            if (rando==1) then diplo_text="The smallest mind strives to comprehend its limits.";
	            if (rando==2) then diplo_text="Your words are illogical and meaningless.";
	            if (rando==3) then diplo_text="Do not waste my time with incongruous statements.";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
	        if (rela=="friendly"){
	            rando=choose(1,2);
	            if (rando==1) then diplo_text="Do not be fictitious, Chapter Master.  What is it you covet?";
	            if (rando==2) then diplo_text="I am unable to be swayed by ingratiating words; the truth of your statement is clear to all.";
	        }
	        if (rela!="friendly"){
	            rando=choose(1,2,3);
	            if (rando==1) then diplo_text="I have better things to do than listen to your praise.";
	            if (rando==2) then diplo_text="Words such as these have no place in my calculations.";
	            if (rando==3) then diplo_text="Do not waste my time.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3,4);
	        if (rando==1) then diplo_text="The Adeptus Mechanicus offers you this.";
	        if (rando==2) then diplo_text="A logical transaction.  What is your answer, Chapter Master?";
	        if (rando==3) then diplo_text="You lack resources; the Adeptus Mechanicus has much at its disposal.";
	        if (rando==4) then diplo_text="Calculations reveal that we shall mutually benefit from this transaction.";
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="...";
	    if (diplo_keyphrase=="artifact"){
	        if (rela!="hostile"){
	            diplo_option[1]="Propose a trade for the Artifact.";
				diplo_option[2]="Leave it be; Exit.";
	            diplo_text="The Adeptus Mechanicus is aware of the Artifact.  Do not concern yourself with that which is rightly within our territory.";
	        }
	        if (rela=="hostile"){
	            force_goodbye=1;
				diplo_text="This Artifact rightly belongs to the Adeptus Mechanicus.  Keep your techno barbarians out of our territory and we shall not be forced to act.";
	        }
	    }
	    if (diplo_keyphrase=="artifact_thanks"){
	        diplo_text="We thank you for your help in retrieving this artifact, though we would doubtless have located it eventually.";
	    }
	    if (diplo_keyphrase=="artifact_angry"){
	        diplo_text="The Mechanicus does not forgive theft and the Mechanicus does not forgive. We will avenge this. We will return and make you pay.";
	    }
	    if (diplo_keyphrase="stc_thanks"){
	        rando=choose(1,2,3,4,5,6);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="I had every confidence that engaging in a mutually beneficial relationship with you would prove a wise move. I had, in non-logical parlance, a 'hunch'.";
	            if (rando==2) then diplo_text="It was the most beneficial action that you could take to inform the Mechanicus of this fragment. I calculated you would take it if ever the opportunity was presented to you.";
	            if (rando==3) then diplo_text="Your cooperation in this matter will not go unappreciated, nor will the servants of the Omnissiah forget your name.";
	            if (rando==4) then diplo_text+="Honoured ally, you have performed your function with incredible efficiency.";
	            if (rando==5) then diplo_text+="+++ Divinitatae Imperator, Dies Optimus Semper +++";
	            if (rando==6) then diplo_text+="A most auspicious gift, Chapter Master, which will not be forgotten.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="We are pleased with your contribution, Astartes. An explorator has been dispatched to receive what is ours- you would do well to ensure the STC sanctity remains intact.";
	            if (rando==2) then diplo_text="It is pleasing that you made the logical choice in this matter.  Our evaluation of you will be adjusted accordingly.";
	            if (rando==3) then diplo_text="You have acted in the interests of the Imperium, giving to us what we can utilize for humanity, now trust our judgment to do the same for you.";
	            if (rando==4) then diplo_text+="This gift is valuable. Your status in relation to the Mechanicus will be reappraised and reassigned.";
	            if (rando==5) then diplo_text+="The origin, purpose, authenticity and quality of this gift will be evaluated before you receive any thanks.";
	            if (rando==6) then diplo_text+="Gratitude is an illogical emotion, do not expect any. Instead, accept that Mechanicus will continue to act as is dictated by logic and the Omnissiah.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Your actions simply prove that you are afraid that the hands of the Machine God are coming for you. Deus Vult.";
	            if (rando==2) then diplo_text="We thank you for the fragment but it has not caused us to forgive or to forget. In the eyes of the Omnissiah, you have been seen to be unworthy.";
	            if (rando==3) then diplo_text="While you have acted like a loyal servant in this case, it does not erase the records of your trespasses.";
	            if (rando==4) then diplo_text+="Query; where did you attain such a technological marvel? Hypothesis; from the lords of chaos. Conclusion; You are an enemy.";
	            if (rando==5) then diplo_text+="The servants of the Omnissiah cannot be bought with trinkets, no matter how valuable, Chapter Master.";
	            if (rando==6) then diplo_text+="Your clumsy attempt to curry favour with us has been seen through and will be recorded as yet another flaw in your character.";
	        }
	    }
	    if (diplo_keyphrase=="bombard_angry"){
	        diplo_text="When you strike at us, you strike the guns from the hands of the soldiers of the God Emperor. This is unacceptable and you have not heard the last of this.";
	    }
	    if (diplo_keyphrase=="trading_demand"){
	        if (rela=="friendly") then diplo_text="Speak, Chapter Master.";
	        if (rela=="neutral") then diplo_text="I am awaiting your query.";
	        if (rela=="hostile"){
	            var randoo=0;
				randoo=floor(random(100))+1;
	            if (randoo==1) then diplo_text="Calculations reveal that depending on your query we may have to beat your ass.";
	            if (randoo!=1) then diplo_text="Certain queries may have to be answered by action.";
	        }
	        diplo_option[1]="Demand Requisition";
			diplo_option[2]="Cancel";
	    }
	}
	// ** Inquisition **
	if (diplomacy==4){
	    if (diplo_keyphrase=="intro"){
	        rando=choose(1,1,2);
	        if (rando==1) then tempd="[[An ancient and well respected Inquistor Lord, "+string(faction_leader[eFACTION.Inquisition])+" has purged heresy and exterminated mutants for well over four centuries. His steely gaze and iron will have broken as many heretics as have the tools of persuasion wielded by his retinue. Were he to die, the Ordo "+choose("Malleus","Xenos","Hereticus")+" would dearly miss his services.]]";
	        if (rando==2) then tempd="[[A thousand heretics have cursed the name of "+string(faction_leader[eFACTION.Inquisition])+" with their last breath but he is still not satisfied. Remorse is as alien to him as pity and he will stop at nothing to destroy the enemies of purity.]]";
	        tempd+="###";
	        if (rela=="friendly") then tempd+="Ave Imperator, Chapter Master. You show great promise and I look forward to seeing you bring the light of the Emperor to "+string(obj_ini.sector_name)+".";
	        if (rela=="neutral") then tempd+="Greetings, space marine. Serve the Emperor in body and soul and you shall have nothing to fear from the Inquisition.";
	        if (rela=="hostile") then tempd+="I hear worrying rumors about your conduct, astartes. I have no doubt we will meet again soon.";
	        diplo_text=tempd;
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly") then diplo_text+="Hail, hero of "+string(obj_ini.sector_name)+".  How may I assist you this day?";
	        if (rela=="neutral") then diplo_text+="Praise be to the Emperor.  What is your business here?";
	        if (rela=="hostile") then diplo_text+="State your business, for many heretics pray the Emperor's mercy.";
	    }
	    if (diplo_keyphrase=="trade_close"){
	        if (rela=="friendly") then diplo_text="There are few people I would allow to back out of a deal in such a way, Chapter Master.  Think of this as a symbol of my friendship.";
	        if (rela=="neutral") then diplo_text="I have work to do Space Marine, much of it implements of torture and stubborn heretics, please make sure you are ready to commit to a deal when you interrupt my labours next time.";
	        if (rela=="hostile") then diplo_text="Do not delude yourself in thinking I was truly going to trade with you. Much of my interest was a ruse.";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Only a true friend would be given such a courteous message as this; the Inquisition does not agree and does not take kindly to such requests.";
	            if (rando==2) then diplo_text="I don't believe I will accept this request, Chapter Master, but do not let it dishearten you.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Do not attempt to sway the mind of an Inquisitor, Chapter Master, it cannot be done.";
	            if (rando==2) then diplo_text="While your request is not without merit, I think not.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Idleness and greed are the signs of a heretic, Chapter Master.";
	            if (rando==2) then diplo_text="Do not presume, Chapter Master, for you too will be judged by the Inquisition.";
	        }
	    }
	    if (string_count("agree",diplo_keyphrase)>0){
			if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
			if (trading_artifact!=0) or (liscensing>0) then diplo_text="[[Trade Accepted.]]##";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="An interesting proposal.  I look forward to the fruition of this deal.";
	            if (rando==2) then diplo_text+="Agreed, may the Emperor bless us both.";
	            if (rando==3) then diplo_text+="Exactly what I wished for; this will benefit us both.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="Then we are in agreement.";
	            if (rando==2) then diplo_text+="Let it be so then and may it benefit us both.";
	            if (rando==3) then diplo_text+="This arrangement will be mutually beneficial.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="It goes against my instincts, but you have a deal.";
	            if (rando==2) then diplo_text+="I believe we shall both come to regret this, but I agree.";
	            if (rando==3) then diplo_text+="Try and play me for a fool and you will be destroyed, but I agree.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
			annoyed[diplomacy]+=2;
	        if (rela=="friendly") and (annoyed[diplomacy]>=8){
				diplo_text+="I cannot help you at this time and advise that you cease pressing the matter.";
				force_goodbye=1;
	        	turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;diplo_alpha=0;
				exit;
			}
	        if (rela=="neutral") and (annoyed[diplomacy]>=6){
				diplo_text+="You are testing my patience, astartes.";
				force_goodbye=1;
				disposition[diplomacy]-=2;
	        	turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;
				diplo_alpha=0;exit;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="I apologize but my resources must be directed in a different direction.";
	            if (rando==2) then diplo_text+="It pains me to deny you but I fear I must.";
	            if (rando==3) then diplo_text+="Unfortunately, I and my forces have a prior engagement.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="I do not believe this will help either of us.";
	            if (rando==2) then diplo_text+="Tempting... but no, I must decline.";
	            if (rando==3) then diplo_text+="Perhaps circumstances will change but for now I must decline.";
	        }
	        if (rela=="hostile"){
				disposition[diplomacy]-=2;
				force_goodbye=1;
				turns_ignored[diplomacy]=max(turns_ignored[diplomacy],3);
	            if (rando==1) then diplo_text+="Not even when the gates of the immaterium have closed, heretic!";
	            if (rando==2) then diplo_text+="Heresy leaks from your every word. I would rather burn than agree.";
	            if (rando==3) then diplo_text+="You have either mistaken me for a fool or wish to offend me. Look to your sins, heretic.";
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        diplo_text="You shall pay dearly for this, as shall your entire chapter. So swears "+string(faction_leader[eFACTION.Inquisition])+"!";
	    }
	    if (diplo_keyphrase=="declare_war") and (sorc=false){force_goodbye=1;turns_ignored[diplomacy]+=4;
	        diplo_text="You have stepped far beyond the acceptable conduct for an Astartes.  Look to your sins and prepare to face the Emperor's judgment.";
	    }
	    if (diplo_keyphrase=="accept_peace"){
	        diplo_text="For now, your judgement shall be postponed. Thank the Emperor for your respite, or perhaps whatever dark gods you now worship would be more appropriate.";
	    }
	    if (diplo_keyphrase=="ignored"){
	        diplo_text="Idleness breeds heresy, marine, and I hear that you have been greatly idle of late.";
	    }
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=15;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
				disposition[diplomacy]-=choose(0,1);
	            if (rando==1) then diplo_text="Words are wind and mean nothing between two servants of the Emperor's eternal glory.";
	            if (rando==2) then diplo_text="Your deeds speak far louder than the words that issue from your mouth, and they speak of heroism and loyalty.";
	            if (rando==3) then diplo_text="An ego is nothing more than a tool for the darkness to use against a servant of the Emperor. Say what you will of me.";
	        }
	        if (rela=="neutral"){
				disposition[diplomacy]-=2;
				force_goodbye=1;
	            if (rando==1) then diplo_text="I cannot agree with what you have said, but perhaps you have your reasons. I hope they are good ones.";
	            if (rando==2) then diplo_text="I will remember what you said today and you will be held accountable.";
	            if (rando==3) then diplo_text="In the future, I ask that you consider what you are saying before you say it.";
	        }
	        if (rela=="hostile"){
				disposition[diplomacy]-=4;
				force_goodbye=1;
	            if (rando==1) then diplo_text="You dare besmirch the honour of the Inquisition!? You have crossed a line this day!";
	            if (rando==2) then diplo_text="The mouths of heretics are ever full of lies and filth.";
	            if (rando==3) then diplo_text="When you stand before the Emperor in death, He will remind you of what you said today.";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
			if (faction_justmet==1){
				disposition[diplomacy]+=2;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="You flatter me, but it would be churlish to deny the truth in your words.";
	            if (rando==2) then diplo_text="You speak only the truth, noble Astartes, as is befitting of one of the Emperor's sons.";
	            if (rando==3) then diplo_text="Thanks are owed for your kind words and I cannot deny they are accurate.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="I will remember those words, but they will not stay my blade if your actions call for it to fall.";
	            if (rando==2) then diplo_text="If only I could believe your actions were as pure as your words.";
	            if (rando==3) then diplo_text="I thank you for the compliment but it will not turn my course.";
	        }
	        if (rela=="hostile"){
				disposition[diplomacy]-=1;
				force_goodbye=1;
	            if (rando==1) then diplo_text="If you think kissing my boots will make me overlook your crimes you are sorely mistaken.";
	            if (rando==2) then diplo_text="For a true servant of mankind's Emperor, compliments mean nothing. Only vindication in serving him brings us satisfaction.";
	            if (rando==3) then diplo_text="Take your liar's, heretic tongue elsewhere, lest I cut it out and roast it on an open fire.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="I believe we would both benefit greatly from an exchange.";
	        if (rando==2) then diplo_text="A trade of goods and services would be most useful at this time.";
	        if (rando==3) then diplo_text="Do you wish to trade with me for some of the resources in my possession?";
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="Make me an offer and I shall consider it, both for its value and its potential heresy.";
	    if (diplo_keyphrase=="artifact"){
	        diplo_option[1]="Propose a trade for the Artifact.";
			diplo_option[2]="Leave it be; Exit.";
	        diplo_text="The Inquisition is, of course, aware of the artifact in question. What, precisely, are you offering for it?";
	    }
	    if (diplo_keyphrase=="artifact_thanks"){
	        diplo_text="You have earned the gratitude of the Inquisition, my friend, and you shall be rewarded. This artifact will serve as a reminder of my debt to you.";
	    }
	    if (diplo_keyphrase=="stc_thanks"){
	        rando=choose(1,2,3);
	        if (rela="friendly"){
	            if (rando==1) then diplo_text+="A treasured relic of the Imperium’s glorious past? You do us great honour, Chapter Master.";
	            if (rando==2) then diplo_text+="As wise as you are fearsome, you choose to place this sacred relic in the care of the Inquisition. We thank you.";
	            if (rando==3) then diplo_text+="Your decision shows you to be a skilful leader, Chapter Master, for only the Inquisition can be trusted with such a hallowed relic.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="It is just that you choose to entrusts such a precious relic to the Inquisition, mankind’s most stalwart defenders in this dark age.";
	            if (rando==2) then diplo_text+="Such artifacts may provide a return to the Golden age of Mankind and the Inquisition are the best candidates to guide us there. Wise decision, Space Marine.";
	            if (rando==3) then diplo_text+="While you smite the Heretic and the Xenos, the Inquisition will will bring light to the sector with this artifact.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="You think that the Inquisition forgive slights simply because you hand us gifts? You are wrong, we take it to remove it from your heretical grasp.";
	            if (rando==2) then diplo_text+="And where did you acquire such an artefact? From your daemonical accomplices? This device bares careful consideration.";
	            if (rando==3) then diplo_text+="A relic owned by a being such as you cannot be taken at face value, much like the honeyed words of a serpent. We are watching you, Astartes.";
	        }
	    }
	    if (diplo_keyphrase=="artifact_daemon"){
	        if (rela=="friendly") then diplo_text="There are few Astartes who have the wisdom and the humility to recognise when their own abilities are not suited to the task in hand. You are one Marine in a thousand, my friend. The Inquisition shall not forget your humble service to the Emperor.";
	        if (rela=="neutral") then diplo_text="The Inquisition will guard this artifact well, I swear it. Only when it has been assured that the foul daemon contained within has no chance of escape will it be used against the Emperor's enemies. Well done, Astartes, you have done the right thing.";
	        if (rela=="hostile") then diplo_text="Only the truest, most noble and most incorruptible servants of the Emperor can be trusted with such an artifact. None but the Inquisition have the immutable will to wield such things. Despite the mistakes you have made in the past, it is good that you have recognised our superiority. Perhaps there is hope for you still, but I doubt it.";
	    }
	    if (diplo_keyphrase=="artifact_returned"){
			scr_quest(3,"artifact_return",4,0);
	        diplo_text="It is well that you have returned the artifact, late though it may be.";
	        if (rela=="friendly") then diplo_text+="  Do not let this happen again.";
	        if (rela!="friendly") then diplo_text+="  Our faith was still poorly placed- if you fail another task there will be dire consequences for your chapter.  Is this understood?";
	    }
	    if (diplo_keyphrase=="artifact_angry"){
	        diplo_text="No man, no woman, no marine, no heretic and no piece of xenos scum steals from the Inquisition and escapes unmarked. There will be a reckoning.";
	    }
	    if (diplo_keyphrase=="gene_trade"){
			rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Chapter Master, even a hero of the Imperium like yourself must abide by the rules of the great Codex Astartes. Please desist in the trading of Gene-seed immediately.";
	            if (rando==2) then diplo_text="As loathe as I am to reprimand you, I must demand that you cease trading away the genetic material of your chapter.";
	            if (rando==3) then diplo_text="Normally, I would leave the running of your chapter in your very capable hands. But the trading of your Gene-seed must stop and I will not be moved on this.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Even Astartes are held to the rule of Law. And those laws decree that Gene-seed is to remain within the Chapter of its origin.";
	            if (rando==2) then diplo_text="No matter what was offered, a true Astartes does not barter away what is both their birthright and their future.  The trading of your Gene-seed must stop.";
	            if (rando==3) then diplo_text="The Imperium allows Chapter Masters free hands in most of their dealings, but on the trading of Gene-seed we must shackle you, firmly and completely.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="You look like a heretic, sound like a heretic and act like a heretic, for only a heretic would place such little store on their own Gene-seed. Prove I am mistaken or there will be dire consequences.";
	            if (rando==2) then diplo_text="By Holy Terra, I need but one more reason to wipe the stain of your existence from the universe and if you do not cease trading in Genetic material, I will have it.";
	            if (rando==3) then diplo_text="When you choose to act outside the rule of Law and trade in forbidden substances, the Inquisition will either bring you back to the Law or bring the Law to you.";
	        }
	        gene_sold=0;
	        // diplo_text="[Missing Dialogue: gene_angry]";
	    }
	    if (diplo_keyphrase=="gene_xeno"){
	        rando=choose(1,2,3);// diplo_text="[Missing Dialogue: gene_xeno]";
	        if (rando==1) then diplo_text="You risk the sanctitude of the Emperor's holy sons, the Adeptus Astartes, and for what? Some paltry material reward? You will reap the seeds you have sown, traitor.";
	        if (rando==2) then diplo_text="No matter your past deeds, you are now an enemy of the Imperium. Only an enemy would give away our most valued secret, the base of the Astartes themselves.";
	        if (rando==3) then diplo_text="You have handed away the root of the Imperium's most powerful warriors to foul xenos. Did you truly believe a crime of this magnitude would escape the eye of the Imperium?";
	        faction_status[diplomacy]="War";
			var lol="";
	        lol=string(obj_controller.faction_title[diplomacy])+" "+string(obj_controller.faction_leader[diplomacy])+" declares war on the "+string(global.chapter_name)+".";
	        scr_event_log("red",lol);
			force_goodbye=1;
			gene_xeno=0;
	    }
	    if (diplo_keyphrase=="trading_demand"){
	        if (rela=="friendly") then diplo_text="Remember whom you speak to, Chapter Master.";
	        if (rela=="neutral") then diplo_text="I, Inquisitor Lord "+string(faction_leader[eFACTION.Inquisition])+", on behalf of the Inquisition, am awaiting your words.";
	        if (rela=="hostile") then diplo_text="Speak your next words very carefully, Astartes, for they may be your last.";
	        diplo_option[1]="Demand Requisition";
			diplo_option[2]="Skip Inspection";
			diplo_option[3]="Cancel";
	        if (inspection_passes>0) then diplo_option[2]="Skip Inspection ("+string(inspection_passes)+" pass)";
	    }
	    if (diplo_keyphrase=="penitent_end"){
	        rando=choose(1,2);
	        if (rando==1) then diplo_text="It seems that congratulations are in order. While some might think the Inquisition blind to the possibility that it, that is to say we, could ever do wrong, it is not so. I know that we are as fallible as any man, save the Emperor, and can make mistakes when judging character. I took you for a traitor to humanity's cause. I see that I was wrong now and let it not be said I will not give credit where it is due; well done, Chapter Master. May the enemies of mankind speak your name in fear and humanity in adoration.";
	        if (rando==2) then diplo_text="Few return from a penitent crusade, Chapter Master, and I find that those who do are invariably changed by the experience. Tell me, do you feel your vision expanded? Your faults exposed and then erased by his glorious light? I do not doubt that you do. To battle the Emperor's enemies without any thought of pause or relief is the highest form of honour, the highest form of service. You are to be congratulated on your diligence and dedication, not to mention your skill at arms.";
	    }
	    if (string_count("assassination_angry",diplo_keyphrase)>0){
	        // aa|planet_name|planet number|
	        var ta="",tb="",tc="";
	        explode_script(diplo_keyphrase,"|");
	        ta=string(explode[0]);
			tb=string(explode[1]);
			tc=real(explode[2]);
	        obj_controller.temp[1008]=string(tb)+"|"+string(tc)+"|";
        
	        diplo_text="My patience is wearing thin, Chapter Master.  I have many more problems more urgent and, yet, you continue to force me away from the work assigned to me by He on Terra.  Your serf on "+string(tb)+" "+scr_roman(tc)+" will be executed along with all the other puppets I ferret out.  You are close to treason, Chapter Master.  Choose your next words with exceptional care for they may be your last.";
        
	        diplo_option[1]="It will not happen again";
	        diplo_option[2]="Very well";
	        diplo_option[3]="You will not.  "+string(tb)+" is MINE!";
	    }
	    if (diplo_keyphrase=="you_better"){
	        rando=choose(1,2);
	        if (rando==1) then diplo_text="I do not know if you are guided by choice or incompetence, Chapter Master, however you are not the only player in this most dangerous game you insist upon pursuing.  There is no more room for failure.";
	        if (rando==2) then diplo_text="Ensure this is your last mistake, Chapter Master.  You and your ivory tower you think stand so tall above man is not indestructible.";
	    }
	    if (diplo_keyphrase=="die_heretic"){
	        rando=choose(1,1,2);
	        if (rando==1) then diplo_text="Very well, Chapter Master.  I will bury you and your Chapter so thoroughly even I will forget your existence.";
	        if (rando==2){
	            if (obj_ini.fleet_type==ePlayerBase.home_world) then diplo_text="I understand.  I am authorizing the deployment of cyclonic torpedoes.  Make peace with your homeworld, Chapter Master.";
	            if (obj_ini.fleet_type != ePlayerBase.home_world) then diplo_text="I am mobilizing the Segmentum battlefleet.  You may run, heretic, but it will do you no good.";
	        }
	        var ev=0;
			for(var v=1; v<=99; v++){if (ev=0) and (event[v]="") then ev=v;}
	        event[ev]="game_over_man";
			event_duration[ev]=1;
	    }
	    rando=choose(1,2,3);
	    if (diplo_keyphrase=="chaos_audience1"){
			force_goodbye=1;
	        if (rando==1) then diplo_text="I have been notified of your corrospondences with "+string(faction_leader[eFACTION.Chaos])+".  There is no reason for you to talk to such a villain, your only interactions should be both short lived and extremely violent.";
	        if (rando==2) then diplo_text="Whatever your reasons for seeking an audience with traitors, they can not be sufficient and I trust you will not repeat your mistake.";
	        if (rando==3) then diplo_text="The words of those who have turned from His light are not worth risking the sanctity of your soul to listen to.";
	    }
	    if (diplo_keyphrase=="chaos_audience2"){
			force_goodbye=1;
	        if (rando==1) then diplo_text="If you give aid to or converse with a heretic or a traitor, you're either a heretic or a traitor. Either way, consider yourself under close scrutiny, Chapter Master.";
	        if (rando==2) then diplo_text="The only people who have any desire to hear the poison that spews from the lips of heretics are other heretics. You have been warned.";
	        if (rando==3) then diplo_text="I can only conclude that you have no conception of how despicable your actions are because you have lost all feeling for how heretical it is to converse with a heretic.";
	    }
	    if (diplo_keyphrase=="sorcery1"){
			force_goodbye=1;
	        if (rando==1) then diplo_text="It pains me to see an Astartes debase his chapter by using the tools of a heretic, especially when you have access to sanctioned psyker powers.  Ensure that it does not happen again.";
	        if (rando==2) then diplo_text="The use of magik and sorcery in place of those powers deemed acceptable by the Imperium is simply not acceptable, Chapter Master.  You have been warned.";
	        if (rando==3) then diplo_text="Please desist from wielding the same weapons as heretics, traitors and chaos filth, lest you become one of them.";
	    }
	    if (diplo_keyphrase=="sorcery2") or (sorc==true){
	        rando=choose(1,1,2,2,2,3,3,3);
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
	        if (rando==1) then diplo_text="Did you not think that the Inquisition might notice the use of sorcerous and heretical powers? You are either foolish beyond belief or wish for your own destruction.";
	        if (rando==2) then diplo_text="To wield such heretical powers in the face of an Inquisitorial inspection speaks of a traitorous streak so deep it can only be purged with fire.";
	        if (rando==3) then diplo_text="You wield the weapons of a traitor, probably gifted to you by a daemonic ally, and you will be dealt with as a traitor; you will be purged.";
	    }
	    if (diplo_keyphrase=="loyalty_zero"){
	        disposition[2]-=20;
			disposition[3]-=15;
			disposition[4]-=20;
			disposition[5]-=20;
	        diplo_text="Your arrogant, blatant disregard for proper Imperial conduct can no longer go unanswered, Astartes.  Time and time again you have ignored the Imperium's call to arms, refusing to strike out at the enemies of man when it was most needed, and callously ignored the Inquisition's wants.  It has become clear that you are not in line with the High Lords of Terra and His will.  This heresy must be cut from your Chapter like the festering blight it is.  You may either atone for your Chapter's crimes, in penitence, or see it ground to dust around you.";
	        // Speak your next words carefully, Chapter Master, for they may damn all the souls of your men to oblivion.
        
	        diplo_option[1]="You are right in that we must account for our sins.  Let our Penitence begin.";
			diplo_goto[1]="loyalty_penitence";
	        diplo_option[2]="I answer only to the Emperor himself, not to the likes of you.";
			diplo_goto[2]="die_heretic";
	        diplo_option[3]="Threaten my Chapter at your own peril.";
			diplo_goto[3]="die_heretic";
	    }
	    if (diplo_keyphrase=="loyalty_penitence"){
	        diplo_text="Brothers, hear my words! It is time to embark on a sacred journey of redemption, a penitence crusade to cleanse our souls. Our past wrongdoings have led us astray form the Emperor, but through unwavering determination and righteous deeds, we shall forge a path to absolution. With every battle fought, every sacrifice made, we shall restore honor to our name and rekindle the flame of righteousness within. ";
        
	        var tx="The "+string(global.chapter_name)+" become Penitent.";
	        scr_alert("green","halp",string(tx),0,0);
			scr_event_log("",string(tx));
        
	        var str=round((marines+command)/130);
	        obj_ini.penitent=1;
			obj_ini.penitent_current=0;
	        obj_ini.penitent_max=(str*1000)+300;
			obj_ini.penitent_end=str*48;
	        obj_controller.penitent=1;
			obj_controller.penitent_current=0;
	        obj_controller.penitent_max=obj_ini.penitent_max;
	        obj_controller.penitent_end=obj_ini.penitent_end;
        
	        loyalty=50;
			loyalty_hidden=50;
			force_goodbye=1;
	    }
	}
	// ** Ecclesiarchy **
	if (diplomacy==5){
	    if (diplo_keyphrase=="intro"){
	        rando=choose(1,2);
	        if (rando==1) then tempd="[[Old and experienced, this Prioress of the Sisters of Battle is not a woman to be trifled with.  Clad in an elaborate set of full power armour and with her face sporting several scars, "+string(faction_leader[eFACTION.Ecclesiarchy])+" exudes battlefield experience.]]";
	        if (rando==2) then tempd="[[The Ecclesiarchy have assigned one of their militant arm to their dealings with you- Prioress "+string(faction_leader[eFACTION.Ecclesiarchy])+".  The woman wears a set of well-used powered armour that has seen many battles, if its charred exterior is to be believed.  Incense burners hang from chains on her belt and waft smoke around her body.]]";
	        tempd+="###";
	        rando=choose(1,1,2,2,2);
	        if (rando==1) then tempd+="Hail, Chapter Master!  As a son of the Emperor, you will no doubt take great joy in bringing his light to this benighted sector.  I look forward to watching heretics fall before your armies."; 
	        if (rando==2) then tempd+="And the Emperor spoke; “You shall know my servants by the eagle they bear, so the people of old Terra did know the eagle as the symbol of enlightenment and freedom.”  Fitting that we, the instruments of His will, still bear the eagle?  May the Emperor's gaze be upon you, Space Marine."; 
	        diplo_text=tempd;
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly") then diplo_text="Hail, hero of "+string(obj_ini.sector_name)+", how may I assist you this day?";
	        if (rela=="neutral") then diplo_text="Praise be to the Emperor. What is your business here?";
	        if (rela=="hostile") then diplo_text="State your business, for many heretics pray the Emperor's mercy.";
	    }
	    if (diplo_keyphrase=="trade_close"){
	        if (rela=="friendly") then diplo_text="Ave Imperator, Chapter Master. No doubt an unslain Xenos calls for your blade.";
	        if (rela=="neutral") then diplo_text="I hope there is a good reason for this affront, Chapter Master, for it is never wise to slight the Emperor's truest servants.";
	        if (rela=="hostile") then diplo_text="While it is immaterial whether the Ecclesiarchy needed those supplies, it is a sign of disrespect for you to act thus. When you slight us, you slight the Emperor, Chapter Master.";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="It is not to be, Chapter Master, as much as we wish it otherwise.";
	            if (rando==2) then diplo_text="I do not believe we can fulfil your request. Ask the Emperor for guidance and perhaps he will see fit to deliver.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Unless we receive a sign from the Lords of Terra to the contrary, we cannot comply with your request.";
	            if (rando==2) then diplo_text="It is not something that we can condone or agree with.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Flee back to the darkness, heretic. You will have nothing from us.";
	            if (rando==2) then diplo_text="While we will not fulfill your request, perhaps your warp spawned allies will, heretic scum?";
	        }
	    }
	    if (diplo_keyphrase=="agree"){
			if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
			if (trading_artifact!=0) then diplo_text="[[Trade Accepted.]]##";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="Let it be so.";
	            if (rando==2) then diplo_text+="You need but ask, Chapter Master, and your commands will be fulfilled.";
	            if (rando==3) then diplo_text+="As you command, son of the Emperor.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="It shall be done.";
	            if (rando==2) then diplo_text+="I agree, and may the Emperor look favorably upon this venture.";
	            if (rando==3) then diplo_text+="Doubt is anathema to a true servant of the Emperor, but still... I have little choice but to agree.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="It will take some time in penitence to erase the crime of this action, but I agree.";
	            if (rando==2) then diplo_text+="Circumstances force me to agree.";
	            if (rando==3) then diplo_text+="Had I any other option, you would be burning in purifying flame at this moment... but I do not. I am with you.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        annoyed[diplomacy]+=2;
	        if (rela=="neutral") and (annoyed[diplomacy]>=8){
				diplo_text+="I cannot agree to this, Chapter Master, no matter how stubborn you may be.";
				force_goodbye=1;
	        	turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;
				diplo_alpha=0;
				exit;
			}        
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="I am sorry Chapter Master but I cannot help you.";
	            if (rando==2) then diplo_text+="Perhaps another Imperial faction can assist you, but I am unable to.";
	            if (rando==3) then diplo_text+="My hands are tied in this matter, my Lord, else I would rush to your aide.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="I cannot agree.";
	            if (rando==2) then diplo_text+="My sisters and I are unwilling to join you in this course of action.";
	            if (rando==3) then diplo_text+="It would not be fitting for my order to join you.";
	        }
	        if (rela=="hostile"){
				force_goodbye=choose(0,1);
	            if (rando==1) then diplo_text+="I would rather die, heretic.  You have turned from His light and will pay the price!";
	            if (rando==2) then diplo_text+="When I made my vows to the Emperor, I made them for life, unlike you.  Take your deal and burn with it.";
	            if (rando==3) then diplo_text+="Your attempt to draw me away from the light are as clumsy as an ork's handwriting!  I say thee nay!";
	            if (annoyed[diplomacy]>=4){
					turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);
					diplo_last=string(diplo_keyphrase);
					diplo_char=0;
					diplo_alpha=0;
				}
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        diplo_text="You pile infamy on sin, traitorous dog.  I will be happy to wipe the stain of your existence from the galaxy.";
	    }
	    if (diplo_keyphrase=="declare_war"){force_goodbye=1;turns_ignored[diplomacy]+=4;known[diplomacy]=max(2,known[diplomacy]);
	        diplo_text="There is a price for all things and the accounting is now.  Know that you reap only what you have sown.";
	    }
	    if (diplo_keyphrase=="accept_peace"){
	        diplo_text="It leaves a bitter taste in my mouth, but you may go in peace.  I will be watching you from now on, however.";
	    }
	    if (diplo_keyphrase=="ignored"){
	        diplo_text="Human we may be, but the Adepta Sororitas are second in loyalty only to the astartes themselves.  Why do you ignore us so?";
	    }
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=5;
				faction_justmet=0;
			}
	        scr_loyalty("Irreverance for His Servants","+");
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="I'm sure you have your reasons for saying such things, my lord.";
	            if (rando==2) then diplo_text="Ha, your words would wound me if I thought you were any less loyal to the Emperor.";
	            if (rando==3) then diplo_text="Lucky for you I don't take offense easily.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="You are wrong and I will show you this.";
	            if (rando==2) then diplo_text="I couldn't give less of a damn for your words.";
	            if (rando==3) then diplo_text="I don't care what you think, only what you do.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Send your poison elsewhere; it is actions and not words that make a man.";
	            if (rando==2) then diplo_text="So men act well but speak lies, some speak beautiful truths but act like common criminals.  But you manage to get the worst of both worlds.  It is almost impressive.";
	            if (rando==3) then diplo_text="When my flame sends you to your dark gods, it will be too late for such words.";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
	        if (faction_justmet==1){
	            disposition[diplomacy]+=3;
				faction_justmet=0;
	            var o=0;
				if (scr_has_adv("Reverent Guardians")) {
					o=500;
				}
				if (o>100) then obj_controller.disposition[5]+=2;
	        }
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Thank you, Chapter Master.  That means a lot from a warrior such as you.";
	            if (rando==2) then diplo_text="Your words raise my spirits, comrade. I hope to see you on the battlefield soon..";
	            if (rando==3) then diplo_text="Apply your mind to defeating the Emperor's enemies, not thinking up clever compliments to pile at my feet.  Unless you feel you can do both?";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="We thank you, but will not let words alter our disposition.";
	            if (rando==2) then diplo_text="The only praise that matters is the praise we give to the Emperor.";
	            if (rando==3) then diplo_text="Venerate the Emperor with the same enthusiasm and He may look kindly upon you.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Your words will not stall my forces.";
	            if (rando==2) then diplo_text="Compliments will not put out the cleansing flame I will bathe you in.";
	            if (rando==3) then diplo_text="Save your breath for prayers of forgiveness, for I will destroy you.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="Is this trade acceptable to you?";
	        if (rando==2) then diplo_text="The Emperor, hallowed be His name, would doubtless endorse this trade.";
	        if (rando==3) then diplo_text="Ask yourself; would a true son of the Emperor turn down this trade?";
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="Make me an offer, Space Marine, and I will pray for the guidance to respond.";
	    if (diplo_keyphrase=="artifact"){
	        diplo_option[1]="Propose a trade for the Artifact.";
			diplo_option[2]="Leave it be; Exit.";
	        diplo_text="You have done a service to us by making us aware of this artifact. It is a little amusing that is was under our noses this whole time, though now I am sure it can be retrieved.";
	    }
	    if (diplo_keyphrase=="artifact_thanks"){
	        diplo_text="You are a true servant of the Emperor! This artifact, while it might be of great value to others, shall forever be a symbol of our friendship.";
	    }
	    if (diplo_keyphrase=="artifact_daemon"){
	        if (rela=="friendly") then obj_controller.disposition[5]-=2;
	        if (rela=="neutral") then obj_controller.disposition[5]-=6;
	        if (rela=="hostile"){obj_controller.disposition[5]-=10;
			if (obj_controller.faction_status[eFACTION.Ecclesiarchy]=="Allied") then obj_controller.faction_status[eFACTION.Ecclesiarchy]="Antagonism";}
	        if (rela=="friendly") then diplo_text=" I am sure it was not your intention, Chapter Master, but to give a daemonic artifact to the Ecclesiarchy is a great insult. Only the Inquisition has been given leave to wield such things, and few among our number agree with the practice. You will be forgiven this time, but do not let it happen again.";
	        if (rela=="neutral") then diplo_text="It is possible that you did not know of the presence of the daemon within this artifact, but ignorance is no excuse. Maybe you are simply too corrupt to notice the heretical whispers and temptations that the item exudes. I will pray for your soul, or cleanse it with holy fire.";
	        if (rela=="hostile") then diplo_text="Heretic! You dare to hand us, the Emperor's most devout followers, a artifact tainted by the presence of a monstrous daemon!? Beneath the facade of an Astartes, you are the very embodiment of servant of chaos! We will not forget this.";
	    }
	    if (diplo_keyphrase=="artifact_angry"){
	        diplo_text="How dare you strike at us, the truest and most devoted servants of the Emperor!? That artifact was on our territory! You had no right and you shall pay in blood for your actions!";
	    }
	    if (diplo_keyphrase=="stc_thanks"){
	        diplo_text="On behalf of Imperium, I extend our deepest gratitude to "+string(global.chapter_name)+" for the invaluable gift given to us.";
	    }
	    if (diplo_keyphrase=="trading_demand"){
	        if (rela=="friendly") then diplo_text=string(obj_ini.master_name)+"?";
	        if (rela=="neutral") then diplo_text="What is the meaning of this?";
	        if (rela=="hostile") then diplo_text="“The Heretic and Blasphemer can offer no excuse for their crimes. Those who are pardoned merely live to further shroud Humanity from the Light of the Emperor with the Darkness of their souls.”";
	        diplo_option[1]="Demand Requisition";
			diplo_option[2]="Cancel";
	    }
	    if (diplo_keyphrase=="penitent_end"){
	        rando=choose(1,2);
	        if (rando==1) then diplo_text="Yours is the glory, Chapter Master. I admit that I did not expect you to survive this ordeal, having wronged the name of the Emperor as you have. It seems, in his wisdom, that he has chosen to spare you for greater things. That you marched through the fires of war and return practically unscathed... it is all the proof I need of your favour with the God Emperor. Take his word to the heretic, the mutant and the Xenos, Astartes. You have once more earned that right.";
	        if (rando==2) then diplo_text="Penitent crusades are a cathartic experience, are they not? To bathe oneself in the blood of The Imperium's foes, until one's faults are washed away. To let oneself forget restraint and self control, to simply revel in the joy of spilling heretical, Xenos blood. Make no mistake, I envy you. It is a long time since I had not thought but of the next kill to fall under my blade. Congratulations on not losing yourself, however. Few return from penitent crusades with as much of their minds in tact as you seem to have.";
	    }
	}
	// ** Eldar **
	if (diplomacy=6){
	    if (string_count("intro",diplo_keyphrase)>0){
	        if (faction_gender[6]==1) then diplo_text="[["+string(faction_leader[diplomacy])+" is a farseer, or witch, of the eldar.  He is dressed in a typical fashion of his position, clad in flowing black cloth and bone-like armour.  Almost seeming to relish in conflict, this xeno is known in local records for "+choose("sudden raid on trade vessels","assassinating a pair of planetary govererners")+".  It is unlikely "+string(faction_leader[diplomacy])+" will be receptive to diplomacy- further audiences are ill-advised.]]";
	        if (faction_gender[6]==2){
	            rando=choose(1,2,3);
	            diplo_text="[["+string(faction_leader[diplomacy])+" is a witch; an old farseer of eldar kind.  While obviously a female, the grating voice and inhuman proportions are an unholy mockery of the human form.  She seems to avoid contact with the Imperium, as is befitting a xeno.  Little is known about "+string(faction_leader[diplomacy])+", other than ";
	            if (rando==1) then diplo_text+="random1.";
	            if (rando==2) then diplo_text+="random2.";
	            if (rando==3){
					diplo_text+="rumors of her involvement at the massacre of ";
					diplo_text+=global.name_generator.generate_star_name();
					diplo_text+=" "+choose("I.","II.","III.","IV.");
				}
	            diplo_text+="  Do not expect futher contact.]]";
	        }
	        diplo_text+="###";
			// * Normal craftworld reveal *
	        if (string_count("1",diplo_keyphrase)>0){
				if (scr_has_adv("Enemy: Eldar")){
					diplo_text+="This is our home, Mon'keigh.  Leave it in peace or feel the full wrath of Kaela Mensha Khaine.";
				} else {
					if (scr_has_disadv("Tolerant")){
						diplo_text+="Your future is clouded, human.  Will you be a tool, or a thorn in our side?";
					} else {
						diplo_text+="Another repulsive Mon'keigh.  Leave the Eldar alone, primitive.  You have no idea what you face.";
					}
				}
	        }
			// * Running into eldar ships *
	        if (string_count("2",diplo_keyphrase)>0){
	            if (scr_has_disadv("Tolerant")) and (!scr_has_adv("Enemy: Eldar")){
					diplo_text+="This meeting is long since due.  I pray that you pull back your forces, "+string(obj_ini.master_name)+".  None of this concerns you.";
				} else {
					diplo_text+="You do not understand that which you trifle with.  Leave or be eradicated.";
				}
	        }
			// * Request audience *
	        if (diplo_keyphrase=="intro"){
				if (scr_has_adv("Enemy: Eldar")){
					diplo_text+="Another repulsive Mon'keigh.  Leave the Eldar alone, primitive, you have no idea what you face.";
				} else {
					if (scr_has_disadv("Tolerant")) {
						diplo_text+="We have been expecting you, "+string(obj_ini.master_name)+".";
					} else {
						diplo_text+="The skeins have foretold of our meeting, Space Marine.";
					}
				}
	        }
	        diplo_text+=tempd;
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly") then diplo_text=choose("For what reason does "+string(obj_ini.master_name)+" seek an audience?","You require something, "+string(obj_ini.master_name)+"?","I have a moment or two to spare.  Speak.");
	        if (rela=="neutral") then diplo_text=choose("I hope you have good reason for this audience.","What is it, space marine?","Do not waste my time.");
	        if (rela=="hostile"){
	            rando=floor(random(100))+1;
	            if (rando>0) and (rando<=32) then diplo_text="What is it, mon-keigh?";
	            if (rando>32) and (rando<=64) then diplo_text="Do not waste my time.";
	            if (rando>64) and (rando<=95) then diplo_text="What is the quickest way I may be rid of you?";
	            if (rando>95) and (rando<=99) then diplo_text="The runes did not foretell listening to your blabbering Mon-keigh mouth.";
	            if (rando==100) then diplo_text="I have little patience for your antics.  You... you... DOUBLE MON-KEIGH.";
	        }
	    }
	    if (diplo_keyphrase=="trade_close"){
	        if (rela=="friendly") then diplo_text="While you are intelligent for a Mon'keigh, I sometimes forget the limitations of your race. You find it difficult to plan ahead with any efficiency, so I do not take this as a slight.";
	        if (rela=="neutral") then diplo_text="Oh, did you see a pretty light? Why don't you go and chase it?  I shall return to my own affairs, which are far beyond your understanding.";
	        if (rela=="hostile") then diplo_text="Typical Mon'keigh, confused in its intentions to the point of injuring itself. Contact me again when you've climbed a few rungs higher on the evolutionary ladder.";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="While I would like to help you, there are more important things afoot in the galaxy than your problem.";
	            if (rando==2) then diplo_text="Mon'keigh, I would like to help you but I cannot currently.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="I have heard words like these a thousand times from Mon'keigh.  And I can only give you one answer; No.";
	            if (rando==2) then diplo_text=" If you could only understand the complexity of my schemes... then perhaps you would understand why I cannot currently help you.  Alas, my plans are far beyond your feeble mind.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Children such as yourself should not be as presumptuous with their elders and betters.";
	            if (rando==2) then diplo_text="Seek not the reasons for my denial of what you seek, know only that you have neither the skill to find them nor the wisdom to interpret them.";
	        }
	    }
	    if (diplo_keyphrase=="agree"){
			if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
			if (trading_artifact!=0) then diplo_text="[[Trade Accepted.]]##";
	    	rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="We are agreed.";
	            if (rando==2) then diplo_text+="Very well.";
	            if (rando==3) then diplo_text+="Your logic is clear.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="Hmm.  I will say yes...this time.";
	            if (rando==2) then diplo_text+="Fine, we'll do it your way.";
	            if (rando==3) then diplo_text+="An unlikely alliance, at best.  Still, it shall happen.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="It appears I have no other choice but to do as you say Mon'keigh.";
	            if (rando==2) then diplo_text+="A repulsive way to put it, Mon'keigh...but yes.";
	            if (rando==3) then diplo_text+="I agree, though not for the reasons you present.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        annoyed[diplomacy]+=2;
	        if (rela=="friendly") and (annoyed[diplomacy]>=6){
				diplo_text+="You test my boundries, "+string(obj_ini.master_name)+", and I find tiresome.";
				force_goodbye=1;
	        	turns_ignored[diplomacy]=max(turns_ignored[diplomacy],2);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;
				diplo_alpha=0;
				exit;
			}
	        if (rela!="friendly") and (annoyed[diplomacy]>=4){
				diplo_text+=choose("I will suffer your presence no longer.","Expect consequences for this offense");force_goodbye=1;
	        	turns_ignored[diplomacy]=max(turns_ignored[diplomacy],4);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;
				diplo_alpha=0;
				exit;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="You test my patience, "+string(obj_ini.master_name)+".";
	            if (rando==2) then diplo_text+="I see no good coming of this.";
	            if (rando==3) then diplo_text+="I must decline.";
	            // 25% chance to close window
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="This is of no concern to us.";
	            if (rando==2) then diplo_text+="I cannot allow such a deal.";
	            if (rando==3) then diplo_text+="Simply unacceptable.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="Remember your place, mon-keigh.";
	            if (rando==2) then diplo_text+="Do not insult me with such an offer.";
	            if (rando==3) then diplo_text+="Expect consequences for this offense.";
	            force_goodbye=choose(0,0,0,1);
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        if (rela!="friendly") then diplo_text="Normal 'we were attacked' line goes here.";
	        if (rela=="friendly") then diplo_text="I would say 'you should know better', "+string(obj_ini.master_name)+", but children are incapable of acting with wisdom, as is their nature.##This act of war obliges us to respond in kind.  I expect to see you upon the fields of battle.";
	    }
	    if (diplo_keyphrase=="declare_war"){
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
	        diplo_text="The Bloody-Handed God calls for your destruction.  We shall only rest when your filth is cleansed from this sector.";
	    }
	    if (diplo_keyphrase=="accept_peace"){
	        diplo_text="A civilization does not survive for as long as ours has without knowing when to put down its weapons. One must also know when to use them again, however.";
	    }
	    /*if (diplo_keyphrase="ignored"){
	        diplo_text="";
	    }*/
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=10;
				faction_justmet=0;
			}
	        if (rela=="friendly"){
	            rando=choose(1,2,3);
				force_goodbye=choose(0,0,0,1);
	            if (rando==1) then diplo_text="You know not what you speak of.";
	            if (rando==2) then diplo_text="There are many mysteries, not all easy to understand.";
	            if (rando==3) then diplo_text="Our ways are not your ways, "+string(obj_ini.master_name)+".";
	        }
	        if (rela!="friendly"){
	            rando=choose(1,2,3,4,5);
				force_goodbye=1;
	            if (rando==1) then diplo_text="You are like a child.";
	            if (rando==2) then diplo_text="Your words harm no one but yourself.";
	            if (rando==3) then diplo_text="This audience serves no purpose.";
	            if (rando==4) then diplo_text="These words spill forth from your mon-keigh mouth like worms.";
	            if (rando==5) then diplo_text="I expect more of a sapient being.";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
			if (faction_justmet==1){
				disposition[diplomacy]+=1;
				faction_justmet=0;
			}
	        if (rela=="friendly"){
	            rando=choose(1,2,3);
	            if (rando==1) then diplo_text="You are amusingly perceptive for your species.";
	            if (rando==2) then diplo_text="A rare, but accurate judgement, "+string(obj_ini.master_name)+".";
	            if (rando==3) then diplo_text="If only you could grasp how little you have understood... I thank you for the compliment none-the-less.";
	        }
	        if (rela!="friendly"){
	            rando=choose(1,2,3,4,5);
	            if (rando==1) then diplo_text="Your words are hollow.";
	            if (rando==2) then diplo_text="Compliments from a Mon-keigh are as meaningless as the guttural growls of the Orks.";
	            if (rando==3) then diplo_text="Do not presume to understand us well enough to appreciate the full breadth and complexity of our actions.";
	            if (rando==4) then diplo_text="You are as a man upon laying eyes upon the ocean for the first time; amazed at what he has seen but woefully ignorant of how much he is still unaware of.";
	            if (rando==5) then diplo_text="Save your words for your “battle brothers”, to whom they will undoubtedly mean much more.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="We offer you this.";
	        if (rando==2) then diplo_text="This trade will benefit all.";
	        if (rando==3) then diplo_text="What say you of this deal?";
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="Speak.";
	    if (diplo_keyphrase=="artifact"){
	        diplo_text="Representatives of the Imperium, as the Chapter Master of "+string(global.chapter_name)+",  I inform you of a potential artifact within our possession, one that we are willing to trade.";
	    }
	    if (diplo_keyphrase=="artifact_thanks"){
	        diplo_text="We... thank you, for the gift of this imperial curio. I am sure it will prove useful for something. What, I am not sure.";
	    }
	    if (diplo_keyphrase=="artifact_angry"){
	        diplo_text="Mon'keigh, there will be a reckoning for the arrogance you have displayed here! You cannot take what you please from our lands and worlds, without paying for it in blood or in a more peaceful currency.";
	    }
	    if (diplo_keyphrase=="stc_thanks"){
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="How quaint, a relic of the “golden age” of your “civilisation”.  Nevertheless, you meant it to be a kind gesture and I thank you.";
	            if (rando==2) then diplo_text+="A kind gesture, even if it is a little... pointless. I am grateful that you have seen past the foolish prejudices of your species.";
	            if (rando==3) then diplo_text+="I remember when these devices were commonplace. Even then, your species was blind to the wisdom of my people. I thank you for the trinket though.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="With your limited mental capacity, I suppose you can’t imagine a more advanced piece of technology, which is amusing. I thank you for the jest.";
	            if (rando==2) then diplo_text+="I suspect you imagined this dusty piece of technology would help us in some way? Amusing. However, we accept the gift anyway.";
	            if (rando==3) then diplo_text+="Your species generally scrabbles for traces of the time before, when you were far greater than you are now. It is good you are letting go and accepting your present lot.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="A child, handing an adult a misshapen failure of a sculpture made of spit, rocks and hope. Still, perhaps we shall find space for it, somewhere.";
	            if (rando==2) then diplo_text+="It is a wonder your species ever mastered space travel, if this was the pinnacle of your “technology”. I don’t know what you expect me to do with it.";
	            if (rando==3) then diplo_text+="How brutish, how dirty. I shall fear to put it down, in case it contaminates part of my Craftworld. Perhaps the void would be a better place for it?";
	        }
	    }
	    if (diplo_keyphrase=="trading_demand"){
	        if (rela=="friendly") then diplo_text="You have proven yourself an able ally, "+string(obj_ini.master_name)=".  Consider your next words thoroughly and deliberately.";
	        if (rela=="neutral") then diplo_text="Speak up, Mon'keigh.";
	        if (rela=="hostile"){
	            rando=choose(1,1,2,2,3);
	            if (rando==1) then diplo_text="Make your demands, Mon'keigh, so that I might refute them.";
	            if (rando==2) then diplo_text="You may not always have what you wish for, Mon'keigh.";
	            if (rando==3) then diplo_text="Were I a lesser being, such as yourself, spitting in your face might prove tempting.";
	        }
	        diplo_option[1]="Demand Requisition";
			diplo_option[2]="Demand Useful Information";
			diplo_option[3]="Cancel";
	    }
	    if (diplo_keyphrase=="mission1"){
	        diplo_text="The good that might come from simple acts of benevolence are oft underestimated.  A token goodwill gesture can go far, ";
	        if (rela=="hostile") then diplo_text+="Mon'keigh";
	        if (rela!="hostile") then diplo_text+="human";
        
	        diplo_text+=".  Even something as small as water, raw material, and sustenance can have a profound efect.";
	        diplo_option[1]="Give 500 Requisition";
	        diplo_option[2]="Maybe";
	        diplo_option[3]="Refuse";
	        questing=1;
	    }
	    if (diplo_keyphrase=="mission1_thanks"){
	        scr_recent("eldar_mission","completed",1);
	        rando=choose(1,1,1,2,2,3,3,3);
	        if (rando==1) then diplo_text="You intend to hand over these resources? Without a promise of compensation?  You are a strange human, Chapter Master. Few would do this, and it will not be forgotten.";
	        if (rando==2) then diplo_text="As little as I expected you to be this generous, I cannot claim complete surprise. While I am a little surprised you were as quick to comply, I expected you to see the light in due course.";
	        if (rando==3) then diplo_text="It is not that I am surprised but I confess a little confusion at your forthright generosity.  Perhaps you expect something in return? Regardless, I thank you.";
	    }
	    if (diplo_keyphrase=="mission1_refused"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="Just as I expected, you are exactly like every other member of your race.  I have met a great many Mon'keigh in my life, and you are no different from the rest.";
	        if (rando==2) then diplo_text="As a brainless fool shouting at the tide to stop, you do your best to fight the inevitable. I shall endure this, however. You too, shall die.";
	        if (rando==3) then diplo_text="Expected. You have done nothing than fulfill my projected outcome. If you think yourself clever for refusing or especially loyal to your leader, do not. You are no more fervent or intelligent than any other Mon'keigh soldier.";
	    }
	    if (diplo_keyphrase=="mission1_failed"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="One would think, with a life span as short as yours, you would have a better memory. It's not as though you live long enough to have enough time to properly forget anything. This insult will not be forgotten, Mon'keigh.";
	        if (rando==2) then diplo_text="You are as predictable as a the rest of your kind. You say things and make promises, which slip from your tiny mind mere moments afterwards. I pity you more than I scorn you.";
	        if (rando==3) then diplo_text="While your mind might be too small to record things for more than a few years, I remember the birth of your “Imperium”. I also remember your words, Mon'keigh. You have, predictably, disappointed me.";
	        force_goodbye=1;
	    }
	    if (diplo_keyphrase=="quest_maybe"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="Ah, the ever cautious Mon'keigh, too scared by the shadow of his precious Emperor to try something new, to adventure a little. Hardly surprising.";
	        if (rando==2) then diplo_text="While this is not the gesture I was referring to, I suppose the fact you are yet to scream and shout about ‘Xenos Scum' must be taken as a minor miracle.";
	        if (rando==3) then diplo_text="Not hard to see why your species is so universally viewed as foolish. Still, perhaps you will manage to be a little more enlightened than the rest.";
	        questing=0;
	        for(var h=1; h<=4; h++){
				obj_controller.diplo_option[h]="";
				obj_controller.diplo_goto[h]="";
			}
	    }
	    if (diplo_keyphrase=="useful_information"){
			var found=0;
	        rando=choose(1,1,2,3,4,4,5);
			force_goodbye=-1;
	
			for(var i=30; i<30; i++){
	            if (rando==5) and (string_count("CM|",obj_controller.useful_info)>0) then rando-=1;
	            if (rando==4) and (random_event_next != EVENT.none) then rando-=1;
	            if (rando==3) and ((turn<chaos_turn) or (known[eFACTION.Chaos]>3)) then rando-=1;
	            if (rando==2) and ((known[eFACTION.Ork]<0) or (known[eFACTION.Ork]>=3) or (string_count("WL7|",obj_controller.useful_info)=1)) then rando-=1;
	            if (rando==1) and (string_count("WG|",obj_controller.useful_info)>1) then rando=5;         
	        }
	        // * Most corrupt mahreen *
	        if (rando==5){
	            obj_controller.useful_info+="CM|";
        
	            var him_c=0,him_i=0,him_num=0,him_cor=0,split="";
            
	            split=scr_max_marine("chaos");
        
	            explode_script(split,"|");
	            him_c=real(explode[0]);
	            him_i=real(explode[1]);
	            him_num=string(explode[2]);
	            him_cor=real(explode[3]);
            
	            if (him_cor==0) then diplo_text="I have looked into the strands of fate, with your chapter, and found that the future is not suspect for any of your men.  None of them have their minds poisoned by the taint of chaos.";
	            if (him_cor>0) then diplo_text="I have looked into the strands of fate, with your chapter.  Your 'battle brother' "+string(him_num)+" has a clouded, dark future- it is advised you watch him carefully.";
	        }
	        // * Next random event *
	        if (rando==4){
	            scr_random_event(false);
	            if (random_event_next == EVENT.strange_behavior) and (obj_controller.disposition[6]<15) then diplo_text="One of your Mon'keigh soldiers will no longer act as you expect him to. Be wary, when one Mon'keigh is influenced the rest of the herd will be.";
	            else if (random_event_next == EVENT.strange_behavior) and (obj_controller.disposition[6]>=15) then diplo_text="One of your soldiers will no longer act as you expect him to. Be wary, when one is influenced the rest of the herd will be.";
	            else if (random_event_next == EVENT.space_hulk) then diplo_text="It comes from the warp, a relic from the past. It is steeped in the energies of the ethereal tides. Beware.";
	            else if (random_event_next == EVENT.promotion) then diplo_text="One of your soldiers will cover himself in glory. As his “Chapter Master”, a title I find inherently foolish, you may wish to reward him.";
	            else if (random_event_next == EVENT.strange_building) then diplo_text="The Red robed ones, their “Machine God”, calls to them. Soon, one shall lose their tenuos grip on the here and now and follow the pictures in his head.";
	            else if (random_event_next == EVENT.sororitas) then diplo_text="Your priestesses of war, who worship He Who Fell, will gather their forces soon, to stay.";
	            else if (random_event_next == EVENT.inquisition_mission) then diplo_text="They will come very soon, the bearers of hellfire and hate. They will scour the sector for so-called ''Heresy''.";
	            else if (random_event_next == EVENT.inquisition_planet) then diplo_text="Your questions askers seek to learn more of a planet.  Warp meddlers and free thinkers would be well-served with caution. Beware, Chapter Master.";
	            else if (random_event_next == EVENT.rogue_trader) then diplo_text="Free thinkers, traders in the vast expanse. They are coming, perhaps you aught to set out your wares?";
	            else if (random_event_next == EVENT.fleet_delay) then diplo_text="Mon'keigh, your fleets may be delayed by my kin. Eldar Pirates, your kind would call them.";
	            else if (random_event_next == EVENT.harlequins) then diplo_text="Rillietann. They have come. They are on some world, hidden, or soon will be.";
	            else if (random_event_next == EVENT.succession_war) then diplo_text="Your underlings fight for power, Mon'keigh.  Someone will die who believes he is important. His children and ''friends'' will vie for the rite to call himself or herself governor. Or king. Or whatever self aggrandising title your people name yourselves.";
	            else if (random_event_next == EVENT.random_fun) then diplo_text="Something will happen soon. The runes do not show me exactly what will happen, only that it concerns you. Watch the horizon, Mon'keigh.";
	            else if (random_event_next == EVENT.warp_storms) then diplo_text="The tides of the Immaterium are unsettled. Of course, it's hard to calculate where the Immaterium will affect the Materium, but I predict it will come soon.";
	            else if (random_event_next == EVENT.enemy_forces) then diplo_text="From beyond your circle of firelight, they are coming. Rest not Mon'keigh, for they will come soon and are bent on destruction."; 
	            else if (random_event_next == EVENT.crusade) then diplo_text="Soon, your masters will call you to heel like a dog to attack the foes of man. One of your ''Crusades'' of hate, ignorance and bigotry will be called."; 
	            else if (random_event_next == EVENT.enemy) then diplo_text="You will make an enemy among your fellow man. Soon they shall whisper into their lord's ear, telling that you are a threat, a beetle to be crushed beneath their boot.  You would do well to speak carefully, for some time.";
	            else if (random_event_next == EVENT.mutation) then diplo_text="Your 'battle brothers' are twisting like snakes beneath your feet. Watch yourself, Chapter Master.";
	            else if (random_event_next == EVENT.ship_lost) then diplo_text="The Immaterium will swallow one of your ships.  Do not look for it to return.";
	            else if (random_event_next == EVENT.chaos_invasion) then diplo_text="Your twisted brethren, who fell to the lure of the Immaterium, will soon arrive with their wrath and demons. Beware.";
	            else if (random_event_next == EVENT.necron_awaken) then diplo_text="Our old enemies, the men of metal, are close. You call them “Necrons”, and you will need to fight them soon. Or flee, it matters not to me.";            
	            else {
					diplo_text="[Missing Dialogue: "+string(random_event_next)+" forcast.]"; // this will print a number rather that a string which is less than ideal, but we can just add new flavour text whem we get the bug reports
				}
	        }
	        // * Chaos warlord location *
	        if (rando==3){
	            obj_controller.useful_info+="WL10|";
	            if (obj_controller.faction_gender[10]==1){
					for(var i=0; i<5; i++){
						if (found==0){
							instance_activate_object(obj_star);
	                    	with(obj_temp5){instance_destroy();}
	                    	with(obj_star){
								for(var i=1; i<=4; i++){
									if (planet_feature_bool(p_feature[1], P_features.Warlord10)==1) then instance_create(x,y,obj_temp5);
								}
						}
	                    if (instance_exists(obj_temp5)){
	                        var you,nuum,plan=0;
	                        you=instance_nearest(obj_temp5.x,obj_temp5.y,obj_star);
	                        nuum=you.name;
							for(var i=1; i<=4; i++){
								if (planet_feature_bool(you.p_feature[1], P_features.Warlord10)==1) then plan=i;
							}
							found=1;
	                        diplo_text="The fallen warlord of your kind is located somewhere within the "+string(nuum)+" system.  More I cannot say.  It would be prudent to deal with this soon- that abomination may not remain there long.";
	                    }
	                }}
	            }
	            if (obj_controller.faction_gender[10]==2){
	                diplo_text="The Lord of Rage turns his foul gaze upon this sector.  With it death and destruction will soon come.  You had best be ready when it does.";
	            }
	        }
	        // * Ork Warboss Location *
	        if (rando==2){
	            obj_controller.useful_info+="WL7|";
				for(var i=0; i<5; i++){
					if (found==0){
						instance_activate_object(obj_star);
	                	with(obj_temp5){instance_destroy();}
						with(obj_star){
							for(var i=1; i<=4; i++){
								if (planet_feature_bool(p_feature[1], P_features.OrkWarboss)==1) then instance_create(x,y,obj_temp5);
							}
						}
						if (instance_exists(obj_temp5)){
							var you,nuum,plan=0;
							you=instance_nearest(obj_temp5.x,obj_temp5.y,obj_star);
							nuum=you.name;
							for(var i=1; i<=4; i++){
								if (planet_feature_bool(you.p_feature[1], P_features.OrkWarboss)==1) then plan=i;
							}
							if (you.p_orks[plan]<6) then you.p_orks[plan]=6;
							diplo_text="The greenskin horde is led by a massive Ork, one who calls himself "+string(faction_leader[eFACTION.Ork])+".  If this warboss were to perish the rest might be dealt with in a more languorous fashion.  He is located on "+string(nuum);
							if (plan==1) then diplo_text+=" I.";
							if (plan==2) then diplo_text+=" II.";
							if (plan==3) then diplo_text+=" III.";
							if (plan==4) then diplo_text+=" IV.";
							found=1;
	                	}
	            	}
				}
	        }     
	        // * Webway Gate Location *
	        // if (rando=1) and (string_count("WG|",obj_controller.useful_info)=2) then rando+=choose(1,2,3,3);
	        if (rando==1){
	            obj_controller.useful_info+="WG|";
	            if (string_count("WG|",obj_controller.useful_info)==1){
					for(var i=0; i<5; i++){
						if (found==0){
							instance_activate_object(obj_star);
							with(obj_temp6){instance_destroy();}
							with(obj_temp5){instance_destroy();}
							if (obj_ini.fleet_type==ePlayerBase.home_world) then with(obj_star){if (owner==1) then instance_create(x,y,obj_temp6);}
							if (obj_ini.fleet_type != ePlayerBase.home_world) then with(obj_p_fleet){if (capital_number>0) then instance_create(x,y,obj_temp6);}
						
							with(obj_star){
								if (owner != eFACTION.Imperium) then instance_deactivate_object(id);
								if (owner == eFACTION.Imperium) and (point_distance(x,y,obj_temp6.x,obj_temp6.y)>250) then instance_deactivate_object(id);
								if (owner == eFACTION.Imperium) and (planets<1) then instance_deactivate_object(id);
							}
							var that,good=0;
							that=instance_nearest(random(room_width),random(room_height),obj_star);
							for(var i=0; i<5; i++){
								if (good==0) then with(that){
									var j=0,onceh=0;
									for(var k=0; k<10; k++){
										j=floor(random(planets))+1;
										if (array_length(p_feature[j])==0) and (onceh==0) then onceh=j;
									}
									if (onceh!=0){
										array_push(p_feature[onceh], new NewPlanetFeature(P_features.Webway));
										obj_controller.temp[90]=name;
										good=1;
										if (onceh==1) then obj_controller.temp[90]+=" I";
										if (onceh==2) then obj_controller.temp[90]+=" II";
										if (onceh==3) then obj_controller.temp[90]+=" III";
										if (onceh==4) then obj_controller.temp[90]+=" IV";
									}
								}
							}
							if (good==1){
								diplo_text="A series of labyrinthian corridors and veins connect the galaxy.  The planet you know as "+string(obj_controller.temp[90])+" contains a dormant entrance to this realm.";
								found=1;
							}
	                	}
					}
	            }
	            if (string_count("WG|",obj_controller.useful_info)==2){
					for(var i=0; i<5; i++){
						if (found==0){
							instance_activate_object(obj_star);
							with(obj_temp6){instance_destroy();}
							with(obj_temp5){instance_destroy();}
							if (obj_ini.fleet_type==ePlayerBase.home_world) then with(obj_star){if (owner==1) then instance_create(x,y,obj_temp6);}
							if (obj_ini.fleet_type != ePlayerBase.home_world) then with(obj_p_fleet){if (capital_number>0) then instance_create(x,y,obj_temp6);}
							with(obj_star){
								if (owner != eFACTION.Imperium) then instance_deactivate_object(id);
								if (owner == eFACTION.Imperium) and (point_distance(x,y,obj_temp6.x,obj_temp6.y)<800) then instance_deactivate_object(id);
								if (owner == eFACTION.Imperium) and (planets<1) then instance_deactivate_object(id);
							}
							var that,good=0;
							that=instance_nearest(random(room_width),random(room_height),obj_star);
							for(var j=0; j<5; j++){
								if (good==0) then with(that){
									var i=0,onceh=0;
									for(var k=0; k<10; k++){
										i=floor(random(planets))+1;
										if (array_length(p_feature[i])==0) and (onceh==0) then onceh=i;}
									if (onceh!=0){
										array_push(p_feature[onceh], new NewPlanetFeature(P_features.Webway));
										obj_controller.temp[90]=name;
										good=1;
										if (onceh==1) then obj_controller.temp[90]+=" I";
										if (onceh==2) then obj_controller.temp[90]+=" II";
										if (onceh==3) then obj_controller.temp[90]+=" III";
										if (onceh==4) then obj_controller.temp[90]+=" IV";
									}
								}
							}
							if (good==1){
								diplo_text="The second dormant webway gate lays upon "+string(obj_controller.temp[90])+".";
								found=1;
							}
	                	}
					}
	            }
	            with(obj_temp6){instance_destroy();}
	            with(obj_temp5){instance_destroy();}
	            instance_activate_object(obj_star);
	        }
	    }
	}
	// ** ORKZZZ **
	if (diplomacy==7){
	    if (disposition[diplomacy]>=20) then rela="friendly";
	    if (disposition[diplomacy]<20) and (disposition[diplomacy]>=-20) then rela="neutral";
	    if (disposition[diplomacy]<-20) then rela="hostile";
		// * Request audience *
	    if (diplo_keyphrase=="intro"){
	        rando=choose(1,2);
	        if (rando==1) then diplo_text="[["+string(faction_leader[diplomacy])+" is the scourge of the sector, a colossal green brute infamous for the destruction of a dozen worlds. He rules his vicious horde of xenos savages the only way greenskins know how; with brute force. Trophies from the champions of a score of races bedeck his armour, including many from "+string(choose("other Astartes","the Tyranids","the Tau Empire"))+".]]";
	        if (rando==2) then diplo_text="[["+string(faction_leader[diplomacy])+" is a veteran of countless engagements, leading his tribe into battle with an almost manic giddiness. His name is synonymous with extended campaigns of looting and senseless violence, even more so than the other members of his barbaric race. He and the rest of his tribe hail from the "+string(choose("Goffs","Blood Axes","Bad Moons","Death Skulls","Death Skulls"))+" clan.]]";
	        diplo_text+="###";
			if (scr_has_adv("Enemy: Orks")){
				diplo_text+="Oi Beaky! I ain't heard your name round here before! If ya eva get bored of havin' your ‘ead attached to your shouldas, good old "+string(faction_leader[diplomacy])+" can sort dat out for ya!";
			} else {
				if (scr_has_disadv("Tolerant")){
					diplo_text+="You seem good for a scrap, ya beaky faced ponce! Bring your lads down my way some time and we'll have one!";
				} else {
					diplo_text+="All you space marines seem da same ta me. I reckon we'll be seein' each other soon enough...";
				}
			}
	        diplo_text+=tempd;
	    }
	    if (diplo_keyphrase=="new_warboss"){
	        rando=choose(1,1,1,2);
	        diplo_text="[["+string(faction_leader[diplomacy])+" is the scourge of many sectors, a colossal green brute infamous for the destruction of dozens of worlds.  His name is synonymous with extended campaigns of looting and senseless violence, even more so than the other members of his barbaric race. He and the rest of his tribe hail from the "+string(choose("Goffs","Blood Axes","Bad Moons","Death Skulls","Death Skulls"))+" clan.  He is recently arrived to the sector, bringing with him a massive invasion fleet.]]";
	        diplo_text+="###";
	        if (rando==1) then diplo_text+="I've got good news, humie! "+string(faction_leader[diplomacy])+" is da warboss now! An' ya know wot dat means? It means yer krumped! Krumped good an' well, just as soon as me Mekboys get dis piece o junk movin'. Thaz right!  Get ready fer a foight, humies; me an' da boyz'll be antsy when we gets there, and it'd be downroight inhorspitotalibile not to give us a good one!"
	        if (rando==2) then diplo_text+="Tasty humie worldz. All dat loot. All dat MEAT. By Gork an Mork, we's gonna smash it all up wiv an ax, burn it to da ground and have a proppa meal!  "+string(faction_leader[diplomacy])+" is da warboss now, and I's commin for you humie!  Git ready for da WWWAAAGGGGGGGGGGHHHHHHH!"
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly"){
	            rando=choose(1,2);
	            if (rando==1) then diplo_text+="Hey, if it isn't me favorite ‘umie! What can I do for ya? Want some help with some skumgrods, a quick trade or just come to chat with old "+string(faction_leader[eFACTION.Ork])+"?";
	            if (rando==2) then diplo_text+="Pull up a chair, Chapta masta! Want some fungus ale? It's good stuff! There's even a squig fight on in da pits today! Oh, but you're always buisness, ain't ya?";
	        }
	        if (rela=="neutral"){
	            rando=choose(1,2);
	            if (rando==1) then diplo_text+="Alright ‘umie, whatcha want? I got betta things ta do today but ‘umies are always good for a laugh so I'll give ya a little while.";
	            if (rando==2) then diplo_text+="Go on den ‘umie, say you piece. But if ya call me xenos or mention the Emprah even once, this is gunna end badly.";
	        }
	        if (rela=="hostile"){
	            rando=choose(1,2);
	            if (rando==1) then diplo_text+="What da zog do ya want, ‘umie? I ain't in da mood for any of your squig dung, so make it quick before I start shootin'.";
	            if (rando==2) then diplo_text+="Ya got eight words to tell me what you want, ‘cause dat's how many finers I got left. After dat, I'll show ya what I learned losing the other three.";
	        }
	    }
	    if (diplo_keyphrase="trade_close"){
	        if (rela=="friendly") then diplo_text="Oi', don't rush off! Why don't ya drink a fungus ale wit me and the nobz? We could discuss business while watching a squigfight! No? Suit ya self.";
	        if (rela=="neutral") then diplo_text="Well dat was a waste of time. See ya ‘around Space Marine.";
	        if (rela=="hostile") then diplo_text="Next time you says you got a deal for me, you beta zoggin' well ‘ave one!";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Nah, I ain't seein it mate. Maybe next time, 'eh?";
	            if (rando==2) then diplo_text="Dun't sound like fun, Spash Mareen. I fink I'll take the boys for a scrap someplace else.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Get lost 'umie, I got me own fings ta do.";
	            if (rando==2) then diplo_text="I'll fink about it but I ain't sure it sounds like fun.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Da only fing I'll 'elp ya with is the removal of you head!";
	            if (rando==2) then diplo_text="Next time ya want somefing, try askin' someone who dun't fink you're a piece of mouldy grot dung.";
			}
	    }
	    if (string_count("agree",diplo_keyphrase)>0){
			if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
			if (trading_artifact!=0) or (liscensing>0) then diplo_text="[[Trade Accepted.]]##";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="Ha, this is gunna be a whole lot of fun! I'm in!";
	            if (rando==2) then diplo_text+="You ain't green but ya fink like an ork all right! It's a deal!";
	            if (rando==3) then diplo_text+="‘ERE WE GO, ‘ERE WE GO, ‘ERE WE GO!";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="Yeah, all right, why not?";
	            if (rando==2) then diplo_text+="You're lucky I'm such a nice boss, no other ork'd agree to this.";
	            if (rando==3) then diplo_text+="Well, I don't see no reasons why I shouldn't agree.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="I dun't like it but I ain't got no choice.";
	            if (rando==2) then diplo_text+="If you cross me, I'll pick me teef with your ribs!";
	            if (rando==3) then diplo_text+="You're a lousy ‘umie skumgrod but you got a deal.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        annoyed[diplomacy]+=2;
	        if (annoyed[diplomacy]>=6){
				diplo_text+="You'ze wasting my time.";
				force_goodbye=1;
	        	turns_ignored[diplomacy]=max(turns_ignored[diplomacy],4);
				diplo_last=string(diplo_keyphrase);
				diplo_char=0;
				diplo_alpha=0;
				exit;
			}
	        if (rela=="friendly"){
	            rando=choose(1,2,3);
	            if (rando==1) then diplo_text+="Not dis time but don't let it get ya down.";
	            if (rando==2) then diplo_text+="Ha, sounds like a good time but dere's too many squigs on me plate right now.";
	            if (rando==3) then diplo_text+="Pull the uvver one mate, it's got bells on it!";
	            // 25% chance to close window
	        }
	        if (rela=="neutral"){
	            rando=choose(1,2,3);
	            if (rando==1) then diplo_text+="Nah, I don't like the sound of dat.";
	            if (rando==2) then diplo_text+="Maybe some uvver time, there's a fight on at the squig pits.";
	            if (rando==3) then diplo_text+="Find some uvver ork, this one ain't got da time.";
	        }
	        if (rela=="hostile"){
	            rando=choose(1,2,3);
	            if (rando==1) then diplo_text+="Not a chance, ya fleshy pink git!";
	            if (rando==2) then diplo_text+="I got a better idea; get zogged!";
	            if (rando==3) then diplo_text+="If dat's a serious offer, you're out of your tiny ‘uman mind.";
	            force_goodbye=choose(0,0,0,1);
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        diplo_text="So it's krumping time is it, you stupid beaky!? I'm gunna find you and smash your zogging face in with me bare hands! Nobody starts a fight round ‘ere ‘cept me!";
	    }
	    if (diplo_keyphrase=="declare_war"){
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
	        diplo_text="Me boyz ain't fought anyone for... at least half a zoggin' hour! It's skrapping time and may da best ork win!";
	    }
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=5;
				faction_justmet=0;
			}
	        if (rela=="friendly"){
	            rando=choose(1,2,3);// force_goodbye=1;
	            if (rando==1) then diplo_text="Ha, I know ya dun't mean that!";
	            if (rando==2) then diplo_text="Say dat again and I'll slap ya ‘round the head, ya daft git! Just kiddin'!";
	            if (rando==3) then diplo_text="If ya think dat, ya must have squig dropping between yur ears.";
	        }
	        if (rela=="neutral"){
	            rando=choose(1,2,3);// force_goodbye=1;
	            if (rando==1) then diplo_text="Words is all ya got, is it?";
	            if (rando==2) then diplo_text="Dat was a paffetic excuse for an insult, dung-for-brains.";
	            if (rando==3) then diplo_text="We'll just see if dem words are true, won't we?";
	        }
	        if (rela=="hostile"){
	            rando=choose(1,2,3);
				force_goodbye=choose(0,0,1);
	            if (rando==1) then diplo_text="Say dat to me face and see what happens, ya gork damned beaky!";
	            if (rando==2) then diplo_text="I'm gunna take dem words and ram ‘em down your throat!";
	            if (rando==3) then diplo_text="Let's see ya say that without a head!";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="You're a mate, ta say such nice fings about little ole' me.";
	            if (rando==2) then diplo_text="Dat's da truth, plain and simple. Well said!.";
	            if (rando==3) then diplo_text="Job's a good ‘un!";
	        }
	        if (rela=="neutral"){
				force_goodbye=choose(0,0,0,1);
	            if (rando==1) then diplo_text="You know how ta polish a name, but do ya know how to wield a blade?";
	            if (rando==2) then diplo_text="That dun't push me one way or the uvver.";
	            if (rando==3) then diplo_text="Words don't last, ‘umie, it's deeds that get remembered.";
	        }
	        if (rela=="hostile"){
				force_goodbye=choose(0,1);
				if (faction_justmet==1) then force_goodbye=1;
	            if (rando==1) then diplo_text="Get your nose outta me arse ‘umie! I dun't want your pretty words, just your head!";
	            if (rando==2) then diplo_text="Quick ta turn tail and kiss arse, ain't ya? It wun't help.";
	            if (rando==3) then diplo_text=string(faction_leader[diplomacy])+" dun't like be called names by ‘umies, not even good ones.";
	        }
	        if (faction_justmet==1){
				disposition[diplomacy]+=5;
				faction_justmet=0;
			}
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="You wanna swap dis ‘ere fine bolter for dat fing?";
	        if (rando==2) then diplo_text="Oi, you want some of dis? Special offer for a limited time only!";
	        if (rando==3) then diplo_text="Take it or leave it, dat's me final offer.";
	    }
	    if (diplo_keyphrase=="stc_thanks"){
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="It’s a... shinybit! Fanks fer da shinybit Beaky!";
	            if (rando==2) then diplo_text+="Wot, so it’s like a box o’ ideas fer ‘Umie teknology? Fanks!";
	            if (rando==3) then diplo_text+="Cor, looks real nice! I’ll stick it on me Choppa!";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="It’s a... not really useful fer anyfin’, is it?";
	            if (rando==2) then diplo_text+="Ya know ‘umie, I dun’t like bitz that dun’t do nuffin’. Just sayin’ fer next time.";
	            if (rando==3) then diplo_text+="So wat, ya want a fank you note or summin’?";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="If ya dun’t zog off, I’m gunna ram dis down yer throat!";
	            if (rando==2) then diplo_text+="Fanks, now get lost ‘afore I smashes ya!";
	            if (rando==3) then diplo_text+="Maybe one o’ da grots will like it, ‘cos I dun’t.";
	        }
	    }
	    if (diplo_keyphrase=="artifact_thanks"){
			rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Thanks mate, dis'll make a good toof pick!";
	            if (rando==2) then diplo_text="Cor, shiny fing, ain't it!? Dun't worry, I'll find a place fer it.";
	            if (rando==3) then diplo_text="Yer a good mate, givin' me such nice dakka!";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Not bad, not bad. I'll see if I can find sum grot ta use it.";
	            if (rando==2) then diplo_text="Aright, just dun't spect me ta give ya one back for Gorkmas!";
	            if (rando==3) then diplo_text="Well, so long as ya aren't askin' for sum teef in return fer it.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Ha, you givin' me a somefin ta shove down your throat, beaky!?";
	            if (rando==2) then diplo_text="It wus mine anyway, seein' as I'll take all yer stuff eventually.";
	            if (rando==3) then diplo_text="Wot a piece o' rubbish. ‘Ope you got better dakka an' dis somewhere.";
	        }
	    }
	    if (diplo_keyphrase=="open_trade") then diplo_text="Wut?";
	    if (diplo_keyphrase=="trading_demand"){
	        diplo_text="Yeah?  Wut?";
	        diplo_option[1]="Demand Requisition";
			diplo_option[2]="Demand Military Assistance";
			diplo_option[3]="Cancel";
	    }
	}
	// ** Tau **
	if (diplomacy==8){
	    if (diplo_keyphrase=="intro"){
	        rando=choose(1,2);     
	        if (rando==1) then tempd="[[Tall and slender, its skin is blue and clammy-looking.  Disgusting.  Its face contains two large, expressionless eyes, a slit-like mouth, and a bizarre I-shaped gash between its eyes that must function as a nose.  So this is "+string(faction_title[8])+" "+string(faction_leader[eFACTION.Tau])+".  This particular xenos is said to "+choose("have quite the silver tongue","have negotiated the surrender of many Imperial worlds","have a great deal of military backing.")+".]]";        
	        if (rando==2) then tempd="[[Tall and slender, its skin is a light blue and looks almost reptilian.  A Y-shaped slit nestles between its eyes, and a mouth like a slit sits below that.  This must be "+string(faction_title[8])+" "+string(faction_leader[eFACTION.Tau])+".  The Ordo Xenos tells us that this particular xeno "+choose("can sense weakness in a rock","knows more than it will let on","uses its words like a scalpel")+".]]";
	        tempd+="###";
	        rando=choose(1,2);
	        if (rando==1) then tempd+="Greetings, Chapter Master.  As you know, we have claimed for ourselves planets along the borders of your Imperium.  I wish to clarify that we of the Tau do not seek a war.  Rather, we hope to cooperate with you so that we may both work towards a Greater Good."; 
	        if (rando==2) then tempd+="Salutations, "+string(obj_ini.master_name)+".  I represent the interests of the Tau Empire.  We wish to exist in peace beside you for now, and hope that one day you will see the wisdom of the Greater Good. We will be more than happy to accept you into the fold, for the way of the Tau is one of benevolence and acceptance."; 
	        diplo_text=tempd;
	    }
	    if (diplo_keyphrase=="hello"){
	        if (rela=="friendly") then diplo_text=string(obj_ini.master_name)+"! How may we help one another today?";
	        if (rela=="neutral") then diplo_text="We welcome you, Chapter Master. What do you wish of the Tau?";
	        if (rela=="hostile") then diplo_text="Chapter Master. Have you finally decided to submit yourself to The Greater Good?";
	    }
	    if (diplo_keyphrase=="trade_close"){
	        if (rela=="friendly") then diplo_text="I will await your word with anxious anticipation, honoured ally, for I am sure something of great importance draws you away.";
	        if (rela=="neutral") then diplo_text="Please reconsider your actions.  I believe we would both benefit from a trade, Gue'la";
	        if (rela=="hostile") then diplo_text="I am saddened by your lack of respect, and can only attribute it to inferior cultural surroundings.";
	    }
	    if (diplo_keyphrase=="demand_refused"){
	        rando=choose(1,2);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="While I truly sympathise with your plight, I'm afraid I cannot acquiesce at this time.";
	            if (rando==2) then diplo_text="I am sorry, friend, but I simply cannot comply at this time.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="It is not possible for such a thing to be done, whatever your reasons.";
	            if (rando==2) then diplo_text="As eloquent as your arguments have been, I cannot give this my approval.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="It will not happen, and you must deal with that.";
	            if (rando==2) then diplo_text="No, and that is our final word upon the matter.";
	        }
	    }
	    if (diplo_keyphrase=="agree"){
			if (trading_artifact==0) then diplo_text=string(trade_msg)+"##";
			if (trading_artifact!=0) then diplo_text="[[Trade Accepted.]]##";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="Yes!  We wholeheartedly agree to this deal.  The Tau Empire thanks you for your continuing support.";
	            if (rando==2) then diplo_text+="Of course. We are always happy to be able to meet the needs of our friends and allies- such is the philosophy of the Greater Good.";
	            if (rando==3) then diplo_text+="Your terms are most amicable.  May the light of wisdom shine on you ever, Chapter Master.  Greater Good prevails.";
	        }
	        if (rela=="neutral"){
	            if (rando=1) then diplo_text+="Hmm.  Agreed.  I hope that this will pave the way to better relations overall.";
	            if (rando=2) then diplo_text+="We accept.  The Greater Good teaches us cooperation, and this is just one of the many ways it applies.";
	            if (rando=3) then diplo_text+="As you say, we are in need of such things... I think this arrangement will profit us both.  Perhaps we shall work together more in the future.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="You drive a hard bargain... but it is for The Greater Good.";
	            if (rando==2) then diplo_text+="An unfair bargain does no good for any... but you force our hand.";
	            if (rando==3) then diplo_text+="Under other circumstances we would refuse... but the word of the Aun's is heard by all.";
	        }
	    }
	    if (diplo_keyphrase=="disagree"){
			if (trading_artifact==0) then diplo_text="[[Trade Refused]]##";
			if (trading_artifact==1) then diplo_text="";
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text+="I am sorry but I will have to say no for now.";
	            if (rando==2) then diplo_text+="You must forgive us, but we are unable to agree to your terms.  We simply cannot fulfil the obligations you suggest.";
	            if (rando==3) then diplo_text+="Your terms are agreeable, and past deeds have proven your trustworthiness... but I fear the consequences of this trade.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text+="This arrangement does not benefit us at this time.  Perhaps if you were to offer again later...";
	            if (rando==2) then diplo_text+="Unfortunately we cannot accept these terms.  I apologize.";
	            if (rando==3) then diplo_text+="We will have to consider it.  For now, you would do well to seek another partner.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text+="The Aun's decree is final. Your terms do not benefit The Greater Good.";
	            if (rando==2) then diplo_text+="Absolutely not.  We of the Tau Empire have pride of our own to maintain.";
	            if (rando==3) then diplo_text+="Your terms are practically insulting.  The Greater Good is not so impotent that we cannot simply go to someone else.";
	        }
	    }
	    if (diplo_keyphrase=="attacked"){
	        diplo_text="You will regret this day, space marine.  The Tau grow stronger by the hour; a dozen races have joined our cause.  The Greater Good is no mere philosophy but a way of life we will fight for.";
	    }
	    if (diplo_keyphrase=="declare_war"){
			force_goodbye=1;
			turns_ignored[diplomacy]+=4;
	        diplo_text="We have attempted diplomacy, Chapter Master.  Time and again, Tau ambassadors have contacted your Imperium with peaceful intentions... and time and again they have been betrayed.  No more.  It is war, Space Marine.  Surrender, or face the fury of those who dream of a Greater Good!";
	    }
	    if (diplo_keyphrase=="accept_peace"){
	        diplo_text="We, the Tau, agree to a complete cessation of hostilities.  Perhaps you may yet join us and achieve a Greater Good.";
	    }
	    if (diplo_keyphrase=="ignored"){
	        diplo_text="You request for an audience is granted, but I would hope that you attempt to keep up more regular contact in future.";
	    }
	    if (diplo_keyphrase=="denounced"){
			if (faction_justmet==1){
				disposition[diplomacy]-=2;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Was this communication sent in error? Do we not all serve a Greater Good?";
	            if (rando==2) then diplo_text="We apologise if we have caused any offence. We are not above admitting our mistakes.";
	            if (rando==3) then diplo_text="This is most unlike you, Chapter Master. Are you unwell?";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Such sentiments are regrettable. We hope one day you realize your mistakes and submit to The Greater Good.";
	            if (rando==2){diplo_text="Foolish notions are below our recognition. Contact us when you have a message of substance.";force_goodbye=1;}
	            if (rando==3) then diplo_text="Coming to insults so soon? Embrace The Greater Good, Gue'la, and we will show you the true way.";
	        }
	        if (rela=="hostile"){
	            force_goodbye=choose(0,0,1);
	            if (rando==1) then diplo_text="Your tiresome slander is noted and dismissed. We do not hold it against you.";
	            if (rando==2) then diplo_text="Gue'la are obviously less sophisticated than the Tau. We know not to sling feces at others.";
	            if (rando==3) then diplo_text="Our greatest poets would respond to your laughable taunts, but none of your race could understand them.";
	        }
	    }
	    if (diplo_keyphrase=="praised"){
			if (faction_justmet==1){
				disposition[diplomacy]+=4;
				faction_justmet=0;
			}
	        rando=choose(1,2,3);
	        if (rela=="friendly"){
	            if (rando==1) then diplo_text="Let us feast and celebrate, Chapter Master! Friends like you are rare in these times.";
	            if (rando==2) then diplo_text="The Greater Good thanks you!";
	            if (rando==3) then diplo_text="The Aun's send their humble thanks, Chapter Master. You should feel honoured.";
	        }
	        if (rela=="neutral"){
	            if (rando==1) then diplo_text="Your entreaty is noted and will be considered in future.";
	            if (rando==2) then diplo_text="A simple gesture, Chapter Master... but we thank you.";
	            if (rando==3) then diplo_text="Hmm... perhaps you are not beyond redemption.  May the Greater Good be with you, Chapter Master.";
	        }
	        if (rela=="hostile"){
	            if (rando==1) then diplo_text="Words are cheap, Chapter Master.  Actions are worth far more.";
	            if (rando==2) then diplo_text="Grovelling before The Greater Good?  Do you have no pride?";
	            if (rando==3) then diplo_text="Forgiveness is earned, not given.  Show us your worth, Chapter Master.";
	        }
	    }
	    if (diplo_keyphrase=="offer"){
	        rando=choose(1,2,3);
	        if (rando==1) then diplo_text="Our emissaries bring gifts, Chapter Master. Perhaps you would consider a mutually beneficial arrangement?";
	        if (rando==2) then diplo_text="The Aun's ask much of you, Chapter Master... but we are more than willing to repay you in full.";
	        if (rando==3) then diplo_text="Let us forget our differences, for we may all reap the rewards of The Greater Good.";
	    }
	    if (diplo_keyphrase=="open_trade"){
	        rando=choose(1,2);
	        if (rando==1) then diplo_text="Make your proposal and the Tau shall answer.";
	        if (rando==2) then diplo_text="Ah, you have something that might possibly allow us both to benefit of The Greater Good?";
	    }
	    if (diplo_keyphrase=="artifact_thanks") then diplo_text="Your generosity will not be forgotten, friend of the Tau.  What you have done shall advance The Greater Good.";
	    if (diplo_keyphrase=="stc_thanks"){
	        diplo_text="We extend our sincere gratitude to you, noble ally of the Tau, for your generosity. The STC fragment you have bestowed upon us shall not only serve our cause but also contribute significantly to The Greater Good. ";
	    }
	    if (diplo_keyphrase=="bombard_angry"){
	        diplo_text="What are you doing!? The bombardment of our planet is inexcusable and shall be met with an immediate and forceful response!";
	    }
	}

	// ** Trading Error Handling **
	if (diplo_keyphrase=="trade_error_1") and (obj_ini.fleet_type==ePlayerBase.home_world) then diplo_text="[Error 1: No valid planet to trade with.]";
	if (diplo_keyphrase=="trade_error_1") and (obj_ini.fleet_type != ePlayerBase.home_world) then diplo_text="[Error 1: No valid fleet to trade with.]";
	if (diplo_keyphrase=="trade_error_2") then diplo_text="[Error 2: "+string(obj_controller.faction[diplomacy])+" has no valid origin for a fleet.]";

	// ** Sets ignored turns when kicked out of diplomacy screen **
	if (force_goodbye==1) then turns_ignored[diplomacy]=max(turns_ignored[diplomacy],1);

	// ** Resets global vars **
	diplo_last=string(diplo_keyphrase);
	diplo_char=0;
	diplo_alpha=0;
	
}
