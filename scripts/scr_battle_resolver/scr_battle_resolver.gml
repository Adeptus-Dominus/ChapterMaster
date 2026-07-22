/// scr_battle_resolver — headless AI ground-battle resolver (Sector Governor, 2026-07-11).
/// Replaces the abstract choose(1..6)xscore attrition in scr_enemy_ai_a with a REAL round-based fight
/// between the two sides' actual rosters (from faction_ladder_composition / ork_composition). Unit
/// stats and the damage kernel are lifted from the tactical sim (obj_enunit/Alarm_1 + scr_shoot 355-399)
/// so AI battles use the same rules a player battle would — just resolved numerically, not rendered.
/// Geometry-free and deterministic apart from a small per-battle accuracy jitter. See
/// docs/POPULATIONS_FORCE_PLAN.md §16.

/// @function battle_unit_profiles
/// @description Static table: unit label -> combat profile {off (damage/model/round pre-armour), ap
///              (0-4 armour-pierce tier), splash, ac (armour), hp (wounds/model), dr (damage-reduction
///              mult), veh}. Values are the real tactical stats where the unit exists there; the rest are
///              tier-calibrated archetypes (see the trailing comment on each row). Built once.
/// @returns {Struct}
function battle_unit_profiles() {
    static _p = undefined;
    if (_p != undefined) { return _p; }
    _p = {};
    // Imperial garrison mass (strategic pdf/guardsmen pools) — a Guardsman is the real tactical stat;
    // PDF is a weaker conscript line (§11a). Used by the AI planet-battle resolver.
    _p[$ "Guardsmen"] = { off: 20, ap: 0, splash: 0, ac: 5, hp: 40, dr: 1, veh: 0 };
    _p[$ "PDF"] = { off: 14, ap: 0, splash: 0, ac: 4, hp: 35, dr: 1, veh: 0 };
    // Astartes — the player's Chapter + progenitors fighting on the Imperial side (elite, few).
    _p[$ "Space Marine"] = { off: 120, ap: 1, splash: 1, ac: 20, hp: 150, dr: 0.6, veh: 0 };
    // Looted Wagon — an enemy tank the Orks have captured, red-painted and bolted with more dakka.
    _p[$ "Looted Wagon"] = { off: 220, ap: 1, splash: 1, ac: 35, hp: 250, dr: 0.55, veh: 1 };
    _p[$ "'Ardboyz"] ={ off: 66, ap: 0, splash: 1, ac: 11, hp: 100, dr: 0.78, veh: 0 }; // real:Ard Boy (buffed: orks are tough)
    _p[$ "Aberrant"] = { off: 80, ap: 2, splash: 0, ac: 5, hp: 80, dr: 0.75, veh: 0 }; // real:Aberrant
    _p[$ "Abominant"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Accursed Cultist"] = { off: 50, ap: 0, splash: 0, ac: 5, hp: 50, dr: 1.0, veh: 0 }; // real:Mutant
    _p[$ "Achilles Ridgerunner"] = { off: 200, ap: 4, splash: 0, ac: 20, hp: 175, dr: 0.75, veh: 1 }; // real:Ridgerunner
    _p[$ "Acolyte Hybrid"] = { off: 150, ap: 2, splash: 3, ac: 10, hp: 50, dr: 1.0, veh: 0 }; // real:Hybrid
    _p[$ "Anchorite"] = { off: 240, ap: 2, splash: 3, ac: 20, hp: 150, dr: 0.8, veh: 1 }; // real:Penitent Engine
    _p[$ "Annihilation Barge"] = { off: 480, ap: 1, splash: 3, ac: 30, hp: 350, dr: 0.65, veh: 1 }; // real:Doomsday Arc
    _p[$ "Arco-flagellant"] = { off: 125, ap: 1, splash: 3, ac: 5, hp: 150, dr: 0.7, veh: 0 }; // real:Arco-Flagellent
    _p[$ "Atalan Jackal"] = { off: 120, ap: 1, splash: 3, ac: 10, hp: 80, dr: 0.9, veh: 0 }; // real:Jackal
    _p[$ "Autarch"] = { off: 320, ap: 4, splash: 0, ac: 15, hp: 150, dr: 0.75, veh: 0 }; // real:Autarch
    _p[$ "Battle Sister"] = { off: 90, ap: 0, splash: 0, ac: 15, hp: 60, dr: 0.8, veh: 0 }; // real:Celestian
    _p[$ "Battlewagon"] = { off: 450, ap: 1, splash: 3, ac: 30, hp: 350, dr: 0.55, veh: 1 }; // real:Battlewagon
    _p[$ "Beast Snagga Boyz"] = { off: 55, ap: 0, splash: 3, ac: 10, hp: 80, dr: 0.9, veh: 0 }; // real:Ard Boy
    _p[$ "Beast of Nurgle"] = { off: 180, ap: 1, splash: 2, ac: 26, hp: 210, dr: 0.7, veh: 0 }; // arch-t2
    _p[$ "Big Mek"] = { off: 250, ap: 1, splash: 3, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Mekboy
    _p[$ "Biophagus"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Biovore"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Blitza-Bommer"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Blood Pact"] = { off: 75, ap: 0, splash: 0, ac: 10, hp: 40, dr: 0.9, veh: 0 }; // real:Cultist Elite
    _p[$ "Bloodcrusher"] = { off: 180, ap: 1, splash: 2, ac: 26, hp: 210, dr: 0.7, veh: 0 }; // arch-t2
    _p[$ "Bloodletter"] = { off: 120, ap: 1, splash: 3, ac: 5, hp: 35, dr: 1.0, veh: 0 }; // real:Cultist
    _p[$ "Blue Horror"] = { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 }; // arch-t0
    _p[$ "Boomdakka Snazzwagon"] = { off: 120, ap: 1, splash: 1, ac: 25, hp: 150, dr: 0.65, veh: 1 }; // arch-veh-t1
    _p[$ "Boyz"] = { off: 64, ap: 0, splash: 1, ac: 6, hp: 78, dr: 0.85, veh: 0 }; // real:Slugga Boy (buffed: orks shrug small-arms)
    _p[$ "Broodlord"] = { off: 113.3, ap: 1, splash: 0, ac: 15, hp: 300, dr: 0.65, veh: 0 }; // real:Genestealer Patriarch
    _p[$ "Burna Boyz"] = { off: 168, ap: 1, splash: 3, ac: 5, hp: 80, dr: 1.0, veh: 0 }; // real:Burna Boy
    _p[$ "Burna-Bommer"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Burning Chariot"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Cadre Fireblade"] = { off: 37, ap: 0, splash: 0, ac: 10, hp: 40, dr: 1.0, veh: 0 }; // real:Fire Warrior
    _p[$ "Canoness"] = { off: 190, ap: 4, splash: 0, ac: 15, hp: 100, dr: 0.5, veh: 0 }; // real:Palatine
    _p[$ "Canoptek Doomstalker"] = { off: 850, ap: 1, splash: 3, ac: 30, hp: 300, dr: 1.0, veh: 0 }; // real:Tomb Stalker
    _p[$ "Canoptek Reanimator"] = { off: 300, ap: 1, splash: 0, ac: 20, hp: 200, dr: 1.0, veh: 0 }; // real:Canoptek Spyder
    _p[$ "Canoptek Scarab"] = { off: 60, ap: 1, splash: 0, ac: 5, hp: 30, dr: 0.75, veh: 0 }; // real:Canoptek Scarab
    _p[$ "Canoptek Spyder"] = { off: 300, ap: 1, splash: 0, ac: 20, hp: 200, dr: 1.0, veh: 0 }; // real:Canoptek Spyder
    _p[$ "Canoptek Wraith"] = { off: 80, ap: 1, splash: 0, ac: 10, hp: 200, dr: 1.0, veh: 0 }; // real:Necron Wraith
    _p[$ "Carnifex"] = { off: 450, ap: 1, splash: 3, ac: 30, hp: 300, dr: 0.6, veh: 1 }; // real:Carnifex
    _p[$ "Castigator"] = { off: 120, ap: 0, splash: 3, ac: 40, hp: 300, dr: 0.65, veh: 1 }; // real:Immolator
    _p[$ "Celestian Sacresant"] = { off: 90, ap: 0, splash: 0, ac: 15, hp: 60, dr: 0.8, veh: 0 }; // real:Celestian
    _p[$ "Chaos Aspirant"] = { off: 90, ap: 0, splash: 0, ac: 15, hp: 100, dr: 0.9, veh: 0 }; // real:Chaos Space Marine
    _p[$ "Chaos Basilisk"] = { off: 420, ap: 0, splash: 3, ac: 30, hp: 150, dr: 0.75, veh: 1 }; // real:Chaos Basilisk
    _p[$ "Chaos Biker"] = { off: 80, ap: 0, splash: 0, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Raptor
    _p[$ "Chaos Cultist"] = { off: 120, ap: 1, splash: 3, ac: 5, hp: 35, dr: 1.0, veh: 0 }; // real:Cultist
    _p[$ "Chaos Land Raider"] = { off: 540, ap: 1, splash: 3, ac: 50, hp: 400, dr: 0.5, veh: 1 }; // real:Land Raider
    _p[$ "Chaos Leman Russ"] = { off: 420, ap: 1, splash: 0, ac: 40, hp: 250, dr: 0.5, veh: 1 }; // real:Chaos Leman Russ
    _p[$ "Chaos Lord"] = { off: 190, ap: 4, splash: 0, ac: 25, hp: 150, dr: 0.5, veh: 0 }; // real:Chaos Lord
    _p[$ "Chaos Predator"] = { off: 500, ap: 1, splash: 0, ac: 40, hp: 350, dr: 0.65, veh: 1 }; // real:Predator
    _p[$ "Chaos Rhino"] = { off: 65, ap: 0, splash: 3, ac: 30, hp: 200, dr: 0.75, veh: 1 }; // real:Rhino
    _p[$ "Chaos Space Marine"] = { off: 90, ap: 0, splash: 0, ac: 15, hp: 100, dr: 0.9, veh: 0 }; // real:Chaos Space Marine
    // God-cult Marines (§16r) — Chaos Space Marine variants tuned to their 10th-ed tabletop character: each
    // god's sect fields its own instead of the generic legionary, so a Chaos world reads by its patron.
    // Berzerker = pure melee (extra attacks / Lethal Hits) but no tougher than a marine; Rubric = low output
    // but very durable (All Is Dust damage-cut, AP inferno bolters); Plague = extremely resilient (T5 /
    // Disgustingly Resilient); Noise = shooting-heavy (sonic blast, splash). Baseline CSM = 90/0/0/15/100/0.9.
    _p[$ "Khorne Berzerker"] = { off: 150, ap: 0, splash: 1, ac: 14, hp: 100, dr: 0.88, veh: 0 }; // Khorne — melee fury
    _p[$ "Rubric Marine"] = { off: 95, ap: 2, splash: 0, ac: 18, hp: 100, dr: 0.68, veh: 0 };     // Tzeentch — AP bolters, All Is Dust
    _p[$ "Plague Marine"] = { off: 95, ap: 1, splash: 0, ac: 16, hp: 150, dr: 0.55, veh: 0 };     // Nurgle — disgustingly resilient
    _p[$ "Noise Marine"] = { off: 140, ap: 1, splash: 2, ac: 14, hp: 95, dr: 0.85, veh: 0 };      // Slaanesh — sonic fusillade
    _p[$ "Chaos Spawn"] = { off: 50, ap: 0, splash: 0, ac: 5, hp: 50, dr: 1.0, veh: 0 }; // real:Mutant
    _p[$ "Chaos Terminator"] = { off: 630, ap: 1, splash: 3, ac: 35, hp: 125, dr: 0.5, veh: 0 }; // real:Chaos Terminator
    _p[$ "Chimera"] = { off: 200, ap: 2, splash: 3, ac: 30, hp: 200, dr: 0.75, veh: 1 }; // real:Chimera
    _p[$ "Chosen"] = { off: 245, ap: 1, splash: 0, ac: 15, hp: 125, dr: 0.85, veh: 0 }; // real:Chaos Chosen
    _p[$ "Crimson Hunter"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Crusader"] = { off: 90, ap: 0, splash: 0, ac: 15, hp: 60, dr: 0.8, veh: 0 }; // real:Celestian
    _p[$ "Cryptek"] = { off: 380, ap: 1, splash: 3, ac: 15, hp: 300, dr: 0.5, veh: 0 }; // real:Necron Overlord
    _p[$ "Cultist Firebrand"] = { off: 190, ap: 4, splash: 0, ac: 15, hp: 40, dr: 0.85, veh: 0 }; // real:Arch Heretic
    _p[$ "Daemon Prince"] = { off: 450, ap: 1, splash: 3, ac: 15, hp: 200, dr: 0.7, veh: 0 }; // real:Daemonhost
    _p[$ "Daemonette"] = { off: 120, ap: 1, splash: 3, ac: 5, hp: 35, dr: 1.0, veh: 0 }; // real:Cultist
    _p[$ "Dakkajet"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Dark Apostle"] = { off: 190, ap: 4, splash: 0, ac: 25, hp: 150, dr: 0.5, veh: 0 }; // real:Chaos Lord
    _p[$ "Dark Commune"] = { off: 190, ap: 4, splash: 0, ac: 15, hp: 40, dr: 0.85, veh: 0 }; // real:Arch Heretic
    _p[$ "Dark Reaper"] = { off: 190, ap: 80, splash: 3, ac: 10, hp: 40, dr: 1.0, veh: 0 }; // real:Dark Reaper
    _p[$ "Death Cult Assassin"] = { off: 190, ap: 4, splash: 0, ac: 15, hp: 100, dr: 0.5, veh: 0 }; // real:Palatine
    _p[$ "Deathmark"] = { off: 135, ap: 1, splash: 0, ac: 15, hp: 90, dr: 0.85, veh: 0 }; // real:Necron Immortal
    _p[$ "Deff Dread"] = { off: 400, ap: 1, splash: 3, ac: 30, hp: 300, dr: 0.6, veh: 1 }; // real:Deff Dread
    _p[$ "Deffkilla Wartrike"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Deffkopta"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Defiler"] = { off: 1130, ap: 1, splash: 3, ac: 40, hp: 300, dr: 0.65, veh: 1 }; // real:Defiler
    _p[$ "Devilfish"] = { off: 150, ap: 1, splash: 0, ac: 30, hp: 150, dr: 0.6, veh: 1 }; // real:Devilfish
    _p[$ "Dialogus"] = { off: 8, ap: 0, splash: 0, ac: 5, hp: 50, dr: 0.65, veh: 0 }; // real:Priest
    _p[$ "Dire Avenger"] = { off: 80, ap: 1, splash: 0, ac: 10, hp: 40, dr: 1.0, veh: 0 }; // real:Dire Avenger
    _p[$ "Dogmata"] = { off: 8, ap: 0, splash: 0, ac: 5, hp: 50, dr: 0.65, veh: 0 }; // real:Priest
    _p[$ "Dominion"] = { off: 230, ap: 200, splash: 1, ac: 15, hp: 60, dr: 0.75, veh: 0 }; // real:Dominion
    _p[$ "Doom Scythe"] = { off: 480, ap: 1, splash: 3, ac: 30, hp: 350, dr: 0.65, veh: 1 }; // real:Doomsday Arc
    _p[$ "Doomsday Ark"] = { off: 480, ap: 1, splash: 3, ac: 30, hp: 350, dr: 0.65, veh: 1 }; // real:Doomsday Arc
    _p[$ "Ethereal"] = { off: 37, ap: 0, splash: 0, ac: 10, hp: 40, dr: 1.0, veh: 0 }; // real:Fire Warrior
    _p[$ "Exocrine"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Exorcist"] = { off: 215, ap: 1, splash: 3, ac: 30, hp: 200, dr: 1.0, veh: 0 }; // real:Exorcist
    _p[$ "Falcon"] = { off: 245, ap: 1, splash: 0, ac: 30, hp: 200, dr: 0.6, veh: 1 }; // real:Falcon
    _p[$ "Farseer"] = { off: 240, ap: 1, splash: 3, ac: 15, hp: 120, dr: 0.6, veh: 0 }; // real:Farseer
    _p[$ "Fiend"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Fire Dragon"] = { off: 270, ap: 200, splash: 1, ac: 15, hp: 40, dr: 1.0, veh: 0 }; // real:Fire Dragon
    _p[$ "Fire Prism"] = { off: 300, ap: 1, splash: 0, ac: 40, hp: 200, dr: 0.5, veh: 1 }; // real:Fire Prism
    _p[$ "Fire Warrior"] = { off: 37, ap: 0, splash: 0, ac: 10, hp: 40, dr: 1.0, veh: 0 }; // real:Fire Warrior
    _p[$ "Firesight Marksman"] = { off: 65, ap: 0, splash: 0, ac: 5, hp: 40, dr: 1.0, veh: 0 }; // real:Pathfinder
    _p[$ "Flamer"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Flash Gitz"] = { off: 108, ap: 0, splash: 3, ac: 10, hp: 100, dr: 1.0, veh: 0 }; // real:Flash Git
    _p[$ "Flayed One"] = { off: 60, ap: 1, splash: 0, ac: 10, hp: 75, dr: 0.9, veh: 0 }; // real:Flayed One
    _p[$ "Flesh Hound"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Forgefiend"] = { off: 1130, ap: 1, splash: 3, ac: 40, hp: 300, dr: 0.65, veh: 1 }; // real:Defiler
    _p[$ "Frateris Militia"] = { off: 73, ap: 0, splash: 0, ac: 5, hp: 30, dr: 1.0, veh: 0 }; // real:Follower
    _p[$ "Furies"] = { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 }; // arch-t0
    _p[$ "Gargantuan Squiggoth"] = { off: 420, ap: 1, splash: 3, ac: 40, hp: 800, dr: 0.5, veh: 1 }; // custom
    _p[$ "Gargoyle"] = { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 }; // arch-t0
    _p[$ "Genestealer"] = { off: 113.3, ap: 1, splash: 0, ac: 10, hp: 75, dr: 1.0, veh: 0 }; // real:Genestealer
    _p[$ "Ghost Ark"] = { off: 480, ap: 1, splash: 3, ac: 30, hp: 350, dr: 0.65, veh: 1 }; // real:Doomsday Arc
    _p[$ "Goliath Rockgrinder"] = { off: 420, ap: 4, splash: 2, ac: 30, hp: 250, dr: 0.5, veh: 1 }; // real:Goliath Rockgrinder
    _p[$ "Goliath Truck"] = { off: 280, ap: 3, splash: 0, ac: 30, hp: 225, dr: 0.7, veh: 1 }; // real:Goliath Truck
    _p[$ "Gorkanaut"] = { off: 380, ap: 2, splash: 2, ac: 40, hp: 520, dr: 0.5, veh: 1 }; // custom
    _p[$ "Greater Daemon"] = { off: 380, ap: 2, splash: 3, ac: 35, hp: 500, dr: 0.5, veh: 0 }; // custom
    _p[$ "Gretchin"] = { off: 12, ap: 0, splash: 0, ac: 5, hp: 15, dr: 1.0, veh: 0 }; // real:Gretchin
    _p[$ "Guardian Defender"] = { off: 75, ap: 1, splash: 0, ac: 5, hp: 30, dr: 1.0, veh: 0 }; // real:Guardian
    _p[$ "Gun Drone"] = { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 }; // arch-t0
    _p[$ "Hammerhead"] = { off: 550, ap: 1, splash: 0, ac: 30, hp: 150, dr: 0.6, veh: 1 }; // real:Hammerhead
    _p[$ "Harpy"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Haruspex"] = { off: 400, ap: 2, splash: 1, ac: 45, hp: 500, dr: 0.5, veh: 1 }; // arch-veh-t3
    _p[$ "Havoc"] = { off: 240, ap: 1, splash: 3, ac: 15, hp: 100, dr: 0.9, veh: 0 }; // real:Havoc
    _p[$ "Helbrute"] = { off: 625, ap: 1, splash: 0, ac: 40, hp: 300, dr: 0.6, veh: 1 }; // real:Hellbrute
    _p[$ "Heldrake"] = { off: 120, ap: 0, splash: 0, ac: 40, hp: 400, dr: 0.5, veh: 1 }; // real:Heldrake
    _p[$ "Hemlock Wraithfighter"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Herald"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Hexmark Destroyer"] = { off: 240, ap: 1, splash: 3, ac: 25, hp: 250, dr: 0.75, veh: 0 }; // real:Necron Destroyer
    _p[$ "Hive Crone"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Hive Guard"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Hive Tyrant"] = { off: 310, ap: 1, splash: 3, ac: 25, hp: 400, dr: 0.5, veh: 0 }; // real:Hive Tyrant
    _p[$ "Hormagaunt"] = { off: 30, ap: 0, splash: 0, ac: 5, hp: 25, dr: 1.0, veh: 0 }; // real:Hormagaunt
    _p[$ "Hospitaller"] = { off: 8, ap: 0, splash: 0, ac: 5, hp: 50, dr: 0.65, veh: 0 }; // real:Priest
    _p[$ "Howling Banshee"] = { off: 145, ap: 4, splash: 0, ac: 10, hp: 40, dr: 0.8, veh: 0 }; // real:Howling Banshee
    _p[$ "Hybrid Metamorph"] = { off: 150, ap: 2, splash: 3, ac: 10, hp: 50, dr: 1.0, veh: 0 }; // real:Hybrid
    _p[$ "Imagifier"] = { off: 8, ap: 0, splash: 0, ac: 5, hp: 50, dr: 0.65, veh: 0 }; // real:Priest
    _p[$ "Immolator"] = { off: 120, ap: 0, splash: 3, ac: 40, hp: 300, dr: 0.65, veh: 1 }; // real:Immolator
    _p[$ "KV128 Stormsurge"] = { off: 300, ap: 1, splash: 0, ac: 25, hp: 250, dr: 0.7, veh: 0 }; // real:XV88 Broadside
    _p[$ "Kelermorph"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Kill Rig"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Kill Tank"] = { off: 400, ap: 2, splash: 1, ac: 45, hp: 500, dr: 0.5, veh: 1 }; // arch-veh-t3
    _p[$ "Killa Kans"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Kommandos"] = { off: 178, ap: 1, splash: 3, ac: 10, hp: 125, dr: 0.9, veh: 0 }; // real:Kommando
    _p[$ "Kroot Carnivore"] = { off: 55, ap: 0, splash: 0, ac: 5, hp: 50, dr: 1.0, veh: 0 }; // real:Kroot
    _p[$ "Krootox Rider"] = { off: 55, ap: 0, splash: 0, ac: 5, hp: 50, dr: 1.0, veh: 0 }; // real:Kroot
    _p[$ "Lictor"] = { off: 350, ap: 0, splash: 0, ac: 15, hp: 300, dr: 0.7, veh: 0 }; // real:Lictor
    _p[$ "Locus"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Lokhust Destroyer"] = { off: 240, ap: 1, splash: 3, ac: 25, hp: 250, dr: 0.75, veh: 0 }; // real:Necron Destroyer
    _p[$ "Lokhust Heavy Destroyer"] = { off: 240, ap: 1, splash: 3, ac: 25, hp: 250, dr: 0.75, veh: 0 }; // real:Necron Destroyer
    _p[$ "Lootas"] = { off: 108, ap: 0, splash: 3, ac: 10, hp: 100, dr: 1.0, veh: 0 }; // real:Flash Git
    _p[$ "Lychguard"] = { off: 200, ap: 1, splash: 0, ac: 25, hp: 100, dr: 0.75, veh: 0 }; // real:Lychguard
    _p[$ "Magus"] = { off: 160, ap: 3, splash: 3, ac: 10, hp: 100, dr: 1.0, veh: 0 }; // real:Magus
    _p[$ "Maleceptor"] = { off: 400, ap: 2, splash: 1, ac: 45, hp: 500, dr: 0.5, veh: 1 }; // arch-veh-t3
    _p[$ "Master of Executions"] = { off: 190, ap: 4, splash: 0, ac: 25, hp: 150, dr: 0.5, veh: 0 }; // real:Chaos Lord
    _p[$ "Maulerfiend"] = { off: 625, ap: 1, splash: 0, ac: 40, hp: 300, dr: 0.6, veh: 1 }; // real:Hellbrute
    _p[$ "Mawloc"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Meganobz"] = { off: 250, ap: 1, splash: 3, ac: 15, hp: 150, dr: 0.65, veh: 0 }; // real:Meganob
    _p[$ "Megatrakk Scrapjet"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Mek"] = { off: 250, ap: 1, splash: 3, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Mekboy
    _p[$ "Mek Gunz"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Ministorum Priest"] = { off: 8, ap: 0, splash: 0, ac: 5, hp: 50, dr: 0.65, veh: 0 }; // real:Priest
    _p[$ "Monolith"] = { off: 480, ap: 1, splash: 3, ac: 40, hp: 500, dr: 0.5, veh: 1 }; // real:Necron Monolith
    _p[$ "Morkanaut"] = { off: 360, ap: 2, splash: 2, ac: 40, hp: 500, dr: 0.5, veh: 1 }; // custom
    _p[$ "Mortifier"] = { off: 240, ap: 2, splash: 3, ac: 20, hp: 150, dr: 0.8, veh: 1 }; // real:Penitent Engine
    _p[$ "Necron Destroyer"] = { off: 240, ap: 1, splash: 3, ac: 25, hp: 250, dr: 0.75, veh: 0 }; // real:Necron Destroyer
    _p[$ "Necron Immortal"] = { off: 135, ap: 1, splash: 0, ac: 15, hp: 90, dr: 0.85, veh: 0 }; // real:Necron Immortal
    _p[$ "Necron Overlord"] = { off: 380, ap: 1, splash: 3, ac: 15, hp: 300, dr: 0.5, veh: 0 }; // real:Necron Overlord
    _p[$ "Necron Warrior"] = { off: 103.3, ap: 1, splash: 0, ac: 10, hp: 75, dr: 0.9, veh: 0 }; // real:Necron Warrior
    _p[$ "Neophyte Hybrid"] = { off: 150, ap: 2, splash: 3, ac: 10, hp: 50, dr: 1.0, veh: 0 }; // real:Hybrid
    _p[$ "Neurotyrant"] = { off: 180, ap: 1, splash: 2, ac: 26, hp: 210, dr: 0.7, veh: 0 }; // arch-t2
    _p[$ "Night Scythe"] = { off: 480, ap: 1, splash: 3, ac: 30, hp: 350, dr: 0.65, veh: 1 }; // real:Doomsday Arc
    _p[$ "Night Spinner"] = { off: 100, ap: 0, splash: 0, ac: 30, hp: 200, dr: 0.6, veh: 1 }; // real:Nightspinner
    _p[$ "Nobz"] = { off: 258, ap: 1, splash: 2, ac: 16, hp: 165, dr: 0.6, veh: 0 }; // real:Meganob (buffed)
    _p[$ "Nurgling"] = { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 }; // arch-t0
    _p[$ "Ophydian Destroyer"] = { off: 240, ap: 1, splash: 3, ac: 25, hp: 250, dr: 0.75, veh: 0 }; // real:Necron Destroyer
    _p[$ "Painboy"] = { off: 250, ap: 1, splash: 3, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Mekboy
    _p[$ "Palatine"] = { off: 190, ap: 4, splash: 0, ac: 15, hp: 100, dr: 0.5, veh: 0 }; // real:Palatine
    _p[$ "Paragon Warsuit"] = { off: 215, ap: 1, splash: 3, ac: 30, hp: 200, dr: 1.0, veh: 0 }; // real:Exorcist
    _p[$ "Pathfinder"] = { off: 65, ap: 0, splash: 0, ac: 5, hp: 40, dr: 1.0, veh: 0 }; // real:Pathfinder
    _p[$ "Penitent Engine"] = { off: 240, ap: 2, splash: 3, ac: 20, hp: 150, dr: 0.8, veh: 1 }; // real:Penitent Engine
    _p[$ "Phantom Titan"] = { off: 1020, ap: 1, splash: 3, ac: 50, hp: 800, dr: 0.4, veh: 1 }; // real:Phantom Titan
    _p[$ "Pink Horror"] = { off: 120, ap: 1, splash: 3, ac: 5, hp: 35, dr: 1.0, veh: 0 }; // real:Cultist
    _p[$ "Piranha"] = { off: 150, ap: 1, splash: 0, ac: 30, hp: 150, dr: 0.6, veh: 1 }; // real:Devilfish
    _p[$ "Plague Drone"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Plaguebearer"] = { off: 120, ap: 1, splash: 3, ac: 5, hp: 35, dr: 1.0, veh: 0 }; // real:Cultist
    _p[$ "Possessed"] = { off: 250, ap: 1, splash: 3, ac: 10, hp: 100, dr: 0.75, veh: 0 }; // real:Possessed
    _p[$ "Primus"] = { off: 180, ap: 1, splash: 3, ac: 10, hp: 125, dr: 0.9, veh: 0 }; // real:Primus
    _p[$ "Purestrain Genestealer"] = { off: 113.3, ap: 1, splash: 0, ac: 10, hp: 75, dr: 1.0, veh: 0 }; // real:Genestealer
    _p[$ "Ranger"] = { off: 85, ap: 0, splash: 0, ac: 5, hp: 40, dr: 0.9, veh: 0 }; // real:Ranger
    _p[$ "Raptor"] = { off: 80, ap: 0, splash: 0, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Raptor
    _p[$ "Ravener"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Razorshark"] = { off: 150, ap: 1, splash: 0, ac: 30, hp: 150, dr: 0.6, veh: 1 }; // real:Devilfish
    _p[$ "Retributor"] = { off: 90, ap: 0, splash: 0, ac: 15, hp: 60, dr: 0.8, veh: 0 }; // real:Celestian
    _p[$ "Ripper Swarm"] = { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 }; // arch-t0
    _p[$ "Royal Warden"] = { off: 380, ap: 1, splash: 3, ac: 15, hp: 300, dr: 0.5, veh: 0 }; // real:Necron Overlord
    _p[$ "Runtherd"] = { off: 12, ap: 0, splash: 0, ac: 5, hp: 15, dr: 1.0, veh: 0 }; // real:Gretchin
    _p[$ "Sanctus"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Screamer"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Screamer-Killer"] = { off: 180, ap: 1, splash: 2, ac: 26, hp: 210, dr: 0.7, veh: 0 }; // arch-t2
    _p[$ "Seeker"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Seeker Chariot"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Sentinel"] = { off: 180, ap: 1, splash: 3, ac: 20, hp: 100, dr: 0.75, veh: 1 }; // real:Technical
    _p[$ "Seraphim"] = { off: 245, ap: 1, splash: 0, ac: 15, hp: 60, dr: 0.6, veh: 0 }; // real:Seraphim
    _p[$ "Shining Spear"] = { off: 130, ap: 0, splash: 3, ac: 10, hp: 75, dr: 0.8, veh: 1 }; // real:Shining Spear
    _p[$ "Sisters Novitiate"] = { off: 73, ap: 0, splash: 0, ac: 5, hp: 30, dr: 1.0, veh: 0 }; // real:Follower
    _p[$ "Sisters Repentia"] = { off: 90, ap: 2, splash: 0, ac: 5, hp: 75, dr: 0.75, veh: 0 }; // real:Sister Repentia
    _p[$ "Skorpekh Destroyer"] = { off: 240, ap: 1, splash: 3, ac: 25, hp: 250, dr: 0.75, veh: 0 }; // real:Necron Destroyer
    _p[$ "Skull Cannon"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Sky Ray"] = { off: 550, ap: 1, splash: 0, ac: 30, hp: 150, dr: 0.6, veh: 1 }; // real:Hammerhead
    _p[$ "Sniper Drone"] = { off: 120, ap: 1, splash: 1, ac: 25, hp: 150, dr: 0.65, veh: 1 }; // arch-veh-t1
    _p[$ "Sorcerer"] = { off: 170, ap: 4, splash: 0, ac: 25, hp: 150, dr: 0.5, veh: 0 }; // real:Chaos Sorcerer
    _p[$ "Sororitas Rhino"] = { off: 65, ap: 0, splash: 3, ac: 30, hp: 200, dr: 0.75, veh: 1 }; // real:Rhino
    _p[$ "Soul Grinder"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Spiritseer"] = { off: 150, ap: 1, splash: 0, ac: 10, hp: 80, dr: 0.75, veh: 0 }; // real:Warlock
    _p[$ "Sporocyst"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Squighog Boyz"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Stompa"] = { off: 500, ap: 2, splash: 3, ac: 45, hp: 750, dr: 0.45, veh: 1 }; // custom
    _p[$ "Storm Guardian"] = { off: 75, ap: 1, splash: 0, ac: 5, hp: 30, dr: 1.0, veh: 0 }; // real:Guardian
    _p[$ "Stormboyz"] = { off: 55, ap: 0, splash: 3, ac: 5, hp: 80, dr: 0.8, veh: 0 }; // real:Stormboy
    _p[$ "Striking Scorpion"] = { off: 85, ap: 0, splash: 3, ac: 10, hp: 60, dr: 0.9, veh: 0 }; // real:Striking Scorpion
    _p[$ "Sun Shark"] = { off: 150, ap: 1, splash: 0, ac: 30, hp: 150, dr: 0.6, veh: 1 }; // real:Devilfish
    _p[$ "Swooping Hawk"] = { off: 50, ap: 0, splash: 0, ac: 10, hp: 40, dr: 0.9, veh: 0 }; // real:Warp Spider
    _p[$ "Tankbustas"] = { off: 454, ap: 1, splash: 3, ac: 5, hp: 80, dr: 1.0, veh: 0 }; // real:Tankbusta
    _p[$ "Technical"] = { off: 180, ap: 1, splash: 3, ac: 20, hp: 100, dr: 0.75, veh: 1 }; // real:Technical
    _p[$ "Termagant"] = { off: 15, ap: 0, splash: 0, ac: 5, hp: 25, dr: 1.0, veh: 0 }; // real:Termagaunt
    _p[$ "Tervigon"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Tesseract Vault"] = { off: 480, ap: 1, splash: 3, ac: 40, hp: 500, dr: 0.5, veh: 1 }; // real:Necron Monolith
    _p[$ "Tomb Blade"] = { off: 300, ap: 1, splash: 0, ac: 20, hp: 200, dr: 1.0, veh: 0 }; // real:Canoptek Spyder
    _p[$ "Tomb Stalker"] = { off: 850, ap: 1, splash: 3, ac: 30, hp: 300, dr: 1.0, veh: 0 }; // real:Tomb Stalker
    _p[$ "Toxicrene"] = { off: 400, ap: 2, splash: 1, ac: 45, hp: 500, dr: 0.5, veh: 1 }; // arch-veh-t3
    _p[$ "Triarch Praetorian"] = { off: 200, ap: 1, splash: 0, ac: 25, hp: 100, dr: 0.75, veh: 0 }; // real:Lychguard
    _p[$ "Triarch Stalker"] = { off: 850, ap: 1, splash: 3, ac: 30, hp: 300, dr: 1.0, veh: 0 }; // real:Tomb Stalker
    _p[$ "Trukk"] = { off: 120, ap: 1, splash: 1, ac: 25, hp: 150, dr: 0.65, veh: 1 }; // arch-veh-t1
    _p[$ "Trygon"] = { off: 220, ap: 1, splash: 1, ac: 32, hp: 250, dr: 0.55, veh: 1 }; // arch-veh-t2
    _p[$ "Tyranid Warrior"] = { off: 150, ap: 1, splash: 3, ac: 15, hp: 100, dr: 0.9, veh: 0 }; // real:Tyranid Warrior
    _p[$ "Tyrannofex"] = { off: 400, ap: 2, splash: 1, ac: 45, hp: 500, dr: 0.5, veh: 1 }; // arch-veh-t3
    _p[$ "Tyrant Guard"] = { off: 90, ap: 1, splash: 3, ac: 25, hp: 200, dr: 0.7, veh: 0 }; // real:Tyrant Guard
    _p[$ "Venomcrawler"] = { off: 625, ap: 1, splash: 0, ac: 40, hp: 300, dr: 0.6, veh: 1 }; // real:Hellbrute
    _p[$ "Venomthrope"] = { off: 90, ap: 1, splash: 1, ac: 13, hp: 95, dr: 0.85, veh: 0 }; // arch-t1
    _p[$ "Vespid Stingwing"] = { off: 90, ap: 0, splash: 0, ac: 10, hp: 75, dr: 1.0, veh: 0 }; // real:Vespid
    _p[$ "Vindicator"] = { off: 600, ap: 1, splash: 0, ac: 40, hp: 300, dr: 0.65, veh: 1 }; // real:Vindicator
    _p[$ "Vyper"] = { off: 130, ap: 1, splash: 0, ac: 20, hp: 100, dr: 0.8, veh: 1 }; // real:Vyper
    _p[$ "War Walker"] = { off: 600, ap: 1, splash: 3, ac: 30, hp: 200, dr: 0.6, veh: 1 }; // real:Wraithlord
    _p[$ "Warbikers"] = { off: 120, ap: 1, splash: 1, ac: 25, hp: 150, dr: 0.65, veh: 1 }; // arch-veh-t1
    _p[$ "Warlock"] = { off: 150, ap: 1, splash: 0, ac: 10, hp: 80, dr: 0.75, veh: 0 }; // real:Warlock
    _p[$ "Warp Spider"] = { off: 50, ap: 0, splash: 0, ac: 10, hp: 40, dr: 0.9, veh: 0 }; // real:Warp Spider
    _p[$ "Warp Talon"] = { off: 80, ap: 0, splash: 0, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Raptor
    _p[$ "Warpsmith"] = { off: 660, ap: 1, splash: 3, ac: 25, hp: 150, dr: 0.5, veh: 0 }; // real:Warpsmith
    _p[$ "Wave Serpent"] = { off: 245, ap: 1, splash: 0, ac: 30, hp: 200, dr: 0.6, veh: 1 }; // real:Falcon
    _p[$ "Weirdboy"] = { off: 250, ap: 1, splash: 3, ac: 15, hp: 100, dr: 0.75, veh: 0 }; // real:Mekboy
    _p[$ "Windrider"] = { off: 130, ap: 1, splash: 0, ac: 20, hp: 100, dr: 0.8, veh: 1 }; // real:Vyper
    _p[$ "Winged Hive Tyrant"] = { off: 310, ap: 1, splash: 3, ac: 25, hp: 400, dr: 0.5, veh: 0 }; // real:Hive Tyrant
    _p[$ "Wraithblade"] = { off: 80, ap: 1, splash: 0, ac: 25, hp: 125, dr: 0.7, veh: 0 }; // real:Wraithguard
    _p[$ "Wraithguard"] = { off: 80, ap: 1, splash: 0, ac: 25, hp: 125, dr: 0.7, veh: 0 }; // real:Wraithguard
    _p[$ "Wraithknight"] = { off: 1020, ap: 1, splash: 3, ac: 50, hp: 800, dr: 0.4, veh: 1 }; // real:Phantom Titan
    _p[$ "Wraithlord"] = { off: 600, ap: 1, splash: 3, ac: 30, hp: 200, dr: 0.6, veh: 1 }; // real:Wraithlord
    _p[$ "XV104 Riptide"] = { off: 500, ap: 1, splash: 3, ac: 15, hp: 300, dr: 0.65, veh: 0 }; // real:XV8 Commander
    _p[$ "XV25 Stealthsuit"] = { off: 130, ap: 0, splash: 3, ac: 15, hp: 75, dr: 0.85, veh: 0 }; // real:XV25 Stealthsuit
    _p[$ "XV8 Commander"] = { off: 500, ap: 1, splash: 3, ac: 15, hp: 300, dr: 0.65, veh: 0 }; // real:XV8 Commander
    _p[$ "XV8 Crisis"] = { off: 280, ap: 1, splash: 3, ac: 15, hp: 150, dr: 0.75, veh: 0 }; // real:XV8 Crisis
    _p[$ "XV88 Broadside"] = { off: 300, ap: 1, splash: 0, ac: 25, hp: 250, dr: 0.7, veh: 0 }; // real:XV88 Broadside
    _p[$ "XV95 Ghostkeel"] = { off: 280, ap: 1, splash: 3, ac: 15, hp: 150, dr: 0.75, veh: 0 }; // real:XV8 Crisis
    _p[$ "Zephyrim"] = { off: 245, ap: 1, splash: 0, ac: 15, hp: 60, dr: 0.6, veh: 0 }; // real:Seraphim
    _p[$ "Zoanthrope"] = { off: 200, ap: 1, splash: 0, ac: 10, hp: 300, dr: 0.5, veh: 0 }; // real:Zoanthrope
    return _p;
}

/// @function battle_unit_profile
/// @param {String} _label
/// @returns {Struct} combat profile; a weak basic-infantry fallback for any unmapped label.
function battle_unit_profile(_label) {
    var _p = battle_unit_profiles();
    if (variable_struct_exists(_p, _label)) { return _p[$ _label]; }
    return { off: 25, ap: 0, splash: 0, ac: 6, hp: 45, dr: 1, veh: 0 };
}

/// @function battle_volley_damage
/// @description Per-attacking-model damage onto one target, lifted from scr_shoot: effective armour =
///              ac * AP_mult[ap] * max(1,splash) (vehicles use the harsher table), then
///              max(0, off - armour) * dr. AP tier 4 zeroes armour; low AP raises it.
/// @param {Struct} _a  attacker profile
/// @param {Struct} _t  target profile
/// @returns {Real}
function battle_volley_damage(_a, _t) {
    static _inf = [1, 3, 2, 1.5, 0];
    static _veh = [1, 6, 4, 2, 0];
    var _ap = clamp(floor(_a.ap), 0, 4);
    var _tbl = _t.veh ? _veh : _inf;   // GML can't index a parenthesised ternary directly
    var _mult = _tbl[_ap];
    var _armour = _t.ac * _mult * max(1, _a.splash);
    return max(0, _a.off - _armour) * _t.dr;
}

/// @function battle_choose_target
/// @description Target priority: concentrate on the biggest (count*hp) enemy block you can actually
///              damage, preferring a hurtable VEHICLE if any (so anti-armour kills tanks instead of
///              wasting fire on infantry, and small-arms that can't scratch armour hit infantry).
/// @param {Struct} _a   attacker profile
/// @param {Array}  _dst array of {label,count,prof}
/// @returns {Real} index into _dst, or -1 if it can hurt nothing
function battle_choose_target(_a, _dst) {
    var _best = -1, _bestScore = -1, _bestVeh = -1, _bestVehScore = -1;
    for (var i = 0; i < array_length(_dst); i++) {
        var _t = _dst[i];
        if (_t.count <= 0) { continue; }
        if (battle_volley_damage(_a, _t.prof) <= 0) { continue; }
        var _score = _t.count * _t.prof.hp;
        if (_t.prof.veh && _score > _bestVehScore) { _bestVehScore = _score; _bestVeh = i; }
        if (_score > _bestScore) { _bestScore = _score; _best = i; }
    }
    return (_bestVeh >= 0) ? _bestVeh : _best;
}

/// @function battle_build_side
/// @description Turn a roster of {label,count} into fight blocks {label,count,prof}, dropping empties.
function battle_build_side(_roster) {
    var _s = [];
    for (var i = 0; i < array_length(_roster); i++) {
        var _u = _roster[i];
        var _cnt = variable_struct_exists(_u, "count") ? _u.count : 0;
        if (_cnt <= 0) { continue; }
        array_push(_s, { label: _u.label, count: _cnt, prof: battle_unit_profile(_u.label) });
    }
    return _s;
}

function battle_side_hp(_s) {
    var _h = 0;
    for (var i = 0; i < array_length(_s); i++) { _h += _s[i].count * _s[i].prof.hp; }
    return _h;
}

function battle_side_fire(_src, _dst, _acc) {
    var _dmg = array_create(array_length(_dst), 0);
    for (var i = 0; i < array_length(_src); i++) {
        var _u = _src[i];
        if (_u.count <= 0) { continue; }
        var _j = battle_choose_target(_u.prof, _dst);
        if (_j < 0) { continue; }
        _dmg[_j] += _u.count * _acc * battle_volley_damage(_u.prof, _dst[_j].prof);
    }
    return _dmg;
}

function battle_apply(_side, _dmg) {
    for (var i = 0; i < array_length(_side); i++) {
        if (_dmg[i] <= 0) { continue; }
        _side[i].count = max(0, _side[i].count - floor(_dmg[i] / _side[i].prof.hp));
    }
}

function battle_side_counts(_s) {
    var _o = [];
    for (var i = 0; i < array_length(_s); i++) { array_push(_o, { label: _s[i].label, count: _s[i].count }); }
    return _o;
}

/// @function resolve_headless_battle
/// @description Fight two rosters round by round until one side is routed (falls below 15% of its
///              starting wounds) or a 60-round cap. Both sides fire simultaneously each round. Returns
///              the outcome plus surviving counts for strategic writeback and a battle report.
/// @param {Array} _rosterA  attacker, array of {label,count}
/// @param {Array} _rosterB  defender, array of {label,count}
/// @param {Real}  _accA     attacker hit fraction (default 0.6)
/// @param {Real}  _accB     defender hit fraction (default 0.6)
/// @returns {Struct} { winner:"A"|"B"|"draw", rounds, a:[{label,count}], b:[{label,count}], a_loss, b_loss }
function resolve_headless_battle(_rosterA, _rosterB, _accA = 0.6, _accB = 0.6) {
    var _A = battle_build_side(_rosterA);
    var _B = battle_build_side(_rosterB);
    _accA *= random_range(0.9, 1.1);
    _accB *= random_range(0.9, 1.1);
    var _startA = battle_side_hp(_A);
    var _startB = battle_side_hp(_B);
    if (_startA <= 0 || _startB <= 0) {
        return { winner: (_startA > _startB) ? "A" : ((_startB > _startA) ? "B" : "draw"), rounds: 0,
                 a: battle_side_counts(_A), b: battle_side_counts(_B), a_loss: 0, b_loss: 0 };
    }
    var _rout = 0.15, _r = 0;
    repeat (60) {
        _r++;
        if (battle_side_hp(_A) <= _startA * _rout) { break; }
        if (battle_side_hp(_B) <= _startB * _rout) { break; }
        var _dA = battle_side_fire(_A, _B, _accA);
        var _dB = battle_side_fire(_B, _A, _accB);
        battle_apply(_B, _dA);
        battle_apply(_A, _dB);
    }
    var _fA = battle_side_hp(_A);
    var _fB = battle_side_hp(_B);
    return {
        winner: (_fA > _fB) ? "A" : ((_fB > _fA) ? "B" : "draw"), rounds: _r,
        a: battle_side_counts(_A), b: battle_side_counts(_B),
        a_loss: 1 - _fA / _startA, b_loss: 1 - _fB / _startB,
    };
}

// ============================================================================================
//  Strategic integration — resolve an AI planet battle through a REAL fight (replaces the
//  choose(1..6)xscore attrition in scr_enemy_ai_a). See docs/POPULATIONS_FORCE_PLAN.md §16.
// ============================================================================================

/// @function br_faction_is_imperial
function br_faction_is_imperial(_f) {
    return (_f == eFACTION.PLAYER) || (_f == eFACTION.IMPERIUM) || (_f == eFACTION.MECHANICUS) || (_f == eFACTION.INQUISITION) || (_f == eFACTION.ECCLESIARCHY);
}

/// @function br_faction_level_get — a faction's 0-6 planet strength scalar (the p_<race> array).
function br_faction_level_get(_star, _planet, _faction) {
    switch (_faction) {
        case eFACTION.ORK:          return _star.p_orks[_planet];
        case eFACTION.TAU:          return _star.p_tau[_planet];
        case eFACTION.TYRANIDS:     return _star.p_tyranids[_planet];
        case eFACTION.CHAOS:        return _star.p_chaos[_planet];
        case eFACTION.HERETICS:     return _star.p_traitors[_planet];
        case eFACTION.NECRONS:      return _star.p_necrons[_planet];
        case eFACTION.ECCLESIARCHY: return _star.p_sisters[_planet];
        case eFACTION.ELDAR:        return _star.p_eldar[_planet];
        case eFACTION.GENESTEALER:  return _star.p_demons[_planet];
        default:                    return 0;
    }
}

/// @function br_faction_level_set
function br_faction_level_set(_star, _planet, _faction, _lvl) {
    _lvl = clamp(round(_lvl), 0, 6);
    switch (_faction) {
        case eFACTION.ORK:          _star.p_orks[_planet] = _lvl; break;
        case eFACTION.TAU:          _star.p_tau[_planet] = _lvl; break;
        case eFACTION.TYRANIDS:     _star.p_tyranids[_planet] = _lvl; break;
        case eFACTION.CHAOS:        _star.p_chaos[_planet] = _lvl; break;
        case eFACTION.HERETICS:     _star.p_traitors[_planet] = _lvl; break;
        case eFACTION.NECRONS:      _star.p_necrons[_planet] = _lvl; break;
        case eFACTION.ECCLESIARCHY: _star.p_sisters[_planet] = _lvl; break;
        case eFACTION.ELDAR:        _star.p_eldar[_planet] = _lvl; break;
        case eFACTION.GENESTEALER:  _star.p_demons[_planet] = _lvl; break;
    }
}

/// @function br_build_faction_roster
/// @description The roster a faction fields on a world: its ladder composition at its current strength,
///              plus (for an Imperial faction) the world's PDF + Guardsmen garrison pools.
function br_build_faction_roster(_star, _planet, _faction, _with_imperial_garrison) {
    // Population-driven roster (§16b): Orks recruit from their Fungal-Bloom headcount, not a 0-6 level.
    var _roster = planet_faction_composition(_star, _planet, _faction);
    if (_with_imperial_garrison) {
        var _guard = _star.p_guardsmen[_planet];
        var _pdf = _star.p_pdf[_planet];
        if (_guard > 0) { array_push(_roster, { label: "Guardsmen", count: _guard }); }
        if (_pdf > 0)   { array_push(_roster, { label: "PDF", count: _pdf }); }
    }
    return _roster;
}

/// @function br_apply_side_casualties
/// @description Scale a faction's forces on a world down to its survivor fraction (both the 0-6 level
///              and, for an Imperial faction, the PDF/Guardsmen pools).
function br_apply_side_casualties(_star, _planet, _faction, _is_imperial, _surv) {
    _surv = clamp(_surv, 0, 1);
    if (_is_imperial) {
        _star.p_pdf[_planet] = floor(_star.p_pdf[_planet] * _surv);
        _star.p_guardsmen[_planet] = floor(_star.p_guardsmen[_planet] * _surv);
    }
    // Total-war races (Orks/Necrons/Nids) ARE their population — take casualties out of the real
    // p_race_pop headcount (what the display + roster read) and re-derive the legacy 0-6 level. Civ
    // races levy a force from a civilian pool, so their COMBAT losses hit the 0-6 level, not the pop.
    var _pop = planet_race_pop(_star, _planet, _faction);
    if ((faction_is_total_war(_faction) || _faction == eFACTION.HERETICS) && _pop > 0) {
        // Population IS the force (total-war races, and the Heretic corrupted-human host): scale the whole
        // headcount. A beaten heretic host is suppressed but the world's corruption re-feeds it next turn.
        var _newpop = floor(_pop * _surv);
        _star.p_race_pop[_planet][_faction] = _newpop;
        br_faction_level_set(_star, _planet, _faction, count_to_level(_faction, _newpop));
    } else if ((_faction == eFACTION.TAU || _faction == eFACTION.ELDAR) && _pop > 0) {
        // Civ race: only the LEVIED force fights and dies — subtract those losses from the civilian pool
        // (the whole population isn't slaughtered when its levy is beaten). The pop re-levies over time.
        var _lost = floor(_pop * faction_levy_rate(_faction) * (1 - _surv));
        _star.p_race_pop[_planet][_faction] = max(0, _pop - _lost);
    } else {
        var _lvl = faction_planet_level(_star, _planet, _faction);
        if (_lvl > 0) {
            br_faction_level_set(_star, _planet, _faction, _lvl * _surv);
        }
    }
}

// ---- Alliances: who fights on whose side (§16b) --------------------------------------------------
// All Imperial arms fight as ONE side (PDF/Guard, Astartes + progenitors, Sisters, Mechanicus,
// Inquisition); the Chaos trio (Marines + Heretics + Daemons) fight as one; each xeno race stands alone.

/// @function br_side_of_faction — the alliance a faction belongs to.
function br_side_of_faction(_f) {
    if (br_faction_is_imperial(_f)) { return "IMP"; }
    switch (_f) {
        case eFACTION.CHAOS: case eFACTION.HERETICS: case eFACTION.GENESTEALER: return "CHAOS";
        case eFACTION.ORK:      return "ORK";
        case eFACTION.TAU:      return "TAU";
        case eFACTION.NECRONS:  return "NECRON";
        case eFACTION.TYRANIDS: return "NID";
        case eFACTION.ELDAR:    return "ELDAR";
        default:                return "IMP";
    }
}

/// @function br_side_factions — the eFACTION members that make up an alliance.
function br_side_factions(_side) {
    switch (_side) {
        case "IMP":    return [eFACTION.PLAYER, eFACTION.IMPERIUM, eFACTION.MECHANICUS, eFACTION.INQUISITION, eFACTION.ECCLESIARCHY];
        case "CHAOS":  return [eFACTION.CHAOS, eFACTION.HERETICS, eFACTION.GENESTEALER];
        case "ORK":    return [eFACTION.ORK];
        case "TAU":    return [eFACTION.TAU];
        case "NECRON": return [eFACTION.NECRONS];
        case "NID":    return [eFACTION.TYRANIDS];
        case "ELDAR":  return [eFACTION.ELDAR];
        default:       return [];
    }
}

/// @function br_side_representative — the faction that becomes owner when a side takes the world.
function br_side_representative(_side) {
    switch (_side) {
        case "IMP":    return eFACTION.IMPERIUM;
        case "CHAOS":  return eFACTION.CHAOS;
        case "ORK":    return eFACTION.ORK;
        case "TAU":    return eFACTION.TAU;
        case "NECRON": return eFACTION.NECRONS;
        case "NID":    return eFACTION.TYRANIDS;
        case "ELDAR":  return eFACTION.ELDAR;
        default:       return eFACTION.IMPERIUM;
    }
}

/// @function br_side_name — human-readable name of an alliance for battle reports.
function br_side_name(_side) {
    switch (_side) {
        case "IMP":    return "Imperial forces (PDF, Guard, Sisters, Astartes)";
        case "CHAOS":  return "Chaos (Marines, Heretics, Daemons)";
        case "ORK":    return "Orks";
        case "TAU":    return "T'au";
        case "NECRON": return "Necrons";
        case "NID":    return "Tyranids";
        case "ELDAR":  return "Aeldari";
        default:       return "forces";
    }
}

/// @function br_build_side_roster — the combined roster of every faction in an alliance on this world.
///           Imperial side folds in the PDF/Guard garrison AND the player's Astartes garrison.
function br_build_side_roster(_star, _planet, _side) {
    var _roster = [];
    var _facs = br_side_factions(_side);
    for (var i = 0; i < array_length(_facs); i++) {
        var _c = planet_faction_composition(_star, _planet, _facs[i]);
        for (var k = 0; k < array_length(_c); k++) { array_push(_roster, _c[k]); }
    }
    if (_side == "IMP") {
        var _guard = _star.p_guardsmen[_planet];
        var _pdf = _star.p_pdf[_planet];
        if (_guard > 0) { array_push(_roster, { label: "Guardsmen", count: _guard }); }
        if (_pdf > 0)   { array_push(_roster, { label: "PDF", count: _pdf }); }
        // Astartes: the player's Chapter (and progenitors) garrisoned here fight alongside the Imperium.
        var _astartes = 0;
        try {
            var _gar = _star.get_garrison(_planet);
            if (is_struct(_gar) && variable_struct_exists(_gar, "viable_garrison")) { _astartes = _gar.viable_garrison; }
        } catch (_e) { _astartes = 0; }
        if (_astartes > 0) { array_push(_roster, { label: "Space Marine", count: _astartes }); }
    }
    return _roster;
}

/// @function br_side_strength — total headcount an alliance fields (to pick the strongest contester).
function br_side_strength(_star, _planet, _side) {
    var _r = br_build_side_roster(_star, _planet, _side);
    var _t = 0;
    for (var i = 0; i < array_length(_r); i++) { _t += _r[i].count; }
    return _t;
}

/// @function br_apply_alliance_casualties — scale every faction in an alliance (and IMP garrison) to surv.
function br_apply_alliance_casualties(_star, _planet, _side, _surv) {
    _surv = clamp(_surv, 0, 1);
    if (_side == "IMP") {
        _star.p_pdf[_planet] = floor(_star.p_pdf[_planet] * _surv);
        _star.p_guardsmen[_planet] = floor(_star.p_guardsmen[_planet] * _surv);
    }
    var _facs = br_side_factions(_side);
    for (var i = 0; i < array_length(_facs); i++) {
        br_apply_side_casualties(_star, _planet, _facs[i], false, _surv); // pop vs level handled within
    }
}

/// @function br_ork_loot_from_battle
/// @description If the Orks fought a vehicle-equipped foe here, they loot some of its tanks — a % chance
///              each battle, accumulating into p_ork_loot ("no tanks unless the enemy has them present").
///              Orks can never loot more than the foe actually fielded.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {String} _owner_side
/// @param {String} _enemy_side
/// @param {Array} _ownerRoster  pre-battle owner roster
/// @param {Array} _enemyRoster  pre-battle enemy roster
function br_ork_loot_from_battle(_star, _planet, _owner_side, _enemy_side, _ownerRoster, _enemyRoster) {
    if (!variable_instance_exists(_star, "p_ork_loot")) { return; }
    var _ork_owner = (_owner_side == "ORK");
    var _ork_enemy = (_enemy_side == "ORK");
    if (!_ork_owner && !_ork_enemy) { return; }             // no Orks in this fight
    var _victim = _ork_owner ? _enemyRoster : _ownerRoster; // the non-Ork side
    var _veh = 0;
    for (var i = 0; i < array_length(_victim); i++) {
        var _prof = battle_unit_profile(_victim[i].label);
        if (_prof.veh) { _veh += _victim[i].count; }
    }
    if (_veh <= 0) { return; }                              // nothing with tracks to loot
    if (random(1) > 0.35) { return; }                       // 35% chance to loot this battle
    var _loot = round(_veh * random_range(0.05, 0.15));
    if (_loot <= 0) { return; }
    _star.p_ork_loot[_planet] = min(_star.p_ork_loot[_planet] + _loot, _veh); // can't hold more than existed
}

/// @function resolve_ai_planet_battle
/// @description Fight a FREE-FOR-ALL between every alliance present on the world — faction v faction v
///              faction (§16i). Each alliance (all Imperial arms together; the Chaos trio together) fights
///              the COMBINED roster of every OTHER alliance present, using the headless resolver, and its
///              survival is written back to the strategic pools. All survival fractions are computed from
///              the same pre-battle state and applied together, so the melee is order-independent. If the
///              owner alliance is effectively spent, the strongest SURVIVING alliance seizes the world.
///              Replaces the old owner-vs-single-strongest pairing (which let 3rd parties sit battles out).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct|Real}
function resolve_ai_planet_battle(_star, _planet) {
    if (!variable_instance_exists(_star, "p_owner")) { return noone; }
    var _owner = _star.p_owner[_planet];
    var _owner_side = br_side_of_faction(_owner);

    // Gather EVERY alliance actually fielding troops on this world (strength > 0). Snapshot each side's
    // pre-battle roster and headcount once, up front, so the melee doesn't depend on evaluation order.
    var _all = ["IMP", "CHAOS", "ORK", "TAU", "NECRON", "NID", "ELDAR"];
    var _present = [];      // side keys present
    var _rosters = [];      // parallel: pre-battle roster for each present side
    var _strength = [];     // parallel: pre-battle headcount for each present side
    for (var i = 0; i < array_length(_all); i++) {
        var _rost = br_build_side_roster(_star, _planet, _all[i]);
        if (array_length(_rost) == 0) { continue; }
        var _st = 0;
        for (var k = 0; k < array_length(_rost); k++) { _st += _rost[k].count; }
        if (_st <= 0) { continue; }
        array_push(_present, _all[i]);
        array_push(_rosters, _rost);
        array_push(_strength, _st);
    }

    // Need the owner present and at least one other side to have a fight.
    var _owner_idx = -1;
    for (var i = 0; i < array_length(_present); i++) { if (_present[i] == _owner_side) { _owner_idx = i; } }
    if (_owner_idx < 0) { return noone; }                        // undefended owner — handled elsewhere
    if (array_length(_present) < 2) { return noone; }            // nobody contesting

    // The free-for-all: each side fights EVERYONE ELSE at once. Its survival is the loss it takes against
    // the combined roster of all other alliances present (so a faction caught between two big foes bleeds
    // on both fronts). In a 2-way contest this reduces exactly to the old owner-vs-enemy fight.
    var _surv = array_create(array_length(_present), 1);
    for (var s = 0; s < array_length(_present); s++) {
        var _foes = [];
        for (var o = 0; o < array_length(_present); o++) {
            if (o == s) { continue; }
            var _or = _rosters[o];
            for (var k = 0; k < array_length(_or); k++) { array_push(_foes, _or[k]); }
        }
        if (array_length(_foes) == 0) { continue; }
        var _r = resolve_headless_battle(_rosters[s], _foes);
        _surv[s] = clamp(1 - _r.a_loss, 0, 1);
    }

    // Apply the melee's casualties to every side at once (all from the pre-battle snapshot above).
    for (var s = 0; s < array_length(_present); s++) {
        br_apply_alliance_casualties(_star, _planet, _present[s], _surv[s]);
    }
    var _owner_surv = _surv[_owner_idx];

    // Ork looted-wagon attrition, then fresh loot from any vehicle-bearing foe in the melee.
    if (variable_instance_exists(_star, "p_ork_loot")) {
        var _ork_i = -1;
        for (var s = 0; s < array_length(_present); s++) { if (_present[s] == "ORK") { _ork_i = s; } }
        if (_ork_i >= 0) {
            if (_surv[_ork_i] < 1) { _star.p_ork_loot[_planet] = floor(_star.p_ork_loot[_planet] * _surv[_ork_i]); }
            var _victims = [];
            for (var o = 0; o < array_length(_present); o++) {
                if (_present[o] == "ORK") { continue; }
                var _or = _rosters[o];
                for (var k = 0; k < array_length(_or); k++) { array_push(_victims, _or[k]); }
            }
            br_ork_loot_from_battle(_star, _planet, "ORK", "MELEE", _rosters[_ork_i], _victims);
        }
    }

    // Ownership: if the owner alliance is effectively spent, the STRONGEST SURVIVING other alliance
    // (post-melee headcount) seizes the world.
    var _flipped = false;
    if (_owner_surv < 0.15) {
        var _win = "";
        var _win_str = 0;
        for (var s = 0; s < array_length(_present); s++) {
            if (_present[s] == _owner_side) { continue; }
            var _post = _strength[s] * _surv[s];
            if (_post > _win_str) { _win_str = _post; _win = _present[s]; }
        }
        if (_win != "" && _win_str > 0) {
            _star.p_owner[_planet] = br_side_representative(_win);
            // New owner develops the world from scratch (§16c) — revert to the basic tier.
            if (variable_instance_exists(_star, "p_infra_turns")) { _star.p_infra_turns[_planet] = 0; }
            if (_owner_side == "IMP") { _star.p_pdf[_planet] = 0; _star.p_guardsmen[_planet] = 0; }
            var _ofacs = br_side_factions(_owner_side);
            for (var j = 0; j < array_length(_ofacs); j++) {
                br_faction_level_set(_star, _planet, _ofacs[j], 0);
                if (faction_is_total_war(_ofacs[j]) && variable_instance_exists(_star, "p_race_pop")) {
                    _star.p_race_pop[_planet][_ofacs[j]] = 0;   // wiped total-war owner: clear its pop too
                }
            }
            if (_owner_side == "ORK" && variable_instance_exists(_star, "p_ork_loot")) {
                _star.p_ork_loot[_planet] = 0;                  // looted wagons lost with the world
            }
            _flipped = true;
            var _wname = variable_instance_exists(_star, "name") ? string(_star.name) : "a world";
            scr_event_log((_win == "IMP") ? "green" : "red", $"{br_side_name(_win)} have taken {_wname} {scr_roman(_planet)} from {br_side_name(_owner_side)}.");
        }
    }

    // A hard fight can catch the WAAAGH's Warboss — a non-duel death that throws the Ork clans into a
    // succession scramble or civil war (§16f). Only when the world did NOT change hands (a flip clears the
    // Ork pop); fires for the ORK side if it's present and survived, scaled by how badly it was mauled.
    if (!_flipped) {
        var _ork_j = -1;
        for (var s = 0; s < array_length(_present); s++) { if (_present[s] == "ORK") { _ork_j = s; } }
        if (_ork_j >= 0) {
            ork_maybe_behead(_star, _planet, clamp(round((1 - _surv[_ork_j]) * 25), 0, 25), "the fighting");
        }
    }

    return {
        owner: _owner, owner_side: _owner_side, sides: _present, survivals: _surv,
        owner_surv: _owner_surv, flipped: _flipped,
    };
}
