// Displays weapon based on the armour type to change the art to match the armour type
// TODO: Refactor a lot of individual armour/weapon checks/array_contains changes to be built-in into each weapon struct presented here.
// TODO: Overall a refactor to weapon draw logic would be good, as current approach may be a bit too verbose and at the same time not very customizable.
// My advice is to use Bolter and Power Sword as baselines for all origin, offset and other adjustments, to keep stuff consistent.
/// @mixin
function set_weapon_display_data(weapon_slot, unit, armour_type) {

    var _equipped_weapon = weapon_slot == 1 ? unit.weapon_one() : unit.weapon_two();
    var standards = {
        "Dark Angels" : spr_da_standard,
    }
    var chap_name = global.chapter_name;

    static weapon_display_data_terminator = {
        "Assault Cannon": {
            "sprite": spr_weapon_assca,
            "draw_preset": "terminator_ranged"
        },
        "Heavy Flamer": {
            "sprite": spr_weapon_hflamer_term,
            "draw_preset": "terminator_ranged"
        },
        "Plasma Cannon": {
            "sprite": spr_weapon_plasma_cannon_term,
            "draw_preset": "terminator_ranged"
        },
        "Grav-Cannon": {
            "sprite": spr_weapon_plasma_cannon_term,
            "draw_preset": "terminator_ranged"
        },
        "Power Fist": {
            "sprite": spr_weapon_powfist4,
            "draw_preset": "terminator_melee"
        },
        "Lightning Claw": {
            "sprite": spr_weapon_lightning2,
            "draw_preset": "terminator_melee"
        },
        "Chainfist": {
            "sprite": spr_weapon_chainfist,
            "draw_preset": "terminator_melee"
        },
        "Boltstorm Gauntlet": {
            "sprite": spr_weapon_boltstorm_gauntlet,
            "draw_preset": "terminator_melee"
        }
    }

    static weapon_display_data_normal = {
        "Bolt Pistol": {
            "sprite": spr_weapon_boltpis,
            "draw_preset": "normal_ranged"
        },
        "Infernus Pistol": {
            "sprite": spr_weapon_inferno,
            "draw_preset": "normal_ranged"
        },
        "Bolter": {
            "sprite": spr_weapon_bolter,
            "draw_preset": "normal_ranged"
        },
        "Storm Bolter": {
            "sprite": spr_weapon_sbolter,
            "draw_preset": "normal_ranged"
        },
        "Plasma Pistol": {
            "sprite": spr_weapon_plasp,
            "draw_preset": "normal_ranged"
        },
        "Plasma Gun": {
            "sprite": spr_weapon_plasg,
            "draw_preset": "normal_ranged"
        },
        "Flamer": {
            "sprite": spr_weapon_flamer,
            "draw_preset": "normal_ranged"
        },
        "Meltagun": {
            "sprite": spr_weapon_melta,
            "draw_preset": "normal_ranged"
        },
        "Stalker Pattern Bolter": {
            "sprite": spr_weapon_stalker,
            "draw_preset": "normal_ranged"
        },
        "Combiflamer": {
            "sprite": spr_weapon_comflamer,
            "draw_preset": "normal_ranged"
        },
        "Combiplasma": {
            "sprite": spr_weapon_complas,
            "draw_preset": "normal_ranged"
        },
        "Combigrav": {
            "sprite": spr_weapon_comgrav,
            "draw_preset": "normal_ranged"
        },
        "Combimelta": {
            "sprite": spr_weapon_commelta,
            "draw_preset": "normal_ranged"
        },
        "Grav-Pistol": {
            "sprite": spr_weapon_grav_pistol,
            "draw_preset": "normal_ranged"
        },
        "Grav-Gun": {
            "sprite": spr_weapon_grav_gun,
            "draw_preset": "normal_ranged"
        },
        "Missile Launcher": {
            "sprite": spr_weapon_missile,
            "draw_preset": "normal_ranged"
        },
        "Hand Flamer": {
            "sprite": spr_weapon_hand_flamer,
            "draw_preset": "normal_ranged"
        },
        "Heavy Bolter": {
            "sprite": spr_weapon_hbolt,
            "draw_preset": "ranged_twohand"
        },
        "Lascannon": {
            "sprite": spr_weapon_lasca,
            "draw_preset": "ranged_twohand"
        },
        "Multi-Melta": {
            "sprite": spr_weapon_mmelta,
            "draw_preset": "ranged_twohand"
        },
        "Heavy Flamer": {
            "sprite": spr_weapon_hflamer,
            "draw_preset": "ranged_twohand"
        },
        "Plasma Cannon": {
            "sprite": spr_weapon_plasc,
            "draw_preset": "ranged_twohand"
        },
        "Grav-Cannon": {
            "sprite": spr_weapon_grav_cannon,
            "draw_preset": "ranged_twohand"
        },
        "Company Standard": {
            "sprite": spr_weapon_standard2,
            "draw_preset": "melee_onehand",
            "main_hand_variant": 0,
            "options": [
                {
                    "sprite": spr_da_standard,
                    "chapter": "Dark Angels",
                }
            ],
        },
        "Chainsword": {
            "sprite": spr_weapon_chsword,
            "draw_preset": "melee_onehand"
        },
        "Combat Knife": {
            "sprite": spr_weapon_knife,
            "draw_preset": "melee_onehand"
        },
        "Power Sword": {
            "sprite": spr_weapon_powswo,
            "draw_preset": "melee_onehand"
        },
        "Eldar Power Sword": {
            "sprite": spr_weapon_eldsword,
            "draw_preset": "melee_onehand"
        },
        "Power Spear": {
            "sprite": spr_weapon_powspear,
            "draw_preset": "melee_onehand"
        },
        "Thunder Hammer": {
            "sprite": spr_weapon_thhammer,
            "draw_preset": "melee_onehand"
        },
        "Power Axe": {
            "sprite": spr_weapon_powaxe,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Crozius Arcanum": {
            "sprite": spr_weapon_crozarc,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Chainaxe": {
            "sprite": spr_weapon_chaxe,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Force Staff": {
            "sprite": spr_weapon_frcstaff,
            "draw_preset": "melee_onehand"
        },
        "Force Sword": {
            "sprite": spr_weapon_powswo,
            "draw_preset": "melee_onehand"
        },
        "Force Axe": {
            "sprite": spr_weapon_powaxe,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Relic Blade": {
            "sprite": spr_weapon_relic_blade,
            "draw_preset": "melee_onehand"
        },
        "Eviscerator": {
            "sprite": spr_weapon_evisc,
            "draw_preset": "melee_onehand"
        },
        "Power Mace": {
            "sprite": spr_weapon_powmace,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Mace of Absolution": {
            "sprite": spr_weapon_mace_of_absolution,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Show Maul": {
            "sprite": spr_weapon_powmaul,
            "draw_preset": "melee_onehand_low_grip"
        },
        "Power Fist": {
            "sprite": spr_weapon_powfist,
            "draw_preset": "melee_fist"
        },
        "Lightning Claw": {
            "sprite": spr_weapon_lightning1,
            "draw_preset": "melee_fist"
        },
        "Boltstorm Gauntlet": {
            "sprite": spr_weapon_boltstorm_gauntlet_small,
            "draw_preset": "melee_fist"
        },
        "Chainfist": {
            "sprite": spr_weapon_chainfist_small,
            "draw_preset": "melee_fist"
        },
        "Assault Chainfist": {
            "sprite": spr_weapon_chainfist_small,
            "draw_preset": "melee_fist"
        },
        "Heavy Thunder Hammer": {
            "sprite": spr_weapon_hthhammer,
            "draw_preset": "melee_twohand"
        },
        "Sniper Rifle": {
            "sprite": spr_weapon_sniper,
            "draw_preset": "melee_onehand"
        },
        "Autocannon": {
            "sprite": spr_weapon_autocannon2,
            "draw_preset": "melee_onehand"
        },
        "Storm Shield": {
            sprite: spr_weapon_storm2,
            options: [
                {
                    sprite: spr_weapon_storm,
                    chapter: "Dark Angels",
                    role: eROLE.HonourGuard,
                }
            ],
            "draw_preset": "shield"
        },
        "Boarding Shield": {
            sprite: spr_weapon_boarding,
            "draw_preset": "shield"
        },
    }


    static draw_presets = {
        "default": {
            "main_arm_variant": 0,
            "secondary_arm_variant": 0,
            "main_hand_variant": 0,
            "secondary_hand_variant": 0,
            "hand_on_top": false,
            "ui_spec": false,
            "ui_twoh": false,
        },
        "normal_ranged": {
            "main_arm_variant": 1,
            "ui_spec": false,
        },
        "ranged_twohand": {
            "main_arm_variant": 0,
            "secondary_arm_variant": 0,
            "main_hand_variant": 0,
            "secondary_hand_variant": 0,
            "ui_spec": true,
            "ui_twoh": true,
        },
        "terminator_ranged": {
            "main_arm_variant": 2,
            "main_hand_variant": 0,
            "ui_spec": true,
        },
        "melee_onehand": {
            "main_arm_variant": 0,
            "main_hand_variant": 2,
            "ui_spec": true,
            "hand_on_top": true,
        },
        "melee_onehand_low_grip": {
            "main_arm_variant": 0,
            "main_hand_variant": 3,
            "ui_spec": true,
            "hand_on_top": true,
        },
        "melee_fist": {
            "main_arm_variant": 1,
            "ui_spec": true,
        },
        "melee_twohand": {
            "main_arm_variant": 0,
            "secondary_arm_variant": 0,
            "main_hand_variant": 0,
            "secondary_hand_variant": 0,
            "hand_on_top": true,
            "ui_spec": true,
            "ui_twoh": true,
        },
        "terminator_ranged": {
            "main_arm_variant": 1,
            "hand_on_top": true,
            "ui_spec": true,
        },
        "terminator_fist": {
            "main_arm_variant": 1,
            "ui_spec": true,
        },
        "shield": {
            "arm_variant": 2,
            "ui_spec": false,
        },
    }
    
    var _weapon_struct = {};
    var _preset = "default"; // Default preset name
    
    // If armour type is Terminator, check the equipped weapon data.
    if (armour_type == ArmourType.Terminator) {
        if (struct_exists(weapon_display_data_terminator, _equipped_weapon)) {
            _weapon_struct = weapon_display_data_terminator;
            _preset = _weapon_struct[$ _equipped_weapon].draw_preset;
        } else if (struct_exists(weapon_display_data_normal, _equipped_weapon)) {
            _weapon_struct = weapon_display_data_normal;
            _preset = _weapon_struct[$ _equipped_weapon].draw_preset;
        }
    } else {
        if (struct_exists(weapon_display_data_normal, _equipped_weapon)) {
            _weapon_struct = weapon_display_data_normal;
            _preset = _weapon_struct[$ _equipped_weapon].draw_preset;
        }
    }
    
    // Initialize all values with the default preset
    var weapon_preset = draw_presets[$ "default"];
    var custom_preset = draw_presets[$ _preset];
    
    // Get the keys from the custom_preset struct
    var _names = struct_get_names(custom_preset);

    // Override with the custom preset values
    for (var i = 0; i < array_length(_names); i++) {
        var _name = _names[i];
        weapon_preset[$ _name] = custom_preset[$ _name];
    }
    
    // Now override with the specific weapon values if present
    if (_weapon_struct != {}) {
        ui_weapon[weapon_slot] = _weapon_struct[$ _equipped_weapon].sprite;
        display_type = _weapon_struct[$ _equipped_weapon].draw_preset;
        
        // Replace with weapon-specific values
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "main_arm_variant")) {
            arm_variant[1] = _weapon_struct[$ _equipped_weapon].main_arm_variant;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "secondary_arm_variant")) {
            arm_variant[2] = _weapon_struct[$ _equipped_weapon].secondary_arm_variant;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "main_hand_variant")) {
            hand_variant[1] = _weapon_struct[$ _equipped_weapon].main_hand_variant;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "secondary_hand_variant")) {
            hand_variant[2] = _weapon_struct[$ _equipped_weapon].secondary_hand_variant;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "hand_on_top")) {
            hand_on_top[1] = _weapon_struct[$ _equipped_weapon].hand_on_top;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "hand_on_top")) { // Checking hand_on_top for both hands
            hand_on_top[2] = _weapon_struct[$ _equipped_weapon].hand_on_top;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "ui_spec")) {
            ui_spec[weapon_slot] = _weapon_struct[$ _equipped_weapon].ui_spec;
        }
        if (struct_exists(_weapon_struct[$ _equipped_weapon], "ui_twoh")) {
            ui_twoh[weapon_slot] = _weapon_struct[$ _equipped_weapon].ui_twoh;
        }
    }
    

    if (weapon_slot == 2 && ui_xmod[weapon_slot] != 0) {
        ui_xmod[weapon_slot] = ui_xmod[weapon_slot] * -1;
    }


    // // Adjust weapon sprites meant for normal power armour but used on terminators
    // if (armour_type == ArmourType.Terminator && !array_contains(["terminator_ranged", "terminator_melee","terminator_fist"],draw_preset)){
    //     ui_ymod[weapon_slot] -= 20;
    //     if (draw_preset == "normal_ranged") {
    //         ui_xmod[weapon_slot] -= 24;
    //         ui_ymod[weapon_slot] += 24;
    //     }
    //     if (draw_preset == "melee_onehand" && _equipped_weapon != "Company Standard") {
    //         arm_variant[weapon_slot] = 2;
    //         hand_variant[weapon_slot] = 2;
    //         ui_xmod[weapon_slot] -= 14;
    //         ui_ymod[weapon_slot] += 23;
    //     }

    //     if (draw_preset == "melee_twohand") {
    //         arm_variant[1] = 2;
    //         arm_variant[2] = 2;
    //         hand_variant[1] = 3;
    //         hand_variant[2] = 4;
    //         ui_ymod[weapon_slot] += 25;
    //     }

    //     if (draw_preset == "ranged_twohand") {
    //         arm_variant[1] = 2;
    //         arm_variant[2] = 2;
    //         hand_variant[1] = 0;
    //         hand_variant[2] = 0;
    //         ui_ymod[weapon_slot] += 15;
    //     }

    //     if (array_contains(["Chainaxe", "Power Axe", "Crozius Arcanum", "Power Mace", "Mace of Absolution", "Relic Blade"], _equipped_weapon)) {
    //         hand_variant[weapon_slot] = 3;
    //         arm_variant[weapon_slot] = 3;
    //     }
    // } else if (armour_type == ArmourType.Scout){
    //     ui_xmod[weapon_slot] += 4;
    //     ui_ymod[weapon_slot] += 11;
    // }

    // // This is for when weapon sprites that are touching the ground and must be independent of unit height.
    // if ((draw_preset == "melee_onehand" && _equipped_weapon != "Combat Knife") || _equipped_weapon == "Sniper Rifle") {
    //     ui_ymod[weapon_slot] = 0;
    // }
    
}

function dreadnought_sprite_components(component){
    var components = {
        "Assault Cannon" : spr_dread_assault_cannon,
        "Lascannon" : spr_dread_plasma_cannon,
        "Close Combat Weapon":spr_dread_claw,
        "Twin Linked Heavy Bolter":spr_dread_heavy_bolter,
        "Plasma Cannon" : spr_dread_plasma_cannon,
        "Autocannon" : spr_dread_autocannon,
        "Missile Launcher" :spr_dread_missile,
        "Dreadnought Lightning Claw": spr_dread_claw,
        "CCW Heavy Flamer": spr_dread_claw,
        "Dreadnought Power Claw": spr_dread_claw,
        "Inferno Cannon": spr_dread_plasma_cannon,
        "Multi-Melta": spr_dread_plasma_cannon,
        "Twin Linked Lascannon": spr_dread_lascannon,
        "Heavy Conversion Beam Projector": spr_dread_plasma_cannon,
    };
    if (struct_exists(components, component)){
        return components[$ component]
    } else {
        return spr_weapon_blank;
    }
}
