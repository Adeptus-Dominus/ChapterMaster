enum eLOOT_TYPE {
    REQUISITION,
    GEAR,
    ARTIFACT,
    STC,
    WILD_CARD,
    BUNKER,
    FORTRESS,
    STARSHIP,
    GENE_SEED,
}

/// @desc Represents a single loot pool from JSON.
/// @param {Struct} _data Raw struct from json_parse.
function LootPool(_data) constructor {
    options = [];
    min_val = 0;
    max_val = 0;

    if (is_struct(_data)) {
        options = _data[$ "options"] ?? options;
        min_val = _data[$ "min"] ?? min_val;
        max_val = _data[$ "max"] ?? max_val;
    }

    /// @desc Rolls for an item and quantity.
    static roll = function() {
        var _count = irandom_range(min_val, max_val);
        if (_count <= 0 || array_length(options) == 0) {
            return undefined;
        }

        return {name: options[irandom(array_length(options) - 1)], count: _count};
    };
}

/// @desc Processes rewards for exploring ancient ruins.
/// @param {Asset.GMObject.obj_star} _star_system The star system object.
/// @param {Real} _pid_idx Planet index within the system.
/// @param {Struct.NewPlanetFeature} _ruins The ruins feature struct.
function scr_ruins_reward(_star_system, _pid_idx, _ruins) {
    // 1. Guard Clause: Logic exit if items need recovery
    if (_ruins.unrecovered_items) {
        _ruins.recover_from_dead();
        return;
    }

    /// @desc Internal logic for handling Gear distribution via JSON data.
    /// @param {Real} _race The ID of the ruins race.
    /// @param {Asset.GMObject.obj_popup} _popup The popup instance to populate.
    static _process_gear_reward = function(_race, _popup) {
        static _loot_registry = undefined;

        // Lazy-load JSON from disk once
        if (_loot_registry == undefined) {
            _loot_registry = {};
            var _path = working_directory + "\\data\\ruins_loot.json";
            var _raw_json = json_to_gamemaker(_path, json_parse);

            var _keys = struct_get_names(_raw_json);
            for (var i = 0, l = array_length(_keys); i < l; i++) {
                var _key = _keys[i];
                var _raw_pools = _raw_json[$ _key];
                var _pools = [];

                if (is_array(_raw_pools)) {
                    for (var i2 = 0, l2 = array_length(_raw_pools); i2 < l2; i2++) {
                        array_push(_pools, new LootPool(_raw_pools[i2]));
                    }
                }

                _loot_registry[$ _key] = _pools;
            }
        }

        // Handle the "Race 10 or higher" legacy logic
        var _key = (_race >= 10) ? "10" : string(_race);
        var _pools = _loot_registry[$ _key];

        if (_pools == undefined || array_length(_pools) == 0) {
            _popup.title = "Ancient Ruins: Empty";
            _popup.text = "The chambers within these ruins were empty, or perhaps scavenged eons ago.";
            return;
        }

        var _display_parts = [];
        var _pool_count = array_length(_pools);

        for (var i = 0; i < _pool_count; i++) {
            /// @type {Struct.LootPool}
            var _pool = _pools[i];
            var _result = _pool.roll();

            if (_result != undefined) {
                scr_add_item(_result.name, _result.count);
                array_push(_display_parts, $"{_result.count}x {_result.name}");
            }
        }

        _popup.title = "Ancient Ruins: Gear";
        var _loot_str = (array_length(_display_parts) > 0) ? string_join_ext(", ", _display_parts) : "nothing of immediate value";

        _popup.text = $"My lord, your brothers have found sealed chamber in these ruins. It bears symbols of one of the ancient legions. After your tech-marines managed to open the chamber, we've found a number of relics that can be brought back to service. We recovered: {_loot_str}. These relics have been added to the Armamentarium.";
    };

    /// @desc Internal logic for handling Artifact retrieval.
    /// @param {Asset.GMObject.obj_popup} _popup
    static _process_artifact_reward = function(_star, _pidx, _popup) {
        var _chosen_ship = -1;
        var _fleet = scr_orbiting_player_fleet(_star);

        if (instance_exists(_fleet)) {
            var _ships = fleet_full_ship_array(_fleet);
            if (array_length(_ships) > 0) {
                _chosen_ship = _ships[0];
            }
        }

        if (_chosen_ship > -1) {
            var _art_idx = scr_add_artifact("random", "random", 4, _pidx, _chosen_ship + 500);
            _popup.title = "Ancient Ruins: Artifact";
            _popup.text = $"An Artifact has been found within the ancient ruins. It appears to be a {obj_ini.artifact[_art_idx]} but should be brought to the Lexicanum and identified posthaste.";
            scr_event_log("", "Artifact recovered from Ancient Ruins.");
        } else {
            _popup.title = "Ancient Ruins: Artifact Lost";
            _popup.text = "An Artifact was discovered within the ancient ruins, but no suitable ship was available for its retrieval. The sacred object remains unclaimed.";
        }

        instance_destroy(obj_star_select);
        instance_destroy(obj_fleet_select);
    };

    // 2. State & Data Initialization
    var _ruins_race = _ruins.ruins_race;
    var _dice = roll_dice_chapter(1, 100, "high");
    var _loot_type = eLOOT_TYPE.REQUISITION;

    // 3. Loot Category Mapping
    if (_dice > 35 && _dice <= 50) {
        _loot_type = eLOOT_TYPE.GEAR;
    } else if (_dice > 50 && _dice <= 60) {
        _loot_type = eLOOT_TYPE.ARTIFACT;
    } else if (_dice > 60 && _dice <= 70) {
        _loot_type = eLOOT_TYPE.STC;
    } else if (_dice > 70 && _dice <= 85) {
        _loot_type = eLOOT_TYPE.WILD_CARD;
    } else if (_dice > 85 && _dice <= 97) {
        _loot_type = eLOOT_TYPE.BUNKER;
    } else if (_dice > 97 && _dice <= 99) {
        _loot_type = eLOOT_TYPE.FORTRESS;
    } else if (_dice > 99) {
        _loot_type = eLOOT_TYPE.STARSHIP;
    }

    // Wild Card logic
    if (_loot_type == eLOOT_TYPE.WILD_CARD) {
        _loot_type = _ruins_race == 1 ? eLOOT_TYPE.GENE_SEED : (_ruins_race == 6 ? eLOOT_TYPE.GEAR : eLOOT_TYPE.REQUISITION);
    }

    // 4. Execution Context
    var _planet_name = planet_numeral_name(_pid_idx, _star_system);
    /// @type {Asset.GMObject.obj_popup}
    var _popup = instance_create(0, 0, obj_popup);
    _popup.image = "ancient_ruins";

    scr_event_log("", $"The Ancient Ruins on {_planet_name} has been explored.", _star_system.name);

    // 5. Reward Processing Dispatcher
    switch (_loot_type) {
        case eLOOT_TYPE.REQUISITION:
            var _amount = (round(random_range(30, 60)) + 1) * 10;
            obj_controller.requisition += _amount;
            _popup.title = "Ancient Ruins: Resources";
            _popup.text = $"My lord, your battle brothers have located several precious minerals and supplies. Everything was returned to the ship, granting {_amount} Requisition.";
            break;

        case eLOOT_TYPE.GEAR:
            _process_gear_reward(_ruins_race, _popup);
            break;

        case eLOOT_TYPE.ARTIFACT:
            _process_artifact_reward(_star_system, _pid_idx, _popup);
            break;

        case eLOOT_TYPE.STC:
            scr_add_stc_fragment();
            _popup.title = "Ancient Ruins: STC Fragment";
            _popup.text = "Praise the Omnissiah, an STC Fragment has been retrieved from the ancient ruins and safely stowed away. It is ready to be decrypted or gifted at your convenience.";
            scr_event_log("", "STC Fragment recovered from Ancient Ruins.");
            break;

        case eLOOT_TYPE.BUNKER:
            var _current_fort = _star_system.p_fortified[_pid_idx];
            var _new_fort = min(_current_fort + 1, 5);
            _star_system.p_fortified[_pid_idx] = _new_fort;
            _popup.image = "ruins_bunker";
            _popup.title = "Ancient Ruins: Bunker Network";
            _popup.text = $"Your battle brothers have found several entrances into an ancient bunker network.  Its location has been handed over to the PDF. The planet's defense rating has increased to {_new_fort}. (+{_new_fort - _current_fort})";
            break;

        case eLOOT_TYPE.STARSHIP:
            _popup.image = "ruins_ship";
            _popup.title = "Ancient Ruins: Starship";
            _popup.text = $"The ground beneath one of your battle brothers crumbles, and he falls a great height. The other marines go down in pursuit. Within a great chamber they find the remains of an ancient starship. Though derelict, it is possible to land {obj_ini.role[100][16]}s to repair the ship. 10,000 Requisition will be needed to make it operational.";
            _ruins.find_starship();
            scr_event_log("", $"Ancient Starship discovered on {_planet_name}.", _star_system.name);
            break;

        case eLOOT_TYPE.FORTRESS:
            ancient_fortress_ruins_loot(_star_system, _pid_idx, _ruins, _popup);
            break;

        case eLOOT_TYPE.GENE_SEED:
            ancient_gene_lab_ruins_loot(_popup);
            break;
    }

    _ruins.ruins_explored();
}

/// @param {Asset.GMObject.obj_popup} _popup The popup instance to populate.
function ancient_gene_lab_ruins_loot(_popup) {
    _popup.image = "geneseed_lab";
    _popup.title = "Ancient Ruins: Gene-seed";
    _popup.text = $"My lord, your battle brothers have located a hidden, fortified laboratory within the ruins. Contained are a number of bio-vaults with astartes gene-seed. Your marines are not able to determine the integrity or origin.";

    _popup.pop_data = {
        options: [
            {
                str1: "Add the gene-seed to chapter vaults.",
                choice_func: function() {
                    var _estimate = irandom_range(3, 15);
                    text = $"{_estimate} gene-seed has been added to the chapter vaults.";
                    reset_popup_options();
                    obj_controller.gene_seed += _estimate;
                    //scr_play_sound(snd_success);
                    with (obj_ground_mission) {
                        instance_destroy();
                    }
                },
            },
            {
                str1: "Salvage the laboratory for requisition.",
                choice_func: function() {
                    var _requisition_gain = floor(random_range(200, 500));
                    text = $"Technological components salvaged for {_requisition_gain} requisition.";
                    reset_popup_options();
                    obj_controller.requisition += _requisition_gain;
                    //scr_play_sound(snd_salvage);
                    with (obj_ground_mission) {
                        instance_destroy();
                    }
                },
            },
            {
                str1: "Leave the laboratory as is.",
                choice_func: function() {
                    with (obj_ground_mission) {
                        instance_destroy();
                    }
                    //scr_play_sound(snd_cancel);
                    popup_default_close();
                },
            }
        ],
    };
}

/// @param {Asset.GMObject.obj_star} _star
/// @param {Real} _planet
/// @param {Struct} _ruins
/// @param {Asset.GMObject.obj_popup} _popup
function ancient_fortress_ruins_loot(_star, _planet, _ruins, _popup) {
    _popup.image = "ruins_fort";
    _popup.title = "Ancient Ruins: Fortress";
    _popup.text = $"Praise the Emperor! We have found a massive, ancient fortress in needs of repairs. The gun batteries are rusted, and the walls are covered in moss with huge hole in it. Such a pity that such a majestic building is now a pale shadow of its former glory. It is possible to repair the structure. What is thy will?";

    _popup.pop_data = {
        feature: _ruins,
        planet: _planet,
        star: _star,
        options: [
            {
                str1: "Repair the fortress (1000 Req)",
                requires: {
                    req: 1000,
                },
                choice_func: function() {
                    /// @type {Asset.GMObject.obj_star}
                    var _star = pop_data.star;
                    var _pidx = pop_data.planet;
                    obj_controller.requisition -= 1000;

                    var _current_fort = _star.p_fortified[_pidx];
                    var _new_fort = max(_current_fort, 5);
                    _star.p_fortified[_pidx] = _new_fort;

                    text = $"Fortress restored. Defense rating increased to {_new_fort}. (+{_new_fort - _current_fort})";
                    reset_popup_options();
                },
            },
            {
                str1: "Salvage raw materials.",
                choice_func: function() {
                    var _requisition_gain = irandom_range(200, 500);
                    text = $"The fortress was demolished for parts, yielding {_requisition_gain} requisition.";
                    obj_controller.requisition += _requisition_gain;
                    reset_popup_options();
                },
            }
        ],
    };
}
