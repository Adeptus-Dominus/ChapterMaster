// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_save_controller(save_id){
    log_message($"Saving to slot {save_id} - Part 1");
    ini_open($"save{save_id}.ini");


    // Global variables
    ini_write_string("Save","chapter_name",global.chapter_name);
    ini_write_string("Save","sector_name",obj_ini.sector_name);
    ini_write_string("Save","version",global.game_version);
    ini_write_real("Save","play_time",play_time);
    ini_write_real("Save","game_seed",global.game_seed);
    ini_write_real("Save","use_custom_icon",obj_ini.use_custom_icon);

   
    // obj_controller variables here
    ini_write_real("boolean", "cheat_req", global.cheat_req);
    ini_write_real("boolean", "cheat_gene", global.cheat_gene);
    ini_write_real("boolean", "cheat_debug", global.cheat_debug);
    ini_write_real("boolean", "cheat_disp", global.cheat_disp);
    ini_write_real("Controller","cheatyface",obj_controller.cheatyface);
    ini_write_real("Controller","x",obj_controller.x);
    ini_write_real("Controller","y",obj_controller.y);
    ini_write_real("Controller","alll",obj_controller.alll);
    ini_write_real("Controller","zoomed",obj_controller.zoomed);
    ini_write_real("Controller","chaos_rating",obj_controller.chaos_rating);
    ini_write_string("Controller","fleet_type",obj_controller.fleet_type);
    ini_write_real("Controller","ifleet_type",obj_ini.fleet_type);
    ini_write_real("Controller","home_rule",obj_controller.homeworld_rule);
    ini_write_string("Controller","star_names",obj_controller.star_names);
    ini_write_real("Controller","craworld",obj_controller.craftworld);
    ini_write_real("Controller","turn",obj_controller.turn);
    ini_write_real("Controller","last_event",obj_controller.last_event);
    ini_write_real("Controller","last_mission",obj_controller.last_mission);
    ini_write_real("Controller","last_world_inspection",obj_controller.last_world_inspection);
    ini_write_real("Controller","last_fleet_inspection",obj_controller.last_fleet_inspection);
    ini_write_real("Controller","chaos_turn",obj_controller.chaos_turn);
    ini_write_real("Controller","chaos_fleets",obj_controller.chaos_fleets);
    ini_write_real("Controller","tau_fleets",obj_controller.tau_fleets);
    ini_write_real("Controller","tau_stars",obj_controller.tau_stars);
    ini_write_real("Controller","tau_messenger",obj_controller.tau_messenger);
    ini_write_real("Controller","fleet_all",obj_controller.fleet_all);
    // ini_write_real("Controller","tolerant",obj_ini.tolerant);
    ini_write_real("Controller","stability",obj_ini.stability);
    ini_write_real("Controller","purity",obj_ini.purity);
    ini_write_real("Controller","unload",obj_controller.unload);
    ini_write_real("Controller","diplomacy",obj_controller.diplomacy);
    ini_write_real("Controller","trading",obj_controller.trading);
    ini_write_real("Controller","audience",obj_controller.audience);
    ini_write_real("Controller","force_goodbye",obj_controller.force_goodbye);
    ini_write_real("Controller","combat",obj_controller.combat);
    ini_write_real("Controller","new_vehicles",obj_controller.new_vehicles);
    ini_write_real("Controller","hurssy",obj_controller.hurssy);
    ini_write_real("Controller","hurssy_time",obj_controller.hurssy_time);
    ini_write_real("Controller","artifacts",obj_controller.artifacts);
    ini_write_real("Controller","pmc",obj_controller.popup_master_crafted);
    ini_write_real("Controller","wndsel",obj_controller.select_wounded);
    ini_write_real("Controller","imdis",obj_ini.imperium_disposition);
    ini_write_real("Controller","terra_dir",obj_controller.terra_direction);

    ini_write_real("Controller","stc_wargear",obj_controller.stc_wargear);
    ini_write_real("Controller","stc_vehicles",obj_controller.stc_vehicles);
    ini_write_real("Controller","stc_ships",obj_controller.stc_ships);
    ini_write_real("Controller","stc_un_total",obj_controller.stc_un_total);
    ini_write_real("Controller","stc_wargear_un",obj_controller.stc_wargear_un);
    ini_write_real("Controller","stc_vehicles_un",obj_controller.stc_vehicles_un);
    ini_write_real("Controller","stc_ships_un",obj_controller.stc_ships_un);

    ini_encode_and_json("Controller","stc_bonus", obj_controller.stc_bonus)

    ini_encode_and_json("Controller","adv", obj_ini.adv);
    ini_encode_and_json("Controller","dis", obj_ini.dis);

    // Player scheduled event
    if (obj_controller.fest_type!=""){
        ini_write_real("Controller","f_si",obj_controller.fest_sid);
        ini_write_real("Controller","f_wi",obj_controller.fest_wid);
        ini_write_real("Controller","f_pl",obj_controller.fest_planet);
        ini_write_string("Controller","f_st",obj_controller.fest_star);
        ini_write_string("Controller","f_t",obj_controller.fest_type);
        ini_write_real("Controller","f_co",obj_controller.fest_cost);
        ini_write_real("Controller","f_wa",obj_controller.fest_warp);
        ini_write_real("Controller","f_sch",obj_controller.fest_scheduled);
        ini_write_real("Controller","f_la",obj_controller.fest_lav);
        ini_write_real("Controller","f_lo",obj_controller.fest_locals);
        ini_write_real("Controller","f_f1",obj_controller.fest_feature1);
        ini_write_real("Controller","f_f2",obj_controller.fest_feature2);
        ini_write_real("Controller","f_f3",obj_controller.fest_feature3);
        ini_write_real("Controller","f_di",obj_controller.fest_display);
        ini_write_string("Controller","f_dit",obj_controller.fest_display_tags);
        ini_write_real("Controller","f_re",obj_controller.fest_repeats);
        ini_write_real("Controller","f_hc",obj_controller.fest_honor_co);
        ini_write_real("Controller","f_hi",obj_controller.fest_honor_id);
        ini_write_real("Controller","f_hon",obj_controller.fest_honoring);
    }
    
    ini_write_real("Controller","f_fee",obj_controller.fest_feasts);
    ini_write_real("Controller","f_boo",obj_controller.fest_boozes);
    ini_write_real("Controller","f_dru",obj_controller.fest_drugses);
    ini_write_real("Controller","rech",obj_controller.recent_happenings);

    ini_encode_and_json("Controller","rect",obj_controller.recent_type);
    ini_encode_and_json("Controller","reck",obj_controller.recent_keyword);
    ini_encode_and_json("Controller","recu",obj_controller.recent_turn);
    ini_encode_and_json("Controller","recn",obj_controller.recent_number);

    ini_write_real("Formation","last_attack",obj_controller.last_attack_form);
    ini_write_real("Formation","last_raid",obj_controller.last_raid_form);
    j=0;

    ini_encode_and_json("Formation", "form",obj_controller.bat_formation);
    ini_encode_and_json("Formation", "form_type",obj_controller.bat_formation_type);
    ini_encode_and_json("Formation", "deva",obj_controller.bat_deva_for);
    ini_encode_and_json("Formation", "assa",obj_controller.bat_assa_for);
    ini_encode_and_json("Formation", "tact",obj_controller.bat_tact_for);
    ini_encode_and_json("Formation", "vete",obj_controller.bat_vete_for);
    ini_encode_and_json("Formation", "hire",obj_controller.bat_hire_for);
    ini_encode_and_json("Formation", "libr",obj_controller.bat_libr_for);
    ini_encode_and_json("Formation", "comm",obj_controller.bat_comm_for);
    ini_encode_and_json("Formation", "tech",obj_controller.bat_tech_for);
    ini_encode_and_json("Formation", "term",obj_controller.bat_term_for);
    ini_encode_and_json("Formation", "hono",obj_controller.bat_hono_for);
    ini_encode_and_json("Formation", "drea",obj_controller.bat_drea_for);
    ini_encode_and_json("Formation", "rhin",obj_controller.bat_rhin_for);
    ini_encode_and_json("Formation", "pred",obj_controller.bat_pred_for);
    ini_encode_and_json("Formation", "landraid",obj_controller.bat_landraid_for);
    ini_encode_and_json("Formation", "landspee",obj_controller.bat_landspee_for);
    ini_encode_and_json("Formation", "whirl",obj_controller.bat_whirl_for);
    ini_encode_and_json("Formation", "scou",obj_controller.bat_scou_for);


    ini_write_string("Controller","random_event_next",obj_controller.random_event_next);

    ini_write_string("Controller","useful_info",obj_controller.useful_info);
	ini_write_real("Controller","random_event_next",obj_controller.random_event_next);
	ini_write_real("Controller","gene_sold",obj_controller.gene_sold);		
    ini_write_real("Controller","gene_xeno",obj_controller.gene_xeno);
    ini_write_real("Controller","gene_tithe",obj_controller.gene_tithe);
    ini_write_real("Controller","gene_iou",obj_controller.gene_iou);

    ini_write_real("Controller","und_armouries",obj_controller.und_armouries);
    ini_write_real("Controller","und_gene_vaults",obj_controller.und_gene_vaults);
    ini_write_real("Controller","und_lairs",obj_controller.und_lairs);

    //
    ini_write_real("Controller","penitent",obj_controller.penitent);
    ini_write_real("Controller","penitent_current",obj_controller.penitent_current);
    ini_write_real("Controller","penitent_max",obj_controller.penitent_max);
    ini_write_real("Controller","penitent_turnly",obj_controller.penitent_turnly);
    ini_write_real("Controller","penitent_turn",obj_controller.penitent_turn);
    ini_write_real("Controller","penitent_end",obj_controller.penitent_end);
    ini_write_real("Controller","penitent_blood",obj_controller.blood_debt);
    //
    ini_write_real("Controller","tagged_training",obj_controller.tagged_training);
    ini_write_real("Controller","training_apothecary",obj_controller.training_apothecary);
    ini_write_real("Controller","apothecary_recruit_points",obj_controller.apothecary_recruit_points);
    ini_write_real("Controller","apothecary_aspirant",obj_controller.apothecary_aspirant);
    ini_write_real("Controller","training_chaplain",obj_controller.training_chaplain);
    ini_write_real("Controller","chaplain_points",obj_controller.chaplain_points);
    ini_write_real("Controller","chaplain_aspirant",obj_controller.chaplain_aspirant);
    ini_write_real("Controller","training_psyker",obj_controller.training_psyker);
    ini_write_real("Controller","psyker_points",obj_controller.psyker_points);
    ini_write_real("Controller","psyker_aspirant",obj_controller.psyker_aspirant);
    ini_write_real("Controller","training_techmarine",obj_controller.training_techmarine);
    ini_encode_and_json("Controller", "spec_train",obj_controller.spec_train_data);

    ini_write_real("Controller","tech_points",obj_controller.tech_points);
    ini_write_real("Controller","tech_aspirant",obj_controller.tech_aspirant);

    ini_write_real("Controller","penitorium",obj_controller.penitorium);

    ini_write_string("Controller","recruiting_worlds",obj_controller.recruiting_worlds);
    ini_write_real("Controller","recruiting",obj_controller.recruiting);
    ini_write_real("Controller","trial",obj_controller.recruit_trial);
    ini_write_real("Controller","recruits",obj_controller.recruits);
    ini_write_real("Controller","recruit_last",obj_controller.recruit_last);
    //
    var g=-1;
    repeat(30){g+=1;
        ini_write_real("Controller","command"+string(g),obj_controller.command_set[g]);
    }
    ini_write_real("Controller","modest_livery",obj_controller.modest_livery);
    ini_write_real("Controller","progenitor_visuals",obj_controller.progenitor_visuals);

    ini_encode_and_json("Recruit", "data",{
    	names :obj_controller.recruit_name,
    	corruption :obj_controller.recruit_corruption,
    	distance :obj_controller.recruit_distance,
    	experience :obj_controller.recruit_exp,
    	training :obj_controller.recruit_training,
    	data : obj_controller.recruit_data

    });
   	ini_encode_and_json("Controller","lyl",obj_controller.loyal);
    ini_encode_and_json("Controller","lyl_nm",obj_controller.loyal_num);
    ini_encode_and_json("Controller","lyl_tm",obj_controller.loyal_time);


   	ini_encode_and_json("Controller","inq",obj_controller.inquisitor);
    ini_encode_and_json("Controller","inq_ge",obj_controller.inquisitor_gender);
    ini_encode_and_json("Controller","inq_ty",obj_controller.inquisitor_type);

    //
    g=-1;
    repeat(14){g+=1;
        ini_write_string("Factions","fac"+string(g),obj_controller.faction[g]);
        ini_write_real("Factions","dis"+string(g),obj_controller.disposition[g]);
        ini_write_real("Factions","dis_max"+string(g),obj_controller.disposition_max[g]);

        ini_write_string("Factions","lead"+string(g),obj_controller.faction_leader[g]);
        ini_write_real("Factions","gen"+string(g),obj_controller.faction_gender[g]);
        ini_write_string("Factions","title"+string(g),obj_controller.faction_title[g]);
        ini_write_string("Factions","status"+string(g),obj_controller.faction_status[g]);
        ini_write_real("Factions","defeated"+string(g),obj_controller.faction_defeated[g]);
        ini_write_real("Factions","known"+string(g),known[g]);

        ini_write_real("Factions","annoyed"+string(g),obj_controller.annoyed[g]);
        ini_write_real("Factions","ignore"+string(g),obj_controller.ignore[g]);
        ini_write_real("Factions","turns_ignored"+string(g),obj_controller.turns_ignored[g]);

        ini_write_real("Factions","audience"+string(g),obj_controller.audien[g]);
        ini_write_string("Factions","audience_topic"+string(g),obj_controller.audien_topic[g]);
    }
    //
    var g;g=0;
    repeat(50){g+=1;
        ini_write_string("Ongoing","quest"+string(g),obj_controller.quest[g]);
        ini_write_real("Ongoing","quest_faction"+string(g),obj_controller.quest_faction[g]);
        ini_write_real("Ongoing","quest_end"+string(g),obj_controller.quest_end[g]);
    }
    var g;g=0;
    repeat(99){g+=1;
        ini_write_string("Ongoing","event"+string(g),obj_controller.event[g]);
        ini_write_real("Ongoing","event_duration"+string(g),obj_controller.event_duration[g]);
    }
    //
    ini_write_real("Controller","justmet",obj_controller.faction_justmet);
    ini_write_real("Controller","check_number",obj_controller.check_number);
    ini_write_real("Controller","year_fraction",obj_controller.year_fraction);
    ini_write_real("Controller","year",obj_controller.year);
    ini_write_real("Controller","millenium",obj_controller.millenium);
    //
    ini_write_real("Controller","req",obj_controller.requisition);
    ini_write_string("Controller","tech_status",obj_controller.tech_status);
    //
    ini_write_real("Controller","income",obj_controller.income);
    ini_write_real("Controller","income_last",obj_controller.income_last);
    ini_write_real("Controller","income_base",obj_controller.income_base);
    ini_write_real("Controller","income_home",obj_controller.income_home);
    ini_write_real("Controller","income_forge",obj_controller.income_forge);
    ini_write_real("Controller","income_agri",obj_controller.income_agri);
    ini_write_real("Controller","income_training",obj_controller.income_training);
    ini_write_real("Controller","income_fleet",obj_controller.income_fleet);
    ini_write_real("Controller","income_trade",obj_controller.income_trade);
    ini_write_real("Controller","loyalty",obj_controller.loyalty);
    ini_write_real("Controller","loyalty_hidden",obj_controller.loyalty_hidden);
        ini_write_real("Controller","flag_lair",obj_controller.inqis_flag_lair);
        ini_write_real("Controller","flag_gene",obj_controller.inqis_flag_gene);


    ini_write_real("Controller","gene_seed",obj_controller.gene_seed);
    ini_write_real("Controller","marines",obj_controller.marines);
    ini_write_real("Controller","command",obj_controller.command);
    ini_write_real("Controller","info_chips",obj_controller.info_chips);
    ini_write_real("Controller","inspection_passes",obj_controller.inspection_passes);
    ini_write_real("Controller","recruiting_worlds_bought",obj_controller.recruiting_worlds_bought);
    ini_write_real("Controller","lwt",obj_controller.last_weapons_tab);

    ini_write_real("Controller","bat_devastator_column",obj_controller.bat_devastator_column);
    ini_write_real("Controller","bat_assault_column",obj_controller.bat_assault_column);
    ini_write_real("Controller","bat_tactical_column",obj_controller.bat_tactical_column);
    ini_write_real("Controller","bat_veteran_column",obj_controller.bat_veteran_column);
    ini_write_real("Controller","bat_hire_column",obj_controller.bat_hire_column);
    ini_write_real("Controller","bat_librarian_column",obj_controller.bat_librarian_column);
    ini_write_real("Controller","bat_command_column",obj_controller.bat_command_column);
    ini_write_real("Controller","bat_techmarine_column",obj_controller.bat_techmarine_column);
    ini_write_real("Controller","bat_terminator_column",obj_controller.bat_terminator_column);
    ini_write_real("Controller","bat_honor_column",obj_controller.bat_honor_column);
    ini_write_real("Controller","bat_dreadnought_column",obj_controller.bat_dreadnought_column);
    ini_write_real("Controller","bat_rhino_column",obj_controller.bat_rhino_column);
    ini_write_real("Controller","bat_predator_column",obj_controller.bat_predator_column);
    ini_write_real("Controller","bat_landraider_column",obj_controller.bat_landraider_column);
    ini_write_real("Controller","bat_scout_column",obj_controller.bat_scout_column);

    ini_close();
}



