function scr_management(argument0) {
    // argument0        1: overview         10+: that chapter -10
    // Creates the company blocks in the main management screen and assigns text to them

    // Variable creation
    var num = 0, nam = "", company = 50, q = 0;
    var romanNumerals = scr_roman_numerals();
    var chapter_name = global.chapter_name;
    var role_names = obj_ini.role[100];
    var unit;

    if (argument0 == 1) {
        with (obj_managment_panel) {
            instance_destroy();
        }

        var pane;
        var _command_company = collect_company(0);

        pane = instance_create(475, 180 - 48, obj_managment_panel);
        pane.company = 0;
        pane.manage = 14;
        pane.header = 2;
        pane.title = "RECLUSIUM";

        var _reclusium_units = _command_company.get_from({group:[SPECIALISTS_CHAPLAINS, true, true]}, true, true);

        var _head = _reclusium_units.get_from({group : SPECIALISTS_HEADS, max_wanted : 1});

        if (_head.number() > 0){
            pane.line = [_head.units[0].name()];
        }

        var _reclusium_units = _reclusium_units.index_roles();

        pane.line = array_join(pane.line,_reclusium_units.create_plural_strings_array());

        pane = instance_create(275, 180 - 48, obj_managment_panel);
        pane.company = 0;
        pane.manage = 12;
        pane.header = 2;
        pane.title = "APOTHECARIUM";

        var _apothecary_units = _command_company.get_from({group:[SPECIALISTS_APOTHECARIES, true, true]}, true, true);
        var _head = _apothecary_units.get_from({group : SPECIALISTS_HEADS, max_wanted : 1});

        if (_head.number() > 0){
            pane.line = [_head.units[0].name()];
        }
        var _apothecary_units = _apothecary_units.index_roles();

        pane.line = array_join(pane.line,_apothecary_units.create_plural_strings_array());

        pane = instance_create(925, 180 - 48, obj_managment_panel);
        pane.company = 0;
        pane.manage = 15;
        pane.header = 2;
        pane.title = "ARMOURY";
        var _armoury_units = _command_company.get_from({group:[SPECIALISTS_TECHS, true, true]}, true, true);
        var _head = _armoury_units.get_from({group : SPECIALISTS_HEADS, max_wanted : 1});

        if (_head.number() > 0){
            pane.line = [_head.units[0].name()];
        }
        var _armoury_units = _armoury_units.index_roles();

        pane.line = array_join(pane.line, _armoury_units.create_plural_strings_array());

        pane = instance_create(925, 180 - 48, obj_managment_panel);
        pane = instance_create(1125, 180 - 48, obj_managment_panel);
        pane.company = 0;
        pane.manage = 13;
        pane.header = 2;
        pane.title = "LIBRARIUM";

        var _lib_units = _command_company.get_from({group:[SPECIALISTS_LIBRARIANS, true, true]}, true, true);
        var _head = _lib_units.get_from({group : SPECIALISTS_HEADS, max_wanted : 1});

        if (_head.number() > 0){
            pane.line = [_head.units[0].name()];
        }
        var _lib_units = _lib_units.index_roles();

        pane.line = array_join(pane.line,_lib_units.create_plural_strings_array());

        pane = instance_create(700, 180 - 48, obj_managment_panel);
        pane.company = 0;
        pane.manage = 11;
        pane.header = 3;
        pane.title = "HEADQUARTERS";
        var _head = _command_company.get_from({group : SPECIALISTS_HEADS, max_wanted : 1});

        if (_head.number() > 0){
            pane.line = [_head.units[0].name()];
        }
        var _command_units = _command_company.index_roles();

        pane.line = array_join(pane.line,_command_units.create_plural_strings_array())

        // Coordinates declaration and text initiation
        var xx = 25, yy = 400 - 48, t;

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

        // ** Marines and vehicles per company and HQ by ranks **
        for (company = 1; company <= obj_ini.companies; company++) {
            q = 0;
            obj_controller.temp[71] = company;

            for (var i = 0; i < 50; i++) {
                num[i] = 0;
                nam[i] = "";
            }
            // Indexing the names to nam array
            nam[1] = role_names[eROLE.CAPTAIN];
            nam[2] = role_names[eROLE.CHAPLAIN];
            nam[3] = role_names[eROLE.APOTHECARY];
            nam[4] = role_names[eROLE.TECHMARINE];
            nam[5] = role_names[eROLE.LIBRARIAN];
            nam[6] = "Codiciery";
            nam[7] = "Lexicanum";
            nam[8] = "Company" + role_names[eROLE.ANCIENT];
            nam[9] = (role_names[eROLE.CHAMPION] == "Champion") ? "Champion" : role_names[eROLE.CHAMPION];
            nam[10] = role_names[eROLE.TERMINATOR];
            nam[11] = role_names[eROLE.SERGEANT];
            nam[12] = (role_names[eROLE.VETERANSERGEANT] == "Veteran Sergeant") ? "Vet Sergeant" : role_names[eROLE.VETERANSERGEANT];
            nam[13] = role_names[eROLE.VETERAN];
            nam[14] = role_names[eROLE.TACTICAL];
            nam[15] = role_names[eROLE.ASSAULT];
            nam[16] = role_names[eROLE.DEVASTATOR];
            nam[17] = role_names[eROLE.SCOUT];
            nam[18] = "Venerable " + role_names[eROLE.DREADNOUGHT]; // Venerable Dreadnought, just the role name is too long for the company box
            nam[19] = role_names[eROLE.DREADNOUGHT];
            nam[20] = "Land Raider";
            nam[21] = "Predator";
            nam[22] = "Rhino";
            nam[23] = "Land Speeder";
            nam[24] = "Whirlwind";

            var _company_group = collect_company(company).index_roles();
            for (var i = 2; i <= 19 ; i++){
                if (_company_group.has_role(nam[i])){
                    num[i] = _company_group.role_count(nam[i]);
                }
            }

            // Vehicles
            for (var i = 0; i < array_length(obj_ini.veh_role[company]); i++) {
                if (obj_ini.veh_role[company][i] == "Land Raider") {
                    num[20]++;
                }
                if (obj_ini.veh_role[company][i] == "Predator") {
                    num[21]++;
                }
                if (obj_ini.veh_role[company][i] == "Rhino") {
                    num[22]++;
                }
                if (obj_ini.veh_role[company][i] == "Land Speeder") {
                    num[23]++;
                }
                if (obj_ini.veh_role[company][i] == "Whirlwind") {
                    num[24]++;
                }
            }

            with (obj_managment_panel) {
                if (manage != obj_controller.temp[71]) {
                    instance_deactivate_object(id);
                }
            }

            q = 0;
            for (var d = 1; d <= 24; d++) {
                if (num[d] > 0) {
                    q += 1;
                    if (d == 1) {
                        obj_managment_panel.line[q] = string(nam[d]);
                        // obj_managment_panel.italic[q] = 1;
                        obj_managment_panel.bold[q] = 1;
                    } else {
                        obj_managment_panel.line[q] = string_plural_count(nam[d], num[d], false);
                    }
                }
            }

            instance_activate_object(obj_managment_panel);
        }
    }
}
