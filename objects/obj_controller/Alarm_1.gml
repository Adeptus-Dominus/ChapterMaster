/// @description Sector spawn logic, including enemy distribution, homeworld selection, and mystery code
// Sets up the sector spawn and assigns spawned enemies to the sector
// Should determine here, randomly what sort of enemy planets there are
// One of the following:
// Lots of damn orks
// Lots of damn tyranids
// Some damn orks and a few genestealer cults

instance_activate_all();

// Faction settings
var _spawn_factions = [
    {
        enabled: true,
        weight: 10,
        faction_id: eFACTION.ORK,
    },
    {
        enabled: false,
        weight: 1,
        faction_id: eFACTION.TYRANIDS,
    },
    {
        enabled: false,
        weight: 1,
        faction_id: eFACTION.CHAOS,
    },
    {
        enabled: !is_test_map,
        weight: 1,
        faction_id: eFACTION.GENESTEALER,
    },
];

// if (global.chapter_name == "Lamenters") { // Was this supposed to be something?

good_log = 1;

// Set player star
/// @type {Id.Instance.obj_star}
var _player_star = find_player_spawn_star();

// Set player homeworld
if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
    set_player_homeworld_star(_player_star);
}

// Crusade and fleet based
if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
    with (_player_star) {
        set_player_recruit_planet(irandom_range(1, _player_star.planets));
    }
}

with (_player_star) {
    for (var f = 1; f <= planets; f++) {
        if ((array_length(search_planet_features(p_feature[f], eP_FEATURES.MONASTERY)) > 0) && (array_length(search_planet_features(p_feature[f], eP_FEATURES.RECRUITING_WORLD)) > 0)) {
            if (p_owner[f] == eFACTION.PLAYER) {
                p_owner[f] = eFACTION.IMPERIUM;
            }
        }
        if (array_length(search_planet_features(p_feature[f], eP_FEATURES.MONASTERY)) > 0) {
            if (p_owner[f] != eFACTION.PLAYER) {
                p_owner[f] = eFACTION.PLAYER;
            }
            owner = eFACTION.PLAYER;
        }
    }
}

if ((obj_ini.veh_loc[1][1] == "random") || (obj_ini.veh_loc[1][1] == "Random")) {
    for (var coh = 0; coh < 11; coh++) {
        for (var iy = 1; iy <= 60; iy++) {
            obj_ini.veh_loc[coh][iy] = _player_star.name;
        }
    }
    _player_star.p_player[2] += obj_ini.man_size;
}

var fleet = create_player_fleet(_player_star.x, _player_star.y);
for (var f = 0; f < array_length(obj_ini.ship); f++) {
    add_ship_to_fleet(f, fleet);
}

with (fleet) {
    set_player_fleet_image();
}

if (obj_ini.load_to_ships[0] > 0) {
    scr_start_load(fleet, _player_star, obj_ini.load_to_ships);
    with (obj_p_fleet) {
        instance_create(x, y, obj_fleet_show);
    }
}

var px = _player_star.x;
var py = _player_star.y;
var xx = px;
var yy = py;
instance_deactivate_object(_player_star);

// Mechanicus capital system

/// @type {Id.Instance.obj_star}
var _current_system = instance_nearest(px, py, obj_star);

with (_current_system) {
    star = "white2";
    image_index = 4;
    owner = eFACTION.MECHANICUS;
    
    if (planets < 2) {
        planets = 2;
    }
    
    p_type[1] = "Forge";
    p_type[2] = "Ice";

    // Orbital sorting; hotter = Closer to sun
    var weights = {
        Lava: 1.0,
        Forge: 1.5,
        Desert: 2.0,
        Hive: 3.0,
        Death: 4.0,
        Agri: 5.0,
        Temperate: 6.0,
        Ice: 7.0,
    };

    var get_weight = function(_type, _slot, _weights_dict) {
        if (_type == "Dead") {
            return (_slot == 1) ? 1.0 : (_slot - 0.5);
        }
        return _weights_dict[$ _type] ?? 99.0;
    };

    // Bubble sort
    repeat (planets) {
        for (var idx = planets - 1; idx >= 1; idx--) {
            var type_a = p_type[idx];
            var type_b = p_type[idx + 1];

            var weight_a = get_weight(type_a, idx, weights);
            var weight_b = get_weight(type_b, idx + 1, weights);

            if (weight_b < weight_a) {
                p_type[idx] = type_b;
                p_type[idx + 1] = type_a;
            }
        }
    }

    for (var p = 1; p <= planets; p++) {
        if (p_type[p] == "Forge" || p_type[p] == "Ice") {
            p_owner[p] = eFACTION.MECHANICUS;
            p_first[p] = p_owner[p];
        }
    }
}

instance_deactivate_object(_current_system);

if (tau == 1) {
    _current_system = instance_furthest(px, py, obj_star);

    with (_current_system) {
        planet[1] = 1;
        p_owner[1] = eFACTION.TAU;
        p_type[1] = "Desert";
        xx = x;
        yy = y;
        tau = choose(3, 4);
        p_influence[1][eFACTION.TAU] = 70;
    }
    instance_deactivate_object(_current_system);

    var tau_start_size = irandom(4) + 5;
    for (var i = 0; i <= tau_start_size; i++) {
        _current_system = instance_nearest(xx, yy, obj_star);
        with (_current_system) {
            if ((planets > 0) && (_current_system.p_type[1] != "Dead") && (_current_system.owner == eFACTION.IMPERIUM)) {
                p_owner[1] = eFACTION.TAU;
                owner = eFACTION.TAU;
                p_influence[1][eFACTION.TAU] = 70;
            }
        }
        instance_deactivate_object(_current_system);
    }
}

// More sneaky this way; you have to be noted of rising heresy or something, or have a ship in the system
var hell_holes = [
    "Badab",
    "Hellsiris",
    "Vraks",
    "Isstvan",
    "Stygies",
    "Stygia",
    "Nostromo",
    "Jhanna",
    "Gangrenous Rot",
];

with (obj_star) {
    if (array_contains(hell_holes, name)) {
        var rando = choose(true, true); // if you only want some of the hell holes to spawn change the trues to falses and vice versa
        if (rando) {
            owner = eFACTION.CHAOS;
            for (var i = 1; i <= planets; i++) {
                p_owner [i] = eFACTION.CHAOS;
                p_heresy[i] = floor(random_range(75, 100));
                p_traitors[i] = 6;
                p_fortified[i] = choose(4, 5, 5, 4, 4, 3, 6);

                if (p_type[i] == "Dead") {
                    p_type[i] = choose("Hive", "Temperate", "Desert", "Ice");
                }
            }

            instance_deactivate_object(id);
        }
    }
}

var _imperial_systems = [];
with (obj_star) {
    if (owner == eFACTION.IMPERIUM && !is_dead_star() && planets != 0) {
        array_push(_imperial_systems, id);
    }
}

var _enemy_systems = 30;
if (obj_ini.fleet_type == ePLAYER_BASE.PENITENT) {
    _enemy_systems += 5;
}

var _total_weight = 0;
var _count = array_length(_spawn_factions);

for (var i = 0; i < _count; i++) {
    var _faction = _spawn_factions[i];
    if (_faction.enabled) {
        _total_weight += _faction.weight;
    }
}

if (_total_weight > 0) {
    for (var f = 0; f < _count; f++) {
        var _faction = _spawn_factions[f];
        
        if (!_faction.enabled) { 
            continue;
        }
        
        var _allocated_systems = round(_enemy_systems * (_faction.weight / _total_weight));
        
        for (var j = 0; j < _allocated_systems && array_length(_imperial_systems) > 0; j++) {
            var s = array_random_index(_imperial_systems);
            var _current_system = _imperial_systems[s];
            
            _current_system.owner = _faction.faction_id;
            for (var p = 1; p <= _current_system.planets; p++) {
                _current_system.p_owner[p] = _current_system.owner;
            }

            array_delete(_imperial_systems, s, 1);
            instance_deactivate_object(_current_system);
        }
    }
}

// Another mechanicus
repeat (choose(3, 4, 5)) {
    xx = floor(random(1152 + 640)) + 64;
    yy = floor(random(748 + 480)) + 64;
    _current_system = instance_nearest(xx, yy, obj_star);
    if ((_current_system.planets > 0) && (_current_system.owner == eFACTION.IMPERIUM)) {
        var forge_planet = irandom(_current_system.planets - 1) + 1;
        _current_system.planet[forge_planet] = 1;
        _current_system.p_type[forge_planet] = "Forge";
        _current_system.owner = eFACTION.MECHANICUS;
        _current_system.p_owner[forge_planet] = _current_system.owner;
        _current_system.p_first[forge_planet] = _current_system.owner;
    }
    instance_deactivate_object(_current_system);
}

instance_activate_all();

with (obj_star) {
    alarm[1] = 1;
}

// Eldar craftworld here
craftworld = 1;

repeat (100) {
    xx = floor(random(1152 + 600)) + 104;
    yy = floor(random(748 + 440)) + 104;
    if (point_distance(room_width / 2, room_height / 2, xx, yy) >= 50) {
        var me = instance_nearest(xx, yy, obj_star);
        if ((point_distance(me.x, me.y, xx, yy) >= 150) && (xx < 1690 && yy > 780)) {
            var craft = instance_create(xx, yy, obj_star);
            craft.craftworld = 1;
            array_push(craft.p_feature[1], new NewPlanetFeature(eP_FEATURES.WARLORD6));

            var elforce = create_enemy_fleet(xx, yy, eFACTION.ELDAR);
            fleet_register_at_star(elforce, craft); // craft star has name="" so get_nearest_star in create_enemy_fleet won't find it
            elforce.sprite_index = spr_fleet_eldar;
            elforce.capital_number = choose(2, 3);
            elforce.frigate_number = choose(4, 5, 6);
            elforce.escort_number = floor(random_range(7, 11)) + 1;
            elforce.image_alpha = 0;
            break;
        }
    }
}
// End craftworld

with (obj_creation) {
    instance_destroy();
}

create_complex_star_routes(_player_star);

with (obj_temp7) {
    instance_destroy();
}
// For tau fleets, if it is stationed on a system it owns, make a temp7 obj
with (obj_en_fleet) {
    if ((owner == eFACTION.TAU) && (instance_nearest(x, y, obj_star).owner == eFACTION.TAU)) {
        instance_create(x, y, obj_temp7);
    }
}
// If any temp objects exist, find the one nearest to the center of the room and set your direction to the angle to the room center
if (instance_exists(obj_temp7)) {
    var t1 = instance_nearest(room_width / 2, room_height / 2, obj_temp7);
    with (t1) {
        other.terra_direction = point_direction(x, y, room_width / 2, room_height / 2);
    }
}

// Save immediately after world gen
if (global.load == -1 && global.settings.autosave == true) {
    alarm[2] = 5;
}
