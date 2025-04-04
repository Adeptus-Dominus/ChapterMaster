function SpecialistPointHandler() constructor{

    static chapter_spread = calculate_full_chapter_spread;
    static healing_and_point_use = apothecary_simple;
    forge_queue = [];
    techs = [];
    apoths = [];
    forge_master=-1;
    master_craft_chance = 0;

    forge_reasons = {};
    
    forge_string = "";
    at_forge = 0;
    apothecary_points = 0;
    armoury_repairs = {};
    apothecary_string = "";
    apothecary_training_points = 0;
    forge_points = 0;
    point_breakdown = {};
    // ** Gene-seed Test-Slaves **
    static add_to_armoury_repair = function(item, count=1){
        if (is_string(item)){
            if (item!=""){
                if (!struct_exists(armoury_repairs, item)){
                    armoury_repairs[$ item] = count;
                } else {
                    armoury_repairs[$ item]+=count;
                }
            }
        }
    }

    static pre_error_wrapped_research_points = function(){

        research_points = 0;
        forge_points = 0;
        master_craft_chance = 0;

        apoth_points_used = 0;
        apothecary_points = 0;

        apothecary_training_points = 0;
        apothecary_points_used = 0;
        tech_points_used = 0;
        crafters=0;
        at_forge = 0;

        if (obj_controller.tech_status == "heretics") then master_craft_chance+=5;

        apoths =[];

        techs = [];
        heretics = [];
        delete point_breakdown;
        point_breakdown = {
            fleets : {},
            systems : {},
        };

        forge_string = $"Forge Production Rate#";
        forge_master=-1;
        forge_veh_maintenance={
            repairs : 0
        };
        healing_and_point_use();

        var at_forge=0;
        tech_locations=[]
        var _cur_tech;
        total_techs = array_length(techs);
        for (var i=0; i<array_length(techs); i++){
           tech_locations[i] = techs[i].marine_location();
        }
        if (forge_master>-1){
            obj_controller.master_of_forge = techs[forge_master];
        }
        apothecary_string = "Apothecaries : +{apothecaries}";
        apothecary_string = "Apothecary Healing : {apothecary_points_used}";
        apothecary_points -= apothecary_points_used;
        apothecary_string = "Recruit screening : -{apothecary_training_points}";
        apothecary_points -= apothecary_training_points;
        //TODO extract to the apothecary simple script
        forge_string += $"Techmarines: +{floor(forge_points)}#";
        forge_points-=tech_points_used;        
        forge_string += $"Vehicle Repairs:#";
        forge_string += $"   Combat Repairs : {forge_veh_maintenance.repairs}#";
        if (struct_exists(forge_veh_maintenance, "land_raider")){
            forge_string += $"   Land Raider Maintenance: -{forge_veh_maintenance.land_raider}#";
            forge_points-=forge_veh_maintenance.land_raider;
        }
        if (struct_exists(forge_veh_maintenance, "small_vehicles")){
            if (floor(forge_veh_maintenance.small_vehicles)>0){
                forge_string += $"   Small Vehicle Maintenance: -{floor(forge_veh_maintenance.small_vehicles)}#";
                forge_points-=floor(forge_veh_maintenance.small_vehicles);
            }
        }
        var _forge_data = obj_controller.player_forge_data;
        if (_forge_data.player_forges>0){
            forge_points += 5*_forge_data.player_forges;
            forge_string += $"Forges: +{5*_forge_data.player_forges}#";
        }
        var _armoury_maintenance_names = struct_get_names(armoury_repairs);
        var _name_length = array_length(_armoury_maintenance_names);

        for (var i=0;i<_name_length;i++){
            var _maintain_item = _armoury_maintenance_names[i];
            forge_points -= gear_weapon_data("any", _maintain_item, "maintenance") * armoury_repairs[$ _maintain_item];

        }
        forge_points = floor(forge_points);
        //in this instance tech  are techmarines with the "tech_heretic" trait
        if (turn_end){
            if (array_length(techs)==0) then scr_loyalty("Upset Machine Spirits","+");

            tech_ideology_spread();
            new_tech_heretic_spawn();

            if (forge_master==-1){ 
                var tech_count = scr_role_count(obj_ini.role[100][16]);
                if (tech_count>1){
                    var last_master = obj_ini.previous_forge_masters[array_length(obj_ini.previous_forge_masters)-1];
                    scr_popup("New Forge Master",$"The Demise of Forge Master {last_master} means a replacement must be chosen. Several Options have already been put forward to you but it is ultimatly your decision.","new_forge_master","");
                } else if (tech_count==1){
                    scr_role_count(obj_ini.role[100][16],"","units")[0].update_role("Forge Master");
                }
            }
            forge_queue_logic();

            gene_slave_logic();     
        }
        obj_controller.research_points = research_points;
        obj_controller.forge_points = forge_points;
        obj_controller.master_craft_chance = master_craft_chance;
        obj_controller.forge_string = forge_string;
        if (turn_end){
            armoury_repairs = {};
        }
    }

    static calculate_research_points = function(turn_end){
        self.turn_end=turn_end;
        try_and_report_loop("Specialist points logic", pre_error_wrapped_research_points);
    }

    static new_tech_heretic_spawn = function() {
        var _tester = global.character_tester;
        var _possibility_of_heresy = 8;
        if (scr_has_disadv("Tech-Heresy")) {
            _possibility_of_heresy = 6;
        }
        if (irandom(power(_possibility_of_heresy, (array_length(techs) + 2.2))) == 0 && array_length(techs) > 0) {
            var _current_tech = array_random_element(techs);
            if (!_tester.standard_test(_current_tech, "piety")[0]) {
                _current_tech.add_trait("tech_heretic");
                _current_tech.edit_corruption(20 + irandom(15));
            }
        }
    };

    static add_forge_points_to_stack = function(unit){
        if (unit.in_jail()) {
            return;
        }
        array_push(techs, unit);
        if (unit.technology > 40 && unit.hp() > 0){
            research_points += unit.technology - 40;
            var _forge_point_gen = unit.forge_point_generation(false);
            var _unit_forge_gen_data = _forge_point_gen[1];
            if (struct_exists(_unit_forge_gen_data, "crafter")) { crafters++; }
            if (struct_exists(_unit_forge_gen_data, "at_forge")){
                at_forge++;
                master_craft_chance += (unit.experience / 50);
            }
            forge_points += _forge_point_gen[0];
            var _tech_array_id = array_length(techs) - 1;
            if (unit.has_trait("tech_heretic")) {
                array_push(heretics, _tech_array_id);
            }
            if (unit.IsSpecialist(SPECIALISTS_HEADS)) {
                forge_master = _tech_array_id;
            }  
        }
    }

    static add_apoth_points_to_stack = function(unit){
        if (unit.in_jail()) {
            return;
        }
        if (unit.hp() > 0){
            var _apoth_point_gen=unit.apothecary_point_generation(false);
            apothecary_points += _apoth_point_gen[0];
        }
    }


    //handles tech heretic idealology rot
    static tech_ideology_spread = function(){
        try{
        var tech_test, charisma_test, piety_test, _met_non_heretic, heretics_persuade_chances;
        var _tester = global.character_tester;
        var _noticed_heresy = false; // should this be in the for loop?
        if (array_length(heretics)>0 && obj_controller.turn>75){
            var _heretic_location, _same_location, _current_heretic, _current_tech;
            //iterate through tech heretics;
            for (var heretic=0; heretic<array_length(heretics); heretic++){
                _heretic_location = tech_locations[heretics[heretic]];
                _current_heretic = techs[heretics[heretic]];
                if (_current_heretic.in_jail()) then continue;
                heretics_persuade_chances = (floor(_current_heretic.charisma/5) - 3)
                //iterate through rest of techs
                var _pursuasions =[];
                _met_non_heretic = false;
                var _new_pursuasion;
                for (var i=0; i<array_length(techs) && heretics_persuade_chances>0; i++){
                    _same_location=false;
                    var _new_pursuasion = array_random_index(techs);
                    //if tech is also heretic skip
                    if (array_contains(heretics,_new_pursuasion)) then continue;
                    if (array_contains(_pursuasions,_new_pursuasion)) then continue;
                    heretics_persuade_chances--;
                    _current_tech = techs[_new_pursuasion];

                    // find out if heretic is in same location as techmarine
                    if (same_locations(_heretic_location, tech_locations[_new_pursuasion])){
                        _met_non_heretic=true;
                        //if so do a an opposed technology test of techmarine vs tech  heretic techmarine
                        tech_test = _tester.oppposed_test(_current_heretic,_current_tech, "technology");


                        if (tech_test[0]==1){
                            // if heretic wins do an opposed charisma test
                            charisma_test =  _tester.oppposed_test(_current_heretic,_current_tech, "charisma", -15+_current_tech.corruption);                           
                            if (charisma_test[0]==1){
                                // if heretic win tech is corrupted
                                //tech is corrupted by half the pass margin of the heretic
                                //this means high charisma heretics will spread corruption more quickly and more often
                                if (_current_heretic.corruption>_current_tech.corruption){
                                    _current_tech.edit_corruption(min(4,charisma_test[1]));
                                }

                                // tech takes a piety test to see if they break faith with cult mechanicus and become tech heretic
                                //piety test is augmented by by the techs corruption with the test becoming harder to pass the more
                                // corrupted the tech is
                                piety_test = _tester.standard_test(_current_tech, "piety", +75 - _current_tech.corruption);

                                // if tech fails piety test tech also becomes tech heretic
                                if (piety_test[0] == false && choose(true,false)){
                                    _current_tech.add_trait("tech_heretic");
                                }
                            } else if (charisma_test[0]==2){
                                if (charisma_test[1] > 40 && _noticed_heresy=false){
                                    scr_alert("purple","Tech Heresy",$"{_current_tech.name_role()} contacts you concerned of Tech Heresy in the Armentarium");
                                    _noticed_heresy=true;
                                }
                            }
                        }
                        if (_new_pursuasion==forge_master){
                            // if tech is the forge master then forge master takes a wisdom in this case doubling as a perception test
                            // if forge master passes tech heresy is noted and chapter master notified
                            if (_tester.standard_test(_current_tech, "wisdom", - 40)[0] && !_noticed_heresy){
                                _noticed_heresy=true;
                                scr_event_log("purple",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                scr_alert("purple","Tech Heresy",$"{techs[forge_master].name_role()} Has noticed signs of tech heresy amoung the Armentarium ranks");
                                //pip=instance_create(0,0,obj_popup);
                            }
                        }
                    }
                }
                if (!_met_non_heretic){
                    if (irandom(4)==0){
                        _current_heretic.edit_corruption(1);
                    }
                }
                //add check to see if tech heretic is anywhere near mechanicus forge if so maybe do stuff??
                /*if (_heretic_location==location_types.planet){
                    if 
                }*/
            }
            if (array_length(techs)>array_length(heretics)){
                if (array_length(heretics)/array_length(techs)>=0.35){
                    if (!irandom(9)){
                        /*var text_string = "You Recive an Urgent Transmision from";
                        if (forge_master>-1){

                        }*/
                        scr_popup("Technical Differences!","You Recive an Urgent Transmision A serious breakdown in culture has coccured causing believers in tech heresy to demand that they are given preseidence and assurance to continue their practises","tech_uprising","");
                    }
                }
            }
        }
        } catch(_exception) {
            handle_exception(_exception);
        }
    }


    static forge_queue_logic = function(){
        if (forge_points>0){
            var _reduction_points = forge_points;
            if (array_length(forge_queue)>0 && forge_points>0){
                var forging_length = array_length(forge_queue);
                for (var i=0;i<forging_length;i++){
                    if (forge_queue[i].forge_points<=_reduction_points){
                        _reduction_points-=forge_queue[i].forge_points;

                        scr_evaluate_forge_item_completion(forge_queue[i]);

                        array_delete(forge_queue, i, 1);
                        i--;
                        forging_length--;
                    } else {
                        forge_queue[i].forge_points -= _reduction_points;
                        _reduction_points=0;
                    }
                    if (_reduction_points<=0) then break;
                }
            }
        } 
    }

    static draw_forge_queue = function(xx,yy){
        var _box_width = 527;
        draw_set_color(c_gray);
        draw_rectangle(xx, yy , xx + _box_width, yy + 15, 0);
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);
        draw_set_color(0);
        draw_text(xx,yy,"Name");
        draw_text(xx+141,yy,"Number");
        draw_text(xx+241,yy,"Forge Points");
        draw_text(xx+341,yy,"Construction ETA");        
        draw_set_color(c_gray);
        var item_gap = 13;
        var total_eta=0;        
        static top_point=0;
        for (var i=top_point; i<13; i++){
            if (i+1>array_length(forge_queue)) then break;
            draw_set_color(c_gray);
            if scr_hit(xx,yy+item_gap,xx+_box_width,yy+item_gap+20){
                draw_set_color(c_white)
            }
            if (is_string(forge_queue[i].name)){
                draw_text(xx,yy + item_gap,string_hash_to_newline(forge_queue[i].name));
                draw_text(xx+166,yy + item_gap,forge_queue[i].count);
                if (forge_queue[i].ordered==obj_controller.turn){
                    if (forge_queue[i].count>1){
                        if (point_and_click(draw_unit_buttons([xx+141 , yy + item_gap],"-",[0.75,0.75],c_red))){
                            var unit_cost = forge_queue[i].forge_points/forge_queue[i].count;
                            forge_queue[i].count--;
                            forge_queue[i].forge_points-=unit_cost;
                        }               
                    }
                    if (forge_queue[i].count<100){
                        if (point_and_click(draw_unit_buttons([xx+180 , yy + item_gap],"+",[0.75,0.75],c_green))){
                            var unit_cost = forge_queue[i].forge_points/forge_queue[i].count;
                            forge_queue[i].count++;
                            forge_queue[i].forge_points+=unit_cost;
                        }                 
                    }
                }
            } else if (is_array(forge_queue[i].name)){
                if (forge_queue[i].name[0]  == "research"){
                    draw_text(xx,yy + item_gap,forge_queue[i].name[1]);
                }
            }
            draw_text(xx+271,yy + item_gap,string_hash_to_newline(forge_queue[i].forge_points));
            total_eta += ceil(forge_queue[i].forge_points/forge_points);
            draw_text(xx+376,yy+ item_gap,$"{total_eta} turns");        
            if (point_and_click(draw_unit_buttons([xx+491, yy + item_gap],"X",[0.75,0.75],c_red))){
                array_delete(forge_queue, i, 1);
            }                    
            item_gap +=20
        }        
    }
    static gene_slave_logic = function(){
        var _slave_length = array_length(obj_ini.gene_slaves);
        var _slaves = obj_ini.gene_slaves;
        var _cur_slave;
        var _lost_gene_slaves = 0
        var _stack_lost_incubators = [];
        for (var i=0; i<_slave_length; i++){
            _cur_slave = _slaves[i];
            if (_cur_slave.num>0){
                _cur_slave.eta--;
                if (irandom(100000)<=(100-obj_ini.stability)*_cur_slave.num){
                    _cur_slave.num--;
                    _lost_gene_slaves++;
                    scr_add_item("Gene Pod Incubator");
                }
                if (_cur_slave.eta==0 && _cur_slave.num>0){
                    _cur_slave.eta=60;
                    obj_controller.gene_seed+=_cur_slave.num;
                    // color / type / text /x/y
                    scr_alert("green","test-slaves",$"Test-Slave Incubators Batch {i} harvested for {_cur_slave.num} Gene-Seed.",0,0);
                } else if (_cur_slave.num==0){
                    array_push(_stack_lost_incubators, i);
                }
            }
        }
        if (array_length(_stack_lost_incubators)){
            var _lost_inc_string = "Incubators Batch no longer has gene slaves and has been removed : ";
            for (var i=array_length(_stack_lost_incubators)-1;i>=0;i--){
                scr_destroy_gene_slave_batch(_stack_lost_incubators[i]);
                _lost_inc_string += $"{i},";

            }
            scr_alert("","test-slaves",_lost_inc_string ,0,0);
        }
        if(_lost_gene_slaves>0){
            scr_alert("","test-slaves",$"{_lost_gene_slaves} gene slaves lost due to geneseed instability their incubators have been returned to the armoury",0,0);
        }
    }    
    static scr_forge_item = function(item){
        var master_craft_count=0;
        var quality_string="";
        var normal_count=0;
        for (var s=0;s<item.count;s++){
            if (master_craft_chance && (irandom(100)<master_craft_chance)){
                master_craft_count++;
            } else {
                normal_count++;
            }
        }
        scr_add_item(item.name, normal_count);
        if (master_craft_count>0){
            scr_add_item(item.name, master_craft_count,"master_crafted");
            var numerical_string = master_craft_count==1?"was":"were";
            quality_string=$"X{master_craft_count} {numerical_string} Completed to a Master Crafted standard";
        }else {
            quality_string=$"all were completed to a standard STC compliant quality";
        }
        scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished {quality_string}","","");
    }    
    static scr_evaluate_forge_item_completion = function(item){
        if (is_string(item.name)){
            var _vehicles = ["Rhino","Predator","Land Raider","Whirlwind","Land Speeder"];
            var is_vehicle =  array_contains(_vehicles,item.name);
            if (!is_vehicle){
                scr_forge_item(item);
            } else {
                repeat(item.count){
                    var vehicle = scr_add_vehicle(item.name,obj_controller.new_vehicles,"standard","standard","standard","standard","standard");
                    var build_loc = array_random_element(obj_controller.player_forge_data.vehicle_hanger);
                    obj_ini.veh_loc[vehicle[0]][vehicle[1]] = build_loc[0];
                    obj_ini.veh_wid[vehicle[0]][vehicle[1]] = build_loc[1];
                    obj_ini.veh_lid[vehicle[0]][vehicle[1]] = -1;
                }
                scr_popup("Forge Completed",$"{item.name} X{item.count} construction finished Vehicles Waiting at hanger on {build_loc[0]} {build_loc[1]}","","");
            }                      
        } else if (is_array(item.name)){
            scr_advance_research(item);
        }
    }
    /*static apothecary_points_calc(){

    }*/
}
