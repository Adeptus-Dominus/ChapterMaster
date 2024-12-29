

function scr_marine_spawn_age(){
	var _age = 0;
	var _minimum_age = 0;
	var _maximum_age = 0;
	var _apply_gauss = false;
	var _gauss_sd_mod = 2; // The smaller this mod, the bigger is the spread;

	switch(company){
		case 1:
			_minimum_age += 75;
			_maximum_age += 105;
			_apply_gauss = true;
			break;
		case 2:
		case 3:
		case 4:
		case 5:
			_minimum_age += 45;
			_maximum_age += 75;
			_apply_gauss = true;
			break;
		case 6:
		case 7:
			_minimum_age += 25;
			_maximum_age += 35;
			break;
		case 8:
			_minimum_age += 15;
			_maximum_age += 15;
			break;
		case 9:
			_minimum_age += 5;
			_maximum_age += 5;
			break;
		case 10:
		default:
			break;
	}

	var _venerable_dred = string_concat("Venerable ", obj_ini.role[100][eROLE.Dreadnought]);

	switch(role()){
		// HQ only
		case "Chapter Master":
			_minimum_age = 200;
			_maximum_age = 300;
			_apply_gauss = true;
			break;
			
		case "Chief Librarian":
		case "Forge Master":
		case "Master of Sanctity":
		case "Master of the Apothecarion":
		case obj_ini.role[100][eROLE.HonourGuard]:
			_minimum_age = 180;
			_maximum_age = 300;
			_apply_gauss = true;
			break;
		case "Codiciery":
			_minimum_age += 60;
			_maximum_age += 70;
			break;
		case "Lexicanum":
			_minimum_age += 50;
			_maximum_age += 60;
			break;
		// 1st company only
		case obj_ini.role[100][eROLE.Veteran]:
			_minimum_age = 100;
			_maximum_age = 140;
			break;
		case obj_ini.role[100][eROLE.Terminator]:
			_minimum_age = 140;
			_maximum_age = 160;
			break;
		case obj_ini.role[100][eROLE.VeteranSergeant]:
			_minimum_age = 140;
			_maximum_age = 160;
			break;
		// Command Squads
		case obj_ini.role[100][eROLE.Captain]:
			_minimum_age += 80;
			_maximum_age += 90;
			break;
		case obj_ini.role[100][eROLE.Champion]:
			_minimum_age += 50;
			_maximum_age += 60;
			break;
		case obj_ini.role[100][eROLE.Ancient]:
			_minimum_age += 90;
			_maximum_age += 140;
			break;
		// Command Squads and HQ
		case obj_ini.role[100][eROLE.Chaplain]:
		case obj_ini.role[100][eROLE.Apothecary]:
		case obj_ini.role[100][eROLE.Techmarine]:
		case obj_ini.role[100][eROLE.Librarian]:
			_minimum_age += 70;
			_maximum_age += 150;
			_apply_gauss = true;
			break;
		// Company marines
		case obj_ini.role[100][eROLE.Dreadnought]:
			_minimum_age = 400;
			_maximum_age = 600;
			_apply_gauss = true;
			break;
		case _venerable_dred:
			_minimum_age = 650;
			_maximum_age = 0;
			_apply_gauss = true;
			break;
		case obj_ini.role[100][eROLE.Tactical]:
		case obj_ini.role[100][eROLE.Devastator]:
		case obj_ini.role[100][eROLE.Assault]:
			_minimum_age += 20;
			_maximum_age += 30;
			break;
		case obj_ini.role[100][eROLE.Sergeant]:
			_minimum_age += 25;
			_maximum_age += 35;
			break;
		case obj_ini.role[100][eROLE.Scout]:
		default:
			_minimum_age = 18;
			_maximum_age = 25;
			break;
	}

	if (_apply_gauss == true) {
		if (_maximum_age != 0){
			_gauss_sd_mod = ((_maximum_age - _minimum_age) / _gauss_sd_mod);
			_age = gauss_positive(_minimum_age, _gauss_sd_mod);
		} else {
			_age = gauss_positive(_minimum_age, _minimum_age / _gauss_sd_mod);
		}
	} else {
		_age = irandom_range(_minimum_age, _maximum_age);
	}

	update_age(round(_age));	
}
function scr_marine_spawn_armour(){
	var _age = age();
	var _exp = experience;
	var _total_score = _age + _exp;

	var armour_weighted_lists = {
		normal_armour: [["MK7 Aquila", 95], ["MK6 Corvus", 5]],
		rare_armour: [["MK7 Aquila", 100], ["MK6 Corvus", 30], ["MK8 Errant", 2], ["MK5 Heresy", 2], ["MK4 Maximus", 1], ["MK3 Iron Armour", 1]],
		quality_armour: [["MK7 Aquila", 30], ["MK6 Corvus", 5], ["MK8 Errant", 5], ["MK4 Maximus", 5]],
		old_armour: [["MK6 Corvus", 4], ["MK8 Errant", 2], ["MK5 Heresy", 2], ["MK4 Maximus", 1], ["MK3 Iron Armour", 1]],
	}

	switch(role()){
		// HQ
		// case obj_ini.role[100][eROLE.ChapterMaster]:
		// case "Chief Librarian":
		// case "Forge Master":
		// case "Master of Sanctity":
		// case "Master of the Apothecarion":
		// case obj_ini.role[100][eROLE.HonourGuard]:
		case "Codiciery":
		case "Lexicanum":
		// 1st company only
		case obj_ini.role[100][eROLE.Veteran]:
		case obj_ini.role[100][eROLE.VeteranSergeant]:
		// Command Squads
		case obj_ini.role[100][eROLE.Captain]:
		case obj_ini.role[100][eROLE.Champion]:
		case obj_ini.role[100][eROLE.Ancient]:
		// Command Squads and HQ
		case obj_ini.role[100][eROLE.Chaplain]:
		case obj_ini.role[100][eROLE.Apothecary]:
		case obj_ini.role[100][eROLE.Librarian]:
		// Company marines
		// case obj_ini.role[100][eROLE.Scout]:
		case obj_ini.role[100][eROLE.Tactical]:
		case obj_ini.role[100][eROLE.Devastator]:
		case obj_ini.role[100][eROLE.Assault]:
		case obj_ini.role[100][eROLE.Sergeant]:
			if (_total_score > 280){
				update_armour(choose_weighted(armour_weighted_lists.old_armour),false,false);
			} else if (_total_score > 180){
				update_armour(choose_weighted(armour_weighted_lists.quality_armour),false,false);
			} else if (_total_score > 100){
				update_armour(choose_weighted(armour_weighted_lists.rare_armour),false,false);
			} else {
				update_armour(choose_weighted(armour_weighted_lists.normal_armour),false,false);
			}
			break;
		case obj_ini.role[100][eROLE.Techmarine]:
			if (_total_score > 280){
				update_armour("Artificer Armour",false,false);
			} else if (_total_score > 180){
				update_armour(choose_weighted(armour_weighted_lists.quality_armour),false,false);
			} else if (_total_score > 100){
				update_armour(choose_weighted(armour_weighted_lists.rare_armour),false,false);
			} else {
				update_armour(choose_weighted(armour_weighted_lists.normal_armour),false,false);
			}
			break;
		case obj_ini.role[100][eROLE.Terminator]:
			if (_total_score > 270){
				update_armour(choose("Tartaros", "Terminator Armour", "Terminator Armour"),false,false);
			} else if (_total_score > 250){
				update_armour(choose("Tartaros", "Terminator Armour", "Terminator Armour", "Terminator Armour"),false,false);
			}else {
				update_armour("Terminator Armour",false,false);
			}
			break;
	}	
}
function scr_marine_game_spawn_constructions(){
	roll_age();
	roll_experience();
	assign_reactionary_traits();
	roll_armour();
	
	var old_guard = irandom(100);

	var bionic_count = choose(0,0,0,0,1,2,3);
	if (global.chapter_name=="Iron Hands"){
		bionic_count = choose(2,3,4,5);
	}
	switch(role()){
		case obj_ini.role[100][5]:  //captain
			if(old_guard>=80 || company == 1){
				bionic_count = choose(0,0,1,2,3)
			} else {
				bionic_count = choose(0,0,0,1,2)
			}
			charisma += (irandom(10));
			wisdom += (irandom(10));
			piety += (irandom(10));
			if (irandom(1)==0){
				add_trait("natural_leader");
			}
			if scr_has_adv("Assault Doctrine"){
				weapon_skill += irandom(5);
				if (irandom(1)==0){
					add_trait("melee_enthusiast");
				}
			}
			if scr_has_adv("Devastator Doctrine"){
				constitution += irandom(5);
				if (irandom(1)==0){
					add_trait("slow_and_purposeful");
				}
			}
			break;
		case  obj_ini.role[100][15]:  //apothecary
			if company > 0 {
				if(old_guard>=80 || company == 1){
					bionic_count = choose(0,0,1,2,3)
				} else{
					bionic_count = choose(0,0,0,1,2)
				}
			} else {
				bionic_count = choose(0,0,0,0,1)
			}
			if (intelligence<40){
				intelligence=40;
			}
			break;
		case obj_ini.role[100][11]: // Ancient
			if(old_guard>=50 || company == 1){
				bionic_count = choose(0,0,1,2,3)
			} else{
				bionic_count = choose(0,0,0,1,2)
			}
			break;
		case  obj_ini.role[100][8]:		//tacticals
			break;
		case  obj_ini.role[100][9]: 		//devastators	
			break;
		case  obj_ini.role[100][3]: //veterans
			if (global.chapter_name=="Ultramarines"){
				if (choose(true,false)){
					add_trait("tyrannic_vet");
					bionic_count+=irandom(1);
				}
			}
			break;
		case obj_ini.role[100][16]: //techmarines
			if ((old_guard >= 90 && company > 0 && company < 6) || company == 1){
				bionic_count = choose(1,2,3,4,5)
			} else if (company > 0 && company < 6){
				bionic_count = choose(1,1,2,3,4)
			} else {
				bionic_count = choose(1,1,1,2,3)
			}
			if (
                (global.chapter_name == "Iron Hands") ||
                (obj_ini.progenitor = ePROGENITOR.IRON_HANDS) ||
                scr_has_disadv("Tech-Heresy")
            ) {
				add_bionics("right_arm", "standard", false);
				bionic_count = choose(6, 6, 7, 7, 7, 8, 9);
				add_trait("flesh_is_weak");
				var tech_heresy = irandom(19);
			} else {
				bionic_count = irandom(5) + 1;
				if (irandom(2) == 0) {
					add_trait("flesh_is_weak");
				}
				var tech_heresy = irandom(49);
			}
			if (scr_has_disadv("Tech-Heresy")) {
				var tech_heresy = irandom(10);
				technology += 4;
			}
			if (tech_heresy == 0) {
				add_trait("tech_heretic");
				edit_corruption(30);
			}
			if (technology < 35) {
				technology = 35;
			}
			add_trait("mars_trained");
			if (irandom(1) == 0) {
				add_trait("tinkerer");
			}
			if (religion != "cult_mechanicus") {
				religion_sub_cult = "none";
			}
			if (array_contains(obj_ini.adv, "Crafters")) {
				if (irandom(2) == 0) {
					add_trait("crafter");
				}
			} else if (obj_ini.progenitor == ePROGENITOR.SALAMANDERS || obj_ini.progenitor == ePROGENITOR.IRON_HANDS) {
				technology += 2;
				if (irandom(4) == 0) {
					add_trait("crafter");
				}
			}
			religion = "cult_mechanicus"
			break;
		case  obj_ini.role[100][12]: //scouts
			bionic_count = choose(0,0,0,0,0,0,0,0,0,0,0,1);
			break;
		case  obj_ini.role[100][14]:  //chaplain
			if company > 0 {
				if(old_guard>=80 || company == 1){
					bionic_count = choose(0,0,1,2,3)
				} else {
					bionic_count = choose(0,0,0,1,2)
				}
			} else {
				bionic_count = choose(0,0,0,0,1)
			}
			if (piety<35){
				piety=35;
			}
			if(irandom(1) ==0){
				add_trait("zealous_faith")
			}
			break;
		case "Codiciery":
			break;
		case "Lexicanum":
			break;
		case obj_ini.role[100][eROLE.Librarian]:
			if ((old_guard >= 90 && company > 0 && company < 6) || company == 1){
				bionic_count = choose(0,0,1,2,3)
			} else if (company > 0 && company < 6){
				bionic_count = choose(0,0,0,1,2)
			} else {
				bionic_count = choose(0,0,0,0,1)
			}
			break;	
		case obj_ini.role[100][eROLE.Champion]:
			if(old_guard>=80 || company == 1){
				bionic_count = choose(0,0,1,2,3)
			} else{
				bionic_count = choose(0,0,0,1,2)
			}
			break;
	}
	if (irandom(75)>74){
		add_trait("tyrannic_vet");
		bionic_count+=irandom(2);
	};		
	if (irandom(399-experience) == 0){
		add_trait("still_standing");
	};
	if (irandom(399-experience) == 0){
		add_trait("beast_slayer");
	};		
	if (irandom(499-experience)==0){
		add_trait("lone_survivor");
	}
	for(var i=0;i<bionic_count;i++){
			add_bionics("none","standard",false);
	}
	if (irandom(3)==0){
		body[$ "torso"][$ "purity_seal"] = [irandom(1),irandom(1),irandom(1),];
	}
	if (irandom(3)==0){
		body[$ "left_arm"][$ "purity_seal"] = [irandom(1),irandom(1),irandom(1),];
	}
	if (irandom(3)==0){
		body[$ "right_arm"][$ "purity_seal"] = [irandom(1),irandom(1),irandom(1),];
	}	
	if (irandom(3)==0){
		body[$ "left_leg"][$ "purity_seal"] = [irandom(1),irandom(1),irandom(1),];
	}
	if (irandom(3)==0){
		body[$ "right_leg"][$ "purity_seal"] = [irandom(1),irandom(1),irandom(1),];
	}	

}