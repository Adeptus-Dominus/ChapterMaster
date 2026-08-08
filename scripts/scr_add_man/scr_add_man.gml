/// @self Asset.GMObject.obj_controller
function scr_add_man(man_role, target_company, spawn_exp, spawn_name, corruption, other_gear, home_spot, other_data = {}) {
    // TODO: Refactor into TTRPG_stats methods; current struct migration is ongoing.

    var non_marine_roles = [
        "Skitarii",
        "Techpriest",
        "Crusader",
        "Sister of Battle",
        "Sister Hospitaler",
        "Ranger",
        "Ork Sniper",
        "Flash Git",
    ];
    var _gear = {};

    var _company_slot = find_company_open_slot(target_company);

    scr_wipe_unit(target_company, _company_slot);
    var _unit = fetch_unit([target_company, _company_slot]);
    if (other_gear == true) {
        // TODO: Implement logic for Chapter Servitor, Neophyte, and Serf (Race 1, Scout/Astartes stats)
        // TODO: Implement logic for Mercenary (Race 2, Human stats, Hellgun)
        // TODO: Implement logic for Auxiliary Soldier (Race 2.5, Renegade stats)

        switch (man_role) {
            case "Skitarii":
                spawn_exp = 10;
                _unit = new TTRPG_stats("mechanicus", target_company, _company_slot, "skitarii");
                break;
            case "Techpriest":
                spawn_exp = 100;
                _unit = new TTRPG_stats("mechanicus", target_company, _company_slot, "tech_priest");
                break;
            case "Crusader":
                spawn_exp = 10;
                _unit = new TTRPG_stats("inquisition", target_company, _company_slot, "inquisition_crusader");
                break;
            // TODO: Implement Sanctioned Psyker (Race 4, Psychic powers, Force Staff)
            case "Sister of Battle":
                spawn_exp = 20;
                _unit = new TTRPG_stats("adeptus_sororitas", target_company, _company_slot, "sister_of_battle");
                break;
            case "Sister Hospitaler":
                spawn_exp = 50;
                _unit = new TTRPG_stats("adeptus_sororitas", target_company, _company_slot, "sister_hospitaler");
                break;
            // TODO: Implement Prioress (Race 5, Sororitas leader gear/stats)
            case "Ranger":
                spawn_exp = 180;
                _unit = new TTRPG_stats("Eldari", target_company, _company_slot, "eldar_ranger");
                break;
            case "Ork Sniper":
                spawn_exp = 20;
                _unit = new TTRPG_stats("ork", target_company, _company_slot, "ork_sniper");
                break;
            case "Flash Git":
                spawn_exp = 40;
                _unit = new TTRPG_stats("ork", target_company, _company_slot, "flash_git");
                break;
            // TODO: Implement Warboss (Race 7)
            // TODO: Implement Fire Warrior (Race 8, T'au gear/stats)
            // TODO: Implement Chaos Cultist (Race 10, Autogun)
            // TODO: Implement Chaos Champion (Race 11, CSM stats)
            // TODO: Implement Chaos Spawn (Race 12, Possessed Claws)
        }
    }
    var _name = "";
    switch (spawn_name) {
        case "":
        case "imperial":
            _name = global.name_generator.ChapterMemberNameGeneration();
            break;
        default:
            _name = spawn_name;
            break;
    }
    switch (man_role) {
        case "Ranger":
            _name = global.name_generator.GenerateMultiSyllable("eldar", 2);
            break;

        case "Ork Sniper":
        case "Flash Git":
            _name = global.name_generator.GenerateComposite("ork", false);
            break;

        case "Sister of Battle":
        case "Sister Hospitaler":
            _name = global.name_generator.GenerateFromSet("imperial_female");
            break;
    }

    if (!array_contains(non_marine_roles, man_role)) {
        if (man_role == obj_ini.player_role_data[eROLE.SCOUT].role) {
            _gear = obj_ini.player_role_data[eROLE.SCOUT];
        }

        _unit = new TTRPG_stats("chapter", target_company, _company_slot, "scout", other_data);
        _unit.corruption = corruption;
        _unit.roll_age();
        _unit.alter_equipment(_gear);
        marines += 1;
    }
    obj_ini.TTRPG[target_company][_company_slot] = _unit;
    _unit.set_name(_name);
    _unit.add_exp(spawn_exp);
    _unit.allocate_unit_to_fresh_spawn(home_spot);
    _unit.update_role(man_role);
    if (array_contains(non_marine_roles, man_role)) {
        _unit.born = obj_ini.sector_handler.get_creation_year(18);
    }

    with (obj_ini) {
        scr_company_order(target_company);
    }
    _unit.update_health(_unit.max_health());
    return _unit;
}
