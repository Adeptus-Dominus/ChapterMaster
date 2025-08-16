function scr_ruins_reward(star_system, planet, _ruins) {
	
	var ruins_type = _ruins.ruins_race;
	
	//if there is gear from previoulsy killed marines retrieve instead of a standard reward
	if (_ruins.unrecovered_items != false){
		_ruins.recover_from_dead();
	} else {

	// star_system: world object
	// planet: planet
	// ruins_type: ruins_type
	var dice=roll_dice_chapter(1, 100, "high");
	var loot="";

	if (dice>0) and (dice<=35) then loot="req";// 
	if (dice>35) and (dice<=50) then loot="gear";// 
	if (dice>50) and (dice<=60) then loot="artifact";// 
	if (dice>60) and (dice<=70) then loot="stc";// 
	if (dice>70) and (dice<=85) then loot="wild_card";// 
	if (dice>85) and (dice<=97) then loot="bunker";// 
	if (dice>97) and (dice<=99) then loot="fortress";// 
	if (dice>99) and (dice<=150) then loot="starship";// 

	if ((loot=="wild_card")){
		if (ruins_type=1) then loot="gene_seed";// 
		if (ruins_type=2) then loot="req";// 
		if (ruins_type=6) then loot="gear";// 
		if (ruins_type>=10) then loot="req";// 
	}

	var _chosen_ship = -1;

	var _fleet = scr_orbiting_player_fleet(star_system);
	if (instance_exists(_fleet))){
		var _ships = fleet_full_ship_array(_fleet);
		if (array_length(_ships)){
			_chosen_ship = _ships[0];
		}
	}
	scr_event_log("",$"The Ancient Ruins on {planet_numeral_name(planet,star_system)} has been explored.", star_system.name);

	// loot="artifact";

	if (loot == "req"){// Requisition
	    var reqi=round(random_range(30,60)+1)*10;
	    obj_controller.requisition+=reqi;
   
	    var pop=instance_create(0,0,obj_popup);
	    pop.image="ancient_ruins";
	    pop.title="Ancient Ruins: Resources";
	    pop.text="My lord, your battle brothers have located several precious minerals and supplies within the ancient ruins.  Everything was taken and returned to the ship, granting "+string(reqi)+" Requisition.";
	}
	else if (loot == "artifact"){
		if (_chosen_ship>-1){
	        var last_artifact = scr_add_artifact("random", "random", 4, planet, _chosen_ship + 500);
	    
		    scr_event_log("","Artifact recovered from Ancient Ruins.");
		    var pop = instance_create(0,0,obj_popup);
		    pop.image = "ancient_ruins";
		    pop.title = "Ancient Ruins: Artifact";
		    pop.text = $"An Artifact has been found within the ancient ruins.  It appears to be a {obj_ini.artifact[last_artifact]} but should be brought to the Lexicanum and identified posthaste.";
		} else {
		    var pop = instance_create(0,0,obj_popup);
		    pop.image = "ancient_ruins";
		    pop.title = "Ancient Ruins: Artifact Lost";
		    pop.text = "An Artifact was discovered within the ancient ruins, but no suitable ship was available for its retrieval. The sacred object remains unclaimed.";
		}
		with(obj_star_select){ instance_destroy(); }
		with(obj_fleet_select){ instance_destroy(); }
	}

	else if (loot="stc"){
	    scr_add_stc_fragment();// STC here
	    var pop=instance_create(0,0,obj_popup);
	    pop.image="ancient_ruins";
	    pop.title="Ancient Ruins: STC Fragment";
	    pop.text="Praise the Omnissiah, an STC Fragment has been retrieved from the ancient ruins and safely stowed away.  It is ready to be decrypted or gifted at your convenience.";
	    scr_event_log("","STC Fragment recovered from Ancient Ruins.");
	}
	else if (loot="gear"){
	    var wep1="",wen1=0,wep2="",wen2=0,wep3="",wen3=0,wep4="",wen4=0,wep5="",wen5=0,wep6="",wen6=0,wep7="",wen7=0,wep8="",wen8=0;


//Fallen Terminator Squad
if (ruins_type<=2) or (ruins_type>=10){
	wep1=choose("Tartaros","Terminator Armour","Cataphractii");
	wen1=choose(1,2,3);
	wep2=choose("Tigris Combi Bolter","Volkite Charger");
	wen2=choose(1,2,);
	wep3=choose("Power Fist","Chainfist","Power Mace","Relic Blade","Power Spear","Lightning Claw","Power Scythe");
	wen3=choose(1,2,3);
	wep4=choose("Assault Cannon","Plasma Cannon",);
	wen4=choose(0,1);
	wep5=choose("Company Standard","Narthecium","Psychic Hood","Rosarius");
	wen5=choose(0,1);
	wep6=choose("Storm Shield");
	wen6=choose(1,2,3);
}
//Fallen Tactical Squad
else if (ruins_type=3){
	wep1=choose("MK3 Iron Armour","MK4 Maximus","MK5 Heresy");
	wen1=choose(3,4,5,6);
	wep2=choose("Phobos Bolter");
	wen2=choose(2,3);
	wep3=choose("Ryza Plasma Gun","Volkite Charger","Volkite Caliver");
	wen3=choose(1,2);
	wep4=choose("Primus Melta Gun", "Phaestos Flamer");
	wen4=choose(1,2);
	wep5=choose("Ryza Plasma Pistol","Phobos Bolt Pistol","Volkite Serpenta");
	wen5=choose(0,1)
	wep6=choose("Power Sword","Chain Axe","Power Axe","Power Fist");
	wen6=choose(0,1);
	wep7=choose("Company Standard","Narthecium","Psychic Hood","Rosarius");
	wen7=choose(0,1);
	wep8=choose("Bionics");
	wen8=choose(1,2,3);
}
//Fallen Devastator Squad
else if (ruins_type=4){
	wep1=choose("MK3 Iron","MK4 Maximus","MK6 Corvus");
	wen1=choose(3,4,5);
	wep2=choose("Mars Heavy Bolter");
	wen2=choose(2,3);
	wep3=choose("Mars Plasma Cannon","Volkite Culverin",);
	wen3=choose(1,2);
	wep4=choose("Ryza Las Cannon","Cthon Auto Cannon");
	wen4=choose(1,2);
	wep5=choose("Ryza Plasma Pistol","Phobos Bolt Pistol","Volkite Serpenta");
	wen5=choose(0,1)
	wep6=choose("Power Sword","Chain Axe","Power Axe","Power Fist");
	wen6=choose(0,1);
	wep7=choose("Company Standard","Narthecium","Psychic Hood","Rosarius");
	wen7=choose(0,1);
	wep8=choose("Heavy Weapons Pack");
	wen8=choose(1,2,3);
}
//Fallen Assault Squad
else if (ruins_type=5){
	wep1=choose("MK4 Maximus","MK6 Corvus","MK5 Heresy");
	wen1=choose(3,4,5);
	wep2=choose("Chainsword","Chain Axe");
	wen2=choose(2,3);
	wep3=choose("Power Sword","Power Axe","Power Fist");
	wen3=choose(1,2);
	wep4=choose("Lightning Claws ","Power Scythe");
	wen4=choose(1,2);
	wep5=choose("Ryza Plasma Pistol","Phobos Bolt Pistol","Volkite Serpenta");
	wen5=choose(0,1)
	wep6=choose("Primus Melta Gun","Phaestos Flamer");
	wen6=choose(0,1);
	wep7=choose("Company Standard","Narthecium","Psychic Hood","Rosarius");
	wen7=choose(0,1);

	wep8=choose("Serpha Jump Pack");
	wen8=choose(1,2,3);
}
//Fallen Breacher Squad
else if (ruins_type=6){
wep1=choose("MK3 Iron Armour","MK4 Maximus","MK5 Heresy");
	wen1=choose(3,4,5,6);
	wep2=choose("Primus Melta Gun");
	wen2=choose(2,3);
	wep3=choose("Ryza Plasma Gun","Volkite Charger","Volkite Caliver");
	wen3=choose(1,2);
	wep4=choose("Phobos Bolter", "Phaestos Flamer");
	wen4=choose(1,2);
	wep5=choose("Ryza Plasma Pistol","Phobos Bolt Pistol","Volkite Serpenta");
	wen5=choose(0,1)
	wep6=choose("Power Sword","Chain Axe","Power Axe","Power Fist");
	wen6=choose(0,1);
	wep7=choose("Company Standard","Narthecium","Psychic Hood","Rosarius");
	wen7=choose(0,1);
	wep8=choose("Boarding Shield");
	wen8=choose(1,2,3);
}
		
    
	    scr_add_item(wep1,wen1);
	    scr_add_item(wep2,wen2);
	    scr_add_item(wep3,wen3);
	    scr_add_item(wep4,wen4);
	    scr_add_item(wep5,wen5);
	    scr_add_item(wep6,wen6);
	    scr_add_item(wep7,wen7);
	    scr_add_item(wep8,wen8);
    
	    var pop;
	    pop=instance_create(0,0,obj_popup);
	    pop.image="ancient_ruins";
	    pop.title="Ancient Ruins: Gear";
	    pop.text="My lord, your brothers have found sealed chamber in these ruins. It bears symbols of one of the ancient legions. After your tech-marines managed to open this chamber, they've found a number of relics that can be brought back to service. They've found:  "+string(wen1)+"x "+string(wep1)+", "+string(wen2)+"x "+string(wep2)+","+string(wen3)+"x "+string(wep3)+","+string(wen4)+"x "+string(wep4)+","+string(wen5)+"x "+string(wep5)+","+string(wen6)+"x "+string(wep6)+","+string(wen7)+"x "+string(wep7)+", and "+string(wen8)+"x "+string(wep8)+" have been added to the Armamentarium.";
	}
	else if (loot="gene_seed"){// Requisition
	    var gene,pop;gene=floor(random_range(20,40))+1;
	    pop=instance_create(0,0,obj_popup);
	    pop.image="geneseed_lab";
	    pop.title="Ancient Ruins: Gene-seed";
	    pop.text="My lord, your battle brothers have located a hidden, fortified laboratory within the ruins.  Contained are a number of bio-vaults with astartes gene-seed; "+string(gene)+" in number.  Your marines are not able to determine the integrity or origin.";
	    pop.option1="Add the gene-seed to chapter vaults.";
	    pop.option2="Salvage the laboratory for requisition.";
	    pop.option3="Leave the laboratory as is.";
	    pop.estimate=gene;
	}
	else if (loot="bunker"){// Bunker
	    var gene=floor(random_range(20,40))+1,pop=instance_create(0,0,obj_popup);;
	    pop.image="ruins_bunker";
	    pop.title="Ancient Ruins: Bunker Network";
	    pop.text="Your battle brothers have found several entrances into an ancient bunker network.  Its location has been handed over to the PDF.  The planet's defense rating has increased to ";
	    pop.text+=string(min(star_system.p_fortified[planet]+1,5))+".  ";
	    if (star_system.p_fortified[planet]<5) then pop.text+="("+string(star_system.p_fortified[planet])+"+1)";
	    if (star_system.p_fortified[planet]>=5) then pop.text+="("+string(star_system.p_fortified[planet])+"+0)";
	    star_system.p_fortified[planet]=min(star_system.p_fortified[planet]+1,5);
	}
	else if (loot="fortress"){// Fortress
	    var pop,gene=floor(random_range(20,40))+1;
	    pop=instance_create(0,0,obj_popup);
	    pop.image="ruins_fort";
	    pop.title="Ancient Ruins: Fortress";
	    pop.planet = planet;
	    pop.feature = _ruins;
	    pop.star_system = star_system;
	    pop.text="Praise the Emperor! We have found a massive, ancient fortress in needs of repairs. The gun batteries are rusted, and the walls are covered in moss with huge hole in it. Such a pity that such a majestic building is now a pale shadow of its former glory.  It is possible to repair the structure.  What is thy will?";
	    pop.option1="Repair the fortress to boost defenses.  (1000 Req)";
	    pop.option2="Salvage raw materials from the fortress.";
	}
	else if (loot="starship"){// Starship
	    var pop=instance_create(0,0,obj_popup);
	    pop.image="ruins_ship";
	    pop.title="Ancient Ruins: Starship";
	    pop.text="The ground beneath one of your battle brothers crumbles, and he falls a great height.  The other marines go down in pursuit- within a great chamber they find the remains of an ancient starship.  Though derelict, it is possible to land "+string(obj_ini.role[100][16])+"s onto the planet to repair the ship.  10,000 Requisition will be needed to make it operational.";
		_ruins.find_starship();
	    scr_event_log("",$"Ancient Starship discovered on {planet_numeral_name(planet, star_system)}.", star_system.name);
	}


	_ruins.ruins_explored();
	// star_system.p_feature[planet]="Ancient Ruins|";

	}
}
