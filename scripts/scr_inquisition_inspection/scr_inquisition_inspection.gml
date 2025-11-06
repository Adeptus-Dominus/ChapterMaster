function inquisitor_inspection_structure() constructor {
    // ----- Instance data -----
    finds = {
        heresy: 0,
        daemonic: 0,
        poor_practices : 0,
    };

    ships = -1;
    planets = 0;        // can be single integer or an array of planet indices
    location = "";      // location string for collect_role_group
    star = -1;          // star instance
    units = [];         // collected units for inspection

    // convenience flags populated during inspection
    finds.secret_lair_flag = false;
    finds.secret_arsenal_flag = false;
    finds.secret_gene_flag = false;
    finds.contraband_demand = false;
    finds.trigger_war = false;
    finds.cha = 0;

    inquisitor_disp =  obj_controller.disposition[eFACTION.Inquisition];

    // ----- Static methods -----

    static collect_inspection_units = function() {
        // Uses stored location, planets, ships
        units = collect_role_group("all", [location, planets, ships]);
    };

    static planet_heresys = function() {
        if (instance_exists(star)) {
            if (is_array(planets)) {
                for (var i = 0; i < array_length(planets); i++) {
                    var _p = planets[i];
                    if (_p >= 0 && _p < array_length(star.p_hurssy)) {
                        finds.heresy += star.p_hurssy[_p];
                    }
                }
            } else {
                var _p_single = planets;
                if (_p_single >= 0 && _p_single < array_length(star.p_hurssy)) {
                    finds.heresy += star.p_hurssy[_p_single];
                }
            }
        }
    };

    static inquisitor_inspect_units = function(_units_override) {
        // Optionally accept an explicit array of units (used by fleet inspections).
        var _units_to_check = _units_override == undefined ? units : _units_override;

        for (var i = 0; i < array_length(_units_to_check); i++) {
            var unit = _units_to_check[i];
            if (unit == undefined) { continue; }
            if (unit.name() == "") { continue; }

            // Xenos merc checks: ork base_group or Rangers of non-Imperial race
            if (unit.base_group == "ork") {
                add_xenos_mercs(unit.role());
            } else if (unit.role() == "Ranger") {
                // example race check - adapt as needed
                var ca = unit.company_index != undefined ? unit.company_index : 0;
                var ia = unit.instance_index != undefined ? unit.instance_index : 0;
                if (obj_ini.race[ca, ia] != 1) {
                    add_xenos_mercs(unit.role());
                }
            }

            // Check equipped artifacts
            var artis = unit.equipped_artifacts();
            for (var art = 0; art < array_length(artis); art++) {
                var artifact_index = artis[art];
                if (artifact_index == undefined) { continue; }
                if (artifact_index < 0 || artifact_index >= array_length(obj_ini.artifact_struct)) { continue; }
                var artifact = obj_ini.artifact_struct[artifact_index];
                if (artifact != undefined) {
                    if (artifact.inquisition_disaprove()) {
                        finds.heresy += 8;
                        finds.daemonic += 1;
                    }
                }
            }
        }
    };

    static inquisitor_inspect_artifacts = function() {
        // Inspect all player artifacts and count those that match the inspection scope
        for (var g = 0; g < array_length(obj_ini.artifact_struct); g++) {
            var _arti = obj_ini.artifact_struct[g];
            if (_arti == undefined) { continue; }
            if (_arti.type() == "") { continue; }

            // Ship-scoped: if ships is an array or single id, only include those ships
            if (_arti.ship_id() > -1) {
                if (is_array(ships)) {
                    if (!array_contains(ships, _arti.ship_id())) { continue; }
                } else {
                    if (_arti.ship_id() != ships) { continue; }
                }
            }

            // Location / star-scoped: if artifact location doesn't match star name, skip
            if (obj_ini.artifact_loc[g] != "" && obj_ini.artifact_loc[g] != star.name) {
                // if the artifact isn't on this star, skip
                continue;
            }

            if (_arti.inquisition_disaprove() && !obj_controller.und_armouries) {
                finds.heresy += 8;
                finds.daemonic += 1;
            }
        }
    };

    static add_xenos_mercs = function(role) {
        // ensure struct exists on finds
        if (!struct_exists(finds, "xenos_mercs")) {
            finds.xenos_mercs = {};
        }
        if (!struct_exists(finds.xenos_mercs, role)) {
            finds.xenos_mercs[$ role] = 1;
        } else {
            finds.xenos_mercs[$ role] += 1;
        }
        finds.heresy += 1;
    };

    // ----- Inspection modules that use internal star & planets -----

    static inspect_secret_base = function() {
        if (!instance_exists(star)) { return; }

        var planet_list = is_array(planets) ? planets : [planets];
        var any_found = false;

        for (var p = 0; p < array_length(planet_list); p++) {
            var pidx = planet_list[p];
            if (pidx < 0) { continue; }
            if (pidx >= star.planets) { continue; }
            if (!is_array(star.p_upgrades[pidx]) || array_length(star.p_upgrades[pidx]) == 0) { continue; }

            var base_search = search_planet_features(star.p_upgrades[pidx], P_features.SecretBase);
            if (array_length(base_search) > 0) {
                any_found = true;
                var player_base = star.p_upgrades[pidx][base_search[0]];
                var _poor_base_practice = finds.poor_practices;

                if (player_base.vox > 0) { _poor_base_practice += 2; }
                if (player_base.torture > 0) { _poor_base_practice += 1; }
                if (player_base.narcotics > 0) { _poor_base_practice += 3; }

                alter_disposition([
                    [eFACTION.Imperium, -_poor_base_practice * 2],
                    [eFACTION.Inquisition, -_poor_base_practice * 3],
                    [eFACTION.Ecclesiarchy, -_poor_base_practice * 3]
                ]);

                finds.heresy += _poor_base_practice;
                finds.secret_lair_flag = true;

                if (_poor_base_practice >= 3) {
                    obj_controller.inqis_flag_lair += 1;
                    obj_controller.loyalty -= 10;
                    obj_controller.loyalty_hidden -= 10;

                    if ((obj_controller.inqis_flag_lair == 2 || obj_controller.disposition[eFACTION.Inquisition] < 0 || obj_controller.loyalty <= 0)
                        && obj_controller.faction_status[eFACTION.Inquisition] != "War") {
                        finds.trigger_war = true;
                    }
                }

                if (player_base.inquis_hidden == 1) { player_base.inquis_hidden = 0; }
            }
        }

        return any_found;
    };

    static inspect_arsenal = function() {
        if (!instance_exists(star)) { return; }

        var planet_list = is_array(planets) ? planets : [planets];
        for (var p = 0; p < array_length(planet_list); p++) {
            var pidx = planet_list[p];
            if (pidx < 0) { continue; }
            if (pidx >= star.planets) { continue; }
            if (!is_array(star.p_upgrades[pidx]) || array_length(star.p_upgrades[pidx]) == 0) { continue; }

            var arsenal_search = search_planet_features(star.p_upgrades[pidx], P_features.Arsenal);
            if (array_length(arsenal_search) > 0) {
                var arsenal = star.p_upgrades[pidx][arsenal_search[0]];
                arsenal.inquis_hidden = 0;

                var cha_local = 0;
                var dem_local = 0;

                for (var e = 0; e < array_length(obj_ini.artifact_tags); e++) {
                    if (obj_ini.artifact[e] != "" && obj_ini.artifact_loc[e] == star.name && obj_controller.und_armouries <= 1) {
                        if (array_contains(obj_ini.artifact_tags[e], "chaos")) { cha_local += 1; }
                        if (array_contains(obj_ini.artifact_tags[e], "chaos_gift")) { cha_local += 1; }
                        if (array_contains(obj_ini.artifact_tags[e], "daemonic")) { dem_local += 1; }
                    }
                }

                var perc = ((dem_local * 10) + (cha_local * 3)) / 100;
                alter_disposition([
                    [eFACTION.Imperium, -max(round(obj_controller.disposition[eFACTION.Imperium] / 6 * perc), round(8 * perc))],
                    [eFACTION.Inquisition, -max(round(obj_controller.disposition[eFACTION.Inquisition] / 4 * perc), round(10 * perc))],
                    [eFACTION.Ecclesiarchy, -max(round(obj_controller.disposition[eFACTION.Ecclesiarchy] / 4 * perc), round(10 * perc))]
                ]);

                finds.heresy += (cha_local + dem_local);
                finds.cha += cha_local;
                finds.daemonic += dem_local;
                finds.secret_arsenal_flag = true;

                if ((dem_local * 10) + (cha_local * 3) >= 10) { finds.contraband_demand = true; }

                var start_inquisition_war = ((obj_controller.disposition[eFACTION.Inquisition] < 0 || obj_controller.loyalty <= 0)
                    && obj_controller.faction_status[eFACTION.Inquisition] != "War");
                if (start_inquisition_war) {
                    if (obj_controller.penitent == 1) { obj_controller.alarm[8] = 1; }
                    else { scr_audience(4, "loyalty_zero", 0, "", 0, 0); }
                    finds.trigger_war = true;
                }
            }
        }
    };

    static inspect_gene_vault = function() {
        if (!instance_exists(star)) { return; }

        var planet_list = is_array(planets) ? planets : [planets];
        for (var p = 0; p < array_length(planet_list); p++) {
            var pidx = planet_list[p];
            if (pidx < 0) { continue; }
            if (pidx >= star.planets) { continue; }
            if (!is_array(star.p_upgrades[pidx]) || array_length(star.p_upgrades[pidx]) == 0) { continue; }

            var vault_search = search_planet_features(star.p_upgrades[pidx], P_features.GeneVault);
            if (array_length(vault_search) > 0) {
                var gene_vault = star.p_upgrades[pidx][vault_search[0]];
                gene_vault.inquis_hidden = 0;

                obj_controller.inqis_flag_gene += 1;
                obj_controller.loyalty -= 10;
                obj_controller.loyalty_hidden -= 10;

                alter_disposition([[eFACTION.Inquisition, -tem1_base * 3]]);

                finds.secret_gene_flag = true;

                if ((obj_controller.inqis_flag_gene >= 3 || obj_controller.loyalty <= 0 || obj_controller.disposition[eFACTION.Inquisition] < 0)
                    && obj_controller.faction_status[eFACTION.Inquisition] != "War") {
                    obj_controller.alarm[8] = 1;
                    finds.trigger_war = true;
                }
            }
        }
    };

    // Build and display the popup based on collected flags/finds
    static finalize_contraband_popup = function() {
        if (!instance_exists(star)) { return; }

        var inquis_string = "The Inquisition";
        var popup = 0;
        var pop_tit = "";
        var pop_txt = "";
        var pop_spe = "";

        // determine popup code (preserve your prior numeric meanings)
        if (finds.secret_lair_flag) {
            popup = (finds.heresy >= 3) ? 2 : 1;
        }
        if (finds.secret_arsenal_flag) {
            popup = (finds.contraband_demand) ? 4 : 3;
        }
        if (finds.secret_gene_flag) {
            popup = (obj_controller.inqis_flag_gene >= 2) ? 6 : 5;
        }
        if (finds.trigger_war) {
            popup = 0.6;
        }

        var planet_label = "";
        if (is_array(planets)) {
            // show first planet for display purposes
            planet_label = scr_roman(planets[0]);
        } else {
            planet_label = scr_roman(planets);
        }
        var star_planet = star.name + planet_label;

        // Logging
        if (popup == 1) {
         scr_event_log("", $"{inquis_string} discovers your Secret Lair on {star_planet}."); 
     }
        else if (popup == 2 || popup == 0.2) { scr_event_log("red", $"{inquis_string} discovers your Secret Lair on {star_planet}.", star); }
        else if (popup == 3 || popup == 0.3) { scr_event_log("", $"{inquis_string} discovers your Secret Arsenal on {star_planet}.", star); }
        else if (popup == 4 || popup == 0.4) { scr_event_log("red", $"{inquis_string} discovers your Secret Arsenal on {star_planet}.", star); }
        else if (popup >= 5 || popup == 0.6) { scr_event_log("", $"{inquis_string} discovers your Secret Gene-Vault on {star_planet}.", star); }

        // Popup text
        if (popup == 1) {
            pop_tit = "Inquisition Discovers Lair";
            pop_txt = $"{inquis_string} has discovered your Secret Lair on {star_planet}. A quick inspection revealed that there was no contraband or heresy, though the Inquisition does not appreciate your secrecy at all.";
        }
        else if (popup == 2) {
            pop_tit = "Inquisition Discovers Lair";
            pop_txt = $"{inquis_string} has discovered your Secret Lair on {star_planet}. A quick inspection turned up heresy, most foul, and it has all been reported to the Inquisition. They are seething, and relations are damaged.";
        }
        else if (popup == 3) {
            pop_tit = "Inquisition Discovers Arsenal";
            pop_txt = $"{inquis_string} has discovered your Secret Arsenal on {star_planet}. A quick inspection revealed that there was no contraband or heresy, though the Inquisition does not appreciate your secrecy at all.";
        }
        else if (popup == 4) {
            pop_tit = "Inquisition Discovers Arsenal";
            pop_txt = $"{inquis_string} has discovered your Secret Arsenal on {star_planet}. A quick inspection turned up heresy, most foul, and it has all been reported to the Inquisition. Relations have been heavily damaged.";
        }
        else if (popup == 5) {
            pop_tit = "Inquisition Discovers Gene-Vault";
            pop_txt = $"{inquis_string} has discovered your Secret Gene-Vault on {star_planet} and reported it. The Inquisition does NOT appreciate your secrecy, nor the mass production of Gene-Seed. Relations are damaged.";
        }
        else if (popup == 6) {
            pop_tit = "Inquisition Discovers Gene-Vault";
            pop_txt = $"{inquis_string} has discovered your Secret Gene-Vault on {star_planet} and reported it. You were warned once already to not sneak about with Gene-Seed stores and Test-Slave incubators. Do not let it happen again or your Chapter will be branded heretics.";
        }

        // Contraband demand text
        if (finds.contraband_demand) {
            pop_txt += " The Inquisitor responsible for the inspection also demands that you hand over all heretical materials and Artifacts.";
            pop_spe = "contraband";
            instance_create(x, y, obj_temp_arti);
        }

        // popup options and inline methods
        var _pop_data = {
            options: [
                {
                    str1: "Hand over all Chaos and Daemonic Artifacts",
                    method: function() {
                        var contraband = [];
                        for (var i = 0; i < array_length(obj_ini.artifact_struct); i++) {
                            if (obj_ini.artifact[i] != "") {
                                var arti = fetch_artifact(i);
                                if (arti.inquisition_disaprove()) { array_push(contraband, i); }
                            }
                        }
                        for (var j = 0; j < array_length(contraband); j++) { delete_artifact(contraband[j]); }
                        obj_controller.cooldown = 10;
                        with (obj_ground_mission) { instance_destroy(); }
                        reset_popup_options();
                        text = $"{array_length(contraband)} Chaos and Daemonic Artifacts have been handed over to the Inquisitor.";
                        image = "";
                        exit;
                    }
                },
                {
                    str1: "Over your dead body",
                    method: function() {
                        obj_controller.cooldown = 10;
                        if (number != 0 && instance_exists(obj_turn_end)) { obj_turn_end.alarm[1] = 4; }
                        instance_destroy();
                        exit;
                    }
                }
            ]
        };

        if (popup >= 1) {
            scr_popup(pop_tit, pop_txt, "inquisition", pop_spe, _pop_data);
        }
    };

    // optional convenience: keep an "inspection_report" wrapper that calls finalize
    static inspection_report = function() {
        if (finds.heresy>0){
        	var _inquisitor_tolerance = inquisitor_disp/5;
            var _heretic_roll = irandom(_inquisitor_tolerance);

            if (_heretic_roll <= finds.heresy){
                obj_controller.alarm[8]=1;
                if (finds.daemonic > 0){
                    scr_alert("red","inspect","Inquisitor discovers Daemonic item(s) in your posession.",0,0);
                }
                if (struct_exists(finds, "xenos_mercs")) {
                    var _merc_types = variable_struct_get_names(finds.xenos_mercs);
                    if (array_length(_merc_types) > 0) {
                        var _msg = "Inquisitor discovers Xenos mercenaries serving within your ranks:";
                        for (var i = 0; i < array_length(_merc_types); i++) {
                            var _role = _merc_types[i];
                            var _count = finds.xenos_mercs[$ _role];
                            var _role_string = string_plural_count(_role, _count, true); 
                            _msg += $"\n- {_role_string}";
                        }
                        scr_alert("red", "inspect", _msg, 0, 0);
                    }
                }
                if (finds.daemonic=0 && !_struct_exists(finds,"xenos_mercs")){
                    scr_alert("red","inspect","Inquisitor discovers heretical material in your posession.",0,0);
                }


                finalize_contraband_popup();
            }
        } else {
        	var _inspection_passed_string = "The inquisitor Has chosen to turnj a blind eye to some of your more heretical dealings on this occaision. However, it would perhaps be wise to be more careful in furture ";
        	scr_popup("Inquisitor Finish Inspection", _inspection_passed_string,"inquisition")
        }
    };
}


function inquisition_inspection_loyalty(inspection_type){
    if (inspection_type="inspect_world") or (inspection_type="inspect_fleet"){
    
        var _inspect_results = new inquisitor_inspection_structure();

        that=instance_nearest(x,y,obj_star);

        if (inspection_type="inspect_world"){
            var _monestary_planet = scr_get_planet_with_feature(that, P_features.Monastery);
            if (_monestary_planet!= -1){
                _inspect_results.planets  = _monestary_planet;
            } else {
                var _plans = [];
                for (var i=1;i<=that.planets;i++){
                    array_push(_plans,i);
                }
                _inspect_results.planets = _plans;
            }

            _inspect_results.star = that;

            _inspect_results.planet_heresys();
            
            _inspect_results.collect_inspection_units();
        
            _inspect_results.inquisitor_inspect_artifacts();

            _inspect_results.inquisitor_inspect_units();
            
        }
    
        else if (inspection_type="inspect_fleet"){
            with(obj_en_fleet){
                if (string_count("Inqis",trade_goods)=0) or (owner  != eFACTION.Inquisition) then instance_deactivate_object(id);
            }

            if (instance_exists(obj_en_fleet)) and (instance_exists(obj_p_fleet)){
                var player_inspection_fleet=instance_nearest(obj_en_fleet.x,obj_en_fleet.y,obj_p_fleet);

                _inspect_results.ships = fleet_full_ship_array(player_inspection_fleet);

                _inspect_results.collect_inspection_units();
            
                _inspect_results.inquisitor_inspect_artifacts();

                _inspect_results.inquisitor_inspect_units();

                if (player_inspection_fleet.hurssy>0){
                    _inspect_results.finds.heresy+=player_inspection_fleet.hurssy;
                }

                var unit;
                if (player_inspection_fleet.hurssy>0) then hurr+=player_inspection_fleet.hurssy;
                var ca, ia;
                
                var _search_units = collect_role_group("all",["",0,player_ships]);

                _inspect_results.inquisitor_inspect_units(_search_units);
            }
            instance_activate_object(obj_en_fleet);
        }
    
        _inspect_results.inspection_report();
        

        for (var i=0;i<array_length(obj_controller.loyal_num);i++){
            var diceh=0;
        
            if (obj_controller.loyal_num[i]<1) and (obj_controller.loyal_num[i]>0) and (obj_controller.loyal[i]!="Avoiding Inspections"){
                diceh=random(floor(100))+1;
            
                if (diceh<=(obj_controller.loyal_num[i]*1000)){
                    if (obj_controller.loyal[i]="Heretic Contact"){
                        obj_controller.loyal_num[i]=80;
                        obj_controller.loyal_time[i]=9999;
                        scr_alert("red","inspect","Inquisitor discovers evidence of Chaos Lord correspondence.",0,0);
                    
                        var one;one=0;
                        if (obj_controller.disposition[4]>=80) and (one=0){obj_controller.disposition[4]=30;one=1;}
                        if (obj_controller.disposition[4]<80) and (obj_controller.disposition[4]>10) and (one=0){obj_controller.disposition[4]=5;one=2;}
                        if (obj_controller.disposition[4]<=10) and (one=0){obj_controller.disposition[4]=0;one=3;}
                    
                        if ((obj_controller.loyalty-80)<=0) and (one<3) then one=3;
                        if (one=1) then with(obj_controller){
                            scr_audience(4,"chaos_audience1",0,"",0,0);
                        }
                        if (one=2) then with(obj_controller){
                            scr_audience(4,"chaos_audience2",0,"",0,0);
                        }
                        if (one=3) then obj_controller.alarm[8]=1;
                    }
                    if (obj_controller.loyal[i]="Heretical Homeworld"){obj_controller.loyal_num[i]=20;obj_controller.loyal_time[i]=3;}
                    if (obj_controller.loyal[i]="Traitorous Marines"){obj_controller.loyal_num[i]=30;obj_controller.loyal_time[i]=9999;}
                    // if (obj_controller.loyal[i]="Use of Sorcery"){obj_controller.loyal_num[i]=30;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Mutant Gene-Seed"){obj_controller.loyal_num[i]=30;obj_controller.loyal_time[i]=9999;}
                
                    if (obj_controller.loyal[i]="Non-Codex Arming"){obj_controller.loyal_num[i]=12;obj_controller.loyal_time[i]=3;}
                    if (obj_controller.loyal[i]="Non-Codex Size"){obj_controller.loyal_num[i]=12;obj_controller.loyal_time[i]=3;}
                    if (obj_controller.loyal[i]="Lack of Apothecary"){obj_controller.loyal_num[i]=8;obj_controller.loyal_time[i]=1;}
                    if (obj_controller.loyal[i]="Upset Machine Spirits"){obj_controller.loyal_num[i]=8;obj_controller.loyal_time[i]=1;}
                    if (obj_controller.loyal[i]="Undevout"){obj_controller.loyal_num[i]=20;obj_controller.loyal_time[i]=3;}
                    if (obj_controller.loyal[i]="Irreverance for His Servants"){obj_controller.loyal_num[i]=12;obj_controller.loyal_time[i]=5;}
                    if (obj_controller.loyal[i]="Unvigilant"){obj_controller.loyal_num[i]=12;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Conduct Unbecoming"){obj_controller.loyal_num[i]=8;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Refusing to Crusade"){obj_controller.loyal_num[i]=20;obj_controller.loyal_time[i]=9999;}
                
                    if (obj_controller.loyal[i]="Eldar Contact"){obj_controller.loyal_num[i]=4;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Ork Contact"){obj_controller.loyal_num[i]=4;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Tau Contact"){obj_controller.loyal_num[i]=4;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Xeno Trade"){obj_controller.loyal_num[i]=20;obj_controller.loyal_time[i]=9999;}
                    if (obj_controller.loyal[i]="Xeno Associate"){obj_controller.loyal_num[i]=20;obj_controller.loyal_time[i]=9999;}
                
                    if (obj_controller.loyal[i]="Inquisitor Killer"){obj_controller.loyal_num[i]=100;obj_controller.loyal_time[i]=9999;}
                    // if (obj_controller.loyal[i]="Avoiding Inspections"){obj_controller.loyal_num[i]=20;obj_controller.loyal_time[i]=120;}
                    // if (obj_controller.loyal[i]="Lost Standard"){obj_controller.loyal_num[i]=10;obj_controller.loyal_time[i]=9999;}
                
                    obj_controller.loyalty_hidden-=obj_controller.loyal_num[i];
                }
            }
        }// End repeat
    
        obj_controller.loyalty=obj_controller.loyalty_hidden;
    }    
}

function inquisitor_contraband_take_popup(cur_star, planet) {
    var _inspect = new inquisitor_inspection_structure();

    _inspect.star = cur_star;
    _inspect.planets = planet;

    // =====================================================
    // --- Run individual inspection modules ---
    // =====================================================

    if (cur_star.p_type[planet] == "Dead" && array_length(cur_star.p_upgrades[planet]) > 0) {

        // --- Secret Base ---
        _inspect.inspect_secret_base();

        // --- Arsenal ---
        _inspect.inspect_arsenal();

        // --- Gene Vault ---
        _inspect.inspect_gene_vault();
    }

    // =====================================================
    // --- Generate Popup + Alerts ---
    // =====================================================
    _inspect.finalize_contraband_popup();
}


function inquisition_inspection_logic(){
	var inspec_alert_string = "";
	var cur_star=instance_nearest(x,y,obj_star);
    inquisitor = inquisitor<0 ? 0 : inquisitor;
	var inquis_string = $"Inquisitor {obj_controller.inquisitor[inquisitor]}";
	 if (string_count("fleet",trade_goods)==0){
            inspec_alert_string = $"{inquis_string} finishes inspection of {cur_star.name}";
            inquisition_inspection_loyalty("inspect_world");// This updates the loyalties
    } 

    else if (string_count("fleet",trade_goods)>0){
    	inspec_alert_string = $"{inquis_string} finishes inspection of your fleet";
        inquisition_inspection_loyalty("inspect_fleet");// This updates the loyalties
        target=noone;
    }

    if (inspec_alert_string!=""){
        scr_event_log("", inspec_alert_string, cur_star.name);
        scr_alert("green","duhuhuhu",inspec_alert_string, x,y);
    }
    
    // Test-Slave Incubator Crap
    if (obj_controller.und_gene_vaults==0){
        var hur = inquisitor_approval_gene_banks()
        if (hur>0){
            
            if (hur=1) then obj_controller.disposition[4]-=max(6,round(obj_controller.disposition[4]*0.2));
            if (hur=2) then obj_controller.disposition[4]-=max(3,round(obj_controller.disposition[4]*0.1));
            
            
            obj_controller.inqis_flag_gene+=1;
            if (obj_controller.inqis_flag_gene=1){
                if (hur=1) then inquis_string+=" has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Your Chapter has plenty enough Gene-Seed to restore itself to full strength and the Incubators on top of that are excessive.  Both have been reported, and you are ordered to remove the Test-Slave Incubators.  Relations with the Inquisition are also more strained than before.";
                if (hur=2) then inquis_string+=" has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Your Chapter is already at full strength and the Incubators on top of that are excessive.  The Incubators have been reported, and you are ordered to remove them immediately.  Relations with the Inquisition are also slightly more strained than before.";
            }
            if (obj_controller.inqis_flag_gene=2){
                if (hur=1) then inquis_string+=" has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Both the stores and incubators have been reported, and you are AGAIN ordered to remove the Test-Slave Incubators.  The Inquisitor says this is your final warning.";
                if (hur=2) then inquis_string+=" has noted your abundant Gene-Seed stores and Test-Slave Incubators.  Your Chapter is already at full strength and the Incubators are unneeded.  The Incubators have been reported, AGAIN, and you are to remove them.  The Inquisitor says this is your final warning.";
            }
            if (obj_controller.inqis_flag_gene=3){
                if (obj_controller.faction_status[eFACTION.Inquisition]!="War") then obj_controller.alarm[8]=1;
            }
            scr_popup("Inquisition Inspection", inquis_string, "inquisition");           
            
        }
    }
}

function inquisitor_approval_gene_banks(){
    var gene_slave_count = 0;
    var hur=0
    for (var e=0;e<array_length(obj_ini.gene_slaves);e++){
        gene_slave_count += obj_ini.gene_slaves[e].num;
    }
    if (obj_controller.marines<=200) and (gene_slave_count>=100) and (obj_controller.gene_seed>=1100) then hur=1;
    if (obj_controller.marines<=500) and (obj_controller.marines>200) and (gene_slave_count>=75) and (obj_controller.gene_seed>=900) then hur=1;
    if (obj_controller.marines<=700) and (obj_controller.marines>500) and (gene_slave_count>=50) and (obj_controller.gene_seed>=750) then hur=1;
    if (obj_controller.marines>700) and (gene_slave_count>=50) and (obj_controller.gene_seed>=500) then hur=1;
    if (obj_controller.marines>990) and (gene_slave_count>=50) then hur=2;
    return hur;
}