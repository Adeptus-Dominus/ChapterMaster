enum eSTART_FACTION {
	Progenitor = 1,
	Imperium,
	Mechanicus,
	Inquisition,
	Ecclesiarchy,
	Astartes,
	Reserved,
}

/// @mixin obj_creation
function scr_creation(slide_num) {

	// 1 = chapter select
	// 2 = Chapter Naming, Points assignment, advantages/disadvantages
	// 3 = Homeworld, Flagship, Psychic discipline, Aspirant Trial
	// 4 = Livery, Roles
	// 5 = Gene Seed Mutations, Disposition
	// 6 = Chapter Master
	
	show_debug_message($"calling scr_creation with input {slide_num}");
	if (slide_num=2 && custom>0){
	    if (name_bad=1){cooldown=8000;/*(sound_play(bad);*/}
	    if (name_bad=0){
	        change_slide=1;goto_slide=3;cooldown=8000;race[100,17]=1;
	        if (scr_has_disadv("Psyker Intolerant")) then race[100,17]=0;
	    }
	}

	if (slide_num=2 && custom==0){
	    change_slide=1;
	    goto_slide=3;
	    cooldown=8000;
	    race[100,eROLE.Chaplain]=1;
		race[100,eROLE.Librarian]=1;
	    if(scr_has_disadv("Psyker Intolerant")){
			race[100,eROLE.Librarian]=0;
		}
	    if (chapter_name="Iron Hands" || chapter_name="Space Wolves"){
			race[100,eROLE.Chaplain]=0;	
		} 
	}


	if (slide_num==3 ){
	    change_slide=1;
	    goto_slide=4;
	    cooldown=8000;
	    alarm[0]=1;
    
	    if (slide_num=3){

			
			if (full_liveries == ""){
			    var struct_cols = {
			        main_color :main_color,
			        secondary_color:secondary_color,
			        main_trim:main_trim,
			        right_pauldron:right_pauldron,
			        left_pauldron:left_pauldron,
			        lens_color:lens_color,
			        weapon_color:weapon_color
			    }
			    livery_picker.scr_unit_draw_data();
			    livery_picker.set_default_armour(struct_cols,col_special);
			    full_liveries = array_create(21,variable_clone(livery_picker.map_colour));
			    full_liveries[eROLE.Librarian] = livery_picker.set_default_librarian(struct_cols);

			    full_liveries[eROLE.Chaplain] = livery_picker.set_default_chaplain(struct_cols);

			    full_liveries[eROLE.Apothecary] = livery_picker.set_default_apothecary(struct_cols);

			    full_liveries[eROLE.Techmarine] = livery_picker.set_default_techmarines(struct_cols);
			    livery_picker.scr_unit_draw_data();
			    livery_picker.set_default_armour(struct_cols,col_special);  
			}
	    }
	}
     
	if (slide_num=4){
	    if (custom == 0 || (hapothecary!="" && hchaplain!="" && clibrarian!="" && fmaster!="" && recruiter!="" && admiral!="" && battle_cry!="")){
	        change_slide=1;
	        goto_slide=5;
	        cooldown=8000;
        
	        if (custom=2){
	            mutations_selected=0;
	            preomnor=0;
	            voice=0;
	            doomed=0;
	            lyman=0;
	            omophagea=0;
	            ossmodula=0;
	            membrane=0;
	            zygote=0;
	            betchers=0;
	            catalepsean=0;
	            secretions=0;
	            occulobe=0;
	            mucranoid=0;
				mutations = 10 - purity
	        }
        
			if (custom > 0) {
				disposition[0] = 0;
				disposition[eSTART_FACTION.Progenitor] = 60 + ((cooperation - 5) * 4); // Prog
				disposition[eSTART_FACTION.Imperium] = 50 + ((cooperation - 5) * 4); // Imp
				disposition[eSTART_FACTION.Mechanicus] = 40 + ((cooperation - 5) * 2); // Mech
				disposition[eSTART_FACTION.Inquisition] = 30 + ((cooperation - 5) * 2) - (2 * (10 - purity)) - ((99 - stability) / 5); // Inq
				disposition[eSTART_FACTION.Ecclesiarchy] = 40 + ((cooperation - 5) * 4)  - (10 - purity) - ((99 - stability) / 5); // Ecclesiarchy
			
				switch (founding) {
					case eCHAPTERS.SPACE_WOLVES:
					case eCHAPTERS.SALAMANDERS:
						disposition[eSTART_FACTION.Progenitor] = 70;
						break;
					case eCHAPTERS.IMPERIAL_FISTS:
						disposition[eSTART_FACTION.Progenitor] = 50;
						break;
					case eCHAPTERS.UNKNOWN:
						disposition[eSTART_FACTION.Inquisition] -= 5;
						break;
					default:
						break;
				}

				if (strength > 5) {
					disposition[eSTART_FACTION.Inquisition] -= (strength - 5) * 2;
				} else if (strength < 5) {
					disposition[eSTART_FACTION.Imperium] += (5 - strength) * 2;
				}
			
				if (scr_has_adv("Crafters")) {
					disposition[eSTART_FACTION.Mechanicus] += 2;
				}
				if (scr_has_adv("Tech-Brothers")) {
					disposition[eSTART_FACTION.Mechanicus] += 10;
				}
				if (scr_has_disadv("Psyker Intolerant")) {
					disposition[eSTART_FACTION.Inquisition] += 5;
					disposition[eSTART_FACTION.Ecclesiarchy] += 5;
				}
				if (scr_has_disadv("Warp Tainted")) {
					disposition[eSTART_FACTION.Progenitor] -= 10;
					disposition[eSTART_FACTION.Imperium] -= 10;
					disposition[eSTART_FACTION.Mechanicus] -= 10;
					disposition[eSTART_FACTION.Inquisition] -= 10;
					disposition[eSTART_FACTION.Ecclesiarchy] -= 10;
					disposition[eSTART_FACTION.Astartes] -= 10;
				}
				if (scr_has_disadv("Sieged")) {
					disposition[eSTART_FACTION.Imperium] += 5;
				}
				if (scr_has_disadv("Suspicious")) {
					disposition[eSTART_FACTION.Inquisition] -= 15;
				}
				if (scr_has_disadv("Tech-Heresy")) {
					disposition[eSTART_FACTION.Mechanicus] -= 8;
				}
				if (scr_has_adv("Warp Touched")) {
					disposition[eSTART_FACTION.Inquisition] -= 4;
					disposition[eSTART_FACTION.Ecclesiarchy] -= 4;
				}
				if (scr_has_disadv("Tolerant")) {
					disposition[eSTART_FACTION.Progenitor] -= 5;
					disposition[eSTART_FACTION.Imperium] -= 5;
					disposition[eSTART_FACTION.Mechanicus] -= 5;
					disposition[eSTART_FACTION.Inquisition] -= 5;
					disposition[eSTART_FACTION.Ecclesiarchy] -= 5;
					disposition[eSTART_FACTION.Astartes] -= 5;
				}
			}
	    }
	}

	// 5 to 6
	if (slide_num=5){
	    if (custom=0 || mutations<=mutations_selected){
			change_slide=1;
			goto_slide=6;
			cooldown=8000;
		}
	}

	// 6 to finish
	if (slide_num=6){
	    if (chapter_master_name!="" && chapter_master_melee!=0 && chapter_master_ranged!=0 && chapter_master_specialty!=0){
	        global.icon_name=obj_creation.icon_name;
	        cooldown=9999;
			instance_create(0,0,obj_ini);
			audio_stop_all();
	        audio_play_sound(snd_royal,0,true);
	        audio_sound_gain(snd_royal,0,0);
			if (master_volume=0 || music_volume=0) {
				audio_sound_gain(snd_royal,0.25*master_volume*music_volume,2000);
			}
        
	        if (founding == eCHAPTERS.SALAMANDERS || global.chapter_id == eCHAPTERS.SALAMANDERS) {
				obj_ini.skin_color=1;
			} 
	        if (global.chapter_id != eCHAPTERS.SALAMANDERS && founding!=eCHAPTERS.SALAMANDERS && secretions=1){
	            obj_ini.skin_color=choose(2,3,4);
	        }
        
	        room_goto(Game);
	    }
	}


}
