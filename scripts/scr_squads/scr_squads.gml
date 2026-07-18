function fetch_squad(array_id) {
    return obj_ini.squads[$ array_id];
}

function get_squad_ids() {
    return struct_get_names(obj_ini.squads);
}

function squad_count() {
    return array_length(get_squad_ids());
}

// constructor for new squad

/* okay so basically this function loops through a given company and attempts to sort the units in the company not in a squad already into 
the requested squad type , if the squad is not possible it will  not be made*/
// squad_type: the type of squad to be created as a string to access the correct key in obj_ini.squad_types
// company : the company you wish to create the squad in (int)
//squad_loadout: true if you want to use the squad loadout sorting algorithem to re-equip the squad in accordance with the squad type loadout

/*
        squad guidance
            define a role that can exist in a squad by defining 
            [<role>, {
                "max":<maximum number of this role allowed in squad>
                "min":<minimum number of this role required in squad>
                }
            ]
            by adding "loadout" as a key to the role struct e.g {"min":1,"max":1,"loadout":{}}
                a default or optional loadout can be created for the given role in the squad
            "loadout" has two possible keys "required" and "option"
            a required loadout always follows this syntax <loadout_slot>:[<loadout_item>,<required number>]
                so "wep1":["Bolter",4], will mean four marines are always equipped with 4 bolters in the wep1 slot

            option loadouts follow the following syntax <loudout_slot>:[[<loadout_item_list>],<allowed_number>]
                for example [["Flamer", "Meltagun"],1], means the role can have a max of one flamer or meltagun
                    [["Plasma Pistol","Bolt Pistol"], 4] means the role can have a mix of 4 plasma pistols and bolt pistols on top
                        of all required loadout options

    */
function SquadEquipmentSorting(squad, from_armoury = true, to_armoury = true) constructor {
    self.target_squad = squad;
    self.from_armoury = from_armoury;
    self.to_armoury = to_armoury;
    squad_type = target_squad.type;
    squad_unit_types = squad.find_squad_unit_types();
    full_squad_data = obj_ini.squad_types[$ squad_type];
    unit_role = "";
    members_UnitGroup = squad.get_members(true);
    members_UnitGroup.shuffle();
    optional_load = undefined;
    required_load = undefined;

    target_squad.update_fulfilment();

    static sort = function() {
        for (var i = 0; i < array_length(squad_unit_types); i++) {
            unit_role = squad_unit_types[i];
            role_squad_loadout();
        }
    };

    //TODO we proobably have amcaro or soomethinng for this somewhere
    static load_out_areas = [
        "wep1",
        "wep2",
        "armour",
        "gear",
        "mobi",
    ];

    static structure_role_optional_loadout = function(optional_data) {
        optional_load = variable_clone(optional_data); //create a fulfillment object for optional loadouts

        var _optional_loadout_slots = struct_get_names(optional_load);

        for (var slot = 0; slot < array_length(_optional_loadout_slots); slot++) {
            var _load_out_slot = _optional_loadout_slots[slot];
            for (var i = 0; i < array_length(optional_load[$ _load_out_slot]); i++) {
                array_insert(optional_load[$ _load_out_slot][i], 2, 0);
            }
        }
    };

    static structure_role_required_loadout = function(required_data) {
        //find out if the _unit type for the squad has required  equipment thresholds

        required_load = variable_clone(required_data);
        required_loadout_slots = struct_get_names(required_load);
        for (var i = 0; i < array_length(required_loadout_slots); i++) {
            var _current_load_slot = required_loadout_slots[i];
            var _equip_slot = required_load[$ _current_load_slot];
            if (is_string(required_load[$ _current_load_slot][1])) {
                if (required_load[$ _current_load_slot][1] == "max") {
                    required_load[$ _current_load_slot][1] = target_squad.squad_fulfilment[$ unit_role];
                }
            }
            array_insert(required_load[$ _current_load_slot], 2, 0);
        }
    };

    static equip_required_for_role = function(_unit) {
        if (required_load[$ current_load_slot][2] < required_load[$ current_load_slot][1]) {
            //if the required amount of equipment is not in the squad already equip this marine with equipment
            var _item_to_add = required_load[$ current_load_slot][0];
            var required_load_set = {};
            required_load_set[$ current_load_slot] = _item_to_add;
            _unit.alter_equipment(required_load_set, from_armoury, to_armoury);
            required_load[$ current_load_slot][2]++;
            return true;
        } //if all required equipment is included in the squad start adding optional equipment
        return false;
    };

    static equip_optional_for_role = function(_unit) {
        //this basically ensures the optional squad items are randomly selected and allocated in order to make squads more variable

        var _optional_groups = optional_load[$ current_load_slot];
        for (var i = 0; i < array_length(_optional_groups); i++) {
            var _optional_load_data = _optional_groups[i];
            var _optionals_filled = _optional_load_data[2];
            var _optionals_max_allowed = _optional_load_data[1];
            var _optionals_equipment = _optional_load_data[0];
            var _item_to_add;
            if (_optionals_filled < _optionals_max_allowed) {
                var _is_equipment_set = array_length(_optional_load_data) > 3;

                if (is_array(_optionals_equipment)) {
                    //if the array items are varibale e.g a struct
                    _item_to_add = array_random_element(_optionals_equipment);
                } else {
                    _item_to_add = _optionals_equipment;
                }

                // this ensures a marine never gets overloaded with an overly bulky weapon loadout
                if (current_load_slot == "wep1") {
                    var _return_item = _unit.weapon_one();
                    _unit.update_weapon_one(_item_to_add, from_armoury, to_armoury);
                    _unit.ranged_attack();
                    _unit.melee_attack();
                    if ((_unit.encumbered_ranged || _unit.encumbered_melee) && !_is_equipment_set) {
                        _unit.update_weapon_one(_return_item, from_armoury, to_armoury);
                        continue;
                    }
                } else if (current_load_slot == "wep2") {
                    var _return_item = _unit.weapon_two();
                    _unit.update_weapon_two(_item_to_add, from_armoury, to_armoury);
                    _unit.ranged_attack();
                    _unit.melee_attack();
                    if ((_unit.encumbered_ranged || _unit.encumbered_melee) && !_is_equipment_set) {
                        _unit.update_weapon_two(_return_item, from_armoury, to_armoury);
                        continue;
                    }
                }
                var _opt_load_out = {};
                _opt_load_out[$ current_load_slot] = _item_to_add;
                _unit.alter_equipment(_opt_load_out, from_armoury, to_armoury);
                _optional_load_data[1]++;
                if (_is_equipment_set) {
                    var _equip_set_data = _optional_load_data[3];
                    if (is_struct(_equip_set_data)) {
                        _unit.alter_equipment(_equip_set_data, from_armoury, to_armoury);
                        array_push(ignore_units, _unit.uid);
                    }
                }
                break;
            }
        }
    };

    static equip_loudouts_specific_equip_slot = function() {
        var _members_with_role = members_UnitGroup.get_from({role: unit_role});
        if (!struct_exists(current_unit_squad_data, "loadout")) {
            return;
        }
        var _unit;
        var _loudouts = current_unit_squad_data[$ "loadout"];
        while (_members_with_role.number() > 0) {
            _unit = _members_with_role.pop();
            if (array_contains(ignore_units, _unit.uid)) {
                continue;
            }
            if (_unit.role() != unit_role) {
                continue;
            }

            if (required_load != undefined && struct_exists(required_load, current_load_slot)) {
                var _needed_required = equip_required_for_role(_unit);
                if (_needed_required) {
                    continue;
                }
            }

            if (optional_load != undefined && struct_exists(optional_load, current_load_slot)) {
                equip_optional_for_role(_unit);
            }
        }
    };

    static role_squad_loadout = function() {
        required_load = undefined;
        optional_load = undefined;

        current_unit_squad_data = full_squad_data[$ unit_role];
        if (!struct_exists(current_unit_squad_data, "loadout")) {
            return;
        }

        var _loudout_data = current_unit_squad_data[$ "loadout"];
        //find out if the _unit type for the squad has optional equipment thresholds
        if (struct_exists(_loudout_data, "option")) {
            structure_role_optional_loadout(_loudout_data[$ "option"]);
        }

        //if there are required loadout items
        if (struct_exists(_loudout_data, "required")) {
            structure_role_required_loadout(_loudout_data[$ "required"]);
        }

        ignore_units = [];
        for (var i = 0; i < array_length(load_out_areas); i++) {
            current_load_slot = load_out_areas[i];
            equip_loudouts_specific_equip_slot();
        }
    };
}

function UnitSquad(squad_type = undefined, company = 0) constructor {
    members = [];
    type = "";
    squad_fulfilment = {};
    base_company = company;
    life_members = 0;
    nickname = "";
    assignment = "none";
    class = [];
    squad_leader = "";
    type_data = {};
    base = "tactical";
    formation_place = "";
    formation_options = [];
    uid = scr_uuid_generate();
    allow_bulk_swap = true;

    //TODO introduce loyalty hits from long periods of exile from hierarchy nodes
    // nodes will be captains chapter masters and other senior staff
    time_from_parent_node = 0;

    // heres where the whole thing gets annoying
    /*basically each equipment slot is looped through and inside each loop each marine is looped through in a random order to ensure 
			that each squad looks different and that each marine has a range of optional and required equipment
			required equipmetn is things like boltguns and combat knives in a tactical squad
			optional equipment is stuff like lascannons and specialist equipment in a tactical squad or plasma pistols in an assualt squad
			in future i'd like to tailer these to marine skill sets e.g the marines with the best ranged stats get given the best ranged equipment	
		*/
    static sort_squad_loadout = function(from_armoury = true, to_armoury = true) {
        var _sorter = new SquadEquipmentSorting(self, from_armoury, to_armoury);
        _sorter.sort();
    };

    static stat_av = function(stat) {};

    static add_type_data = function(data) {
        type_data = data;
        display_name = type_data[$ "display_data"];
        if (struct_exists(type_data, "class")) {
            class = type_data.class;
        }
        if (struct_exists(type_data, "base")) {
            base = type_data.base;
        } else {
            base = "tactical";
        }
        if (struct_exists(type_data, "formation_options")) {
            formation_options = type_data.formation_options;
            formation_place = formation_options[0];
        }
    };

    static change_type = function(new_type) {
        type = new_type;
        add_type_data(obj_ini.squad_types[$ type].type_data);
    };

    if (squad_type != undefined) {
        change_type(squad_type);
    }

    static find_squad_unit_types = function() {
        //find out what type of units squad consists of
        var fill_squad = obj_ini.squad_types[$ type];
        squad_unit_types = struct_get_names(fill_squad);
        var _wanted_unit_role;
        var unit_type_count = array_length(squad_unit_types);
        for (var i = 0; i < unit_type_count; i++) {
            _wanted_unit_role = squad_unit_types[i];
            if (_wanted_unit_role == "type_data") {
                array_delete(squad_unit_types, i, 1);
                unit_type_count--;
                i--;
                continue;
            }
            squad_fulfilment[$ _wanted_unit_role] = 0; //create a fulfilment structure to log members of squad
        }
        return squad_unit_types;
    };

    static get_squad_structs = function(as_UnitGroup) {
        var _struct_array = [];
        for (var i = array_length(members) - 1; i >= 0; i--) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                continue;
            } else {
                array_push(_struct_array, _unit);
            }
        }
        return _struct_array;
    };

    // for creating a new sergeant from existing squad members
    static new_sergeant = function(veteran = false) {
        var exp_unit = "";
        var _unit;
        var highest_exp = 0;
        var member_length = array_length(members);
        for (var i = 0; i < member_length; i++) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            }
            if (_unit.experience > highest_exp) {
                highest_exp = _unit.experience;
                exp_unit = _unit;
            }
        }
        if ((array_length(members) > 0) && is_struct(exp_unit)) {
            if (exp_unit.name() != "") {
                var new_role;
                if (veteran == true) {
                    new_role = obj_ini.role[100][19];
                } else {
                    new_role = obj_ini.role[100][18];
                }
                exp_unit.update_role(new_role);
                if (irandom(1) == 0) {
                    exp_unit.add_trait("lead_example");
                }
            }
        }
    };

    static kill_members = function() {
        for (var i = 0; i < array_length(members); i++) {
            scr_kill_unit(members[i][0], members[i][1]);
        }
        members = [];
    };

    static cancel_assignment = function() {};

    /*checks the status of squad so it can be either restocked or 
		deleted if there are no longer enough members ot make a squad*/
    // fill from requiures a valid UnitIndex struct
    static update_fulfilment = function(fill_from = undefined) {
        var _unit;

        squad_fulfilment = {};
        var fill_squad = obj_ini.squad_types[$ type]; //grab all the squad struct info from the squad_types struct

        var squad_unit_types = struct_get_names(fill_squad); //find out what type of units squad consists of
        var unit_type_count = array_length(squad_unit_types);
        for (var i = unit_type_count - 1; i >= 0; i--) {
            var _wanted_unit_role = squad_unit_types[i];
            if (_wanted_unit_role == "type_data") {
                array_delete(squad_unit_types, i, 1);
                continue;
            }
            squad_fulfilment[$ _wanted_unit_role] = 0; //create a fulfilment structure to log members of squad
        }
        var member_length = array_length(members);
        for (var i = member_length - 1; i >= 0; i--) {
            //checks squad member is still valid
            _unit = fetch_member(i);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                continue;
            }
            if (struct_exists(squad_fulfilment, _unit.role())) {
                squad_fulfilment[$ _unit.role()]++;
            } else {
                squad_fulfilment[$ _unit.role()] = 1;
            }
        }
        fulfilled = true;
        required = {};
        space = {};
        has_space = false;
        for (var i = 0; i < array_length(squad_unit_types); i++) {
            var _wanted_unit_role = squad_unit_types[i];
            var _max_role_count = fill_squad[$ _wanted_unit_role][$ "max"];
            var _squad_role_current = squad_fulfilment[$ _wanted_unit_role];

            var _min_role_allowed = fill_squad[$ _wanted_unit_role][$ "min"];

            if (fill_from != undefined) {
                while (fill_from.has_role(_wanted_unit_role) && _squad_role_current < _max_role_count) {
                    var _new_member = fill_from.pop_role_member(_wanted_unit_role);
                    add_member(_new_member.company, _new_member.marine_number);
                    squad_fulfilment[$ _wanted_unit_role]++;
                    _squad_role_current = squad_fulfilment[$ _wanted_unit_role];
                    _new_member.squad = uid;
                }
            }

            if (_squad_role_current < _max_role_count) {
                space[$ _wanted_unit_role] = _max_role_count - _squad_role_current;
                has_space = true;
            }

            if (squad_fulfilment[$ _wanted_unit_role] < _min_role_allowed) {
                fulfilled = false;
                required[$ _wanted_unit_role] = _min_role_allowed - _squad_role_current;
            }
        }
        var _sarge = obj_ini.role[100][eROLE.SERGEANT];
        if (struct_exists(required, _sarge)) {
            if (required[$ _sarge] > 0) {
                new_sergeant();
                required[$ _sarge]--;
            }
        }
        //find a new veteran sergeant
        var _vet_sarge = obj_ini.role[100][eROLE.VETERANSERGEANT];
        if (struct_exists(required, _vet_sarge)) {
            if (required[$ _vet_sarge] > 0) {
                new_sergeant(true);
                required[$ _vet_sarge]--;
            }
        }
    };

    static empty_squad = function() {
        for (var r = array_length(members) - 1; r >= 0; r--) {
            fetch_member(r).squad = "none";
        }
        members = [];
    };

    static empty_squad_to_index = function(index) {
        var _mems = [];
        var _mem;
        for (var r = array_length(members) - 1; r >= 0; r--) {
            _mem = fetch_member(r);
            _mem.squad = "none";
            array_push(_mems, _mem);
        }
        index.add_to_index(_mems);
        members = [];
    };

    static fetch_member = function(index) {
        return fetch_unit(members[index]);
    };

    static fetch_members = function() {
        return collect_role_group("all", "", false, {"company": base_company, "squad": uid, "max_wanted": array_length(members)});
    };

    static add_member = function(comp, unit_number) {
        if (is_struct(comp)) {
            unit_number = comp.marine_number;
            comp = comp.company;
        }
        array_push(members, [comp, unit_number]);
        life_members++;
    };

    // for saving squads
    static jsonify = function(stringify = true) {
        var copy_struct = self; //grab marine structure
        var new_struct = {};
        var copy_part;
        var names = variable_struct_get_names(copy_struct); // get all keys within structure
        for (var name = 0; name < array_length(names); name++) {
            //loop through keys to find which ones are methods as they can't be saved as a json string
            if (!is_method(copy_struct[$ names[name]])) {
                copy_part = variable_clone(copy_struct[$ names[name]]);
                variable_struct_set(new_struct, names[name], copy_part); //if key value is not a method add to copy structure
            }
        }
        if (stringify) {
            return json_stringify(new_struct, true);
        } else {
            return new_struct;
        }
    };

    //function for loading in squad save data
    static load_json_data = function(data) {
        var names = variable_struct_get_names(data);
        for (var i = 0; i < array_length(names); i++) {
            variable_struct_set(self, names[i], variable_struct_get(data, names[i]));
        }
    };

    //this dermine the relative coherency of a squad on the basis that a squad needs to more or less be all together in order ot undertake squad actions
    static squad_loci = function() {
        var member_length = array_length(members);
        var locations = [];
        var system = "";
        var unit_loc;
        var _unit;
        var same_system = true;
        var same_loc_type = true;
        var loc_type = false;
        var same_loc_id = false;
        var loc_id;
        var in_orbit = false;
        var planet_side = false;
        var exact_loc = false;
        for (var i = 0; i < member_length; i++) {
            _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            }
            unit_loc = _unit.marine_location();
            if (system == "") {
                system = unit_loc[2];
                loc_type = unit_loc[0];
                loc_id = unit_loc[1];
            }
            if (system != unit_loc[2]) {
                same_system = false;
            }
            if (same_system) {
                if (loc_type != unit_loc[0]) {
                    same_loc_type = false;
                }
            }
            if (same_loc_type && same_system) {
                if (loc_id == unit_loc[1]) {
                    exact_loc = true;
                } else {
                    exact_loc = false;
                    if (loc_type == eLOCATION_TYPES.SHIP) {
                        in_orbit = true;
                    } else if (loc_type == eLOCATION_TYPES.PLANET) {
                        planet_side = true;
                    }
                }
            }
        }
        var final_loc_status = "";
        if (!same_system) {
            final_loc_status = "Scattered";
        } else if (same_loc_type) {
            if (loc_type == eLOCATION_TYPES.SHIP) {
                if (exact_loc) {
                    final_loc_status = $"aboard {obj_ini.ship[loc_id]}";
                } else if (in_orbit) {
                    final_loc_status = $"various ships orbiting {system}";
                }
            } else if (loc_type == eLOCATION_TYPES.PLANET) {
                if (exact_loc) {
                    final_loc_status = $"{system} {scr_roman_numerals()[loc_id - 1]}";
                } else if (planet_side) {
                    final_loc_status = $"various planets in {system}";
                }
            }
        } else {
            final_loc_status = $"system {system}";
        }
        return {
            text: final_loc_status,
            system: system,
            same_system: same_system,
            exact_loc: exact_loc,
            planet_side: planet_side,
            in_orbit: in_orbit,
        };
        //returns all the squad coherency data
    };

    //determines the leader of a squad by using the hierarchy array returned by role_hierarchy()
    //this means the highest ranking dude in a squad will always be the squad leader
    //failing that the highest experience dude
    static determine_leader = function() {
        var member_length = array_length(members);
        var hierarchy = role_hierarchy();
        var leader_hier_pos = array_length(hierarchy);
        var leader = "none";
        var highest_exp = 0;
        for (var i = 0; i < member_length; i++) {
            var _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            } else {
                if (leader == "none") {
                    leader = [
                        _unit.company,
                        _unit.marine_number,
                    ];
                    for (var r = 0; r < array_length(hierarchy); r++) {
                        if (hierarchy[r] == _unit.role()) {
                            leader_hier_pos = r;
                            break;
                        }
                    }
                } else if (leader_hier_pos < array_length(hierarchy) && hierarchy[leader_hier_pos] == _unit.role()) {
                    var _leader = fetch_unit(leader);
                    if (_leader.experience < _unit.experience) {
                        leader = [
                            _unit.company,
                            _unit.marine_number,
                        ];
                    }
                } else {
                    for (var r = 0; r < leader_hier_pos; r++) {
                        if (hierarchy[r] == _unit.role()) {
                            leader_hier_pos = r;
                            leader = [
                                _unit.company,
                                _unit.marine_number,
                            ];
                            break;
                        }
                    }
                }
            }
        }
        squad_leader = leader;
        return leader;
    };

    static change_sgt = function(new_sgt) {
        sgt = determine_leader();
        var remove_sgt;
        if (sgt != "none") {
            remove_sgt = fetch_unit(sgt);
            if (remove_sgt.IsSpecialist(SPECIALISTS_SQUAD_LEADERS)) {
                var replace_role = remove_sgt.role();
                remove_sgt.update_role(new_sgt.role());
                //TODO centralise loyalty changes for role changes in the update_role method
                remove_sgt.alter_loyalty(-10);
                new_sgt.update_role(replace_role);
                new_sgt.alter_loyalty(10);
            }
        }
    };

    static set_location = function(loc, lid, wid) {
        var member_length = array_length(members);
        var member_location;
        var system = noone;
        with (obj_star) {
            if (name == loc) {
                system = self;
                break;
            }
        }
        if (system == noone) {
            return "invalid system";
        }
        member_loop(set_member_loc, {loc: loc, lid: lid, wid: wid, system: system});
    };

    static member_loop = function(member_func, data_pack) {
        member_length = array_length(members);
        for (var i = 0; i < member_length; i++) {
            var _unit = fetch_unit(members[i]);
            if (_unit.name() == "") {
                array_delete(members, i, 1);
                member_length--;
                i--;
                continue;
            } else {
                var pack_return;
                with (_unit) {
                    pack_return = member_func(data_pack);
                }
                data_pack = pack_return;
                if (struct_exists(data_pack, "action")) {
                    if (data_pack.action == "break") {
                        break;
                    }
                }
            }
        }
        return data_pack;
    };

    static get_members = function(as_UnitGroup = false) {
        var mems = [];
        for (var i = 0; i < array_length(members); i++) {
            array_push(mems, fetch_member(i));
        }
        if (as_UnitGroup) {
            return new UnitGroup(mems);
        }
        return mems;
    };
}

// creates the origional distribution of squads accross the chapter
// lots of room for customisation of different chapters here

function get_compay_squad_arrangement(company) {
    var _comp_datas = obj_ini.chapter_squad_arrangement.companies;
    for (var i = 0; i < array_length(_comp_datas); i++) {
        if (_comp_datas[i].company == company) {
            return _comp_datas[i];
        }
    }
}

function ProportionalSquadEditor(data) constructor {
    move_data_to_current_scope(data);

    deleted = false;

    static draw = function() {
        box.draw();
        proportion_val_shift.draw();
        squad_title.draw();
        required_squad.proportion = max(proportion_val_shift.current_value, 1);
        if (delete_button.draw()) {
            for (var i = 0; i < array_length(arrangement); i++) {
                var _squad = arrangement[i];
                if (!struct_exists(_squad, "require") || _squad.require != true) {
                    if (required_squad.squad == _squad.squad) {
                        array_delete(arrangement, i, 1);
                        deleted = true;
                        deleted = true;
                        break;
                    }
                }
            }
        }
    };
}

function RequireSquadEditor(data) constructor {
    move_data_to_current_scope(data);

    deleted = false;

    static draw = function() {
        box.draw();
        min_val_shift.update({max_clamp: max_val_shift.current_value});
        min_val_shift.draw();
        max_val_shift.draw();
        squad_title.draw();
        required_squad.min_count = max(min_val_shift.current_value, 1);
        required_squad.max_count = max_val_shift.current_value;
        if (delete_button.draw()) {
            for (var i = 0; i < array_length(arrangement); i++) {
                var _squad = arrangement[i];
                if (struct_exists(_squad, "require") && _squad.require == true) {
                    if (required_squad.squad == _squad.squad) {
                        array_delete(arrangement, i, 1);
                        break;
                    }
                }
            }
        }
    };
}

function SquadArrangementEditor(company) constructor {
    self.company = company;
    arrangement = get_compay_squad_arrangement(company).squads;
    squads = obj_ini.squad_types;

    // --- layout constants (all derived from required_editor_box) ---
    static y_top = 175;
    static column_gap = 25;
    static column_w = 200;

    required_editor_box = new Box({
        x1: 100,
        w: column_w,
        y1: y_top,
        h: 1000,
    });

    static required_picker_x = function() {
        return required_editor_box.x2 + column_gap;
    };

    static proportional_editor_x = function() {
        return required_picker_x() + column_w + column_gap;
    };

    static proportional_picker_x = function() {
        return proportional_editor_x() + column_w + column_gap;
    };

    required_types = [];
    required_y = y_top;
    proportional_types = [];
    proportional_y = y_top;

    showing_required_picker = false;
    showing_proportional_picker = false;
    required_picker_options = [];
    proportional_picker_options = [];

    static get_squads_not_in_arrangement = function(require_filter, picker_x, picker_start_y) {
        var _available = [];
        var _squad_keys = struct_get_names(squads);
        var _py = picker_start_y;
        for (var i = 0; i < array_length(_squad_keys); i++) {
            var _key = _squad_keys[i];
            var _already_present = false;
            for (var j = 0; j < array_length(arrangement); j++) {
                var _arr_squad = arrangement[j];
                var _is_required = struct_exists(_arr_squad, "require") && _arr_squad.require == true;
                if (_arr_squad.squad == _key && _is_required == require_filter) {
                    _already_present = true;
                    break;
                }
            }
            if (!_already_present) {
                var _squad_data = squads[$ _key];
                var _btn = new UnitButtonObject({
                    style: "pixel",
                    label: _squad_data.type_data.display_data,
                    tooltip: $"add {_key} as a {require_filter ? "required" : "proportional"} squad",
                    set_width: true,
                    x1: picker_x,
                    y1: _py,
                    w: column_w,
                });
                _py += _btn.h + 4;
                array_push(_available, {key: _key, btn: _btn});
            }
        }
        return _available;
    };

    static add_new_required_type = function(required_squad) {
        var _squad_data = squads[$ required_squad.squad];
        var _squad_display = _squad_data.type_data.display_data;
        var _cx = required_editor_box.x1 + (required_editor_box.w / 2);

        var box = new Box({
            x1: required_editor_box.x1,
            y1: required_y,
            w: required_editor_box.w,
            h: 80,
        });

        var squad_title = new ReactiveString(_squad_display, _cx, required_y + 5, {
            halign: fa_center,
        });

        var max_val_shift = new ValueShifter("max", {
            current_value: required_squad.max_count,
            x1: _cx,
            y1: required_y + 25,
            max_clamp: 50,
            min_clamp: 1,
        });

        var min_val_shift = new ValueShifter("min", {
            current_value: required_squad.min_count,
            x1: _cx,
            y1: required_y + 55,
            min_clamp: 1,
            max_clamp: 50,
        });

        var delete_button = new UnitButtonObject({
            style: "pixel",
            label: "remove squad",
            tooltip: $"remove {_squad_display} from required squads",
            set_width: true,
            x1: required_editor_box.x1,
            y1: box.y2,
            w: required_editor_box.w,
        });

        var _edit = new RequireSquadEditor({
            required_squad,
            box,
            max_val_shift,
            min_val_shift,
            squad_title,
            delete_button,
        });

        array_push(required_types, _edit);
        required_y = delete_button.y2 + 10;
    };

    static add_new_proportional_type = function(required_squad) {
        var _squad_data = squads[$ required_squad.squad];
        var _squad_display = _squad_data.type_data.display_data;
        var _px = proportional_editor_x();
        var _cx = _px + (column_w / 2);

        var box = new Box({
            x1: _px,
            y1: proportional_y,
            w: column_w,
            h: 50,
        });

        var squad_title = new ReactiveString(_squad_display, _cx, proportional_y + 5, {
            halign: fa_center,
        });

        var proportion_val_shift = new ValueShifter("proportion", {
            current_value: required_squad.proportion,
            x1: _cx,
            y1: proportional_y + 25,
            min_clamp: 1,
            max_clamp: 50,
        });

        var delete_button = new UnitButtonObject({
            style: "pixel",
            label: "remove squad",
            tooltip: $"remove {_squad_display} from proportional squads",
            set_width: true,
            x1: _px,
            y1: box.y2,
            w: column_w,
        });

        var _edit = new ProportionalSquadEditor({
            required_squad,
            box,
            proportion_val_shift,
            squad_title,
            delete_button,
            arrangement,
        });

        array_push(proportional_types, _edit);
        proportional_y = delete_button.y2 + 10;
    };

    // --- reset ---

    static reset_required_squads = function() {
        required_types = [];
        required_y = y_top;
        for (var i = 0; i < array_length(arrangement); i++) {
            var _squad = arrangement[i];
            if (struct_exists(_squad, "require") && _squad.require == true) {
                add_new_required_type(_squad);
            }
        }
    };

    static reset_proportional_squads = function() {
        proportional_types = [];
        proportional_y = y_top;
        for (var i = 0; i < array_length(arrangement); i++) {
            var _squad = arrangement[i];
            if (!struct_exists(_squad, "require") || _squad.require != true) {
                add_new_proportional_type(_squad);
            }
        }
    };

    // --- picker openers ---

    static open_required_picker = function() {
        required_picker_options = get_squads_not_in_arrangement(true, required_picker_x(), add_required_button.y2 + 4);
        showing_required_picker = true;
        showing_proportional_picker = false;
        proportional_picker_options = [];
    };

    static open_proportional_picker = function() {
        proportional_picker_options = get_squads_not_in_arrangement(false, proportional_picker_x(), add_proportional_button.y2 + 4);
        showing_proportional_picker = true;
        showing_required_picker = false;
        required_picker_options = [];
    };

    // --- picker drawers ---

    static draw_required_picker = function() {
        for (var i = 0; i < array_length(required_picker_options); i++) {
            var _option = required_picker_options[i];
            if (_option.btn.draw()) {
                array_push(arrangement, {squad: _option.key, min_count: 1, max_count: 1, require: true});
                showing_required_picker = false;
                required_picker_options = [];
                reset_required_squads();
            }
        }
    };

    static draw_proportional_picker = function() {
        for (var i = 0; i < array_length(proportional_picker_options); i++) {
            var _option = proportional_picker_options[i];
            if (_option.btn.draw()) {
                array_push(arrangement, {squad: _option.key, proportion: 1});
                showing_proportional_picker = false;
                proportional_picker_options = [];
                reset_proportional_squads();
            }
        }
    };

    // --- labels ---

    required_string = new ReactiveString("Required Squads", required_editor_box.x1, y_top - 30, {
        tooltip: "Required Squads will always get filled and created first",
    });

    proportional_string = new ReactiveString("Proportional Squads", proportional_editor_x(), y_top - 30, {
        tooltip: "Proportional Squads will be built proportionally to other proportional squads — e.g. if Tactical is 1 and Bikers is 2, the system will make 2 Biker squads for every 1 Tactical squad",
    });

    // --- add buttons (top of their picker column, y tracks below last editor on reset) ---

    add_required_button = new UnitButtonObject({
        style: "pixel",
        label: "add required squad",
        tooltip: "add a new required squad to this company",
        set_width: true,
        x1: required_picker_x(),
        y1: y_top,
        w: column_w,
    });

    add_proportional_button = new UnitButtonObject({
        style: "pixel",
        label: "add proportional squad",
        tooltip: "add a new proportional squad to this company",
        set_width: true,
        x1: proportional_picker_x(),
        y1: y_top,
        w: column_w,
    });

    reset_required_squads();
    reset_proportional_squads();

    // --- draw ---

    static draw = function() {
        var _reset_required_structs = false;
        var _reset_proportional_structs = false;

        required_string.draw();
        for (var i = 0; i < array_length(required_types); i++) {
            var _squad = required_types[i];
            _squad.draw();
            if (_squad.deleted) {
                _reset_required_structs = true;
            }
        }
        if (add_required_button.draw()) {
            open_required_picker();
        }
        if (showing_required_picker) {
            draw_required_picker();
        }

        proportional_string.draw();
        for (var i = 0; i < array_length(proportional_types); i++) {
            var _squad = proportional_types[i];
            _squad.draw();
            if (_squad.deleted) {
                _reset_proportional_structs = true;
            }
        }
        if (add_proportional_button.draw()) {
            open_proportional_picker();
        }
        if (showing_proportional_picker) {
            draw_proportional_picker();
        }

        if (_reset_required_structs) {
            reset_required_squads();
        }
        if (_reset_proportional_structs) {
            reset_proportional_squads();
        }
    };
}

function game_start_squads() {
    obj_ini.squads = {};
    if (struct_exists(chapter_squad_arrangement, "companies")) {
        var _comp_datas = obj_ini.chapter_squad_arrangement.companies;
        for (var i = 0; i < array_length(_comp_datas); i++) {
            var _company = collect_company(_comp_datas[i].company);
            _company.organise_by_template(_comp_datas[i]);
        }
    }
}

function set_member_loc(loc_data) {
    var loc = loc_data.loc;
    var lid = loc_data.lid;
    var wid = loc_data.wid;
    var system = loc_data.system;
    var member_location = marine_location();
    if (wid > 0 && loc == member_location[2]) {
        if (member_location[0] == eLOCATION_TYPES.SHIP) {
            unload(wid, system);
        } else if (member_location[0] == eLOCATION_TYPES.PLANET && member_location[1] != wid && member_location[2] == loc) {
            get_unit_size();
            system.p_player[member_location[1]] -= size;
            system.p_player[wid] += size;
            planet_location = wid;
            ship_location = -1;
        }
    } else {
        if (wid == 0 && lid > -1) {
            load_marine(lid);
        }
    }
    return loc_data;
}
//finds all the squads linked to a given company
//TODO coalece lots of these functions to make make a company object
//maybe then we can have more than 10 companies 
