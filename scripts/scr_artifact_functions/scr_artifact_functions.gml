/// @desc Creates and registers a new artifact, returns its ID.
/// @param {String} artifact_type Base type ("random", "random_nodemon", "good", "chaos_gift", "Robot", "Tome", or a specific base type).
/// @param {String} artifact_tags Tag override ("minor", "inquisition", "daemonic", or "").
/// @param {Real} is_identified Turns remaining until identification.
/// @param {String} artifact_location Storage location (star name); "" resolves to the player's current location.
/// @param {Real} ship_id Ship array index (-1 = not on a ship).
/// @returns {Real} The new artifact's ID.
function scr_add_artifact(artifact_type = "random", artifact_tags = "", is_identified = 4, artifact_location = "", ship_id = -1) {
    // 1. INITIALIZE VARIABLES
    var tags = [];
    var base_type = "";
    var base_type_detail = "";
    var t3 = "", t4 = "", t5 = "";

    // 2. DETERMINE BASE TYPE AND DETAIL
    switch (artifact_type) {
        case "good":
            var good_choice = choose("Relic Blade", "Plasma Gun", "Rosarius", "Terminator Armour");
            base_type_detail = good_choice;
            switch (good_choice) {
                case "Rosarius":
                    base_type = "Gear";
                    break;
                case "Terminator Armour":
                    base_type = "Armour";
                    break;
                default:
                    base_type = "Weapon";
                    break;
            }

            break;
        case "Robot":
            base_type = "Device";
            base_type_detail = "Robot";
            break;
        case "Tome":
            base_type = "Device";
            base_type_detail = "Tome";
            break;
        case "chaos_gift":
            base_type = "Device";
            base_type_detail = choose("Casket", "Chalice", "Statue");
            break;
        case "random":
        case "random_nodemon":
            var rand1 = irandom(99); // 0 to 99
            if (rand1 < 45) {
                base_type = "Weapon";
            } else if (rand1 < 80) {
                base_type = "Armour";
            } else if (rand1 < 90) {
                base_type = "Gear";
            } else {
                base_type = "Device";
            }

            break;

        default:
            // If a specific base type was passed directly
            if (array_contains(["Weapon", "Armour", "Gear", "Device"], artifact_type)) {
                base_type = artifact_type;
            }

            break;
    }

    // 3. DETERMINE BASE TYPE DETAIL (If not already set by above logic)
    if (base_type_detail == "") {
        var rand2 = irandom(99); // 0 to 99

        switch (base_type) {
            case "Weapon":
                if (rand2 < 30) {
                    base_type_detail = "Bolter";
                } else if (rand2 < 40) {
                    base_type_detail = "Plasma Pistol";
                } else if (rand2 < 50) {
                    base_type_detail = "Plasma Gun";
                } else if (rand2 < 70) {
                    base_type_detail = choose("Power Sword", "Power Axe", "Power Spear", "Lightning Claw");
                } else if (rand2 < 90) {
                    base_type_detail = choose("Power Fist", "Power Fist", "Lightning Claw");
                } else {
                    base_type_detail = choose("Relic Blade", "Thunder Hammer");
                }

                break;
            case "Armour":
                if (rand2 < 70) {
                    base_type_detail = array_random_element(global.list_basic_power_armour);
                } else if (rand2 < 80) {
                    base_type_detail = array_random_element(global.list_terminator_armour);
                } else if (rand2 < 90) {
                    base_type_detail = "Dreadnought Armour";
                } else {
                    base_type_detail = "Artificer Armour";
                }

                break;
            case "Gear":
                if (rand2 < 20) {
                    base_type_detail = "Rosarius";
                } else if (rand2 < 45) {
                    base_type_detail = "Psychic Hood";
                } else if (rand2 < 80) {
                    base_type_detail = "Jump Pack";
                } else {
                    base_type_detail = "Servo-arm";
                }

                break;
            case "Device":
                if (rand2 < 30) {
                    base_type_detail = "Casket";
                } else if (rand2 < 50) {
                    base_type_detail = "Chalice";
                } else if (rand2 < 70) {
                    base_type_detail = "Statue";
                } else if (rand2 < 90) {
                    base_type_detail = "Tome";
                } else {
                    base_type_detail = "Robot";
                }

                break;
        }
    }

    // 4. CHAOS / DAEMONIC ROLL
    var chaos_roll = roll_dice_chapter(1, 100, "low");
    if (chaos_roll > 70 && artifact_type != "random_nodemon") {
        t3 = (chaos_roll > 90) ? "daemonic" : "chaos";
    }

    // 5. GENERATE VISUAL TAGS
    switch (base_type) {
        case "Weapon":
            t5 = choose("GOLD", "GLOW", "UBOLT", "UFL");
            t4 = choose("RUNE", "SCOPE", "ADAMANTINE", "VOI");

            // Weapon-specific tag corrections
            var is_blade = base_type_detail == "Power Sword" || base_type_detail == "Power Axe" || base_type_detail == "Power Spear";
            if (is_blade && t4 == "SCOPE") {
                t4 = "CHB";
            }

            if (base_type_detail == "Power Fist" && t4 == "SCOPE") {
                t4 = "DUB";
            }

            if (base_type_detail == "Thunder Hammer" && t4 == "RUNE") {
                t4 = "GLOW";
            }

            if (base_type_detail == "Relic Blade" && t4 == "SCOPE") {
                t4 = "UFL";
            }

            break;
        case "Armour":
            t5 = choose("GOLD", "GLOW", "PUR");
            t4 = choose("ART", "SPIKES", "RUNE", "DRA");
            break;
        case "Gear":
            t4 = choose("SUP", "ADAMANTINE", "GOLD");
            switch (base_type_detail) {
                case "Rosarius":
                    t5 = choose("GOLD", "GLOW", "BIG", "BUR");
                    break;
                case "Bionics":
                    t5 = choose("GOLD", "GLOW", "RUNE", "SOO");
                    break;
                case "Psychic Hood":
                    t5 = choose("FIN", "GOLD", "BUR", "MASK");
                    break;
                case "Jump Pack":
                    t5 = choose("SPIKES", "SKRE", "WHI", "SILENT");
                    break;
                case "Servo-arm":
                case "Servo-harness":
                    t5 = choose("GOLD", "TENTACLES", "GOR", "SOO");
                    break;
            }

            break;
        case "Device":
            if (base_type_detail == "Robot") {
                t4 = choose("HU", "RO", "SHI");
                t5 = choose("ADAMANTINE", "JAD", "BRO", "RUNE");
            } else {
                t4 = choose("GOLD", "CRU", "GLOW", "ADAMANTINE");
                if (base_type_detail == "Statue") {
                    t5 = choose("GOAT", "SPE", "DYI", "JUM", "CHE");
                } else if (base_type_detail == "Tome") {
                    t4 = choose("GOLD", "GLOW", "PRE", "ADAMANTINE", "SAL", "BUR");
                    t5 = choose("SKU", "FAL", "THI", "TENTACLES", "MIN");
                } else {
                    t5 = choose("SKU", "FAL", "THI", "TENTACLES", "MIN");
                }
            }

            break;
    }

    // 6. HANDLE ARTIFACT-SPECIFIC TAG OVERRIDES
    if (artifact_tags == "minor") {
        t4 = "";
        t5 = "";
        t3 = "MINOR";
    } else if (artifact_tags == "inquisition") {
        array_push(tags, "inq");
    } else if (artifact_tags == "daemonic") {
        array_push(tags, "daemonic");
        t3 = (base_type_detail == "Tome") ? choose("NURGLE", "TZEENTCH", "SLAANESH") : choose("KHORNE", "NURGLE", "TZEENTCH", "SLAANESH");
    }

    if (artifact_type == "chaos_gift") {
        array_push(tags, "daemonic", "chaos_gift");
    }

    // 7. COMPILE TAGS (Only push non-empty strings)
    if (t3 != "") {
        array_push(tags, t3);
    }

    if (t4 != "") {
        array_push(tags, t4);
    }

    if (t5 != "") {
        array_push(tags, t5);
    }

    // 8. RESOLVE LOCATION
    if (artifact_location == "") {
        if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
            artifact_location = obj_ini.home_name;
            ship_id = -1;
        } else {
            artifact_location = obj_ini.ship[0];
            ship_id = 0;
        }
    }

    // 9. CREATE AND REGISTER ARTIFACT
    var arti = new ArtifactStruct(base_type_detail, tags, is_identified, artifact_location, ship_id);
    obj_ini.artifact_map[$ string(arti.artifact_id)] = arti;
    scr_recent("artifact_acquired", string(arti.get_tags()), arti.artifact_id);

    with (obj_controller) {
        set_chapter_arti_data();
    }

    return arti.artifact_id;
}

/// @desc Applies random corruption to units and vehicles collecting a heretical artifact.
/// @param {Real} last_artifact The artifact ID to check.
function corrupt_artifact_collectors(last_artifact) {
    try {
        var arti = fetch_artifact(last_artifact);
        if (arti.is_heretical()) {
            for (var i = 0; i < array_length(obj_controller.display_unit); i++) {
                var _unit = obj_controller.display_unit[i];
                if (obj_controller.man_sel[i] == 1) {
                    if (obj_controller.man[i] == "man") {
                        if (is_struct(_unit)) {
                            _unit.edit_corruption(choose(0, 2, 4, 6, 8));
                        }
                    } else if (obj_controller.man[i] == "vehicle" && is_array(_unit)) {
                        var _val = fetch_deep_array(obj_ini.veh_chaos, _unit);
                        _val += choose(0, 2, 4, 6, 8);
                        alter_deep_array(obj_ini.veh_chaos, _unit, _val);
                    }
                }
            }
        }
    } catch (_exception) {
        ERROR_HANDLER.handle_exception(_exception);
    }
}

/// @desc Fetches an artifact struct from the global artifact map by ID.
/// @param {Real} id The artifact ID.
/// @returns {Struct.ArtifactStruct}
function fetch_artifact(id) {
    var _artifact_struct = obj_ini.artifact_map[$ string(id)];
    if (_artifact_struct == undefined) {
        ERROR_HANDLER.assert_popup("Artifact ID not found during fetch!");
    }
    return _artifact_struct;
}

/// @desc Returns the total number of registered artifacts.
/// @returns {Real}
function artifact_count() {
    return struct_names_count(obj_ini.artifact_map);
}

/// @desc Deletes an artifact, unequipping it from its bearer first.
/// @param {Real} index The artifact ID to delete.
function delete_artifact(index) {
    var arti = fetch_artifact(index);
    arti.unequip_from_unit();
    struct_remove(obj_ini.artifact_map, string(index));

    if (index == obj_controller.fest_display) {
        obj_controller.fest_display = -1;
    }

    with (obj_controller) {
        set_chapter_arti_data();
    }
}

/// @desc Loads artifacts from save data, resetting the artifact map and next ID.
/// @param {Array<Struct>} artifact_list Serialized artifact data.
function load_artifact_list(artifact_list) {
    obj_ini.artifact_map = {};
    var max_id = -1;
    for (var i = 0; i < array_length(artifact_list); i++) {
        var arti = new ArtifactStruct();
        var arti_data = artifact_list[i];
        arti.from_json(arti_data);

        obj_ini.artifact_map[$ string(arti.artifact_id)] = arti;
        if (arti.artifact_id > max_id) {
            max_id = arti.artifact_id;
        }
    }

    static_get(ArtifactStruct).__next_id = max_id + 1;
}
