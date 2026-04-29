/// @mixin
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
        "Flash Git"
    ];
    var _gear = {};
    var _company_slot = 0;

    _company_slot = find_company_open_slot(target_company);

    if (_company_slot != -1) {
        scr_wipe_unit(target_company, _company_slot);
        var _unit = fetch_unit([target_company, _company_slot]);
        if (other_gear == true) {
            // TODO: Implement logic for Chapter Servitor, Neophyte, and Serf (Race 1, Scout/Astartes stats)
            // TODO: Implement logic for Mercenary (Race 2, Human stats, Hellgun)
            // TODO: Implement logic for Auxiliary Soldier (Race 2.5, Renegade stats)

            switch (man_role) {
                case "Skitarii":
                    spawn_exp = 10;
                    obj_ini.race[target_company][_company_slot] = 3;
                    _unit = new TTRPG_stats("mechanicus", target_company, _company_slot, "skitarii");
                    break;
                case "Techpriest":
                    spawn_exp = 100;
                    obj_ini.race[target_company][_company_slot] = 3;
                    _unit = new TTRPG_stats("mechanicus", target_company, _company_slot, "tech_priest");
                    break;
                case "Crusader":
                    spawn_exp = 10;
                    obj_ini.race[target_company][_company_slot] = 4;
                    _unit = new TTRPG_stats("inquisition", target_company, _company_slot, "inquisition_crusader");
                    break;
                // TODO: Implement Sanctioned Psyker (Race 4, Psychic powers, Force Staff)
                case "Sister of Battle":
                    spawn_exp = 20;
                    obj_ini.race[target_company][_company_slot] = 5;
                    _unit = new TTRPG_stats("adeptus_sororitas", target_company, _company_slot, "sister_of_battle");
                    break;
                case "Sister Hospitaler":
                    spawn_exp = 50;
                    obj_ini.race[target_company][_company_slot] = 5;
                    _unit = new TTRPG_stats("adeptus_sororitas", target_company, _company_slot, "sister_hospitaler");
                    break;
                // TODO: Implement Prioress (Race 5, Sororitas leader gear/stats)
                case "Ranger":
                    spawn_exp = 180;
                    obj_ini.race[target_company][_company_slot] = 6;
                    _unit = new TTRPG_stats("Eldari", target_company, _company_slot, "eldar_ranger");
                    break;
                case "Ork Sniper":
                    spawn_exp = 20;
                    obj_ini.race[target_company][_company_slot] = eFACTION.ORK;
                    _unit = new TTRPG_stats("ork", target_company, _company_slot, "ork_Sniper");
                    break;
                case "Flash Git":
                    spawn_exp = 40;
                    obj_ini.race[target_company][_company_slot] = eFACTION.ORK;
                    _unit = new TTRPG_stats("ork", target_company, _company_slot, "flash_git");
                    break;
                // TODO: Implement Warboss (Race 7)
                // TODO: Implement Fire Warrior (Race 8, T'au gear/stats)
                // TODO: Implement Chaos Cultist (Race 10, Autogun)
                // TODO: Implement Chaos Champion (Race 11, CSM stats)
                // TODO: Implement Chaos Spawn (Race 12, Possessed Claws)
            }
        }

        obj_ini.age[target_company][_company_slot] = (obj_controller.millenium * 1000) + obj_controller.year;

        switch (spawn_name) {
            case "":
            case "imperial":
                obj_ini.name[target_company][_company_slot] = global.name_generator.ChapterMemberNameGeneration();
                break;
            default:
                obj_ini.name[target_company][_company_slot] = spawn_name;
                break;
        }
        switch (man_role) {
            case "Ranger":
                obj_ini.name[target_company][_company_slot] = global.name_generator.GenerateMultiSyllable("eldar", 2);
                break;
                
            case "Ork Sniper":
            case "Flash Git":
                obj_ini.name[target_company][_company_slot] = global.name_generator.GenerateComposite("ork", false);
                break;
                
            case "Sister of Battle":
            case "Sister Hospitaler":
                obj_ini.name[target_company][_company_slot] = global.name_generator.GenerateFromSet("imperial_female");
                break;
        }

        if (!array_contains(non_marine_roles, man_role)) {
            obj_ini.race[target_company][_company_slot] = eFACTION.PLAYER;
            if (man_role == obj_ini.role[100][12]) {
                _gear = {
                    wep2: obj_ini.wep2[100][12],
                    wep1: obj_ini.wep1[100][12],
                    armour: obj_ini.armour[100][12],
                    gear: obj_ini.gear[100][12],
                    mobi: obj_ini.mobi[100][12],
                };
            }

            _unit = new TTRPG_stats("chapter", target_company, _company_slot, "scout", other_data);
            _unit.corruption = corruption;
            _unit.roll_age();
            _unit.alter_equipment(_gear);
            marines += 1;
        }
        obj_ini.TTRPG[target_company][_company_slot] = _unit;
        _unit.add_exp(spawn_exp);
        _unit.allocate_unit_to_fresh_spawn(home_spot);
        _unit.update_role(man_role);
        with (obj_ini) {
            scr_company_order(target_company);
        }
        _unit.update_health(_unit.max_health());
        return _unit;
    }
}
