// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_detail_text(){
	var unit_data_string = "";
	var is_astartes = false;
	var is_superior = array_contains([obj_ini.role[100][18], obj_ini.role[100][19]], role());
	var unit_name = name();
	var unit_role = role();
	var body_augmentations = {mutations:[], bionics:[[],[]]}
	var body_bionics = get_body_data("bionic");
	var _phy_levels = ARR_psy_levels;
	var _body_parts = ARR_body_parts;
	var _body_parts_display = ARR_body_parts_display;
	if(base_group == "astartes"){
		is_astartes = true;
	}

	// Chapter Role text
	var chapter_role = ""
	if (company > 0){
		if (squad != "none"){
			chapter_role += is_superior ? $"{unit_name}, sergeant of the " : $"{unit_name}, member of the ";
			chapter_role += scr_convert_company_to_string(company, true, true);
			chapter_role += string(" {0} {1}.", squad, obj_ini.squads[squad].display_name);
		} else {
			chapter_role += $"{unit_name}, {unit_role} from the ";
			chapter_role += scr_convert_company_to_string(company, false, true) + ".";
		}
	} else {
		chapter_role += $"{unit_name}, {unit_role}.";
	}
	unit_data_string += chapter_role;


		// Age and ascension date
		unit_data_string += "\n"
		if (base_group == "astartes"){
			var ascension_date = marine_ascension;
			if ascension_date = "pre_game" then ascension_date = "when the chapter was created";
			unit_data_string += $"{round(age())} years old. Ascended to an Astartes in the year {ascension_date}.";
			if (struct_exists(spawn_data, "recruit_data")){
				var recruit_data = spawn_data.recruit_data;
				unit_data_string+="\n";
				unit_data_string += $"they were recruited from a {recruit_data.recruit_world} World, and was chosen as potential candidate for the chapter by way of a {scr_trial_data(recruit_data.aspirant_trial).name} Trial";
			}
		}

		// Religion text
		unit_data_string +="\n\n";
		if (religion != "none"){
			unit_data_string += string("Follower of the {0}",global.religions[$ religion][$ "name"])
			if (religion_sub_cult != "none"){
				unit_data_string += $", in particular a sub cult known as {religion_sub_cult}"
			}
			if ((piety > 25)and (piety <40)){
				unit_data_string += ", he is firmly committed to the faith."
			}else if(piety <= 25){
				unit_data_string += ", however, he is not putting much value in religion."
			}else if(piety >= 40){
				unit_data_string += ", he is fervently devoted in his worship."
			}else if(piety >= 50){
				unit_data_string += ", he exhibits an unshakeable fanaticism in his worship."
			}
			unit_data_string+="\n";
		}

		// Psyker text
		unit_data_string += $"Has an Assignment rating of {_phy_levels[psionic]} ({psionic}) ";
		var is_lib = array_contains(["Lexicanum", "Codiciery",obj_ini.role[100,17]], role());
		if (psionic<2){
			unit_data_string += "and as such has almost no presence in the warp.";
		} else if(psionic<8){
			unit_data_string += "and a limited presence in the warp causing them to be more prone to attacks from the immaterium.";
		} else if(psionic<11){
			unit_data_string += "and therefore is considered to be a low level psyker with conscious levels of psionic talent.";
			if (is_astartes){
				if (!is_lib){
					unit_data_string += "\n";
					unit_data_string += "He would be eligible for a role in the Librarium however is unlikely to ever exceed the role of Lexicanum.";
				}
			}
		}else if(psionic<13){
			unit_data_string += "and has a very high level of mental psychic activity, making them a potent psyker, their presence in the warp is obvious to the daemons of the immaterium.";
			if (is_astartes){
				if (!is_lib){
					unit_data_string += "\n";
					unit_data_string += " He would be eligible for a role in the Librarium capable of wielding his power to good effect.";
				}
			}
		}else if(psionic<15){
			unit_data_string += ", occurring in approximately one-per-billion human births, they are a very potent psyker.";
			if (is_astartes){
				if (!is_lib){
					unit_data_string += "\n";
					unit_data_string += " He would be eligible for a role in the Librarium And should be enrolled at once in order to train his abilities and stop his untrained mind causing damage to the chapter.";
				} else {
					unit_data_string += "\n";
					unit_data_string += " His rare talent is of great benefit to the chapter and could one day be a candidate for Chief of the librariam.";
				}
			}		       				       			
		} else if(psionic<15){
			unit_data_string += ", exceedingly rare and dangerous but unfathomably powerful.";
			if (is_astartes){
				unit_data_string += "\n"
				unit_data_string += " Their talents are both a great boon and huge risk to the chapter.";
				if (!is_lib){
					unit_data_string += " He must brought into the guided sphere of the librarium immediately or else dealt with by other methods for the good of the chapter.";
				} else {
					unit_data_string += " His rare talent is of great benefit to the chapter and will likely one day be a candidate for Chief of the librariam if he does not succumb to either the material or immaterium.";
				}
			}
		}

		// Bionics text
		unit_data_string += "\n\n"
		if (is_astartes){
			var bionic_positions = struct_get_names(body_bionics);
			var bionic_count = bionics;
			if (bionic_count == 0){
				unit_data_string+= "Has no bodily augmentations besides his astartes gene-seed and organs.";
			}else if(bionic_count == 1 && array_length(bionic_positions)>0){
				for (var i=0;i<array_length(_body_parts);i++){
					if (bionic_positions[0]==_body_parts[i]){
						unit_data_string+= $"Has a bionic {_body_parts_display[i]}.";
					}
				}
			}else if((bionic_count >1) and (bionic_count <=4)){
				unit_data_string+= "Has some bionic replacements.";
			}else if((bionic_count >=5) and (bionic_count <8)){
				unit_data_string+= "Has many bionic replacements.";
			}else if (bionic_count >8){
				unit_data_string+= "Is mostly a machine, having replaced most of his flesh with bionic replacements.";
			}
			// Not sure why you need this line only for the throat.
			// if (array_contains(bionic_positions, "throat")){
			// 	unit_data_string+=" People tend to find the sound from his augmented throat unnerving.";
			// }
			// Gene-seed text
			unit_data_string+="\n";
			var mutation_names = struct_get_names(gene_seed_mutations);
			var mutation_count = 0;
			var mutation_string = "";
			for (var mute =0; mute <array_length(mutation_names); mute++){
				if (gene_seed_mutations[$ mutation_names[mute]] == 1){
					mutation_count += 1;
					switch(mutation_names[mute]){
						case "preomnor":
							mutation_string += "Lacks the detoxifying gland called the Preomnor - he is more susceptible to poisons and toxins.";
							break;
						case "lyman":
							mutation_string += "Lacks a working Lyman's ear, and therefore struggles with deep strikes and certain other actions.";
							break;
						case "omophagea":
							mutation_string += "Suffers from a faulty Omophagea.";
							break;
						case "ossmodula":
							mutation_string += "Suffers from a faulty Ossmodula, and takes longer to heal from injuries.";
							break;
						case "zygote":
							mutation_string +="One of his Zygotes is faulty or missing.";
							break;
						case "betchers":
							mutation_string +="Missing his Betchers Gland and therefore cannot spit acid.";
							break;
						case "catalepsean":
							mutation_string +="Has a faulty Catalepsean Node reducing his awareness when tired.";
							break;
						case "occulobe":
							mutation_string += "Suffers from a faulty occulobe limiting his eyesight enhancements.";
							break;
						case "mucranoid":
							mutation_string += "Suffers from a faulty mucranoid reducing his resistance to extreme heat and cold.";
							break;
						case "membrane":
							mutation_string += "Cannot properly activate his Sus-an Membrane, this limits his ability to survive mortal wounds.";
							break;
						case "voice":
							mutation_string += "Gene-seed implantation process damaged his vocal cords, causing many to find the sound of his voice to be rather unnerving.";
					}
					mutation_string += "\n";
				}
			}
		if (mutation_count == 0){
			unit_data_string += "His gene-seed is pure and has no mutations.\n"
		} else {
			unit_data_string += mutation_string;
		}
		// Black carapace text
		var has_carapace;
		if (struct_exists(body[$ "torso"], "black_carapace")){
			if (body[$ "torso"][$"black_carapace"]){
				has_carapace=true;
			}else{
				has_carapace=false;
				unit_data_string+="Doesn't have black carapace installed and therefore can't use power armour to its maximum potential.\n";
			}
		}

		// Sergeant text
		if (is_superior){
			unit_data_string += "\n";
			var charisma_string = "";
			var wisdom_string = "";
			unit_data_string += "Marines under his command ";
			// Charisma text
			if (charisma <= 25){
				charisma_string += "dislike him";
			} else if (charisma >= 35){
				charisma_string += "like him";
			} else{
				charisma_string += "are neutral towards him"
			}
			// Wisdom text
			var separator = (charisma <= 25 && wisdom <= 35) || (charisma >= 35 && wisdom > 35) ? " and " : " yet ";
			if (wisdom <= 30){
				wisdom_string += "are generally dissatisfied with his tactical decisions.";
			} else if (wisdom <= 35){
				wisdom_string += "do not always have a positive view of his tactical abilities.";
			} else if (wisdom <= 45){
				wisdom_string += "consider him to be a good tactician.";
			} else {
				wisdom_string += "acknowledge that his military mind has saved them many times.";
			}
			unit_data_string+= string_join(separator, charisma_string, wisdom_string);
			// Combat skills text
			var combat_skill_sum = ballistic_skill + weapon_skill;
			if (combat_skill_sum >= 100){
				unit_data_string += "\nThey are in awe of his combat skills, seeing him as a paragon of martial prowess.";
			} else if (combat_skill_sum >= 80){
				unit_data_string += "\nThey regard him with respect, his battle prowess a testament to his leadership.";
			} else{
				unit_data_string += "\nThey harbor doubts about his combat abilities, having skills seemingly inadequate for his rank.";
			}
		}
		// Strength text
		if (strength >= 50){
			unit_data_string+= "\nHis strength greatly exceeds that of the standard astartes allowing him to wield weapons that normally require two hands in one."
		} 
		// Technology text
		if(!array_contains(traits, "mars_trained")){
			if (technology >= 35){
				unit_data_string +="\nDisplays a talent with technology that might make him suited to a role within the armentarium.";
			} else if (technology <= 25){
				unit_data_string +="\nIs a technological luddite capable of little more than cleaning his own bolter.";
			} else{
				unit_data_string +="\nHas a decent understanding of technology, capable of performing routine maintenance on standard issue equipment.";
			}
		} else{
			if(technology >= 45){
				unit_data_string +="\nIs a technological prodigy able to understand and build most anything that takes his interest.";
			} else{
				unit_data_string +="\nIs capable enough with technical skills to carry out basic tasks in the field.";
			}
		}
	}

	// Traits text
	if (array_length(traits) > 0){
		unit_data_string+="\n\n"
		for (var i=0;i<array_length(traits);i++){
			unit_data_string += string(global.trait_list[$ traits[i]].flavour_text + ".\n", unit_name);
			// if (struct_exists(global.trait_list[$ traits[i]], "effect")){
			// 	unit_data_string += $" ({global.trait_list[$ traits[i]].effect})";
			// }
		}
	}
	return unit_data_string
}





