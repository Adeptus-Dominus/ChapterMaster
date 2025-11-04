enum eSTART_FACTION {
	Progenitor = 1,
	Imperium,
	Mechanicus,
	Inquisition,
	Ecclesiarchy,
	Astartes,
	Reserved,
}

function set_complex_livery_buttons() {
	try {
	    var _type  = complex_livery_radio.selection_val("value");
	    var _name  = complex_livery_radio.selection_val("display_name");
	    var _data  = complex_livery_data[$_type];
	    var _alpha = (custom != eCHAPTER_TYPE.CUSTOM) ? 0.5 : 1;

	    // --- Ensure stored colour indices are always valid ---
	    _data.helm_primary   = clamp(_data.helm_primary,   0, array_length(col) - 1);
	    _data.helm_secondary = clamp(_data.helm_secondary, 0, array_length(col) - 1);
	    _data.helm_lens      = clamp(_data.helm_lens,      0, array_length(col) - 1);

	    // --- Build button objects ---
	    complex_livery_buttons = [
	        new UnitButtonObject({
	            x1: 500,
	            y1: 252,
	            style: "pixel",
	            tooltip: $"Primary Helm Colour\nPrimary helm colour of {_name}",
	            label: $"Helm Primary : {get_colour_name(_data.helm_primary)}",
	            area: "helm_primary",
	            role_id: _type,
	            alpha: _alpha,
	        }),

	        new UnitButtonObject({
	            x1: 500,
	            y1: 287,
	            style: "pixel",
	            tooltip: $"Secondary Helm Colour\nSecondary helm colour of {_name}",
	            label: $"Helm Secondary : {get_colour_name(_data.helm_secondary)}",
	            area: "helm_secondary",
	            role_id: _type,
	            alpha: _alpha,
	        }),

	        new UnitButtonObject({
	            x1: 500,
	            y1: 322,
	            style: "pixel",
	            tooltip: $"Helm Lens Colour\nHelm lens colour of {_name}",
	            label: $"Lens : {get_colour_name(_data.helm_lens)}",
	            area: "helm_lens",
	            role_id: _type,
	            alpha: _alpha,
	        }),
	    ];

	    // --- Update current pattern selection ---
	    advanced_helmet_livery.current_selection = _data.helm_pattern;
	}
	catch (_exception) {
	    handle_exception(_exception);
	}
}



function update_creation_roles_radio(start_role = 1){
    var _role_data = [];

	for (var i=start_role;i<=19;i++){
		if (race[100,i]!=0 && role[100][i] != ""){
			array_push(_role_data, {
			    str1 : role[100][i],
			    font : fnt_40k_14b,
			    role_id : i,
			});
		}
	};

	var _radio_data = {max_width : 50, x1:862, y1:220, y_gap:1}
	roles_radio = new RadioSet(_role_data, "Role Settings", _radio_data);
	roles_radio.current_selection = -1;
}

function bulk_selection_buttons_setup(){

	var _button_data = [
        {
            text : $"Primary : {col[main_color]}",
            tooltip:"Primary",
            tooltip2:"The main color of your Astartes and their vehicles. And the colour of your chapters Ships",
            cords : [500, 287],
        },
        {
            text : $"Secondary: {col[secondary_color]}",
            tooltip:"Secondary",
            tooltip2:"The secondary color of your Astartes and their vehicles.",
            cords : [500, 322],
        },
        {
            text : $"Pauldron 1: {col[left_pauldron]}",
            tooltip:"First Pauldron",
            tooltip2:"The color of your Astartes' left Pauldron.  Normally this Pauldron displays their rank and designation.",
            cords : [500, 357],
        },
        {
            text : $"Pauldron 2: {col[right_pauldron]}",
            tooltip:"Second Pauldron",
            tooltip2:"The color of your Astartes' right Pauldron.  Normally this Pauldron contains the Chapter Insignia.",
            cords : [500, 392],
        },
        {
            text : $"Trim: {col[main_trim]}",
            tooltip:"Trim",
            tooltip2:"The trim color that appears on the Pauldrons, armour plating, and any decorations.",
            cords : [500, 427],                
        },
        {
            text : $"Lens: {col[lens_color]}",
            tooltip:"Lens",
            tooltip2:"The color of your Astartes' lenss.  Most of the time this will be the visor color.",
            cords : [500, 462],                
        },
        {
            text : $"Weapon: {col[weapon_color]}",
            tooltip:"Weapon",
            tooltip2:"The primary color of your Astartes' weapons.",
            cords : [500, 497],                
        }             
    ]
   	bulk_buttons = [
	]
	draw_set_font(fnt_40k_14b);
    for (var i=0;i<array_length(_button_data);i++){
    	var _but = _button_data[i];
    	array_push(bulk_buttons, new UnitButtonObject({
            x1: _but.cords[0], 
            y1: _but.cords[1], 
            style : "pixel",
            tooltip : $"{_but.tooltip}\n{_but.tooltip2}",
            label:_but.text,
            alpha: custom != eCHAPTER_TYPE.CUSTOM ? 0.5 : 1,
			
        }),
    	)
    }
}
/// @mixin obj_creation
function scr_creation(slide_num) {

	// 1 = chapter select
	// 2 = Chapter Naming, Points assignment, advantages/disadvantages
	// 3 = Homeworld, Flagship, Psychic discipline, Aspirant Trial
	// 4 = Livery, Roles
	// 5 = Gene Seed Mutations, Disposition
	// 6 = Chapter Master
	if (slide_num == eCREATIONSLIDES.CHAPTERSELECT){
		setup_chapter_trait_select();
	}
	
	show_debug_message($"calling scr_creation with input {slide_num}");
	if (slide_num == eCREATIONSLIDES.CHAPTERTRAITS && custom!=eCHAPTER_TYPE.PREMADE){
	    if (name_bad=1){/*(sound_play(bad);*/}
	    if (name_bad=0){
	        change_slide=true;
	        goto_slide=3;
	        race[100,17]=1;
	        if (scr_has_disadv("Psyker Intolerant")){
	        	race[100,17]=0;
	        }
	    }
	}

	if (slide_num=eCREATIONSLIDES.CHAPTERTRAITS && custom==eCHAPTER_TYPE.PREMADE){
	    change_slide=true;
	    goto_slide=3;
	    race[100,eROLE.Chaplain]=1;
		race[100,eROLE.Librarian]=1;
	    if(scr_has_disadv("Psyker Intolerant")){
			race[100,eROLE.Librarian]=0;
		}
	    if (chapter_name="Iron Hands" || chapter_name="Space Wolves"){
			race[100,eROLE.Chaplain]=0;	
		} 
	}


	if (slide_num== eCREATIONSLIDES.CHAPTERHOME){
	    change_slide=true;
	    goto_slide=eCREATIONSLIDES.CHAPTERLIVERY;
	    alarm[0]=1;
	    update_creation_roles_radio();
    	
	    if (slide_num == eCREATIONSLIDES.CHAPTERHOME){
	    	draw_set_font(fnt_40k_12);
	    	complex_livery_radio = new RadioSet([
	    		{
				    str1 : "Sergeant Markers",
				    font : fnt_40k_12,
				    value : "sgt",
				    display_name : "Sergeant"
				},
	    		{
				    str1 : "Veteran Sergeant Markers",
				    font : fnt_40k_12,
				    value : "vet_sgt",
				    display_name : "Veteran Sergeant"
				},
	    		{
				    str1 : "Captain Markers",
				    font : fnt_40k_12,
				    value : "captain",
				    display_name : "Captain"
				},
	    		{
				    str1 : "Veteran Markers",
				    font : fnt_40k_12,
				    value : "veteran",
				    display_name : "Veteran"
				},												
	    	], "", {max_width : 50, x1:862, y1:225});

	    	bulk_armour_pattern = new RadioSet([
	    		{
				    str1 : "Single Colour",
				    font : fnt_40k_12,
				    style : "box",
				},
	    		{
				    str1 : "Breastplate",
				    font : fnt_40k_12,
				    style : "box",
				},
	    		{
				    str1 : "Vertical",
				    font : fnt_40k_12,
				    style : "box",
				},
	    		{
				    str1 : "Quadrant",
				    font : fnt_40k_12,
				    style : "box",
				},												
	    	], "", {x1 : 477, y1 : 515, max_width : 400});

	    	advanced_helmet_livery = new RadioSet([
	    		{
				    str1 : "Single Colour",
				    font : fnt_40k_12,
				    style : "box",
				},
	    		{
				    str1 : "Stripe",
				    font : fnt_40k_12,
				    style : "box",
				},
	    		{
				    str1 : "Muzzle",
				    font : fnt_40k_12,
				    style : "box",
				},
	    		{
				    str1 : "Pattern",
				    font : fnt_40k_12,
				    style : "box",
				},												
	    	], "", {x1 : 477, y1 : 515, max_width : 400});

	    	set_complex_livery_buttons();

	    	draw_set_font(fnt_40k_14b);
	    	bulk_selection_buttons_setup();
			livery_selection_options = new RadioSet([
				{
					str1 : "Default",
					tooltip : "The default livery all marines will be coloured in",
					font: fnt_menu
				},
				{
					str1 : "Role",
					tooltip : "Role specific livery that will overide default livery",
					font: fnt_menu
				},
				{
					str1 : "Company",
					tooltip : "company specific livery that will overide role livery",
					font: fnt_menu

				}
			]) 
			colour_selection_options = new RadioSet([
				{
					str1 : "Standard",
					tooltip : "standard options to colour marine",
					font: fnt_menu
				},
				{
					str1 : "Bulk",
					tooltip : "bulk colouring for ease and speed",
					font: fnt_menu
				},
				{
					str1 : "Advanced",
					tooltip : "Advanced options for colouring",
					font: fnt_menu
				}
			]) 
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
    
	if (slide_num=eCREATIONSLIDES.CHAPTERLIVERY){
	    if (custom == eCHAPTER_TYPE.PREMADE || (hapothecary!="" && hchaplain!="" && clibrarian!="" && fmaster!="" && recruiter!="" && admiral!="" && battle_cry!="")){
	        change_slide=true;
	        goto_slide=eCREATIONSLIDES.CHAPTERROLES;
	        update_creation_roles_radio(2);
	        role_setup_objects();
	    }
	}

	if (slide_num = eCREATIONSLIDES.CHAPTERROLES){
		if (custom == eCHAPTER_TYPE.PREMADE || (hapothecary!="" && hchaplain!="" && clibrarian!="" && fmaster!="" && recruiter!="" && admiral!="" && battle_cry!="")){
			change_slide=true;
			goto_slide=eCREATIONSLIDES.CHAPTERGENE
			if (custom==eCHAPTER_TYPE.CUSTOM){
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
	    
			if (custom != eCHAPTER_TYPE.PREMADE) {
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
	if (slide_num=eCREATIONSLIDES.CHAPTERGENE){
	    if (custom==eCHAPTER_TYPE.PREMADE || mutations<=mutations_selected){
			change_slide=true;
			goto_slide=eCREATIONSLIDES.CHAPTERMASTER;
		}
	}

	// 6 to finish
	if (slide_num=eCREATIONSLIDES.CHAPTERMASTER){
	    if (chapter_master_name!="" && chapter_master_melee!=0 && chapter_master_ranged!=0 && chapter_master_specialty!=0){
	        cooldown=9999;
			instance_create(0,0,obj_ini);
			audio_stop_all();
	        audio_play_sound(snd_royal,0,true);
	        audio_sound_gain(snd_royal,0,0);
			if (master_volume=0 || music_volume=0) {
				audio_sound_gain(snd_royal,0.25*master_volume*music_volume,2000);
			}
        
			if (founding == ePROGENITOR.RANDOM) {
				founding = irandom_range(ePROGENITOR.NONE, ePROGENITOR.RAVEN_GUARD);
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
