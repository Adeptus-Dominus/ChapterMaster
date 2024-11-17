function scr_management(argument0) {

	// argument0        1: overview         10+: that chapter -10
	// Creates the company blocks in the main management screen and assigns text to them

	// Variable creation
	var num=0, nam="", company=50, q=0;	
	var romanNumerals=scr_roman_numerals();
	var chapter_name = global.chapter_name;
	var role_names  = obj_ini.role[100];
	var unit;

	if (argument0=1){
	    with(obj_managment_panel){instance_destroy();}

	    var pane;
		
		pane=instance_create(700,180-48,obj_managment_panel);
	    pane.company=0;
		pane.manage=11;
		pane.header=3;
		pane.title="HEADQUARTERS";
    
	    pane=instance_create(475,180-48,obj_managment_panel);
	    pane.company=0;
		pane.manage=14;
		pane.header=2;
		pane.title="RECLUSIUM";
    
	    pane=instance_create(275,180-48,obj_managment_panel);
	    pane.company=0;
		pane.manage=12;
		pane.header=2;
		pane.title="APOTHECARIUM";
    
	    pane=instance_create(925,180-48,obj_managment_panel);
	    pane.company=0;
		pane.manage=15;
		pane.header=2;
		pane.title="ARMOURY";
    
	    pane=instance_create(1125,180-48,obj_managment_panel);
	    pane.company=0;
		pane.manage=13;
		pane.header=2;
		pane.title="LIBRARIUM";

		// Coordinates declaration and text initiation
	    var xx=25,yy=400-48,t;
    
		// Creates the first 10 companies using roman numerals
	    for (var i = 1; i <= 10; i++) {
			t = string_upper(scr_convert_company_to_string(i));

			var pane = instance_create(xx, yy, obj_managment_panel);
			pane.company = i;
			pane.manage = i;
			pane.header = 1;
			pane.title = t;
    
			xx += 156;
		}
		
		// Generates the company if there are more than 10 companites
		// TODO improve logic or add extra romanNumerals to array TBD
	    if (obj_ini.companies>10){
	        xx=25;
			yy=400-48+(258);
			t="";
        
	        for (var i = 11; i <= obj_ini.companies; i++) {
				t = scr_convert_company_to_string(i);
        
				var pane = instance_create(xx, yy, obj_managment_panel);
				pane.company = i;
				pane.manage = i + 100;
				pane.header = 1;
				pane.title = t;
        
				xx += 156;
			}
	    }

		for(var i=1;i<=50;i++) {
			num[i] = 0;
			nam[i] = "";
		}
		
	    // ****** MAIN PANEL ******
	    q=0;
	    company=0;
		obj_controller.temp[71]=11;

	    for (var i = 0; i < 50; i++) {
			num[i] = 0;
			nam[i] = "";
		}
	    nam[2]=role_names[Role.HONOUR_GUARD];

	    for (var i = 0; i < array_length(obj_ini.name[0]); i++) {
			unit = fetch_unit([0,i]);
			if (unit.role() == "Chapter Master") {
				num[1] += 1;
				if (nam[1] == "") then nam[1] = unit.name();
			}
			if (unit.role() == role_names[Role.HONOUR_GUARD]) then num[2] += 1;
		}
		

	    // if (num[2]=0) then nam[2]="Strategic Staff";// reserved for co-master alien or something
		
	    // if (num[2]>0) {
		// 	nam[2]=string(num)+"x "+string(role_names[Role.HONOUR_GUARD]);
		// 	nam[3]="Strategic Staff";
		// 	num[3]=1;
		// }
		
	    with(obj_managment_panel){if (manage!=obj_controller.temp[71]) then instance_deactivate_object(id);}
		
	
	    if (num[1]>0){
			q++;
			obj_managment_panel.line[q]=string(nam[1]);
			obj_managment_panel.italic[q]=1; obj_managment_panel.bold[q]=1;
		}
	    if (num[2]>0){
			q++;
			obj_managment_panel.line[q]=string(num[2])+"x "+string(nam[2]);
		}

	    obj_managment_panel.italic[1]=1; obj_managment_panel.bold[q]=1;
		instance_activate_object(obj_managment_panel);
    
	    // ll=0;ll2=0;repeat(200){ll2++;if (obj_ini.role[company,ll2]=role_names[Role.HONOUR_GUARD]) then ll++;}
	    // if (ll>0) then temp[3]=string(ll)+"x "+string(role_names[Role.HONOUR_GUARD]);
    
	
    
	    // ** Apothecarium **
	    q=0;
		company=0;
		obj_controller.temp[71]=12;
	    for (var i = 0; i < 50; i++) {
			num[i] = 0;
			nam[i] = "";
		}
	    nam[2]=role_names[Role.APOTHECARY];
		
		// Ranks
		nam[3]=string(role_names[Role.APOTHECARY])+" Aspirant";// nam[4]="Sister Hospitaler";
		
	    for (var i = 1; i <= 200; i++) {
			unit = fetch_unit([0,i]);
			if (unit.role() == "Master of the Apothecarion") {
				num[1] += 1;
				if (nam[1] == "") then nam[1] = unit.name();
			}
    
			if (unit.role() == role_names[Role.APOTHECARY]) then num[2] += 1;
    
			if (unit.role() == string(role_names[Role.APOTHECARY]) + " Aspirant") then num[3] += 1;
			// if (unit.role() == "Sister Hospitaler") then num[4] += 1;
		}
		
	    with(obj_managment_panel){if (manage!=obj_controller.temp[71]) then instance_deactivate_object(id);}
		
	    if (num[1]>0){
			q++;obj_managment_panel.line[q]=string(nam[1]);
			obj_managment_panel.italic[q]=1; obj_managment_panel.bold[q]=1;
		}
	    if (num[2]>0){
			q++;
			obj_managment_panel.line[q]=string(num[2])+"x "+string(nam[2]);
		}
	    if (num[3]>0){
			q++;
			obj_managment_panel.line[q]=string(num[3])+"x "+string(nam[3]);
		}
	    // if (num[4]>0){q++;obj_managment_panel.line[q]=string(num[4])+"x "+string(nam[4]);}
	    instance_activate_object(obj_managment_panel);
	
	    // ** Reclusium **
		q=0;
	    company=0;
		obj_controller.temp[71]=14;
		
	    for (var i = 0; i < 50; i++) {
			num[i] = 0;
			nam[i] = "";
		}
		
	    nam[2]=role_names[Role.CHAPLAIN];
		
		// Ranks
		nam[3]=string(role_names[Role.CHAPLAIN])+" Aspirant";
		
	    for (var i = 1; i <= 200; i++) {
			unit = fetch_unit([0,i]);
			if (unit.role() == "Master of Sanctity") {
				num[1] += 1;
				if (nam[1] == "") then nam[1] = unit.name();
			}
    
			if (unit.role() == role_names[Role.CHAPLAIN]) then num[2] += 1;
    
			if (unit.role() == string(role_names[Role.CHAPLAIN]) + " Aspirant") then num[3] += 1;
		}
		
	    with(obj_managment_panel){if (manage!=obj_controller.temp[71]) then instance_deactivate_object(id);}
		
	    if (num[1]>0){
			q++;
			obj_managment_panel.line[q]=string(nam[1]);
			obj_managment_panel.italic[q]=1; obj_managment_panel.bold[q]=1;
		}
		
		// TODO add specific Space Wolves and successor chapter logic for Master of Sanctity
	    // if (global.chapter_name!="Space Wolves")
		
		// Specific Iron Hands chapter logic
	    if (chapter_name!="Iron Hands"){
	        if (num[2]>0){
				q++;
				obj_managment_panel.line[q]=string(num[2])+"x "+string(nam[2]);
			}
	        if (num[3]>0){
				q++;
				obj_managment_panel.line[q]=string(num[3])+"x "+string(nam[3]);
			}
	    }
	    instance_activate_object(obj_managment_panel);
    
	
	
	    // ** Armoury **
	    q=0;
		company=0;
		obj_controller.temp[71]=15;
		
	    for (var i = 0; i < 50; i++) {
			num[i] = 0;
			nam[i] = "";
		}
		
	    nam[2]=role_names[Role.TECHMARINE];
		
		// Ranks
		nam[3]=string(role_names[Role.TECHMARINE])+" Aspirant";
		nam[4]="Techpriest";
		
	    for (var i = 1; i <= 200; i++) {
			unit = fetch_unit([0,i]);
			if (unit.role() == "Forge Master") {
				num[1] += 1;
				if (nam[1] == "") then nam[1] = unit.name();
			}
    
			if (unit.role() == role_names[Role.TECHMARINE]) then num[2] += 1;
    
			if (unit.role() == string(role_names[Role.TECHMARINE]) + " Aspirant") then num[3] += 1;
    
			if (unit.role() == "Techpriest") then num[4] += 1;
		}
		
	    with(obj_managment_panel){if (manage!=obj_controller.temp[71]) then instance_deactivate_object(id);}
		
	    if (num[1]>0){
			q++;
			obj_managment_panel.line[q]=string(nam[1]);
			obj_managment_panel.italic[q]=1; obj_managment_panel.bold[q]=1;
		}
		
	    if (num[2]>0){
			q++;
			obj_managment_panel.line[q]=string(num[2])+"x "+string(nam[2]);
		}
		
	    if (num[3]>0){
			q++;
			obj_managment_panel.line[q]=string(num[3])+"x "+string(nam[3]);
		}
		
	    if (num[4]>0){
			q++;
			obj_managment_panel.line[q]=string(num[4])+"x "+string(nam[4]);
		}
		
	    instance_activate_object(obj_managment_panel);
	
	    // ** Librarium **
		q=0;
	    company=0;
		obj_controller.temp[71]=13;
	    for (var i=0;i<50;i++) {
			num[i] = 0;
			nam[i] = "";
		}
		
	    nam[2]=role_names[Role.LIBRARIAN];
		
		// Ranks
		nam[3]="Codiciery";
		nam[4]="Lexicanum";
		nam[5]=string(role_names[Role.LIBRARIAN])+" Aspirant";
		
	    for (var i = 1; i <= 200; i++) {
			unit = fetch_unit([0,i]);
			if (unit.role() == "Chief " + string(role_names[Role.LIBRARIAN])) {
				num[1] += 1;
				if (nam[1] == "") then nam[1] = unit.name();
			}
    
			if (unit.role() == role_names[Role.LIBRARIAN]) then num[2] += 1;
    
			if (unit.role() == "Codiciery") then num[3] += 1;
    
			if (unit.role() == "Lexicanum") then num[4] += 1;
    
			if (unit.role() == string(role_names[Role.APOTHECARY]) + " Aspirant") then num[5] += 1;
		}
		
	    with(obj_managment_panel){if (manage!=obj_controller.temp[71]) then instance_deactivate_object(id);}
		
	    if (num[1]>0){
			q++;
			obj_managment_panel.line[q]=string(nam[1]);obj_managment_panel.italic[q]=1; obj_managment_panel.bold[q]=1;
		}
		
	    if (num[2]>0){
			q++;
			obj_managment_panel.line[q]=string(num[2])+"x "+string(nam[2]);
		}
		
	    if (num[3]>0){
			q++;
			obj_managment_panel.line[q]=string(num[3])+"x "+string(nam[3]);
		}
		
	    if (num[4]>0){
			q++;
			obj_managment_panel.line[q]=string(num[4])+"x "+string(nam[4]);
		}
		
	    if (num[5]>0){
			q++;
			obj_managment_panel.line[q]=string(num[5])+"x "+string(nam[5]);
		}
		
	    instance_activate_object(obj_managment_panel);
	    
		// ** Marines and vehicles per company and HQ by ranks **
	    for (company=1;company<=obj_ini.companies;company++){
	        q=0;
			obj_controller.temp[71]=company;
			
	        for (var i=0;i<50;i++) {
				num[i] = 0;
				nam[i] = "";
			}
			// Indexing the names to nam array
			// nam[1] = role_names[Role.CAPTAIN];
			nam[2] = role_names[Role.CHAPLAIN];
			nam[3] = role_names[Role.APOTHECARY];
			nam[4] = role_names[Role.TECHMARINE];
			nam[5] = role_names[Role.LIBRARIAN];
			nam[6] = "Codiciery";
			nam[7] = "Lexicanum";
			nam[8] = "Company" + role_names[Role.ANCIENT];
			nam[9] = (role_names[Role.CHAMPION] == "Champion") ? "Champion" : role_names[Role.CHAMPION];
			nam[10] = role_names[Role.TERMINATOR];
			nam[11] = role_names[Role.SERGEANT];
			nam[12] = (role_names[Role.VETERAN_SERGEANT] == "Veteran Sergeant") ? "Sergeant" : role_names[Role.VETERAN_SERGEANT];
			nam[13] = role_names[Role.VETERAN];
			nam[14] = role_names[Role.TACTICAL];
			nam[15] = role_names[Role.ASSAULT];
			nam[16] = role_names[Role.DEVASTATOR];
			nam[17] = role_names[Role.SCOUT];
			nam[18] = role_names[Role.DREADNOUGHT]; // Venerable Dreadnought, just the role name is too long for the company box
			nam[19] = role_names[Role.DREADNOUGHT];
			nam[20] = "Land Raider";
			nam[21] = "Predator";
			nam[22] = "Rhino";
			nam[23] = "Land Speeder";
			nam[24] = "Whirlwind";
	        for (var i=0;i<array_length(obj_ini.name[0]);i++) {
	        	if (obj_ini.name[company][i] == "") then continue;
	        	unit = fetch_unit([company,i]);
	            if (unit.role()=role_names[Role.CAPTAIN]){
					num[1]++;
					nam[1] = unit.name();
				}
				// Space Wolves exception
				if (chapter_name != "Iron Hands" && unit.role() == role_names[Role.CHAPLAIN]) then num[2]++;
				if (chapter_name != "Space Wolves" && unit.role() == role_names[Role.APOTHECARY]) then num[3]++;
				if (unit.role() == role_names[Role.TECHMARINE]) then num[4]++;
				if (unit.role() == role_names[Role.LIBRARIAN]) then num[5]++;
				if (unit.role() == "Codiciery") then num[6]++;
				if (unit.role() == "Lexicanum") then num[7]++;
				if (unit.role() == role_names[Role.ANCIENT]) then num[8]++;
				if (unit.role() == role_names[Role.CHAMPION]) then num[9]++;
				if (unit.role() == role_names[Role.TERMINATOR]) then num[10]++;
				if (unit.role() == role_names[Role.VETERAN_SERGEANT]) then num[11]++;
				if (unit.role() == role_names[Role.SERGEANT]) then num[12]++;
				if (unit.role() == role_names[Role.VETERAN]) then num[13]++;
				if (unit.role() == role_names[Role.TACTICAL]) then num[14]++;
				if (unit.role() == role_names[Role.ASSAULT]) then num[15]++;
				if (unit.role() == role_names[Role.DEVASTATOR]) then num[16]++;
				if (unit.role() == role_names[Role.SCOUT]) then num[17]++;
				if (unit.role() == "Venerable " + string(role_names[Role.DREADNOUGHT])) then num[18]++;
				if (unit.role() == role_names[Role.DREADNOUGHT]) then num[19]++;
				// Vehicles
				if (i <= 100){
					if (obj_ini.veh_role[company,i] == "Land Raider") then num[20]++;
					if (obj_ini.veh_role[company,i] == "Predator") then num[21]++;
					if (obj_ini.veh_role[company,i] == "Rhino") then num[22]++;
					if (obj_ini.veh_role[company,i] == "Land Speeder") then num[23]++;
					if (obj_ini.veh_role[company,i] == "Whirlwind") then num[24]++;
				}
				
	        }
			
	        with(obj_managment_panel){
	        	if (manage!=obj_controller.temp[71]) then instance_deactivate_object(id);
	        }
			
	        q=0;
				for (var d = 1; d <= 24; d++) {
					if (num[d] > 0) {
							q += 1;
							if (d == 1) {
								obj_managment_panel.line[q] = string(nam[d]);
								obj_managment_panel.italic[q] = 1;
								obj_managment_panel.bold[q] = 1;
							} else if (num[d] > 1){
								obj_managment_panel.line[q] = string(num[d]) + " " + string_plural(nam[d]);
							} else{
								obj_managment_panel.line[q] = string(nam[d]);
							}
					}
			}
			
	        instance_activate_object(obj_managment_panel);
	    }
	}
}
