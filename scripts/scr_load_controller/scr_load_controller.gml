// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function default_bat_formation(){
    if (bat_formation[1]=="" && obj_controller.bat_formation_type[1]==0){

    	obj_controller.bat_formation[1]="Attack";
    	obj_controller.bat_formation_type[1]=1;

    	obj_controller.bat_formation[2]="Defend";
    	obj_controller.bat_formation_type[2]=1;

    	obj_controller.bat_formation[3]="Raid";
    	obj_controller.bat_formation_type[3]=2;

    }	
}

function scr_load_controller(save_id){
		var rang=0,i=0,g=0,stars=0,pfleets=0,efleets=0;
		log_message("Loading slot "+string(save_id));
		var save_file_name = $"save{save_id}.ini";

		if(file_exists("tsave.ini"))
		{
			// file_copy() will fail if destination file already exists
			file_delete("tsave.ini");
		}

		if(file_exists(save_file_name))
		{
	    	file_copy(save_file_name,"tsave.ini");
		}
		else
		{
			log_error("Could not load save game " + save_file_name + ", file does not exist.");
			game_restart();
		}

	    ini_open("tsave.ini");

	    // Global variables
	    global.chapter_name=ini_read_string("Save","chapter_name","Error"); //
	    obj_ini.sector_name=ini_read_string("Save","sector_name","Error"); //

		// TODO make it either throw error (if version is wrong) or try to upgrade the saved game data and version
	    global.save_version=ini_read_string("Save","version",0);
	    global.game_seed=ini_read_real("Save","game_seed",0);

	    obj_controller.play_time=ini_read_real("Save","play_time",0);

	    obj_ini.progenitor=ini_read_real("Save","founding",ePROGENITOR.NONE);
	    // global.founding_secret=ini_read_string("Save","founding_secret","Error");
	    global.custom=ini_read_real("Save","custom",1);
	    stars=ini_read_real("Save","stars",0);
	    // pfleets=ini_read_real("Save","p_fleets",0);
	    // efleets=ini_read_real("Save","en_fleets",0);
	    g=ini_read_real("Save","sod",0);
	    random_set_seed(g);g=0;
	    var corrupt;corrupt=1;
	    corrupt=ini_read_real("Save","corrupt",1);

	    if (corrupt=1){
	        game_restart();
	    }

	    // obj_controller variables here
	    obj_controller.load_game=save_id;
	    global.cheat_req = ini_read_real("boolean", "cheat_req", 0);
	    global.cheat_gene = ini_read_real("boolean", "cheat_gene", 0);
	    global.cheat_debug = ini_read_real("boolean", "cheat_debug", 0);
	    global.cheat_disp = ini_read_real("boolean", "cheat_disp", 0);
	    obj_controller.cheatyface=ini_read_real("Controller","cheatyface",0);
	    obj_controller.x=ini_read_real("Controller","x",obj_controller.x);
	    obj_controller.y=ini_read_real("Controller","y",obj_controller.y);
	    obj_controller.zoomed=ini_read_real("Controller","zoomed",0);
	    obj_controller.chaos_rating=ini_read_real("Controller","chaos_rating",0);
	    obj_controller.fleet_type=ini_read_string("Controller","fleet_type",""); //
	    obj_ini.fleet_type=round(ini_read_real("Controller","ifleet_type",0));
	    obj_controller.homeworld_rule=ini_read_real("Controller","home_rule",1);

	    obj_controller.star_names=ini_read_string("Controller","star_names","Error"); //
	    obj_controller.craftworld=ini_read_real("Controller","craftworld",0);

	    obj_controller.turn=ini_read_real("Controller","turn",0);
	    obj_controller.last_event=ini_read_real("Controller","last_event",0);
	    obj_controller.last_mission=ini_read_real("Controller","last_mission",0);
	    obj_controller.last_world_inspection=ini_read_real("Controller","last_world_inspection",0);
	    obj_controller.last_fleet_inspection=ini_read_real("Controller","last_fleet_inspection",0);
	    obj_controller.chaos_turn=ini_read_real("Controller","chaos_turn",0);
	    obj_controller.chaos_fleets=ini_read_real("Controller","chaos_fleets",0);
	    obj_controller.tau_fleets=ini_read_real("Controller","tau_fleets",0);
	    obj_controller.tau_stars=ini_read_real("Controller","tau_stars",0);
	    obj_controller.tau_messenger=ini_read_real("Controller","tau_messenger",0);
	    obj_controller.fleet_all=ini_read_real("Controller","fleet_all",0);
	    // obj_ini.tolerant=ini_read_real("Controller","tolerant",0);
	    obj_ini.stability=ini_read_real("Controller","stability",90);
	    obj_ini.purity=ini_read_real("Controller","purity",5);
	    // obj_controller.tolerant=ini_read_real("Controller","tolerant",0);
	    obj_controller.unload=ini_read_real("Controller","unload",0);
	    obj_controller.diplomacy=0;
	    obj_controller.trading=0;
	    obj_controller.audience=0;
	    obj_controller.force_goodbye=0;
	    obj_controller.combat=0;
	    obj_controller.new_vehicles=ini_read_real("Controller","new_vehicles",0);
	    obj_controller.hurssy=ini_read_real("Controller","hurssy",0);
	    obj_controller.hurssy_time=ini_read_real("Controller","hurssy_time",0);
	    obj_controller.artifacts=ini_read_real("Controller","artifacts",0);
	    obj_controller.popup_master_crafted=ini_read_real("Controller","pmc",0);
	    obj_controller.select_wounded=ini_read_real("Controller","wndsel",1);
	    obj_ini.imperium_disposition=ini_read_real("Controller","imdis",40);
	    obj_controller.terra_direction=ini_read_real("Controller","terra_dir",floor(random(360))+1);

        obj_controller.stc_wargear=ini_read_real("Controller","stc_wargear",0);
        obj_controller.stc_vehicles=ini_read_real("Controller","stc_vehicles",0);
        obj_controller.stc_ships=ini_read_real("Controller","stc_ships",0);
        obj_controller.stc_un_total=ini_read_real("Controller","stc_un_total",0);
        obj_controller.stc_wargear_un=ini_read_real("Controller","stc_wargear_un",0);
        obj_controller.stc_vehicles_un=ini_read_real("Controller","stc_vehicles_un",0);
        obj_controller.stc_ships_un=ini_read_real("Controller","stc_ships_un",0);

	    obj_controller.stc_bonus = return_json_from_ini("Controller","stc_bonus", array_create(6,0));
	    obj_ini.adv = return_json_from_ini("Controller","adv", []);
	    obj_ini.dis = return_json_from_ini("Controller","dis", []);

	    // Player scheduled event
	    obj_controller.fest_type=ini_read_string("Controller","f_t",""); //

	    if (obj_controller.fest_type!=""){
	        obj_controller.fest_sid=ini_read_real("Controller","f_si",0);
	        obj_controller.fest_wid=ini_read_real("Controller","f_wi",0);
	        obj_controller.fest_planet=ini_read_real("Controller","f_pl",0);
	        obj_controller.fest_star=ini_read_string("Controller","f_st",""); //
	        obj_controller.fest_cost=ini_read_real("Controller","f_co",0);
	        obj_controller.fest_warp=ini_read_real("Controller","f_wa",0);
	        obj_controller.fest_scheduled=ini_read_real("Controller","f_sch",0);
	        obj_controller.fest_lav=ini_read_real("Controller","f_la",0);
	        obj_controller.fest_locals=ini_read_real("Controller","f_lo",0);
	        obj_controller.fest_feature1=ini_read_real("Controller","f_f1",0);
	        obj_controller.fest_feature2=ini_read_real("Controller","f_f2",0);
	        obj_controller.fest_feature3=ini_read_real("Controller","f_f3",0);
	        obj_controller.fest_display=ini_read_real("Controller","f_di",0);
	        obj_controller.fest_display_tags=ini_read_string("Controller","f_dit",""); //
	        obj_controller.fest_repeats=ini_read_real("Controller","f_re",0);
	        obj_controller.fest_honor_co=ini_read_real("Controller","f_hc",0);
	        obj_controller.fest_honor_id=ini_read_real("Controller","f_hi",0);
	        obj_controller.fest_honoring=ini_read_real("Controller","f_hon",0);
	    }

	    obj_controller.fest_feasts=ini_read_real("Controller","f_fee",0);
	    obj_controller.fest_boozes=ini_read_real("Controller","f_boo",0);
	    obj_controller.fest_drugses=ini_read_real("Controller","f_dru",0);
	    obj_controller.recent_happenings=ini_read_real("Controller","rech",0);

		obj_controller.recent_type = return_json_from_ini("Controller","rect",[]);
		obj_controller.recent_keyword = return_json_from_ini("Controller","reck",[]);
		obj_controller.recent_turn = return_json_from_ini("Controller","recu",[]);
		obj_controller.recent_number =	 return_json_from_ini("Controller","recn",[]);

	    obj_controller.last_attack_form=ini_read_real("Formation","last_attack",1);
	    if (obj_controller.last_attack_form=0) then obj_controller.last_attack_form=1;
	    obj_controller.last_raid_form=ini_read_real("Formation","last_raid",3);
	    if (obj_controller.last_raid_form=0) then obj_controller.last_raid_form=3;
	    j=0;

	   	obj_controller.bat_formation=return_json_from_ini("Formation","form",array_create(17,""));
	    obj_controller.bat_formation_type=return_json_from_ini("Formation","form_type",array_create(17,0));
        default_bat_formation();

        obj_controller.bat_deva_for=return_json_from_ini("Formation","deva",array_create(17,1));
        obj_controller.bat_assa_for=return_json_from_ini("Formation","assa",array_create(17,4));
        obj_controller.bat_tact_for=return_json_from_ini("Formation","tact",array_create(17,2));
        obj_controller.bat_vete_for=return_json_from_ini("Formation","vete",array_create(17,2));
        obj_controller.bat_hire_for=return_json_from_ini("Formation","hire",array_create(17,3));
        obj_controller.bat_libr_for=return_json_from_ini("Formation","libr",array_create(17,3));
        obj_controller.bat_comm_for=return_json_from_ini("Formation","comm",array_create(17,3));
        obj_controller.bat_tech_for=return_json_from_ini("Formation","tech",array_create(17,3));
        obj_controller.bat_term_for=return_json_from_ini("Formation","term",array_create(17,3));
        obj_controller.bat_hono_for=return_json_from_ini("Formation","hono",array_create(17,3));
        obj_controller.bat_drea_for=return_json_from_ini("Formation","drea",array_create(17,5));
        obj_controller.bat_rhin_for=return_json_from_ini("Formation","rhin",array_create(17,6));
        obj_controller.bat_pred_for=return_json_from_ini("Formation","pred",array_create(17,7));
        obj_controller.bat_landraid_for=return_json_from_ini("Formation","landraid",array_create(17,7));
        obj_controller.bat_landspee_for=return_json_from_ini("Formation","landspee",array_create(17,4));
        obj_controller.bat_whirl_for=return_json_from_ini("Formation","whirl",array_create(17,1));
        obj_controller.bat_scou_for=return_json_from_ini("Formation","scou",array_create(17,1));


	    obj_controller.useful_info=ini_read_string("Controller","useful_info",""); 
	    obj_controller.random_event_next=ini_read_real("Controller","random_event_next","0"); 
	    obj_controller.gene_sold=ini_read_real("Controller","gene_sold",0);
	    obj_controller.gene_xeno=ini_read_real("Controller","gene_xeno",0);
	    obj_controller.gene_tithe=ini_read_real("Controller","gene_tithe",24);
	    obj_controller.gene_iou=ini_read_real("Controller","gene_iou",0);

	    obj_controller.und_armouries=ini_read_real("Controller","und_armouries",0);
	    obj_controller.und_gene_vaults=ini_read_real("Controller","und_gene_vaults",0);
	    obj_controller.und_lairs=ini_read_real("Controller","und_lairs",0);

	    obj_controller.penitent=ini_read_real("Controller","penitent",0);
	    obj_controller.penitent_current=ini_read_real("Controller","penitent_current",0);
	    obj_controller.penitent_max=ini_read_real("Controller","penitent_max",0);
	    obj_controller.penitent_turnly=ini_read_real("Controller","penitent_turnly",0);
	    obj_controller.penitent_turn=ini_read_real("Controller","penitent_turn",0);
	    obj_controller.penitent_end=ini_read_real("Controller","penitent_end",0);
	    obj_controller.blood_debt=ini_read_real("Controller","penitent_blood",0);

	    obj_controller.tagged_training=ini_read_real("Controller","tagged_training",0);
	    obj_controller.training_apothecary=ini_read_real("Controller","training_apothecary",0);
	    obj_controller.apothecary_recruit_points=ini_read_real("Controller","apothecary_recruit_points",0);
	    obj_controller.apothecary_aspirant=ini_read_real("Controller","apothecary_aspirant",0);
	    obj_controller.training_chaplain=ini_read_real("Controller","training_chaplain",0);
	    obj_controller.chaplain_points=ini_read_real("Controller","chaplain_points",0);
	    obj_controller.chaplain_aspirant=ini_read_real("Controller","chaplain_aspirant",0);
	    obj_controller.training_psyker=ini_read_real("Controller","training_psyker",0);
	    obj_controller.psyker_points=ini_read_real("Controller","psyker_points",0);
	    obj_controller.psyker_aspirant=ini_read_real("Controller","psyker_aspirant",0);
	    obj_controller.training_techmarine=ini_read_real("Controller","training_techmarine",0);
	    obj_controller.tech_points=ini_read_real("Controller","tech_points",0);
	    obj_controller.tech_aspirant=ini_read_real("Controller","tech_aspirant",0);

	    obj_controller.spec_train_data = return_json_from_ini("Controller", "spec_train",[
		    {
		        name : "Techmarine",
		        min_exp : 30,
		        coord_offset : [0, 0],
		        req : [["technology",34, "exmore"]]
		    },
		    {
		        name : "Librarian",
		        min_exp : 0,
		        coord_offset : [0, -7],
		        req : [["psionic", 1, "exmore"]]
		    },
		    {
		        name : "Chaplain",
		        min_exp : 60,
		        coord_offset : [7, -7],
		        req : [["piety", 34, "exmore"], ["charisma", 29, "exmore"]]
		    },
		    {
		        name : "Apothecary",
		        min_exp : 60,
		        coord_offset : [7, 0],
		        req : [["technology", 29, "exmore"], ["intelligence",44, "exmore"]]
		    },
		]);

	    obj_controller.penitorium=ini_read_real("Controller","penitorium",0);

	    obj_controller.recruiting_worlds=ini_read_string("Controller","recruiting_worlds","");
	    obj_controller.recruiting=ini_read_real("Controller","recruiting",0);
	    obj_controller.recruit_trial=ini_read_real("Controller","trial",eTrials.BLOODDUEL);
	    obj_controller.recruits=ini_read_real("Controller","recruits",0);
	    obj_controller.recruit_last=ini_read_real("Controller","recruit_last",0);

	    var Production_research=ini_read_string("Controller","production_research",0);
	    if (Production_research!=0){
	    	obj_controller.production_research = json_parse(base64_decode(Production_research));
	    }
	    specialist_point_handler = new SpecialistPointHandler();
	    var forge_queue=ini_read_string("Controller","forge_queue",0);
	    if (forge_queue!=0){
	    	obj_controller.specialist_point_handler.forge_queue = json_parse(base64_decode(forge_queue));
	    }
	    var Stc_research=ini_read_string("Controller","stc_research",0);
	    if (Stc_research!=0){
	    	obj_controller.stc_research = json_parse(base64_decode(Stc_research));
	    }

	    var g;g=-1;repeat(30){g+=1;
	        obj_controller.command_set[g]=ini_read_real("Controller","command"+string(g),0);
	    }
	    if (obj_controller.command_set[20]=0) and (obj_controller.command_set[21]=0) and (obj_controller.command_set[22]=0) then obj_controller.command_set[20]=1;
	    if (obj_controller.command_set[23]=0) and (obj_controller.command_set[24]=0) then obj_controller.command_set[24]=1;


	    ini_read_real("Controller","modest_livery",0);
		ini_read_real("Controller","progenitor_visuals",0);
	    var _recruit_data = return_json_from_ini("Recruit", "data", {
	    	names:[""],
	    	corruption :[0],
	    	distance :[0],
	    	experience :[0],
	    	training :[0],
	    	recruit_data : [{}]	    	
	    })
    	obj_controller.recruit_name = _recruit_data.names;
    	obj_controller.recruit_corruption= _recruit_data.corruption;
    	obj_controller.recruit_distance= _recruit_data.distance;
    	obj_controller.recruit_exp= _recruit_data.experience;
    	obj_controller.recruit_training = _recruit_data.training;
    	if (struct_exists(_recruit_data,"recruit_data")){
    		obj_controller.recruit_data = _recruit_data.recruit_data;
    	} else {
    		obj_controller.recruit_data =  array_create(array_length(obj_controller.recruit_name), {});
    	}

    	var dummyArray = array_create(30, "");
    	obj_controller.loyal = return_json_from_ini("Controller","lyl",dummyArray);
    	dummyArray = array_create(30, 0);
    	obj_controller.loyal_num = return_json_from_ini("Controller","lyl_nm",dummyArray);
    	obj_controller.loyal_time = return_json_from_ini("Controller","lyl_tm",dummyArray);

    	var dummyArray = array_create(30, "");
    	obj_controller.inquisitor = return_json_from_ini("Controller","inq",dummyArray);
    	obj_controller.inquisitor_type = return_json_from_ini("Controller","inq_ty",dummyArray);
    	dummyArray = array_create(30, 0);
    	obj_controller.inquisitor_gender = return_json_from_ini("Controller","inq_ge",dummyArray);

	    var g;g=-1;repeat(14){g+=1;
	        obj_controller.faction[g]=ini_read_string("Factions","fac"+string(g),"Error");
	        obj_controller.disposition[g]=ini_read_real("Factions","dis"+string(g),0);
	        obj_controller.disposition_max[g]=ini_read_real("Factions","dis_max"+string(g),0);

	        obj_controller.faction_leader[g]=ini_read_string("Factions","lead"+string(g),"Error");
	        obj_controller.faction_gender[g]=ini_read_real("Factions","gen"+string(g),1);
	        obj_controller.faction_title[g]=ini_read_string("Factions","title"+string(g),"Error");
	        obj_controller.faction_status[g]=ini_read_string("Factions","status"+string(g),"Error");
	        obj_controller.faction_defeated[g]=ini_read_real("Factions","defeated"+string(g),0);
	        obj_controller.known[g]=ini_read_real("Factions","known"+string(g),0);

	        obj_controller.annoyed[g]=ini_read_real("Factions","annoyed"+string(g),0);
	        obj_controller.ignore[g]=ini_read_real("Factions","ignore"+string(g),0);
	        obj_controller.turns_ignored[g]=ini_read_real("Factions","turns_ignored"+string(g),0);
	        obj_controller.audien[g]=ini_read_real("Factions","audience"+string(g),0);
	        obj_controller.audien_topic[g]=ini_read_string("Factions","audience_topic"+string(g),"");
	    }
	    //
	    var g;g=0;
	    repeat(50){g+=1;
	        obj_controller.quest[g]=ini_read_string("Ongoing","quest"+string(g),"");
	        obj_controller.quest_faction[g]=ini_read_real("Ongoing","quest_faction"+string(g),0);
	        obj_controller.quest_end[g]=ini_read_real("Ongoing","quest_end"+string(g),0);
	    }
	    var g;g=0;
	    repeat(99){g+=1;
	        obj_controller.event[g]=ini_read_string("Ongoing","event"+string(g),"");
	        obj_controller.event_duration[g]=ini_read_real("Ongoing","event_duration"+string(g),0);
	    }
	    //
	    obj_controller.justmet=0;
	    obj_controller.check_number=ini_read_real("Controller","check_number",0);
	    obj_controller.year_fraction=ini_read_real("Controller","year_fraction",0);
	    obj_controller.year=ini_read_real("Controller","year",0);
	    obj_controller.millenium=ini_read_real("Controller","millenium",0);
	    //
	    obj_controller.requisition=ini_read_real("Controller","req",0);
	    obj_controller.tech_status=ini_read_string("Controller","tech_status","Cult Mechanicus");
	    //
	    obj_controller.income=ini_read_real("Controller","income",0);
	    obj_controller.income_last=ini_read_real("Controller","income_last",0);
	    obj_controller.income_base=ini_read_real("Controller","income_base",0);
	    obj_controller.income_home=ini_read_real("Controller","income_home",0);
	    obj_controller.income_forge=ini_read_real("Controller","income_forge",0);
	    obj_controller.income_agri=ini_read_real("Controller","income_agri",0);
	    obj_controller.income_training=ini_read_real("Controller","income_training",0);
	    obj_controller.income_fleet=ini_read_real("Controller","income_fleet",0);
	    obj_controller.income_trade=ini_read_real("Controller","income_trade",0);
	    obj_controller.loyalty=ini_read_real("Controller","loyalty",0);
	    obj_controller.loyalty_hidden=ini_read_real("Controller","loyalty_hidden",0);
	    obj_controller.inqis_flag_lair=ini_read_real("Controller","flag_lair",0);
	    obj_controller.inqis_flag_gene=ini_read_real("Controller","flag_gene",0);
	    obj_controller.gene_seed=ini_read_real("Controller","gene_seed",0);
	    obj_controller.marines=ini_read_real("Controller","marines",0);
	    obj_controller.command=ini_read_real("Controller","command",0);
	    obj_controller.info_chips=ini_read_real("Controller","info_chips",0);
	    obj_controller.inspection_passes=ini_read_real("Controller","inspection_passes",0);
	    obj_controller.recruiting_worlds_bought=ini_read_real("Controller","recruiting_worlds_bought",0);
	    obj_controller.last_weapons_tab=ini_read_real("Controller","lwt",1);
	    //
	    obj_ini.battle_cry=ini_read_string("Ini","battle_cry","Error");
	    // obj_ini.fortress_name=ini_read_string("Ini","fortress_name","Error");
	    obj_ini.flagship_name=ini_read_string("Ini","flagship_name","Error");
	    obj_ini.home_name=ini_read_string("Ini","home_name","Error");
	    obj_ini.home_type=ini_read_string("Ini","home_type","Error");
	    obj_ini.recruiting_name=ini_read_string("Ini","recruiting_name","Error");
	    obj_ini.recruiting_type=ini_read_string("Ini","recruiting_type","Error");


	    var tempa,tempa2,q,good;q=0;good=0;tempa="";tempa2=0;
	    scr_colors_initialize();

		tempa = ini_read_string("Controller", "main_color", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}
		obj_controller.main_color = tempa2;
		obj_ini.main_color = tempa2;

		tempa = ini_read_string("Controller", "secondary_color", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}
		obj_controller.secondary_color = tempa2;
		obj_ini.secondary_color = tempa2;

		tempa = ini_read_string("Controller", "main_trim", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}
		obj_controller.main_trim = tempa2;
		obj_ini.main_trim = tempa2;

		tempa = ini_read_string("Controller", "left_pauldron", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}
		obj_controller.left_pauldron = tempa2;
		obj_ini.left_pauldron = tempa2;

		tempa = ini_read_string("Controller", "right_pauldron", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}
		obj_controller.right_pauldron = tempa2;
		obj_ini.right_pauldron = tempa2;

		tempa = ini_read_string("Controller", "lens_color", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}
		obj_controller.lens_color = tempa2;
		obj_ini.lens_color = tempa2;

		tempa = ini_read_string("Controller", "weapon_color", "Error");
		tempa2 = 0;
		q = 0;
		good = 0;
		for(var q=0; q<global.colors_count; q++){
			if (tempa = col[q]) and(good = 0) {
				good = q;
				tempa2 = q;
			}
		}

	    obj_controller.weapon_color = tempa2;
	    obj_ini.weapon_color = tempa2;

	    obj_controller.col_special=ini_read_real("Controller","col_special",0);obj_ini.col_special=obj_controller.col_special;
	    obj_controller.trim=ini_read_real("Controller","trimmed",0);obj_ini.trim=obj_controller.trim;
	    obj_ini.skin_color=ini_read_real("Controller","skin_color",0);obj_controller.skin_color=obj_ini.skin_color;

	    obj_ini.adept_name=ini_read_string("Controller","adept_name","Error");
	    obj_ini.recruiter_name=ini_read_string("Controller","recruiter_name","Error");
	    // obj_ini.progenitor=ini_read_string("Controller","progenitor","Error");
	    obj_ini.mutation=ini_read_string("Controller","mutation","Error");
	    obj_ini.successor_chapters=ini_read_real("Controller","successors",0);
	    obj_ini.progenitor_disposition=ini_read_real("Controller","progenitor_disposition",0);
	    obj_ini.imperium_disposition=ini_read_real("Controller","imperium_disposition",0);
	    obj_controller.astartes_disposition=ini_read_real("Controller","astartes_disposition",0);

	    obj_controller.bat_devastator_column=ini_read_real("Controller","bat_devastator_column",1);
	    obj_controller.bat_assault_column=ini_read_real("Controller","bat_assault_column",4);
	    obj_controller.bat_tactical_column=ini_read_real("Controller","bat_tactical_column",2);
	    obj_controller.bat_veteran_column=ini_read_real("Controller","bat_veteran_column",2);
	    obj_controller.bat_hire_column=ini_read_real("Controller","bat_hire_column",3);
	    obj_controller.bat_librarian_column=ini_read_real("Controller","bat_librarian_column",3);
	    obj_controller.bat_command_column=ini_read_real("Controller","bat_command_column",3);
	    obj_controller.bat_techmarine_column=ini_read_real("Controller","bat_techmarine_column",3);
	    obj_controller.bat_terminator_column=ini_read_real("Controller","bat_terminator_column",3);
	    obj_controller.bat_honor_column=ini_read_real("Controller","bat_honor_column",3);
	    obj_controller.bat_dreadnought_column=ini_read_real("Controller","bat_dreadnought_column",5);
	    obj_controller.bat_rhino_column=ini_read_real("Controller","bat_rhino_column",6);
	    obj_controller.bat_predator_column=ini_read_real("Controller","bat_preadtor_column",7);
	    obj_controller.bat_landraiders_column=ini_read_real("Controller","bat_landraiders_column",7);
	    obj_controller.bat_scout_column=ini_read_real("Controller","bat_scout_column",1);

	    ini_close();
}
