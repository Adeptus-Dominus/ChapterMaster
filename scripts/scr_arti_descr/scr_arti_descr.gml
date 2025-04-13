function scr_arti_descr() {
	var mission_data="",basic_asthetic="",other_data="",p4="",final_description="",typ="",good=0,text_possibles;
	// This script generates the longish artifact description.
	if (custom_description==""){
	
		var temp=tags();
	
		typ=determine_base_type();
		
		var inq_mission = has_tag("inq");
		if (typ!="armour"){
		    mission_data=$"This artifact is a {type()}";
		    if (inq_mission) then mission_data+=", entrusted by the Inquisition.#";
		    else if (!inq_mission) then mission_data+=".#";
		}
	
		else if (typ=="armour"){
		    mission_data=$"This artifact is {type()}";
		    if (inq_mission){
		    	mission_data+=", entrusted by the Inquisition.#";
		    }
		    else{
		    	mission_data+=".#";
		    }
		}
		
		if (!inq_mission &&  has_tag("chaos_gift")) then mission_data=$"This artifact is a {type()} gifted by the Chaos Lord.";
	
	
		if (typ="weapon"){
			text_possibles = {
				"RUNE" : "Several glowing runes have been carved along its surfaces.",
				"SCOPE" : "An extremely finely crafted scope, with several lenses, sits on top.",
				"DUB" : "Rather than a single power fist there is a matching pair of two.",
				"ADAMANTINE" : "All ceremite on the weapon has been substituted for polished adamantium.",
				"VOI" : "The weapon is black as night, with green, pulsing veins of an unknown energy.",
				"CHB" : "The striking surface has been replaced with a very powerful chainblade.",
				"UFL" : "A promethium flamethrower has been built in to the bottom of the weapon.",
			}
			if (type()=="Power Fist"){
				text_possibles.CHB = "The addition of a small chainblade has turned it into a chainfist.";
			}
			basic_asthetic = assign_text_from_tag_match(text_possibles);

			text_possibles = {
				"GOLD" : "It is decorated with gold filigree.",
				"GLOW" : "It glows with an eery, soft blue color.",
				"UBOLT" : "A bolter has been integrated.",
			}
			other_data = assign_text_from_tag_match(text_possibles);
		}
	
		else if (typ="armour"){

			text_possibles = {
				"ART" : "Much of the armour is made up of finely articulated plates, neatly interlocking.",
				"SPIKES" : "A multitude of spikes, of varying sizes, adorn the armour.",
				"RUNE" : "Several glowing runes have been carved along its surfaces.",
				"DRA" : "Several areas of the armour have been patched over with Drake scales.",
			}

			basic_asthetic = assign_text_from_tag_match(text_possibles);
			text_possibles = {
				"GOLD" : "It is decorated with gold filigree.",
				"GLOW" : "The optics glow dark red.",
				"PUR" : "It has many crude purity seals.",
			}
			other_data = assign_text_from_tag_match(text_possibles);
		}
	
		else if (typ="gear"){
			text_possibles = {
				"SUP" : "It has been carved with such intricate detail that the facets are uncountable.",
				"ADAMANTINE" : "All ceremite on the item has been substituted for polished adamantium.",
				"GOLD" : "All ceremite on the item has been replaced with shining, polished gold.",
			}
			basic_asthetic = assign_text_from_tag_match(text_possibles);		

			text_possibles = {
				"SAL" : "An emblem of a Fire Drake is embossed on the cover.",
				"ADAMANTINE" : "All ceremite on the item has been substituted for polished adamantium.",
				"GOLD" : "All ceremite on the item has been replaced with shining, polished gold.",
				"GLOW":"It glows a soft green color.",
				"BUR":"Small, non-burning flames lick across the surface.",
				"BIG":"It is of unusually large size.",
				"SOO":"It has a soothing appearance.",
				"RUNE":"Several glowing runes have been carved along its surfaces.",
				"MASK":"It is shaped and contorted into a Fearsome Mask.",
				"SPIKES":"A multitude of spikes, of varying sizes, adorn it.",
				"SKRE":"While on it lets out a tormented scream.",
				"SILENT":"Somehow it is completely silent in operation.",
				"GOR":"The arms are especially lengthy and massively strong.",
				"TENTACLES":"Instead of a single arm it is made up of many smaller tentacles.",
			}

			other_data = assign_text_from_tag_match(text_possibles);		
		}
	
		else if (typ="device"){
		    if (type()!="Robot"){
				text_possibles = {
					"GLOW" : "It emits a sickly, red glow that unnerves those that look upon it.",
					"ADAMANTINE" : "The devise is seemingly built of near-pure adamantium, impressively heavy.",
					"GOLD" : "The devise is covered in a thin layer of gold, which glitters and shines.",
					"CRU" : "Many parts of the device are crumbling apart and cracking from old age.",
				}
				basic_asthetic = assign_text_from_tag_match(text_possibles);			    	

				text_possibles = {
					"SKU" : "It is fashioned to resemble a massive pile of skulls of all races and ages.",
					"FAL" : "It resembles an angel, fallen with broken wings, a sad look on its face.",
					"TENTACLES" : "Carved on top is a ball of wriggling tentacles, eyes, and fangs.",
					"MIN" : "The top panel seemingly writhes with motion, the geometric shapes blinding to behold.",
					"GOAT" : "It resembles a bipedal goat with odd skin blemishes and four small horns.",
					"THI" : "Carved on top is a strange creature with elongated limbs and small head.",
					"SPE" : "The statue is of a man with no eyes, ears, or nose.  The teeth are rotted and mishappen.",
					"DYI" : "The statue is of an angel, sagging against a spear which has pierced its heart.",
					"JUM" :"It resembles a scene of small children with large heads happily jumping into a pit of magma.",
					"CHE" :"The statue resembles a fat grinx which smiles and looks outward with a malicious gaze.",
				}

				other_data  = assign_text_from_tag_match(text_possibles);			    	
		    }
		    else if (type()=="Robot"){
				text_possibles = {
					"HU" :"It is built in the likeness of an attractive human female.",
					"RO" : "It is squat and fat, though tall, and has simple utilitarian limbs.",
					"SHI" : "The devise is covered in a thin layer of gold, which glitters and shines.",
					"CRU" : "It resembles a roaring, four-armed woman with abundant curves.",
				}
				basic_asthetic = assign_text_from_tag_match(text_possibles);

				text_possibles = {
					"ADAMANTINE" :"The machine is seemingly built of near-pure adamantium, impressively heavy.",
					"JAD" : "The machine is built out of a type of jade, pure black, with many veins of green.",
					"BRO" : "The machine is made out of a strange bronze material that seems impossibly durable.",
					"RUNE" : "Several glowing runes have been carved along its surfaces.",
				}
				other_data = assign_text_from_tag_match(text_possibles);			    		

		    }
		}
	} else {
		final_description = custom_description;
	}

	if (has_tag("MINOR")){other_data+="It is more crude and utilitarian than one might expect from an artifact.";}
	if (has_tag("Chaos")){p4="It bears the taint of Chaos.";}
	if (has_tag("Daemonic")){p4="It is infested with a Daemonic entity.";}

	final_description+=mission_data;
	if (basic_asthetic!="") then final_description+=$"  {basic_asthetic}";
	if (other_data!="") then final_description+=$"  {other_data}";
	if (p4!="") then final_description+=$"  {p4}";

	if (equipped() && is_array(bearer)){
		var unit = fetch_unit(bearer);
		final_description += $"#It is currently in the possession of {unit.name_role()}."
	}

	return final_description;


}

function assign_text_from_tag_match(text_set){
	var return_text = "";
	var tag_names = struct_get_names(text_set);
	for (var i=0;i<array_length(tag_names);i++){
		if (has_tag(tag_names[i])){
			return_text = text_set[$ tag_names[i]];
			break;
		}
	}
	return return_text;
}
