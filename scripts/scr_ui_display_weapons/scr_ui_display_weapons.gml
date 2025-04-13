// Displays weapon based on the armour type to change the art to match the armour type
// TODO: Refactor a lot of individual armour/weapon checks/array_contains changes to be built-in into each weapon struct presented here.
// TODO: Overall a refactor to weapon draw logic would be good, as current approach may be a bit too verbose and at the same time not very customizable.
// My advice is to use Bolter and Power Sword as baselines for all origin, offset and other adjustments, to keep stuff consistent.
/// @mixin
function scr_ui_display_weapons(left_or_right, current_armor, equiped_weapon, current_armor_type) {
    clear = false;
    display_type = "normal_ranged";
    var sprite_found = false;

    if (current_armor_type == ArmourType.Terminator){
        // Handle terminator ranged sprites
        if (!sprite_found){
            var terminator_ranged = {
                "Assault Cannon":spr_weapon_assca,
                "Heavy Flamer":spr_weapon_hflamer_term,
                "Plasma Cannon":spr_weapon_plasma_cannon_term,
                "Grav-Cannon":spr_weapon_plasma_cannon_term,
            }
            var terminator_ranged_names=struct_get_names(terminator_ranged);
            for (var i=0;i<array_length(terminator_ranged_names);i++){
                if (terminator_ranged_names[i] == equiped_weapon){
                    set_as_terminator_ranged(terminator_ranged[$ terminator_ranged_names[i]],left_or_right)
                    sprite_found = true;
                    break;               
                }
            }
        }

        // Handle terminator melee sprites
        if (!sprite_found){
            var terminator_melee = {

            }
            var terminator_melee_names=struct_get_names(terminator_melee);
            for (var i=0;i<array_length(terminator_melee_names);i++){
                if (terminator_melee_names[i] == equiped_weapon){
                    set_as_terminator_melee(terminator_melee[$ terminator_melee_names[i]],left_or_right)
                    sprite_found = true;
                    break;               
                }
            }
        }

        // Handle terminator fist sprites
        if (!sprite_found){
            var terminator_fist = {
                "Power Fist":spr_weapon_powfist4,
                "Lightning Claw":spr_weapon_lightning2,
                "Chainfist":spr_weapon_chainfist,
                "Boltstorm Gauntlet":spr_weapon_boltstorm_gauntlet,
            }
            var terminator_fist_names=struct_get_names(terminator_fist);
            for (var i=0;i<array_length(terminator_fist_names);i++){
                if (terminator_fist_names[i] == equiped_weapon){
                    set_as_terminator_fist(terminator_fist[$ terminator_fist_names[i]],left_or_right)
                    sprite_found = true;
                    break;               
                }
            }
        }
    }

    // Handle one-handed ranged
    if (!sprite_found){
        var normal_ranged ={
            "Bolt Pistol":spr_weapon_boltpis,
            "Infernus Pistol":spr_weapon_inferno,
            "Bolter":spr_weapon_bolter,
            "Storm Bolter":spr_weapon_sbolter,
            "Plasma Pistol":spr_weapon_plasp,
            "Plasma Gun":spr_weapon_plasg,
            "Flamer":spr_weapon_flamer,
            "Meltagun":spr_weapon_melta,
            "Stalker Pattern Bolter":spr_weapon_stalker,
            "Combiflamer":spr_weapon_comflamer,
            "Combiplasma":spr_weapon_complas,
            "Combigrav":spr_weapon_comgrav,
            "Combimelta":spr_weapon_commelta,
            "Grav-Pistol":spr_weapon_grav_pistol,
            "Grav-Gun":spr_weapon_grav_gun,
            "Missile Launcher":spr_weapon_missile,
            "Hand Flamer":spr_weapon_hand_flamer,
        }
        var normal_ranged_names = struct_get_names(normal_ranged);
        for (var i=0;i<array_length(normal_ranged_names);i++){
            if (normal_ranged_names[i] == equiped_weapon){
                set_as_normal_ranged(normal_ranged[$ normal_ranged_names[i]],left_or_right)
                sprite_found = true;
                break;
            }
        }
    }

    // Handle two-handed ranged
    if (!sprite_found){
        var heavy_ranged ={
            "Heavy Bolter":spr_weapon_hbolt,
            "Lascannon":spr_weapon_lasca,
            "Multi-Melta":spr_weapon_mmelta,
            "Heavy Flamer":spr_weapon_hflamer,
			"Plasma Cannon":spr_weapon_plasc,
            "Grav-Cannon":spr_weapon_grav_cannon,
            "Infernus Heavy Bolter": spr_weapon_infernus_hbolt, 
        }
        var heavy_ranged_names=struct_get_names(heavy_ranged);
        for (var i=0;i<array_length(heavy_ranged_names);i++){
            if (heavy_ranged_names[i] == equiped_weapon) {
                set_as_ranged_twohand(heavy_ranged[$ heavy_ranged_names[i]],left_or_right)
                sprite_found = true;
                break;               
            }
        }
    }

    // Handle one-handed melee
    if (!sprite_found){
        var standards = {
            "Dark Angels" : spr_da_standard,
        }
        var chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;
        var melee_weapons ={
            "Company Standard":struct_exists(standards, chap_name) ? standards[$ chap_name] :spr_weapon_standard2,
            "Chainsword":spr_weapon_chsword,
            "Combat Knife":spr_weapon_knife,
            "Power Sword":spr_weapon_powswo,
            "Eldar Power Sword":spr_weapon_eldsword,
            "Power Spear":spr_weapon_powspear,
            "Thunder Hammer":spr_weapon_thhammer,
            "Power Axe":spr_weapon_powaxe,
			"Crozius Arcanum":spr_weapon_crozarc,
            "Chainaxe":spr_weapon_chaxe,
            "Force Staff":spr_weapon_frcstaff,
			"Force Sword":spr_weapon_powswo,
			"Force Axe":spr_weapon_powaxe,
            "Relic Blade":spr_weapon_relic_blade,
            "Eviscerator":spr_weapon_evisc,
            "Power Mace":spr_weapon_powmace,
            "Mace of Absolution":spr_weapon_mace_of_absolution,
            "Shock Maul":spr_weapon_powmaul,
            "Xenophase Blade": spr_weapon_xenophase_blade_var1
        }
        var melee_weapons_names=struct_get_names(melee_weapons);
        var wep_
        for (var i=0;i<array_length(melee_weapons_names);i++){
            if (melee_weapons_names[i] == equiped_weapon){
                set_as_melee_onehand(melee_weapons[$ melee_weapons_names[i]],left_or_right);
                sprite_found = true;
                break;               
            }                      
        }
    }

    // Handle one-handed fist melee
    if (!sprite_found){
        if (string_count("DUB", equiped_weapon) == 0){
            var fist_melee ={
                "Power Fist":spr_weapon_powfist,
                "Lightning Claw":spr_weapon_lightning1,
                "Boltstorm Gauntlet":spr_weapon_boltstorm_gauntlet_small,
                "Chainfist":spr_weapon_chainfist_small,
                "Assault Chainfist": spr_weapon_chainfist_small,
            }
            var fist_melee_names=struct_get_names(fist_melee);
            for (var i=0;i<array_length(fist_melee_names);i++){
                if (fist_melee_names[i] == equiped_weapon) {
                    set_as_normal_fist(fist_melee[$ fist_melee_names[i]],left_or_right)
                    sprite_found = true;
                    break;               
                }
            }
        }
    }

    // Handle two-handed melee
    if (!sprite_found){
        var heavy_melee ={
            "Heavy Thunder Hammer":spr_weapon_hthhammer,
        }
        var heavy_melee_names=struct_get_names(heavy_melee);
        for (var i=0;i<array_length(heavy_melee_names);i++){
            if (heavy_melee_names[i] == equiped_weapon) {
                set_as_melee_twohand(heavy_melee[$ heavy_melee_names[i]],left_or_right)
                sprite_found = true;
                break;               
            }
        }
    }

    // Handle special ranged
    if (!sprite_found){
        var special_ranged ={
            "Sniper Rifle":spr_weapon_sniper,
            "Autocannon":spr_weapon_autocannon2,
        }
        var special_ranged_names=struct_get_names(special_ranged);
        for (var i=0;i<array_length(special_ranged_names);i++){
            if (special_ranged_names[i] == equiped_weapon){
                set_as_special_ranged(special_ranged[$ special_ranged_names[i]],left_or_right)
                sprite_found = true;
                break;               
            }
        }
    }

    static set_as_normal_ranged = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 1;
        ui_spec[left_or_right] = false;
        new_weapon_draw[left_or_right] = true;
        display_type = "normal_ranged";
    }
    
    static set_as_ranged_assault = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        display_type = "ranged_assault";
        arm_variant[left_or_right] = 0;
        hand_variant[left_or_right] = 0;
        ui_spec[left_or_right] = true;
    }
    
    static set_as_ranged_twohand = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        display_type = "ranged_twohand";
        arm_variant[1] = 0;
        arm_variant[2] = 0;
        hand_variant[1] = 0;
        hand_variant[2] = 0;
        ui_spec[left_or_right] = true;
        ui_twoh[left_or_right] = true;
    }
    
    static set_as_special_ranged = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 0;
        hand_variant[left_or_right] = 0;
        ui_spec[left_or_right] = true;
        new_weapon_draw[left_or_right] = true;
        display_type = "special_ranged";
    }
    
    static set_as_terminator_ranged = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 2;
        hand_variant[left_or_right] = 0;
        ui_spec[left_or_right] = true;
        display_type = "terminator_ranged";
    }
    
    static set_as_melee_onehand = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 0;
        hand_variant[left_or_right] = 0;
        hand_on_top[left_or_right]=true;
        ui_spec[left_or_right] = true;
        display_type = "melee_onehand";
    }
    
    static set_as_normal_fist = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 1;
        ui_spec[left_or_right] = true;
        display_type = "normal_fist";
    }
    
    static set_as_melee_twohand = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        display_type = "melee_twohand";
        arm_variant[1] = 0;
        arm_variant[2] = 0;
        hand_variant[1] = 0;
        hand_variant[2] = 0;
        hand_on_top[1]=true;
        hand_on_top[2]=true;
        ui_spec[left_or_right] = true;
        ui_twoh[left_or_right] = true;
    }
    
    static set_as_terminator_melee = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 1;
        hand_on_top[left_or_right]=true;
        ui_spec[left_or_right] = true;
        display_type = "terminator_melee";
    }
    
    static set_as_terminator_fist = function(sprite, left_or_right) {
        ui_weapon[left_or_right] = sprite;
        arm_variant[left_or_right] = 1;
        ui_spec[left_or_right] = true;
        display_type = "terminator_fist";
    }

    /////////
    // Hands and stuff
    //////////

    if ("Storm Shield" == equiped_weapon) {
        if (global.chapter_name == "Dark Angels" && role() == obj_ini.role[100][eROLE.HonourGuard]){
            ui_weapon[left_or_right] = spr_weapon_storm;
        }
        else {
            ui_weapon[left_or_right] = spr_weapon_storm2;
        }
        arm_variant[left_or_right] = 2;
        ui_spec[left_or_right] = false;
    }
    if ("Boarding Shield" == equiped_weapon) {
        ui_weapon[left_or_right] = spr_weapon_boarding;
        arm_variant[left_or_right] = 2;
        ui_spec[left_or_right] = false;
    }

    if ("Company Standard" == equiped_weapon) {
        hand_variant[left_or_right] = 0;
    }

    if ("Autocannon" == equiped_weapon) {
        arm_variant[1] = 0;
        arm_variant[2] = 1;
        hand_variant[1] = 6;
        hand_on_top[2]=true;
    }

    if (array_contains(["Power Mace", "Mace of Absolution", "Power Axe", "Shock Maul", "Chainaxe", "Force Axe"], equiped_weapon)) {
        hand_variant[left_or_right] = 3;
    }

    if (array_contains(["Sniper Rifle", "Force Staff", "Power Sword", "Thunder Hammer", "Autocannon", "Combat Knife", "Power Spear", "Chainsword", "Force Sword", "Xenophase Blade"], equiped_weapon)) {
        hand_variant[left_or_right] = 2;
        hand_on_top[left_or_right] = true;
    }

    // New weapon draw method
    if (array_contains(["Force Staff", "Mace of Absolution", "Power Mace", "Power Axe", "Power Sword", "Autocannon", "Combat Knife", "Power Spear", "Shock Maul", "Chainsword", "Chainaxe", "Force Sword", "Force Axe", "Xenophase Blade"], equiped_weapon)) {
        new_weapon_draw[left_or_right] = true;
    }

    // Adjust weapon sprites meant for normal power armour but used on terminators
    if (current_armor_type == ArmourType.Terminator && !array_contains(["terminator_ranged", "terminator_melee","terminator_fist"],display_type)){
        ui_ymod[left_or_right] -= 20;
        if (display_type == "normal_ranged") {
            ui_xmod[left_or_right] -= 24;
            ui_ymod[left_or_right] += 24;
        }
        if (display_type == "melee_onehand" && equiped_weapon != "Company Standard") {
            arm_variant[left_or_right] = 2;
            hand_variant[left_or_right] = 2;
            ui_xmod[left_or_right] -= 14;
            ui_ymod[left_or_right] += 23;
        }

        if (display_type == "melee_twohand") {
            arm_variant[1] = 2;
            arm_variant[2] = 2;
            hand_variant[1] = 3;
            hand_variant[2] = 4;
            ui_ymod[left_or_right] += 25;
        }

        if (display_type == "ranged_twohand") {
            arm_variant[1] = 2;
            arm_variant[2] = 2;
            hand_variant[1] = 0;
            hand_variant[2] = 0;
            ui_ymod[left_or_right] += 15;
        }

        if (array_contains(["Chainaxe", "Power Axe", "Crozius Arcanum", "Power Mace", "Mace of Absolution", "Relic Blade"], equiped_weapon)) {
            hand_variant[left_or_right] = 3;
            arm_variant[left_or_right] = 3;
        }
    } else if (current_armor_type == ArmourType.Scout){
        ui_xmod[left_or_right] += 4;
        ui_ymod[left_or_right] += 11;
    }

    // This is for when weapon sprites that are touching the ground and must be independent of unit height.
    if ((display_type == "melee_onehand" && equiped_weapon != "Combat Knife") || equiped_weapon == "Sniper Rifle") {
        ui_ymod[left_or_right] = 0;
    }

    // Flip the ui_xmod for offhand
    if (left_or_right == 2  && ui_xmod[left_or_right] != 0) {
        /*and (current_armor=0)*/
        ui_xmod[left_or_right] = ui_xmod[left_or_right] * -1;
    }
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
