var a1 = "";

if ((ally > 0) && (ally_forces > 0)) {
    if (ally == 3) {
        if (ally_forces >= 1) {
            a1 = "Joining your forces are 10 Techpriests and 20 Skitarii.  Omnissian Power Axes come to life, crackling and popping with disruptive energy, and Conversion Beam Projectors are levelled to fire.  The Tech-Guard are silent as they form a perimeter around their charges, at contrast with their loud litanies and Lingua-technis bursts.";
        }
    }
}

// Player crap here
var p1 = "";
var p2 = "";
var p3 = "";
var p4 = "";
var p5 = "";
var p6 = "";
var p8 = "";
var temp2 = 0;
var temp3 = 0;
var temp4 = 0;
var temp5 = 0;
var temp6 = 0;
var d1 = "";
var d2 = "";
var d3 = "";
var d4 = "";
var d5 = "";
var d6 = "";
var d7 = "";

var _newline = "";
var _newline_color = eMSG_COLOR.DEFAULT;

var _marine_roles = active_roles();
array_push(_marine_roles, "Forge Master");
array_push(_marine_roles, "Master of Sanctity");
array_push(_marine_roles, "Master of the Apothecarion");
array_push(_marine_roles, $"Chief {obj_ini.player_role_data[eROLE.LIBRARIAN].role}");

var _marine_count = player_unit_index.sum_roles(_marine_roles);

// Random variations; dark out, rain pooling down, dawn shining off of the armour, etc.
var variation = choose("", "dawn", "rain");
var color_descr = "";

if (obj_ini.main_color != obj_ini.secondary_color) {
    color_descr = string(obj_controller.col[obj_ini.main_color]) + " and " + string(obj_controller.col[obj_ini.secondary_color]);
}
if (obj_ini.main_color == obj_ini.secondary_color) {
    color_descr = string(obj_controller.col[obj_ini.main_color]);
}

if (battle_special == "ship_demon") {
    p1 = "As the Artifact is smashed and melted down some foul smoke begins to erupt from it, spilling outward and upward.  After a sparse handful of seconds it takes form into a ";
    p1 += string(obj_enunit.dudes[1]);
    p1 += ".  Now free, it seems bent upon slaying your marines.  Onboard you have ";
}

if ((battle_special == "ruins") || (battle_special == "ruins_eldar")) {
    p1 = "Your marines place themselves into a proper fighting position, defensible and ready to fight whatever may come.  Enemies may only come from a few directions, though the ancient corridors and alleyways are massive, and provide little cover.";
    p1 += "  You have ";
}

if (string_count("mech", battle_special) > 0) {
    p1 = "Large, hulking shapes advance upon your men from every direction.  The metal corridors and blast chambers prevent escape.  Soon 4 Thallax and half a dozen Praetorian Servitors can be seen, with undoubtably more to come.";
    p1 += "  You have ";
}

if (battle_special == "space_hulk") {
    if (hulk_forces > 0) {
        p1 = "Your marines maneuver through the hull of the Space Hulk, shadows dancing and twisting before their luxcasters.  The hallway integrity is non-existent – twisted metal juts out in hazardous ways or opens into bottomless pits.  Still, there is loot and knowledge to be gained.  It is not long before your men's sensorium pick up hostile blips.  Your own forces are made up of ";
    }
    if (hulk_forces == 0) {
        p1 = "Your marines maneuver through the hull of the Space Hulk, shadows dancing and twisting before their luxcasters.  The hallway integrity is non-existent – twisted metal juts out in hazardous ways or opens into bottomless pits.  Your forces are made up of ";
    }
}

var _dread_count = player_unit_index.sum_roles([_marine_roles[eROLE.DREADNOUGHT], "Venerable " + _marine_roles[eROLE.DREADNOUGHT]]);

if (battle_special == "") {
    if (!dropping) {
        if (_marine_count - _dread_count > 0) {
            if (variation == "") {
                p1 = "Dirt crunches beneath the soles of " + string(_marine_count) + " " + string(global.chapter_name) + " as they form up.  Your ranks are made up of ";
            }
            if (variation == "rain") {
                p1 = "Rain pelts the ground and fogs the air, partly veiling the " + string(_marine_count) + " " + string(global.chapter_name) + ".  Your ranks are made up of ";
            }
            if (variation == "dawn") {
                p1 = "The bright light of dawn reflects off the " + string_lower(color_descr) + " ceremite of " + string(_marine_count) + " " + string(global.chapter_name) + ".  Your ranks are made up of ";
            }
        }
    }
    if (dropping) {
        if (_marine_count - _dread_count > 0) {
            // lyman
            p1 = "The air rumbles and quakes as " + string(_marine_count) + " " + string(global.chapter_name) + " descend in drop-pods.  ";
        }
    }
}
if (string_count("spyrer", battle_special) > 0) {
    p1 = "Your marines search through the alleyways and corridors likely to contain the Spyrer.  It does not take long before the lunatic attacks, springing off from a wall to fall among your men.  Your ranks are made up of ";
}
if (string_count("protect_raiders", battle_special) > 0) {
    p1 = "Following responses from scans, Your marine squad deploys and lies in wait on the planets surface. Either the eldar were expecting you or the scope of the raids on the planet had been underplayed by the governor perhaps to hide his incompetence in allowing such foul xenos actions to persist unchecked for so long.";
}
if (string_count("fallen", battle_special) > 0) {
    p1 = "Your marines search through the alleyways and dens likely to contain the Fallen.  Several days pass before the search is succesful; the prey is located by Auspex and closed in upon.  ";
    if (battle_climate == "Lava") {
        p1 = "Your marines search through the broken craggs and spires of the molten planet.  Among the bubbling lava, and cracking earth, they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    }
    if (battle_climate == "Dead") {
        p1 = "Your marines search through the cratered surface of the debris field.  Among the cracking earth and dust they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    }
    if (battle_climate == "Agri") {
        p1 = "Endless fields of wheat and barley are an unlikely harbor for a renegade, but your marines search the agri world all the same.  After several days of searching Auspex detect the prey.  ";
    }
    if (battle_climate == "Death") {
        p1 = "Deadly carniverous plants and endless canopy blot out the surface of the planet.  Among the disheveled hills, and heavy underbrush, your marines search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    }
    if (battle_climate == "Ice") {
        p1 = "Your marines search through the endless glaciers and peaks of the frozen planet.  Among the howling wind, and cracking ice, they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    }
    if (obj_enunit.dudes_num[1] == 1) {
        p1 += "The coward soon realizes he has been located, and reacts like a cornered animal, brandishing weapons.";
    }
    if (obj_enunit.dudes_num[1] > 1) {
        p1 += "The cowards soon realize they have been located, and react like cornered animals, brandishing weapons.";
    }
    p1 += "  Your ranks are made up of ";
}

if (string_count("_attack", battle_special) > 0) {
    var wh = choose(1, 2);
    if (wh == 1) {
        p1 = "Cave dirt crunches beneath the soles of your marines as they continue their descent.  There is little warning before ";
    }
    if (wh == 2) {
        p1 = "The shadows stretch and morph as the lights cast by your marines move along.  One large shadow begins to move on its own- ";
    }

    if (string_count("wake", battle_special) > 0) {
        p1 = "Cave dirt crunches beneath the soles of your marines as they continue their descent.  There is little warning when the ground begins to shake.  An old, dusty breeze seems to flow through the tunnel, followed by rumbling sensations and distant mechanical sounds.  ";
        if (string_count("1", battle_special) > 0) {
            p1 += "Within minutes Necrons begin to appear from every direction.  There appears to be nearly fourty, cramped in the dark tunnels.";
        }
        if (string_count("2", battle_special) > 0) {
            p1 += "Within minutes Necrons begin to appear from every direction.  There appears to be nearly a hundred, cramped in the dark tunnels.";
        }
        if (string_count("3", battle_special) > 0) {
            p1 += "Within minutes Necrons begin to appear from every direction.  Their numbers are wihout number.";
        }
    }

    if (string_count("wraith", battle_special) > 0) {
        p1 += "two Necron Wraiths appear out of nowhere and begin to attack.";
    }
    if (string_count("spyder", battle_special) > 0) {
        p1 += "a large Canoptek Spyder launches towards your marines, a small group of scuttling Scarabs quickly following.";
    }
    if (string_count("stalker", battle_special) > 0) {
        p1 += "the tunnel begins to shake and a massive Tomb Stalker scuttles into your midst.";
    }
    _newline = p1;
    combat_log.push(_newline, _newline_color);
    exit;
}



p2 = "";
var _auto_include = [
    _marine_roles[eROLE.TACTICAL],
    _marine_roles[eROLE.VETERAN],
    _marine_roles[eROLE.ASSAULT],
    _marine_roles[eROLE.DEVASTATOR],
]

for (var i = 0; i < array_length(_auto_include); i++){
    var _role = _auto_include[i];
    if (player_unit_index.role_count(_role) > 0){
        p2 += player_unit_index.plural_string_role(_role) + ", ";
    }
}

var _small_include = [
    _marine_roles[eROLE.TERMINATOR],
    _marine_roles[eROLE.CHAPLAIN],
    _marine_roles[eROLE.APOTHECARY],
    _marine_roles[eROLE.LIBRARIAN],
    _marine_roles[eROLE.TECHMARINE],
    _marine_roles[eROLE.SERGEANT],
    _marine_roles[eROLE.VETERANSERGEANT],
    _marine_roles[eROLE.SCOUT],
]
if (_marine_count < 200) {
    for (var i = 0; i < array_length(_small_include); i++){
        var _role = _small_include[i];
        if (player_unit_index.role_count(_role) > 0){
            p2 += player_unit_index.plural_string_role(_role) + ", ";
        }
    }
} else {
    var _others = _marine_count - player_unit_index.sum_roles(_auto_include);
    _others -= _dread_count;
p2 = "";

var _auto_include = [
    _marine_roles[eROLE.TACTICAL],
    _marine_roles[eROLE.VETERAN],
    _marine_roles[eROLE.ASSAULT],
    _marine_roles[eROLE.DEVASTATOR],
];

for (var i = 0; i < array_length(_auto_include); i++) {
    var _role = _auto_include[i];
    if (player_unit_index.role_count(_role) > 0) {
        p2 += player_unit_index.plural_string_role(_role) + ", ";
    }
}

var _small_include = [
    _marine_roles[eROLE.TERMINATOR],
    _marine_roles[eROLE.CHAPLAIN],
    _marine_roles[eROLE.APOTHECARY],
    _marine_roles[eROLE.LIBRARIAN],
    _marine_roles[eROLE.TECHMARINE],
    _marine_roles[eROLE.SERGEANT],
    _marine_roles[eROLE.VETERANSERGEANT],
    _marine_roles[eROLE.SCOUT],
];

var _other_count = _marine_count
    - player_unit_index.sum_roles(_auto_include)
    - _dread_count;

if (_marine_count < 200) {
    for (var i = 0; i < array_length(_small_include); i++) {
        var _role = _small_include[i];
        if (player_unit_index.role_count(_role) > 0) {
            p2 += player_unit_index.plural_string_role(_role) + ", ";
        }
    }

    _other_count -= player_unit_index.sum_roles(_small_include);
}

if (_other_count > 0) {
    p2 += $"{_other_count} other various Astartes, ";
}

var woo = string_length(p2);
p2 = string_delete(p2, woo - 1, 2);

if (string_count(", ", p2) > 1) {
    woo = string_rpos(", ", p2);
    p2 = string_insert(" and", p2, woo + 1);
}
if (string_count(", ", p2) == 1) {
    woo = string_rpos(", ", p2);
    p2 = string_delete(p2, woo - 1, 2);
    p2 = string_insert(" and", p2, woo + 1);
}
p2 += ".";

if ((player_unit_index.role_count(_marine_roles[eROLE.ANCIENT]) > 1) && (!dropping)) {
    p5 = "  Chapter Ancients hold your Chapter heraldry high and proud.";
}

if (_dread_count + predators + land_raiders > 3) {
    p6 = "  Forming up the armoured division is ";
if (_dread_count > 0) {
    p6 += string_plural_count(
        _marine_roles[eROLE.DREADNOUGHT],
        _dread_count,
        false
    ) + ", ";
    }

    if (rhinos > 0) {
        p6 += string_plural_count("Rhino", rhinos) + ", ";
    }
    
    if (predators > 0) {
        p6 += string_plural_count("Predator", predators) + ", ";
    }

    if (land_raiders > 0) {
        p6 += string_plural_count("Land Raider", land_raiders) + ", ";
    }

    if (land_speeders > 0) {
        p6 += string_plural_count("Land Speeder", land_speeders) + ", ";
    }

    if (whirlwinds > 0) {
        p6 += string_plural_count("Whirlwind", whirlwinds) + ", ";
    }

    // Other vehicles here?

    woo = string_length(p6);
    p6 = string_delete(p6, woo - 1, 2);

    if (string_count(", ", p6) > 1) {
        woo = string_rpos(", ", p6);
        p6 = string_insert(" and", p6, woo + 1);
    }
    if (string_count(", ", p6) == 1) {
        woo = string_rpos(", ", p6);
        p6 = string_delete(p6, woo - 1, 2);
        p6 = string_insert(" and", p6, woo + 1);
    }
    p6 += ".";
}
// If less than three spell out the individual vehicles

if (battle_special == "space_hulk") {
    _newline = p1 + p2;
    combat_log.push(_newline, _newline_color);
    if (a1 != "") {
        _newline = a1;
        combat_log.push(_newline, _newline_color);
    }
    if (hulk_forces > 0) {
        _newline = "There are " + string(hulk_forces) + " or so blips.";
        combat_log.push(_newline, _newline_color);
    }

    exit;
}
if (!dropping) {
    _newline = p1 + p2 + p3 + p4 + p5 + p6;
    combat_log.push(_newline, _newline_color);
    if (a1 != "") {
        _newline = a1;
        combat_log.push(_newline, _newline_color);
    }
}

if (dropping && (battle_special != "space_hulk")) {
    d1 = p1;
    d2 = p2;
    d3 = p3;
    d4 = p4;
    d5 = p5;
    d6 = p6;
}

if ((battle_special == "ruins") || (battle_special == "ruins_eldar")) {
    _newline = "The enemy forces are made up of " + enemy_dudes;

    if (enemy == eFACTION.ELDAR) {
        _newline += " Craftworld Eldar.";
    }
    if (enemy == eFACTION.CHAOS && threat != 7) {
        _newline += " Cultists and Mutants.";
    }
    if (enemy == eFACTION.HERETICS) {
        _newline += " Chaos Space Marines.";
    }
    if (enemy == eFACTION.CHAOS && threat == 7) {
        _newline += " Daemons.";
    }

    combat_log.push(_newline, _newline_color);
    exit;
}

// Enemy crap here
var rand = 0;
p1 = "";
p2 = "";
p3 = "";
p4 = "";
p5 = "";
p6 = "";
temp2 = 0;
temp3 = 0;
temp4 = 0;
temp5 = 0;

if (enemy == eFACTION.IMPERIUM) {
    p1 = "Opposing your forces are a total of " + scr_display_number(floor(guard_effective)) + " Guardsmen, including Heavy Weapons and Armour.";
    p2 = "";
    p3 = "";
}

if ((enemy == eFACTION.ECCLESIARCHY) && (!dropping)) {
    p1 = "Marching to face your forces ";
    if (threat == 1) {
        p2 = "are a squad of Adepta Sororitas, back up by a dozen priests.  Forming up a protective shield around them are a large group of religious followers, gnashing and screaming out litanies to the Emperor.";
    }
    if (threat == 2) {
        p2 = "are several squads of Adepta Sororitas.  A large pack of religious followers forms up a protective shield in front, backed up by numerous Acro-Flagellents.";
    }
    if (threat == 3) {
        p2 = "are more than four hundred Adepta Sororitas, thick clouds of incense and smoke heralding their advance.  An equally massive pack of religious followers are spread around, screaming and babbling hyms to the Emperor.  Many are already bleeding from self-inflicted wounds or flagellation.  Several Penitent Engines clank and advance in the forefront.";
    }
    if (threat == 4) {
        p2 = "are more than a thousand Adepta Sororitas, a large portion of an order, thick clouds of incense and smoke heralding their advance.  A massive pack of religious followers are spread among the force, screaming and babbling hyms to the Emperor.  Many are already bleeding from self-inflicted wounds or flagellation.  Their voices are drowned out by the rumble of Penitent Engines and the loud vox-casters of Excorcists, blasting out litanies and organ music even more deafening volumes.";
    }
    if (threat >= 5) {
        p2 = "is the entirety of an Adepta Sororitas order, the ground shaking beneath their combined thousands of footsteps.  Forming a shield around them in a massive, massive pack of religious followers, screaming out or babbling hyms to the Emperor.  All of the opposing army is a blurring, shifting mass of robes and ceremite, and sound, Ecclesiarchy Priests and Mistresses whipping the masses into more of a blood frenzy.  Organ music and litanies blast from the many Exorcists, the sound deafening to those too close.  Carried with the wind, and lingering in the air, is the heavy scent of promethium.";
    }
}

if ((enemy == eFACTION.ELDAR) && (!dropping)) {
    // Need a few random descriptors here
    rand = choose(1, 2, 3);
}
if ((enemy == eFACTION.ORK) && (!dropping)) {
    rand = choose(1, 2, 3);
    if (rand < 4) {
        p1 = "Howls and grunts ring from the surrounding terrain as the Orks announce their presence.  ";
        p2 = enemy_dudes + ", the bloodthirsty horde advances toward your Marines, ecstatic in their anticipation of carnage.  ";
        p3 = p2;
        p2 = string_delete(p2, 2, 999);
        p3 = string_delete(p3, 1, 1);
        p2 = string_upper(p2); // Capitalize the ENEMY DUDES first letter
    }
}
if ((enemy == eFACTION.ORK) && dropping) {
    p1 = "The " + enemy_dudes + "-some Orks howl and roar at the oncoming marines.  Many of the beasts fire their weapons, more or less spraying rounds aimlessly into the sky.";
}

if ((enemy == eFACTION.TAU) && (!dropping)) {
    rand = choose(1, 2, 3);
}
if ((enemy == eFACTION.TYRANIDS) && (!dropping)) {
    rand = choose(1, 2, 3);
}
if ((enemy == eFACTION.TYRANIDS) && dropping) {
    p1 = "The " + enemy_dudes + "-some Tyranids hiss and chitter as your marines rain down.  Blasts of acid and spikes fill the sky, but none seem to quite find their mark.";
}

if ((enemy == eFACTION.CHAOS) && (!dropping)) {
    rand = choose(1, 2, 3);
}

if ((enemy == eFACTION.CHAOS) && (threat == 7)) {
    rand = choose(1, 2);
    if (rand == 1) {
        p1 = "Laying before them is a hellish landscape, fitting for nightmares.  Twisted, flesh-like spires reach for the sky, each containing a multitude of fanged maws or eyes.  Lightning crackles through the red sky.  ";
    }
    if (rand == 2) {
        p1 = "Waiting for your marines is a twisted landscape.  Mutated, fleshy spires reach for the sky.  The ground itself is made up of choking purple ash, kicked up with each footstep, blocking vision.  ";
    }
    p1 += "All that can be seen twists and shifts, as though looking through a massive, distorted lens.  ";
    p8 = "The enemy forces are made up of over 3000 lesser Daemons.  Their front and rear ranks are made up of Maulerfiends and Soulgrinders, backed up by nearly a dozen Greater Daemons.  Each of the four Chaos Gods are represented.";
}

if ((enemy == eFACTION.HERETICS) && (dropping == 0)) {
    rand = choose(1, 2, 3);
}

if ((enemy == eFACTION.NECRONS) && (dropping == 0)) {
    rand = choose(1, 2, 3);
    if (rand < 4) {
        p1 = "Dirt crunches beneath the feet of the Necrons as they make their silent advance.  ";
        p2 = enemy_dudes + ", the souless xeno advance toward your Marines, silent and pulsing with green energy.  ";
        p3 = p2;
        p2 = string_delete(p2, 2, 999);
        p3 = string_delete(p3, 1, 1);
        p2 = string_upper(p2); // Capitalize the ENEMY DUDES first letter
    }
}

if (!dropping) {
    _newline = p1 + p2 + p3 + p4 + p5 + p6;
    combat_log.push(_newline, _newline_color);
    if (a1 != "") {
        _newline = a1;
        combat_log.push(_newline, _newline_color);
    }
    if (p8 != "") {
        _newline = p8;
        combat_log.push(_newline, _newline_color);
    }
}

if (dropping) {
    _newline = d1 + p1;
    combat_log.push(_newline, _newline_color);
    if (lyman == 0) {
        d7 = "After a brief descent all of the drop-pods smash down, followed quickly by your marines pouring free.  Their ranks are made up of ";
    }
    if (lyman == 1) {
        d7 = "After a brief descent all of the drop-pods smash down.  Your marines exit the vehicles, shaking off their vertigo and nausea with varying degrees of success.  Their ranks are made up of ";
    }
    _newline = d7 + d2 + d3 + d4 + d5 + d6;
    combat_log.push(_newline, _newline_color);
    if (a1 != "") {
        _newline = a1;
        combat_log.push(_newline, _newline_color);
    }
    if (p8 != "") {
        _newline = p8;
        combat_log.push(_newline, _newline_color);
    }
}

if ((occulobe == 1) && (battle_special != "space_hulk")) {
    if ((time == 5) || (time == 6)) {
        _newline = "The morning light of dawn is blinding your marines!";
        _newline_color = eMSG_COLOR.RED;
        combat_log.push(_newline, _newline_color);
    }
}

if ((fortified > 1) && !dropping && !(enemy == eFACTION.CHAOS && threat == 7)) {
    if (fortified == 2) {
        _newline = "An Aegis Defense Line protects your forces.";
    }
    if (fortified == 3) {
        _newline = "Thick plasteel walls protect your forces.";
    }
    if (fortified == 4) {
        _newline = "A series of thick plasteel walls protect your forces.";
    }
    if (fortified >= 5) {
        _newline = "A massive plasteel bastion protects your forces.";
    }

    if ((player_defenses > 0) && (player_silos > 0)) {
        _newline += "  The front of your Monastery also boasts " + string(player_defenses) + " Weapon Emplacements and " + string(player_silos) + " Missile Silos.";
    }
    if ((player_defenses == 0) && (player_silos > 0)) {
        _newline += "  Your Monastery also boasts " + string(player_silos) + " Missile Silos.";
    }
    if ((player_defenses > 0) && (player_silos == 0)) {
        _newline += "  The front of your Monastery also boasts " + string(player_defenses) + " Weapon Emplacements.";
    }

    combat_log.push(_newline, _newline_color);
}

var _roles = active_roles();
var _speech_giver_role_priority = [
    _roles[eROLE.CHAPTERMASTER],
    "Master of Sanctity",
    "Chief " + _roles[eROLE.LIBRARIAN],
    _roles[eROLE.CAPTAIN],
    _roles[eROLE.CHAPLAIN],
]

var _speech_giver_role = -1;
for (var i = 0; i < array_length(_speech_giver_role_priority); i++){
    if (player_unit_index.has_role(_speech_giver_role_priority[i])){
        _speech_giver_role = i;
        break;
    }
}

// Check for battlecry here
if ((_marine_count >= 100) && (threat > 1) && _speech_giver_role > -1 && !dropping) {
    p1 = "";
    p2 = "";
    p3 = "";
    p4 = "";
    p5 = "";
    p6 = "";
    temp4 = 0;
    temp5 = 0;

    var _r_name = _speech_giver_role_priority[_speech_giver_role];
    var _index = player_unit_index.role_index;
    var _speech_giver = _index[$ _r_name][0];

    var _cm_giving_speech = _speech_giver_role == 0;
    if (_cm_giving_speech) {
        p1 = "You ";
    } else {
        p1 = _speech_giver.name_role() + " ";
    }

    var standard_cry = 0;
    if (global.chapter_name == "Salamanders") {
        standard_cry = 1;
        rand = choose(1, 2, 3, 4, 5);
        if ((rand == 1) && (_cm_giving_speech != 1)) {
            p2 = "breaks the silence, begining the Chapter Battlecry-";
        }
        if ((rand == 1) && (_cm_giving_speech == 1)) {
            p2 = "break the silence, begining the Chapter Battlecry-";
        }
        if ((rand == 2) && (_cm_giving_speech != 1)) {
            p2 = "roars the first half of the Chapter Battlecry-";
        }
        if ((rand == 2) && (_cm_giving_speech == 1)) {
            p2 = "roar the first half of the Chapter Battlecry-";
        }
        if ((rand == 3) && (_cm_giving_speech != 1)) {
            p2 = "shouts the start of the Chapter Battlecry-";
        }
        if ((rand == 3) && (_cm_giving_speech == 1)) {
            p2 = "shout the start of the Chapter Battlecry-";
        }
        if ((rand == 4) && (_cm_giving_speech != 1)) {
            p2 = "calls out to your marines-";
        }
        if ((rand == 4) && (_cm_giving_speech == 1)) {
            p2 = "call out to your marines-";
        }
        if ((rand == 5) && (_cm_giving_speech != 1)) {
            p2 = "roars to your marines-";
        }
        if ((rand == 5) && (_cm_giving_speech == 1)) {
            p2 = "roar to your marines-";
        }
        p3 = "''Into the fires of battle!''";
        if ((_marine_count >= 100) && (_marine_count < 200)) {
            p4 = "Over a hundred Astartes roar in return, their voice one-";
        }
        if ((_marine_count >= 200) && (_marine_count < 400)) {
            p4 = "Several hundred Astartes roar in return, their voice one-";
        }
        if ((_marine_count >= 500) && (_marine_count < 800)) {
            p4 = "Your battle brothers echoe the cry, a massive sound felt more than heard-";
        }
        if (_marine_count > 800) {
            p4 = "The sound is deafening as the " + string(global.chapter_name) + " shout in unison-";
        }
        p5 = "''UNTO THE ANVIL OF WAR!''";
        _newline = p1 + p2;
        combat_log.push(_newline, _newline_color);
        _newline = p3;
        combat_log.push(_newline, _newline_color);
        _newline = p4;
        combat_log.push(_newline, _newline_color);
        _newline = p5;
        combat_log.push(_newline, _newline_color);
    }
    if (obj_ini.battle_cry == "...") {
        standard_cry = 1;
        rand = choose(1, 2, 3);
        if ((rand == 1) && (_cm_giving_speech != 1)) {
            p2 = "remains silent as the Chapter forms for battle-";
        }
        if ((rand == 1) && (_cm_giving_speech == 1)) {
            p2 = "remain silent as the Chapter forms for battle-";
        }
        if ((rand == 2) && (_cm_giving_speech != 1)) {
            p2 = "remains silent and issues orders to the Chapter for battle-";
        }
        if ((rand == 2) && (_cm_giving_speech == 1)) {
            p2 = "remain silent and issues orders to the Chapter for battle-";
        }
        if ((rand == 3) && (_cm_giving_speech != 1)) {
            p2 = "issues orders to the Chapter over Vox-";
        }
        if ((rand == 3) && (_cm_giving_speech == 1)) {
            p2 = "whisper to your brothers the plans for initial deployment over vox-";
        }
        p3 = "''Sharp gestures and handsigns from officers direct the Marines''";
        if ((_marine_count >= 100) && (_marine_count < 200)) {
            p4 = "Over a hundred Astartes nod in acknowledgement and move quickly-";
        }
        if ((_marine_count >= 200) && (_marine_count < 400)) {
            p4 = "Several hundred Astartes nod in acknowledgement and move swiftly-";
        }
        if ((_marine_count >= 500) && (_marine_count < 800)) {
            p4 = "Your battle brothers all nod in acknowledgement and move hastily-";
        }
        if (_marine_count > 800) {
            p4 = "The fluidity is astounding as the " + string(global.chapter_name) + " move seamlessly into position ready for battle-";
        }
        p5 = "''They stand ready to engage the enemy''";
        _newline = p1 + p2;
        combat_log.push(_newline, _newline_color);
        _newline = p3;
        combat_log.push(_newline, _newline_color);
        _newline = p4;
        combat_log.push(_newline, _newline_color);
        _newline = p5;
        combat_log.push(_newline, _newline_color);
    }

    if ((global.chapter_name == "Iron Warriors") && (global.custom == eCHAPTER_TYPE.PREMADE)) {
        standard_cry = 1;
        rand = choose(1, 2, 3, 4, 5);
        if ((rand == 1) && (_cm_giving_speech != 1)) {
            p2 = "breaks the silence, begining the Chapter Battlecry-";
        }
        if ((rand == 1) && (_cm_giving_speech == 1)) {
            p2 = "break the silence, begining the Chapter Battlecry-";
        }
        if ((rand == 2) && (_cm_giving_speech != 1)) {
            p2 = "roars the first half of the Chapter Battlecry-";
        }
        if ((rand == 2) && (_cm_giving_speech == 1)) {
            p2 = "roar the first half of the Chapter Battlecry-";
        }
        if ((rand == 3) && (_cm_giving_speech != 1)) {
            p2 = "shouts the start of the Chapter Battlecry-";
        }
        if ((rand == 3) && (_cm_giving_speech == 1)) {
            p2 = "shout the start of the Chapter Battlecry-";
        }
        if ((rand == 4) && (_cm_giving_speech != 1)) {
            p2 = "calls out to your marines-";
        }
        if ((rand == 4) && (_cm_giving_speech == 1)) {
            p2 = "call out to your marines-";
        }
        if ((rand == 5) && (_cm_giving_speech != 1)) {
            p2 = "roars to your marines-";
        }
        if ((rand == 5) && (_cm_giving_speech == 1)) {
            p2 = "roar to your marines-";
        }
        p3 = "''Iron within!''";
        if ((_marine_count >= 100) && (_marine_count < 200)) {
            p4 = "Over a hundred Astartes roar in return, their voice one-";
        }
        if ((_marine_count >= 200) && (_marine_count < 400)) {
            p4 = "Several hundred Astartes roar in return, their voice one-";
        }
        if ((_marine_count >= 500) && (_marine_count < 800)) {
            p4 = "Your battle brothers echoe the cry, a massive sound felt more than heard-";
        }
        if (_marine_count > 800) {
            p4 = "The sound is deafening as the " + string(global.chapter_name) + " shout in unison-";
        }
        p5 = "''IRON WITHOUT!''";
        _newline = p1 + p2;
        combat_log.push(_newline, _newline_color);
        _newline = p3;
        combat_log.push(_newline, _newline_color);
        _newline = p4;
        combat_log.push(_newline, _newline_color);
        _newline = p5;
        combat_log.push(_newline, _newline_color);
    }

    if (standard_cry == 0) {
        standard_cry = 1;
        rand = choose(1, 2, 3, 4);
        if (rand == 1) {
            if (_cm_giving_speech != 1) {
                p2 = "breaks ";
            }
            if (_cm_giving_speech == 1) {
                p2 = "break ";
            }
            p2 += "the silence, calling out the Chapter Battlecry-";
        }
        if (rand == 2) {
            if (_cm_giving_speech != 1) {
                p2 = "roars ";
            }
            if (_cm_giving_speech == 1) {
                p2 = "roar ";
            }
            p2 += "the Chapter Battlecry-";
        }
        if (rand == 3) {
            if (_cm_giving_speech != 1) {
                p2 = "shouts ";
            }
            if (_cm_giving_speech == 1) {
                p2 = "shout ";
            }
            p2 += "the Chapter Battlecry-";
        }
        if (rand == 4) {
            if (_cm_giving_speech != 1) {
                p2 = "roars ";
            }
            if (_cm_giving_speech == 1) {
                p2 = "roar ";
            }
            p2 += "to your marines-";
        }
        p3 = "''" + string(obj_ini.battle_cry) + "!''";
        if ((_marine_count >= 100) && (_marine_count < 200)) {
            p4 = "Over a hundred Astartes echoe the cry or let out shouts of their own.";
        }
        if ((_marine_count >= 200) && (_marine_count < 400)) {
            p4 = "Several hundred Astartes roar in return, echoing the cry.";
        }
        if ((_marine_count >= 500) && (_marine_count < 800)) {
            p4 = "Your battle brothers echoe the cry, a massive sound felt more than heard.";
        }
        if ((_marine_count > 800) && (rand >= 3)) {
            p4 = "The sound is deafening as the " + string(global.chapter_name) + " add their voices.";
        }
        if ((_marine_count > 800) && (rand <= 2)) {
            p4 = "The sound is deafening as the " + string(global.chapter_name) + " return the cry and magnify it a thousand times.";
        }
        _newline = p1 + p2;
        combat_log.push(_newline, _newline_color);
        _newline = p3;
        combat_log.push(_newline, _newline_color);
        _newline = p4;
        combat_log.push(_newline, _newline_color);
    }
}

var line_break = "------------------------------------------------------------------------------";
_newline = line_break;
combat_log.push(_newline, _newline_color);
_newline = line_break;
combat_log.push(_newline, _newline_color);
