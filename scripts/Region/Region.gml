/// @function Region
/// @description Plain-data record for a single region of a planet.
///              Regions are stored per planet in obj_star.p_regions[planet] and persist
///              automatically through the generic p_* save/load path (see obj_star Create).
///              IMPORTANT: keep this a DATA record. On load, saved regions come back as plain
///              structs WITHOUT constructor methods, so all region behaviour lives in
///              scr_region_functions and reads/writes these fields directly. Do not rely on
///              instanceof/methods for regions elsewhere.
/// @param {String} _name Region display name.
/// @param {Bool} _is_capital Whether this is the planetary capital region.
/// @param {Enum.eFACTION} _owner Controlling faction of this region.
/// @returns {Struct.Region}
function Region(_name = "Region", _is_capital = false, _owner = eFACTION.IMPERIUM) constructor {
    name = _name;
    is_capital = _is_capital;

    // Ownership. Contested worlds arise when regions of the same planet have different owners.
    owner = _owner;
    first_owner = _owner;

    // Demographics (share of the planet total; see regions_generate / regions_rollup).
    population = 0;
    max_population = 0;

    // Garrison this region can field.
    pdf = 0;
    guardsmen = 0;

    // 0-5 "problem" strength for non-Imperial owners (orks/tau/nids/etc.), mirroring the
    // per-faction planet arrays (p_orks, p_tau, ...).
    force_level = 0;

    // STEP 1 of the "planets within a planet" rework: a region now OWNS its slice of the
    // planet's force as a stored, mutable weight rather than the split being recomputed live
    // every draw. Seeded at worldgen from faction_deployment_weight (the owner's garrison
    // doctrine). region_faction_share reads this, so a region's forces can later be depleted
    // independently (clear one region without touching the others) and troops can be unloaded
    // into a specific region. -1 = unseeded (old save) -> seeded on first access.
    force_weight = -1;

    // STEP 2 of the "planets within a planet" rework: the PLAYER'S own force stationed in THIS
    // region (a foothold headcount), the mirror of the enemy garrison. Troops unloaded via a won
    // Hold Ground assault land in the region that was targeted, so the player can hold and fight
    // for specific regions rather than a single planet-wide blob. p_player[planet] is kept as the
    // SUM of these per-region forces so the rest of the game (contest, enemy AI, auto-battle)
    // keeps working unchanged. Defaults to 0; old saves simply start with no per-region record.
    player_force = 0;

    // STEP 3 (regional combat): the enemy garrison actually STATIONED in this region, stored and
    // depletable, so clearing a region reduces IT rather than the split recomputing from the planet
    // pool (which read as instant reinforcement). -1 = unseeded (old save / not yet initialised) ->
    // seeded on first access from the live region_garrison. reinforce_cooldown gates cross-region
    // reinforcement to ONE HOP PER TURN: a region that received (or sent) reinforcements this turn
    // waits a turn before moving force again, so the enemy cannot instantly rebalance the planet.
    enemy_force = -1;
    reinforce_cooldown = 0;

    // Defensive depth. fortification 0-5 (walls/bunkers), defences = ground turret batteries.
    fortification = 0;
    defences = 0;

    // Adjacency graph: indices of the regions this one borders (a real map, not just the
    // capital-inward line). Built at worldgen (see regions_build_adjacency) as a hub-and-ring:
    // the capital borders every outlying region, and outlying regions form a ring among
    // themselves, so there are multiple fronts and flanking routes. Drives which regions can
    // be assaulted from a held region (region_can_assault_index). Guarded for old saves.
    neighbors = [];

    // Dig-In tracking: how many consecutive turns the CURRENT owner has held this region
    // without it changing hands. After DIG_IN_TURNS turns held, the occupier entrenches
    // (+1 fortification, capped at DIG_IN_FORT_CAP), representing field works and light
    // cover thrown up by a force that has had time to consolidate. Reset to the new owner
    // with the counter at 0 whenever the region changes hands. See regions_dig_in_tick.
    hold_owner = _owner;
    hold_turns = 0;

    // Buildings/upgrades constructed in this region (array of eP_FEATURES values).
    upgrades = [];

    // Player-constructed region buildings (Sector Governor building tree). Array of string ids
    // from region_building_catalogue (see scr_region_functions). Separate from `upgrades` so it
    // never mixes with the eP_FEATURES machinery. Persists as part of this struct in p_regions.
    buildings = [];

    // Whether the current occupier has worked out how to fire a captured Anti-Orbital Gun here.
    // Only Genestealer Cults ever set this; it is cleared when the region leaves cult hands.
    gun_mastered = false;

    // Construction License (Sector Governor): when true, the player may build the full
    // region building set here even though they do NOT own the region yet, at the normal
    // disposition-discounted price. Bought per region from the population screen (500 req,
    // outlying regions only). A partial game-starter: raise a factory or barracks on a
    // world before you have conquered it. Persists as part of this struct in p_regions.
    build_licensed = false;
}
