
function scr_powers(power_set, power_count, enemy_target, unit_id) {

	// power_set: letter
	// power_count: number
	// enemy_target: target
	// unit_id: marine_id

	// This is a stand-alone script that determines powers based on the POWERS variable,
	// executes them, and applies the effect and flavor.  All in one.  Because I eventually
	// got better at this sort of thing.
    
    // This is called in context of a obj_pnunit
    
	var unit = unit_struct[unit_id];
	if (!is_struct(unit))then exit;
	if (unit.name()=="")then exit;
	var psy_discipline,power_name,target_type,enemy5,onc,using,binders,book_powers,book_roll,tome_bad,tome_slot,tome_tags;
	var psy_discipline="";
	var power_name="";
	var target_type="";
	var weapon_one = unit.get_weapon_one_data()
	var weapon_two = unit.get_weapon_two_data()
	enemy5=enemy_target;
	onc=power_count;
	using=power_set;
	var flavour_text1="",flavour_text2="",flavour_text3="",flavour_text_4="";
	binders=false;
	book_powers="";
	book_roll=irandom(99)+1;
	tome_bad=0;tome_slot=0;tome_tags="";

	// In here check if have book

	if (unit.weapon_one()=="Tome"||unit.weapon_two()=="Tome"){
	    // Nurge is 2, tzeentch is 3, slaanesh 4
    
	    var tomes=1,onf=0;
	    if (unit.weapon_two()=="Tome"){//has one tome in right
	    	tomes++;
	    	if (unit.weapon_one()=="Tome"){//has two tomes
	    		tomes++;
	    	}
	    }
	    if (tomes==3){
	    	tomes=choose(1,2)
	    }
	    if (tomes=1) then tome_tags=marine_wep1[unit_id];
	    if (tomes=2) then tome_tags=marine_wep2[unit_id];
    
	    if (string_count("Tome",tome_tags)>0){
	        if (string_count("PRE",tome_tags)>0) then book_powers="nu";
	        if (string_count("MIN",tome_tags)>0) then book_powers="tz_daemon";
	        if (string_count("2",tome_tags)>0) then book_powers="nu_daemon";
	        if (string_count("3",tome_tags)>0) then book_powers="tz_daemon";
	        if (string_count("4",tome_tags)>0) then book_powers="sl_daemon";
        
	        if (book_powers=""){// Check materials here for non-chaos powers
	            if (string_count("GOLD",tome_tags)>0) then book_powers="default";// gold
	            if (string_count("CRU",tome_tags)>0) then book_powers="telekenesis";// crumbling
	            if (string_count("GLOW",tome_tags)>0) then book_powers="default";// blue glow
	            if (string_count("ADAMANTINE",tome_tags)>0) then book_powers="default";// adamantium
	            if (string_count("PRE",tome_tags)>0) then book_powers="biomancy";// preserved flesh
	            if (string_count("THI",tome_tags)>0) then book_powers="biomancy";// thin
	            if (string_count("FAL",tome_tags)>0) then book_powers="nu";// fallen angle
	            if (string_count("SAL",tome_tags)>0) then book_powers="pyromancy";// salamander
	            if (string_count("TENTACLES",tome_tags)>0) then book_powers="what_the_fuck_man";// tentacles
	            if (string_count("MIN",tome_tags)>0) then book_powers="tz_daemon";// mindfuck
	            if (book_powers="default") and (string_count("BUR",tome_tags)>0) then book_powers="pyromancy";// burning book
            
            
	            // skulls, falling angel, thin, tentacle, mindfuckif (t2!="Statue") then t5=choose("SKU","FAL","THI","TENTACLES","MIN");
            
	        }
        
	    }
	}
	if (scr_has_adv("Daemon Binders")) then binders=true;
	var p_type="";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=0;

	if (string_count("Z",using)>0){
		psy_discipline="hacks";
		power_name="gather_energy";
	}

	if (string_count("D",using)>0){psy_discipline="default";
	    if (onc=0) then power_name="Minor Smite";
	    if (onc=1) then power_name="Smite";
	    if (onc=2) then power_name="Force Dome";
	    if (onc=3) then power_name="Machine Curse";
	    if (onc=4) then power_name="Avenge";
	    if (onc=5) then power_name="Quickening";
	    if (onc=6) then power_name="Might of the Ancients";
	    if (onc=7) then power_name="Vortex of Doom";
	}
	if (string_count("B",using)>0){psy_discipline="biomancy";
	    if (onc=0) then power_name="Minor Smite";
	    if (onc=1) then power_name="Blood Boil";
	    if (onc=2) then power_name="Iron Arm";
	    if (onc=3) then power_name="Endurance";
	    if (onc=4) then power_name="Regenerate";
	    if (onc=5) then power_name="Haemorrhage";
	}
	if (string_count("P",using)>0){psy_discipline="pyromancy";
	    if (onc=0) then power_name="Breathe Fire";
	    if (onc=1) then power_name="Fiery Form";
	    if (onc=2) then power_name="Fire Shield";
	    if (onc=3) then power_name="Inferno";
	    if (onc=4) then power_name="Sun Burst";
	    if (onc=5) then power_name="Molten Beam";
	}
	if (string_count("T",using)>0){psy_discipline="telekinesis";
	    if (onc=0) then power_name="Crush";
	    if (onc=1) then power_name="Shockwave";
	    if (onc=2) then power_name="Wave of Force";
	    if (onc=3) then power_name="Telekinetic Dome";
	    if (onc=4) then power_name="Spatial Distortion";
	    if (onc=5) then power_name="Vortex of Doom";
	}
	if (string_count("R",using)>0){psy_discipline="rune Magick";
	    if (onc=0) then power_name="Living Lightning";
	    if (onc=1) then power_name="Murderous Hurricane";
	    if (onc=2) then power_name="Stormbringer";
	    if (onc=3) then power_name="Fury of the Wolf";
	    if (onc=4) then power_name="Thunder Clap";
	    if (onc=5) then power_name="Spatial Distortion";
	}


	if (book_powers!="") and (book_roll<=50){power_name="";
	    if (book_powers="nu"){onc=choose(1,2,3);tome_bad=1;
	        if (onc=1) then power_name="Wave of Entropy";
	        if (onc=2) then power_name="Insect Swarm";
	        if (onc=3) then power_name="Blood Dementia";
	    }
	    if (book_powers="nu_daemon"){onc=choose(1,2,3,4);tome_bad=2;
	        if (onc=1) then power_name="Wave of Entropy";
	        if (onc=2) then power_name="Insect Swarm";
	        if (onc=3) then power_name="Blood Dementia";
	        if (onc=4) then power_name="Putrid Vomit";
	    }
	    if (book_powers="tz_daemon"){onc=choose(1,2,3,4);tome_bad=2;
	        if (onc=1) then power_name="Wave of Change";
	        if (onc=2) then power_name="Warp Bolts";
	        if (onc=3) then power_name="Warp Beam";
	        if (onc=4) then power_name="Iron Arm";
	    }
	    if (book_powers="sl_daemon"){onc=choose(1,2,3,4);tome_bad=2;
	        if (onc=1) then power_name="Warp Bolts";
	        if (onc=2) then power_name="Rainbow Beam";
	        if (onc=3) then power_name="Hysterical Frenzy";
	        if (onc=4) then power_name="Symphony of Pain";
	    }
    
	    if (book_powers="default") or (book_powers=""){onc=choose(1,2,3);
	        if (onc=1) then power_name="Avenge";
	        if (onc=2) then power_name="Spatial Distortion";
	        if (onc=3) then power_name="Stormbringer";
	    }
	    if (book_powers="telekenesis"){onc=choose(1,2,3);
	        if (onc=1) then power_name="Spatial Distortion";
	        if (onc=2) then power_name="Telekinetic Dome";
	        if (onc=3) then power_name="Vortex of Doom";
	    }
	    if (book_powers="biomancy"){onc=choose(1,2,3,4);tome_bad=1;
	        if (onc=1) then power_name="Haemorrhage";
	        if (onc=2) then power_name="Regenerate";
	        if (onc=3) then power_name="Iron Arm";
	        if (onc=4) then power_name="Insect Swarm";
	    }
	    if (book_powers="pyromancy"){onc=choose(1,2,3);
	        if (onc=1) then power_name="Inferno";
	        if (onc=2) then power_name="Sun Burst";
	        if (onc=3) then power_name="Molten Beam";
	    }
	    if (book_powers="what_the_fuck_man"){onc=choose(1,2,3,1,3);tome_bad=2;
	        if (onc=1) then power_name="Blood Dementia";
	        if (onc=2) then power_name="Spatial Distortion";
	        if (onc=3) then power_name="Haemorrhage";
	    }
	}

	// Change cases here
	if (power_name="Machine Curse"){
	    with(obj_enunit){if (veh>0) then instance_create(x,y,obj_temp3);}
	    if (instance_number(obj_temp3)=0) then power_name="Smite";
	    if (obj_ncombat.enemy=9) then power_name="Smite";
	    with(obj_temp3){instance_destroy();}
	}

	// show_message(string(power_name));
	// 

	// Chaos powers here

	if (power_name="Wave of Entropy"){p_type="attack";p_rang=3;p_tar=3;p_spli=1;p_att=220;p_arp=0;p_duration=0;
	    flavour_text2="- a putrid cone of warp energy splashes outward, ";
	    if (obj_ncombat.enemy=9) then flavour_text2+="twisting and rusting everything it touches.  ";
	    if (obj_ncombat.enemy!=9) then flavour_text2+="boiling and putrifying flesh.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Wave of Change"){p_type="attack";p_rang=3;p_tar=3;p_spli=1;p_att=220;p_arp=0;p_duration=0;
	    flavour_text2="- a wispy cone of warp energy reaches outward, twisting and morphing all that it touches.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Insect Swarm"){p_type="attack";p_rang=3;p_tar=3;p_spli=1;p_att=500;p_arp=1;p_duration=0;
	    var rah;rah=choose(1,2);
	    if (rah=1) then flavour_text2="- a massive, black cloud of insects spew from his body.  At once they begin burrowing into your foes.  ";
	    if (rah=2) then flavour_text2="- rank, ichory insects spew forth from his body at your foes.  They begin burrowing through flesh and armour alike.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Blood Dementia"){
	    p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  He goes absolutely nuts, screaming and raging, his mind and body pulsing with chaotic energy.  ";
	    // marine_dementia[unit_id]=1;
	    marine_attack[unit_id]+=2;marine_ranged[unit_id]=0;
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Putrid Vomit"){p_type="attack";p_rang=2.1;p_tar=3;p_spli=1;p_att=600;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2);
	    flavour_text2="- from in front of their mouth a stream of rancid, acidic vomit spews forth at tremendous pressure, splashing over his foes.  ";
	    if (obj_ncombat.enemy=9) then p_att=450;
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Warp Bolts"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=300;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2,3);
	    if (rah=1) then flavour_text2="- several bolts of purple warp energy appear and are flung at the enemy.  ";
	    if (rah=2) then flavour_text2="- he launches a series of rapid warp bolts at the enemy.  ";
	    if (rah=3) then flavour_text2="- three oozing, shifting bolts of warp energy fly outward from his palms.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Warp Beam"){p_type="attack";p_rang=8;p_tar=4;p_spli=1;p_att=600;p_arp=1;p_duration=0;
	    flavour_text2="- a massive beam of purple warp energy shoots forth.  All that it touches is consumed.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Rainbow Beam"){p_type="attack";p_rang=10;p_tar=3;p_spli=1;p_att=500;p_arp=1;p_duration=0;
	    flavour_text2="- a massive beam of warp energy hisses at the enemy, the crackling energy shifting through every color imaginable sickeningly fast.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Hysterical Frenzy"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=999;
	    if (obj_ncombat.player_forces>1) then flavour_text2=".  Warp energy infuses his body, and several other marines, frenzying them into sensation-seeking destruction.  ";
	    if (obj_ncombat.player_forces=1) then flavour_text2=".  Warp energy infuses his body, frenzying him into sensation-seeking destruction.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Symphony of Pain"){p_type="attack";p_rang=2.1;p_tar=3;p_spli=1;p_att=750;p_arp=1;p_duration=0;
	    flavour_text2="- mouth stretching unnaturally wide, before letting out a hellish shriek.  ";
	    var rah;rah=choose(1,2);
	    if (rah=1) then flavour_text2="The air rumbles and shifts at the sheer magnitude of the sound.  ";
	    if (rah=2) then flavour_text2="Armour and flesh tear alike are torn apart by volume of the howl.  ";
	    if (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}










	if (power_name="gather_energy"){
	    p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=0;
	    if (obj_ncombat.big_boom<1) then flavour_text2=" begins to gather psychic energy.";
	    if (obj_ncombat.big_boom>=1) then flavour_text2=" continues to gather psychic energy.";
	    obj_ncombat.big_boom+=1;
	}
	if (power_name="gather_energy") and (obj_ncombat.big_boom=3) then power_name="Imperator Maior";

	if (power_name="Imperator Maior"){obj_ncombat.big_boom=0;
	    p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=1000;p_arp=1;p_duration=0;
	    flavour_text2="- he unleashes all of the gathered energy in a massive psychic blast.  ";
	}





	// target       0: self     1: ally     2: ally vehicle     3: enemy       4: enemy vehicle
	if (power_name="Minor Smite"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=160;p_arp=0;p_duration=0;
	    flavour_text2="- a coil of warp energy lashes out at the enemy.  ";
	    if (binders=true) then flavour_text2="- a green, sickly coil of energy lashes out at the enemy.  ";
	}
	if (power_name="Smite"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=260;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2,3);
	    if (rah=1) then flavour_text2="- a blast of warp energy smashes into the enemy.  ";
	    if (rah=2) then flavour_text2="- warp lightning crackles and leaps to the enemy.  ";
	    if (rah=3) then flavour_text2="- a brilliant bolt of lightning crashes into the enemy.  ";
	    if (binders=true) and (rah=1) then flavour_text2="-a green blast of sorcery smashes into the enemy.  ";
	    if (binders=true) and (rah>=2) then flavour_text2="-a wave of green fire launches forth, made up of hideous faces and claws.  ";
	}
	if (power_name="Force Dome"){p_type="buff";p_rang=1;p_tar=1;p_spli=0;p_att=0;p_arp=0;p_duration=2;
	    flavour_text2=".  An oozing, shifting dome of pure energy appears, covering your forces.";
	    if (binders=true) then flavour_text2=".  An oozing, shifting dome of sorcerous energy appears, covering your forces.";
	    if (binders=true) and (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Machine Curse"){p_type="attack";p_rang=5;p_tar=4;p_spli=0;p_att=300;p_arp=1;p_duration=0;
	    flavour_text2="- the machine spirit within an enemy vehicle is roused.  ";
	}
	if (power_name="Avenge"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=500;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2);
	    if (rah=1) then flavour_text2="- a destructive avatar of rolling flame crashes into the enemy.  ";
	    if (rah=2) then flavour_text2="- a massive conflagration rises up and then crashes down upon the enemy.  ";
	    if (binders=true) and (rah=1) then flavour_text2="- a hideous being of rolling flame crashes into the enemy.  ";
	    if (binders=true) and (rah=2) then flavour_text2="- a massive conflagration rises up and then crashes down upon the enemy.  ";
	}
	if (power_name="Quickening"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  Gaining precognitive powers, he is better able to avoid enemy blows.";
	}
	if (power_name="Might of the Ancients"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  His physical power and might is increased to unimaginable levels.";
	}
	if (power_name="Vortex of Doom"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=800;p_arp=1;p_duration=0;
	    flavour_text2="- a hole between real and warp space is torn open with deadly effect.  ";
	    if (binders=true) then flavour_text2="- a hole bewteen realspace and the warp is torn, unleashing a myriad of sorcerous energies.  ";
	    if (binders=true) and (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}


	if (power_name="Breathe Fire"){p_type="attack";p_rang=3;p_tar=3;p_spli=0;p_att=200;p_arp=-1;p_duration=0;
	    flavour_text2="- a bright jet of flame shoots forth at the enemy.  ";
	    if (binders=true) then flavour_text2="- a greenish, eery jet of flame shoots forth at the enemy.  ";
	}
	if (power_name="Fiery Form"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  Hissing flames appear and roar around the marine, threatening nearby foes.  ";
	    if (binders=true) then flavour_text2=".  Hideous, eery beings of warp fire begin to dance around the marine, threatening nearby foes.  ";
	}
	if (power_name="Fire Shield"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  Orange sheets of fire shimmer around your forces, protecting them.  ";
	    if (binders=true) then flavour_text2="-  Purple sheets of warp fire shimmer around your forces, protecting them.  ";
	}
	if (power_name="Inferno"){p_type="attack";p_rang=4;p_tar=3;p_spli=1;p_att=600;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2);
	    if (rah=1) then flavour_text2="- a massive conflagration rises up and then crashes down upon the enemy.  ";
	    if (rah=2) then flavour_text2="- after breathing deeply a massive jet of flame is unleashed.  Smoke billows into the sky.  ";
	    if (binders=true) and (rah=1) then flavour_text2="- a hideous being of rolling flame crashes into the enemy.  ";
	    if (binders=true) and (rah=2) then flavour_text2="- a massive conflagration rises up and then crashes down upon the enemy.  ";
	}
	if (power_name="Sun Burst"){p_type="attack";p_rang=8;p_tar=4;p_spli=1;p_att=200;p_arp=1;p_duration=0;
	    flavour_text2="- a crackling, hissing beam of purple-red flame shoots from him.  ";
	    if (binders=true) then flavour_text2="- a crackling, hissing beam of purple warp shoots from him.  ";
	    if (binders=true) and (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}
	if (power_name="Molten Beam"){p_type="attack";p_rang=8;p_tar=4;p_spli=1;p_att=600;p_arp=1;p_duration=0;
	    flavour_text2="- a white-blue beam, blinding to behold, shoots forth.  All that it touches turns to slag.  ";
	    if (binders=true) then flavour_text2="- a massive beam of purple warp energy shoots forth.  All that it touches is consumed.  ";
	    if (binders=true) and (obj_ncombat.sorcery_seen<2) and (obj_ncombat.present_inquisitor=1) then obj_ncombat.sorcery_seen=1;
	}

	if (power_name="Blood Boil"){p_type="attack";p_rang=3;p_tar=3;p_spli=0;p_att=220;p_arp=0;p_duration=0;
	    flavour_text2="- accelerating the pulse and blood pressure of his foes.  ";
	}
	if (power_name="Iron Arm"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  His flesh is transmuted into a form of living metal.  ";
	}
	if (power_name="Endurance"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  He reaches into nearby allies, restoring their flesh and kniting wounds.  ";
	}
	if (power_name="Regenerate"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=0;
	    flavour_text2=".  His flesh shimmers and twists back together, sealing up wounds and damage.  ";
	}
	if (power_name="Haemorrhage"){p_type="attack";p_rang=3;p_tar=3;p_spli=1;p_att=800;p_arp=0;p_duration=0;
	    flavour_text2="- reaching inside of his foes and lighting their flesh aflame.  ";
	}

	if (power_name="Crush"){p_type="attack";p_rang=4;p_tar=3;p_spli=0;p_att=190;p_arp=0;p_duration=0;
	    flavour_text2="- his foes are entraped in a crushing mass of force.  ";
	}
	if (power_name="Shockwave"){p_type="attack";p_rang=4;p_tar=3;p_spli=1;p_att=280;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2,3);
	    flavour_text2="- a massive wave of force smashes aside his foes.  ";
	}
	if (power_name="Telekinetic Dome"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  Invisible currents of force surround him, ready to deflect bolts or blows.  ";
	}
	if (power_name="Spatial Distortion"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  His blows, once thrown, are now able to become impossibly heavy and forceful.  ";
	}


	if (power_name="Living Lightning"){p_type="attack";p_rang=5;p_tar=3;p_spli=0;p_att=160;p_arp=0;p_duration=0;
	    flavour_text2="- arcs of lightning shoot from hand and strike his foes.  ";
	}
	if (power_name="Stormbringer"){p_type="buff";p_rang=1;p_tar=1;p_spli=0;p_att=0;p_arp=0;p_duration=2;
	    flavour_text2=".  A vortex of ice and winds crackle into existance, covering your forces.";
	}
	if (power_name="Murderous Hurricane"){p_type="attack";p_rang=4;p_tar=3;p_spli=1;p_att=320;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2,3);
	    flavour_text2="- a mighty winter gale billows forth, shredding and freezing flesh.  ";
	}
	if (power_name="Fury of the Wolf Spirits"){p_type="attack";p_rang=3;p_tar=3;p_spli=1;p_att=440;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2);
	    if (rah=1) then flavour_text2="- a pair of Thunderwolf revenants sprint outward, running down and overwhelming foes.  ";
	    if (rah=2) then flavour_text2="- ghostly visages of Freki and Geri launch into his foes, overwhelming them.  ";
	}
	if (power_name="Thunderclap"){p_type="attack";p_rang=1.1;p_tar=3;p_spli=1;p_att=600;p_arp=0;p_duration=0;
	    flavour_text2="- smashing his gauntlets together and unleashing a mighty shockwave.  ";
	}
	if (power_name="Jaws of the World Wolf"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=800;p_arp=1;p_duration=0;
	    flavour_text2="- chasms open up beneath his foes, swallowing them down and crushing them.  ";
	}



	if (power_name="Avenge"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=500;p_arp=0;p_duration=0;
	    var rah;rah=choose(1,2);
	    if (rah=1) then flavour_text2="- a destructive avatar of rolling flame crashes into the enemy.  ";
	    if (rah=2) then flavour_text2="- a massive conflagration rises up and then crashes down upon the enemy.  ";
	}
	if (power_name="Quickening"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  Gaining precognitive powers, he is better able to avoid enemy blows.";
	}
	if (power_name="Might of the Ancients"){p_type="buff";p_rang=0;p_tar=0;p_spli=0;p_att=0;p_arp=0;p_duration=3;
	    flavour_text2=".  His physical power and might is increased to unimaginable levels.";
	}
	// if (power_name="Vortex of Doom"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=800;p_arp=800;p_duration=0;
	//     flavour_text2="- a hole between real and warp space is torn open with deadly effect.  ";
	// }
	var has_force_weapon=false;
	if (is_struct(weapon_one)){
		if weapon_one.has_tag("force"){
			has_force_weapon=true;
		}
	}

	if (is_struct(weapon_two)){
		if weapon_two.has_tag("force"){
			has_force_weapon=true;
		}
	}

	if (has_force_weapon){
		if (unit.weapon_one()=="Force Staff" || unit.weapon_two()=="Force Staff"){
			if (p_att>0) then p_att=round(p_att)*2;
			if (p_rang>0) then p_rang=round(p_rang)*1.5;
		}
		else{
			if (p_att>0) then p_att=round(p_att)*1.25;
			if (p_rang>0) then p_rang=round(p_rang)*1.25;
		}
	}

	if (binders==true) and (p_type=="attack"){
	    if (p_att>0) then p_att=round(p_att)*1.15;
	    // if (p_arp>0) then p_arp=round(p_arp)*1.15;
	    if (p_rang>0) then p_rang=round(p_rang)*1.2;
	}
	if (marine_type[unit_id]="Chapter Master"){
	    if (unit.has_trait("paragon")){
	        if (p_att>0) then p_att=round(p_att)*1.25;
	        // if (p_arp>0) then p_arp=round(p_arp)*1.25;
	        if (p_rang>0) then p_rang=round(p_rang)*1.25;
	    }
	}


	flavour_text1=$"{unit.name_role()} casts '{power_name}'"
	if (book_powers!="") and (book_roll<=33) and (power_name!="Imperator Maior") and (power_name!="gather_energy"){
	    flavour_text1=unit.name_role();
	    if (string_char_at(flavour_text1,string_length(flavour_text1))="s") then flavour_text1+="' tome ";
	    if (string_char_at(flavour_text1,string_length(flavour_text1))!="s") then flavour_text1+="'s tome ";
	    flavour_text1+="confers knowledge upon him.  He casts '"+string(power_name)+"'";
    
	    if (tome_bad>0){
	        var tome_roll=irandom(99)+1;
	        if (tome_roll<=10) and (tome_bad=1) then unit.corruption+=choose(1,2);
	        if (tome_roll<=20) and (tome_bad>1) then unit.corruption+=choose(3,4,5);
	    }
    
	}

	if (power_name="gather_energy") then flavour_text1=unit.name_role()+" ";
	if (power_name="Imperator Maior") then flavour_text1=unit.name_role()+" casts '"+string(power_name)+"'";





	// determine target here
	var good=0,good2=0,peril1=0,peril2=0,perils=0;
	var heh=choose(0,0,0,2);

	peril1=(marine_exp[unit_id]*-0.03)+9;
	// peril1+=30;
	if (string_count("Hood",marine_gear[unit_id])>0) then peril1-=5;
	if (peril1<1) then peril1=1;
	if (scr_has_disadv("Warp Touched")) then peril1+=2;
	if (marine_type[unit_id]="Chapter Master") and (peril1>1) then peril1=round(peril1/2);
	if (scr_has_disadv("Shitty Luck")) then peril1+=3;

	if (book_powers!="") then peril1+=tome_bad;
	if (string_count("daemon",book_powers)>0) then peril1+=3;

	peril1+=obj_ncombat.global_perils;
	peril2=floor(random(100))+1;
	peril3=floor(random(100))+1;

	if (binders=true){heh=choose(0,0,0,0,0,2);peril3+=40;if (peril3<=47) then peril3=48;}// I hope you like demons



	// show_message("Peril of the Warp Chance: "+string(peril1)+"#Roll: "+string(peril2));
	// peril2=1;peril3=88;
	if (peril2<=peril1) and (heh=2){
	    if (obj_ncombat.sorcery_seen=1) then obj_ncombat.sorcery_seen=0;

	    p_type="perils";
	    flavour_text3="";
	    if (scr_has_disadv("Warp Touched")) then peril3+=20;
	    if (scr_has_disadv("Shitty Luck")) then peril3+=25;

	    if (string_count("daemon",book_powers)>0) then peril1+=25;


	    flavour_text1=$"{unit.name_role()} suffers Perils of the Warp!  ";
	    flavour_text2=scr_perils_table(peril3, unit, psy_discipline, power_name,unit_id, book_powers);
    
        if (unit.hp() < 0){//TODO create is_dead function to remove repeats of this log
            if (marine_dead[unit_id] == 0) {
                marine_dead[unit_id] = 1;
                obj_ncombat.player_forces -= 1;
            }
            
            // Track the lost unit
            var existing_index = array_get_index(lost, marine_type[unit_id]);
            if (existing_index != -1) {
                lost_num[existing_index] += 1;
            } else {
                array_push(lost, marine_type[unit_id]);
                array_push(lost_num, 1);
            }

            // Update unit counts
            var armour_data = unit.get_armour_data();
            var is_dread = false;
            if (is_struct(armour_data)){
                 is_dread = armour_data.has_tag("dreadnought");
            }
            if (is_dread) {
                dreads -= 1;
            } else {
                men -= 1;
            }

            // Trigger red thirst
            if (obj_ncombat.red_thirst == 1 && marine_type[unit_id] != "Death Company") {
                obj_ncombat.red_thirst = 2;
            }

	    }
    
	    obj_ncombat.messages+=1;
	    obj_ncombat.message[obj_ncombat.messages]=flavour_text1+flavour_text2+flavour_text3;
	    // if (enemy5.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
	    obj_ncombat.message_sz[obj_ncombat.messages]=999+(0.5-(obj_ncombat.messages/100));
	    obj_ncombat.message_priority[obj_ncombat.messages]=0;
	}

	if (obj_ncombat.sorcery_seen=1) then obj_ncombat.sorcery_seen=2;

	if (p_type="buff") or (power_name="gather_energy"){
		var marine_index;
		var _random_marine_list = [];
        for (var i=0;i<array_length(unit_struct);i++){
        	array_push(_random_marine_list, i);
        }
        _random_marine_list = array_shuffle(_random_marine_list);

	    if (power_name="Force Dome") or (power_name="Stormbringer"){
	        var buf=9;
	        for (var i=0;i<array_length(_random_marine_list);i++){
	        	if (buf<=0) then break;
	        	marine_index = _random_marine_list[i];
	        	if (!marine_dead[marine_index]) and (!marine_mshield[marine_index]){
            		buf-=1;
            		marine_mshield[marine_index]=2;
	        	}
	        }
	    }

	    if (power_name="Quickening"){
	    	if (marine_quick[unit_id]<3) then marine_quick[unit_id]=3;
	    }
	    if (power_name="Might of the Ancients"){if (marine_might[unit_id]<3) then marine_might[unit_id]=3;}
    
	    if (power_name="Fiery Form"){if (marine_fiery[unit_id]<3) then marine_fiery[unit_id]=3;}
	    if (power_name="Fire Shield"){
	        var buf=9;
	        for (var i=0;i<array_length(_random_marine_list);i++){
	        	if (buf<=0) then break;
	        	marine_index = _random_marine_list[i];
	        	if (!marine_dead[marine_index]) and (!marine_fshield[marine_index]){
            		buf-=1;
            		marine_fshield[marine_index]=2;
	        	}
	        }	    	
	    }
    
	    if (power_name="Iron Arm") then marine_iron[unit_id]+=1;
	    if (power_name="Endurance"){
	    	
	        var buf=5;h=0;
	        for (var i=0;i<array_length(_random_marine_list);i++){
	        	if (buf<=0) then break;
	        	marine_index = _random_marine_list[i];
	        	if (!marine_dead[marine_index]){
	        		var _buff_unit = unit_struct[marine_index];
	        		if (_buff_unit.hp()<_buff_unit.max_health()){
	        			buf-=1;
	        			_buff_unit.add_or_sub_health(20);
	        		}
	        	}
	        }	        
	    }
	    if (power_name="Hysterical Frenzy"){
	        var buf=5;h=0;
	        for (var i=0;i<array_length(_random_marine_list);i++){
	        	if (buf<=0) then break;
	        	marine_index = _random_marine_list[i];
	        	if (!marine_dead[marine_index]) and (marine_attack[marine_index]<2.5){
            		buf-=1;
            		marine_attack[marine_index]+=1.5;
            		marine_defense[marine_index]-=0.15;
	        	}
	        }
	    }
	    if (power_name="Regenerate"){
	    	unit.add_or_sub_health(choose(2,3,4)*5);
	    	if (unit.hp()>unit.max_health()) then unit.update_health(unit.max_health())}

	    if (power_name="Telekinetic Dome"){
	    	if (marine_dome[unit_id]<3) then marine_dome[unit_id]=3;
	    }
	    if (power_name="Spatial Distortion"){
	    	if (marine_spatial[unit_id]<3) then marine_spatial[unit_id]=3;
	    }
    
	    /*obj_ncombat.newline=string(flavour_text1)+string(flavour_text2)+string(flavour_text3);
	    obj_ncombat.newline_color="blue";
	    with(obj_ncombat){scr_newtext();}*/
    
	    obj_ncombat.messages+=1;
	    obj_ncombat.message[obj_ncombat.messages]=flavour_text1+flavour_text2+flavour_text3;
	    // if (enemy5.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
	    obj_ncombat.message_sz[obj_ncombat.messages]=0.5-(obj_ncombat.messages/100);
	    obj_ncombat.message_priority[obj_ncombat.messages]=0;
    
	    if (power_name="gather_energy"){obj_ncombat.message_priority[obj_ncombat.messages]=135;obj_ncombat.message_sz[obj_ncombat.messages]=300-(obj_ncombat.messages/100);}
	    // obj_ncombat.alarm[3]=2;
	}




	var shot_web;shot_web=1;
	if (p_type="attack") and (power_name="Imperator Maior") then shot_web=3;

	if (shot_web>1){
	    obj_ncombat.messages+=1;
	    obj_ncombat.message[obj_ncombat.messages]=flavour_text1+flavour_text2;
	    obj_ncombat.message_priority[obj_ncombat.messages]=136;
	    obj_ncombat.message_sz[obj_ncombat.messages]=2500;
	}



	flavour_text_4="";

	repeat(shot_web){
	    if (shot_web>1) then flavour_text3="";

	    if (p_type="attack"){
	        if (good=0){
        
	            repeat(10){
	                if (good2=0) and (instance_exists(obj_enunit)){
	                    enemy5=instance_nearest(x,y,obj_enunit);
	                    var s;s=0;
                    
	                    repeat(20){
	                        if (point_distance(x,y,enemy5.x,enemy5.y)<(p_rang*10)){
	                            if (p_tar=3) and (good=0){s+=1;
	                                if (enemy5.dudes_hp[s]>0) and (dudes_vehicle[s]=0) then good=s;
	                            }
	                            if (p_tar=4) and (good=0){s+=1;
	                                if (enemy5.dudes_hp[s]>0) and (dudes_vehicle[s]=1) then good=s;
	                            }
	                        }
	                    }
	                    if (good=0) then instance_deactivate_object(enemy5);
	                    if (good!=0) then good2=good;
	                }
	            }
            
	            var onk;onk=0;
	            if (p_tar=3) and (good=0) and (good2=0) and (p_arp>0) and (onk=0){p_tar=4;onk=1;}
	            if (p_tar=4) and (good=0) and (good2=0) and (p_att>0) and (onk=0){p_tar=3;onk=1;}
            
	            instance_activate_object(obj_enunit);
            
	            repeat(10){
	                if (good2=0) and (instance_exists(obj_enunit)){
	                    enemy5=instance_nearest(x,y,obj_enunit);
	                    var s;s=0;
                    
	                    repeat(20){
	                        if (point_distance(x,y,enemy5.x,enemy5.y)<(p_rang*10)){
	                            if (p_tar=3) and (good=0){s+=1;
	                                if (enemy5.dudes_hp[s]>0) and (dudes_vehicle[s]=0) then good=s;
	                            }
	                            if (p_tar=4) and (good=0){s+=1;
	                                if (enemy5.dudes_hp[s]>0) and (dudes_vehicle[s]=1) then good=s;
	                            }
	                        }
	                    }
	                    if (good=0) then instance_deactivate_object(enemy5);
	                    if (good!=0) then good2=good;
	                }
	            }
            
	            instance_activate_object(obj_enunit);
	        }
    
    
    
	    // show_message(string(flavour_text1)+string(flavour_text2)+"#"+string(enemy5));
        
	        if (good2>0){
	            var damage_type,stap;
	            damage_type="att";stap=0;
            
	            damage_type="att";
	            if (p_arp>0) and (p_att>=100) then damage_type="arp";
            
	            // if (p_tar=3) then damage_type="att";
	            // if (p_tar=4) then damage_type="arp";
            
            
	            if (damage_type="att") and (stap=0) and (instance_exists(enemy5)) and (enemy5.dudes_num[good2]>0){
	                var a,b,c,eac;eac=enemy5.dudes_ac[good2];
	                a=p_att;// Average damage
                
	                // b=a-enemy5.dudes_ac[good2];// Average after armour
                
	                if (enemy5.dudes_vehicle[good2]=0){
	                    if (p_arp=1) then eac=0;
	                    if (p_arp=-1) then eac=eac*6;
	                }
	                if (enemy5.dudes_vehicle[good2]=1){
	                    if (p_arp=-1) then eac=a;
	                    if (p_arp=0) then eac=eac*6;
	                    if (p_arp=-1) then eac=a;
	                }
	                b=a-eac;if (b<=0) then b=0;
                
	                c=b*1;// New damage
                
                
	                if (enemy5.dudes_hp[good2]=0){
	                    show_message(power_name);
	                    show_message("Getting a 0 health error for target "+string(enemy5)+", dudes "+string(good2));
	                    show_message("Dudes: "+string(enemy5.dudes[good2])+", Number: "+string(enemy5.dudes_num[good2]));
	                    show_message("Damage: "+string(c));
	                    show_message(string(enemy5.dudes_hp[good2]));
	                }
                
	                var casualties,ponies,onceh;onceh=0;ponies=0;
	                if (p_spli=0) then casualties=min(floor(c/enemy5.dudes_hp[good2]),1);
	                if (p_spli!=0) then casualties=floor(c/enemy5.dudes_hp[good2]);
                
	                ponies=enemy5.dudes_num[good2];
	                if (enemy5.dudes_num[good2]=1) and ((enemy5.dudes_hp[good2]-c)<=0){casualties=1;}
                
	                if (enemy5.dudes_num[good2]-casualties<0) then casualties=ponies;
	                if (casualties<0) then casualties=0;
                
	                if (enemy5.dudes_num[good2]=1) and (c>0) then enemy5.dudes_hp[good2]-=c;// Need special flavor here for just damaging
                
	                if (casualties>1) then flavour_text3=string(casualties)+" "+string(enemy5.dudes[good2])+" are killed.";
	                if (casualties=1) then flavour_text3="A "+string(enemy5.dudes[good2])+" is killed.";
	                if (casualties=0) then flavour_text3="The "+string(enemy5.dudes[good2])+" survives the attack.";

                
                
	                if (casualties>0){
	                    var duhs;
	                    duhs=enemy5.dudes[good2];
	                    if (obj_ncombat.battle_special="WL10_reveal") or (obj_ncombat.battle_special="WL10_later"){
	                        if (duhs="Veteran Chaos Terminator") then obj_ncombat.chaos_angry+=casualties*2;
	                        if (duhs="Veteran Chaos Chosen") then obj_ncombat.chaos_angry+=casualties;
	                        if (duhs="Greater Daemon of Slaanesh") then obj_ncombat.chaos_angry+=casualties*5;
	                        if (duhs="Greater Daemon of Tzeentch") then obj_ncombat.chaos_angry+=casualties*5;
	                    }
	                }
                
	                obj_ncombat.messages+=1;
	                obj_ncombat.message[obj_ncombat.messages]=flavour_text1+flavour_text2+flavour_text3;
	                if (shot_web>1) then obj_ncombat.message[obj_ncombat.messages]=flavour_text3;
                
	                    obj_ncombat.message_sz[obj_ncombat.messages]=casualties+1;
	                // if (enemy5.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
	                // else{obj_ncombat.message_sz[obj_ncombat.messages]=(casualties)+(0.5-(obj_ncombat.messages/100));}
	                obj_ncombat.message_priority[obj_ncombat.messages]=0;
	                if (shot_web>1){
	                    obj_ncombat.message_priority[obj_ncombat.messages]=135;
	                    obj_ncombat.message_sz[obj_ncombat.messages]=2000+obj_ncombat.messages;
	                }
                
	                // obj_ncombat.alarm[3]=2;
                
	                if (casualties>=1){
	                    enemy5.dudes_num[good2]-=casualties;
	                    obj_ncombat.enemy_forces-=casualties;
	                }
	            }
            
	            if (damage_type="arp") and (stap=0) and (instance_exists(enemy5)) and (enemy5.dudes_num[good2]>0){
	                var a,b,c,eac;eac=enemy5.dudes_ac[good2];
	                a=p_att;// Average damage
	                // b=a-enemy5.dudes_ac[good2];// Average after armour
                
	                if (enemy5.dudes_vehicle[good2]=0){
	                    if (p_arp=1) then eac=0;
	                    if (p_arp=-1) then eac=eac*6;
	                }
	                if (enemy5.dudes_vehicle[good2]=1){
	                    if (p_arp=-1) then eac=a;
	                    if (p_arp=0) then eac=eac*6;
	                    if (p_arp=-1) then eac=a;
	                }
	                b=a-eac;if (b<=0) then b=0;
                
	                c=b*1;// New damage
                
                
	                if (enemy5.dudes_hp[good2]=0){
	                    show_message(power_name);
	                    show_message("Getting a 0 health error for target "+string(enemy5)+", dudes "+string(good2));
	                    show_message("Dudes: "+string(enemy5.dudes[good2])+", Number: "+string(enemy5.dudes_num[good2]));
	                    show_message("Damage: "+string(c));
	                    show_message(string(enemy5.dudes_hp[good2]));
	                }
                
	                var casualties,ponies,onceh;onceh=0;ponies=0;
	                if (p_spli=0) then casualties=min(floor(c/enemy5.dudes_hp[good2]),1);
	                if (p_spli!=0) then casualties=floor(c/enemy5.dudes_hp[good2]);
                
	                ponies=enemy5.dudes_num[good2];
	                if (enemy5.dudes_num[good2]=1) and ((enemy5.dudes_hp[good2]-c)<=0){casualties=1;}
                
	                if (enemy5.dudes_num[good2]-casualties<0) then casualties=ponies;
	                if (casualties<0) then casualties=0;
                
	                if (enemy5.dudes_num[good2]=1) and (c>0) then enemy5.dudes_hp[good2]-=c;// Need special flavor here for just damaging
                
	                if (casualties>1) then flavour_text3=string(casualties)+" "+string(enemy5.dudes[good2])+" are destroyed.";
	                if (casualties=1) then flavour_text3="A "+string(enemy5.dudes[good2])+" is destroyed.";
	                if (casualties=0) then flavour_text3="The "+string(enemy5.dudes[good2])+" survives the attack.";
                
	                /*obj_ncombat.newline=string(flavour_text1)+string(flavour_text2)+string(flavour_text3);
	                obj_ncombat.newline_color="blue";
	                with(obj_ncombat){scr_newtext();}*/
                
	                if (casualties>0){
	                    var duhs;
	                    duhs=enemy5.dudes[good2];
	                    if (obj_ncombat.battle_special="WL10_reveal") or (obj_ncombat.battle_special="WL10_later"){
	                        if (duhs="Veteran Chaos Terminator") then obj_ncombat.chaos_angry+=casualties*2;
	                        if (duhs="Veteran Chaos Chosen") then obj_ncombat.chaos_angry+=casualties;
	                        if (duhs="Greater Daemon of Slaanesh") then obj_ncombat.chaos_angry+=casualties*5;
	                        if (duhs="Greater Daemon of Tzeentch") then obj_ncombat.chaos_angry+=casualties*5;
	                    }
	                }
                
	                obj_ncombat.messages+=1;
	                obj_ncombat.message[obj_ncombat.messages]=flavour_text1+flavour_text2+flavour_text3;
	                if (shot_web>1) then obj_ncombat.message[obj_ncombat.messages]=flavour_text3;
                
	                    obj_ncombat.message_sz[obj_ncombat.messages]=casualties+1;
	                // if (enemy5.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
	                // else{obj_ncombat.message_sz[obj_ncombat.messages]=(casualties)+(0.5-(obj_ncombat.messages/100));}
	                obj_ncombat.message_priority[obj_ncombat.messages]=0;
	                if (shot_web>1){
	                    obj_ncombat.message_priority[obj_ncombat.messages]=135;
	                    obj_ncombat.message_sz[obj_ncombat.messages]=2000+obj_ncombat.messages;
	                }
	                // obj_ncombat.alarm[3]=2;
                
	                if (casualties>=1){
	                    enemy5.dudes_num[good2]-=casualties;
	                    obj_ncombat.enemy_forces-=casualties;
	                }
	            }
            
	            if (stap=0) then with(enemy5){
	                var j,good,open;
	                j=0;good=0;open=0;
	                repeat(20){j+=1;
	                    if (dudes_num[j]<=0){
	                        dudes[j]="";
	                        dudes_special[j]="";
	                        dudes_num[j]=0;
	                        dudes_ac[j]=0;
	                        dudes_hp[j]=0;
	                        dudes_vehicle[j]=0;
	                        dudes_damage[j]=0;
	                    }
	                    if (dudes[j]="") and (dudes[j+1]!=""){
	                        dudes[j]=dudes[j+1];
	                        dudes_special[j]=dudes_special[j+1];
	                        dudes_num[j]=dudes_num[j+1];
	                        dudes_ac[j]=dudes_ac[j+1];
	                        dudes_hp[j]=dudes_hp[j+1];
	                        dudes_vehicle[j]=dudes_vehicle[j+1];
	                        dudes_damage[j]=dudes_damage[j+1];
                        
	                        dudes[j+1]="";
	                        dudes_special[j+1]="";
	                        dudes_num[j+1]=0;
	                        dudes_ac[j+1]=0;
	                        dudes_hp[j+1]=0;
	                        dudes_vehicle[j+1]=0;
	                        dudes_damage[j+1]=0;
	                    }
	                }
	                j=0;
	            }
	            if (enemy5.men+enemy5.veh+enemy5.medi=0) and (enemy5.owner!=1) {
	                with(enemy5){instance_destroy();}
	            }
	        }
        
	    }

    
	}// End repeat


	obj_ncombat.alarm[3]=5;


}
