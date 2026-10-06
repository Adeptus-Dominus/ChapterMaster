/// @param {string} _name
/// @param {Real} _timer
/// @param {struct} _data
function Problem(_name, _timer, _data) constructor {
    p_id = _name;
    timer = _timer;
    data = _data;
    uid = scr_uuid_generate();
    delete_mission = false;
    f_type = eP_FEATURES.MISSION;
    stage_id = "";
    members = [];
    if (struct_exists(data, "stage")){
        stage_id = data.stage;
    }
    if (struct_exists(data, "members")){
        members = data.members;
    }
    static has_data = function(key){
        return struct_exists(data, key);
    }
    static description = function(){
        var _n = mission_name_key(p_id);
        _n = _n == "" ? p_id : _n;
        return _n;
    }
    static __popup_delete = function(){
        with(obj_popup){
            popup_default_close();
        }
        __check_delete();
    }

    static __save_members = function(_save_copy){
        var _mems = clean_unit_array(members);
        _save_copy.members = [];
        for (var i=0;i<array_length(_mems);i++){
            _save_copy.members[i] = _mems[i].uid;
        }        
    }

    static __load_members =  function(){
        for (var i=0;i<array_length(members);i++){
            members[i] = fetch_unit_uid(members[i]);
        }
    }

    static find_func_ref = function(trigger_string){
        var _func_string = "__" + p_id + "_" + trigger_string;
        return _func_string;
    }

    static has_func = function(trigger_string){
        var _func_string = find_func_ref(trigger_string);
        return struct_exists(self,_func_string);
    }
    static find_func = function(trigger_string){
        var _func_string = find_func_ref(trigger_string);
        if (struct_exists(self,_func_string)){
            return self[$ _func_string]
        }
        return undefined;
    }

    static __popup_choice = function(trigger_string){
        var _func = find_func(trigger_string);
        if (!is_undefined(_func)){
            return method(self, _func);
        }
        return undefined;
    }

// PlanetProblem
    static mission_log_entry = function(){
        var _func = find_func("mission_log_entry");
        if (!is_undefined(_func)){
            try {
                return _func();
            } catch (_exception) {
                delete_mission = true;
                ERROR_HANDLER.handle_exception(_exception);
                __check_delete();
                return undefined;
            }
        }
        return __default_mission_log_entry();
    }

    static __default_mission_log_entry = function(){
        if (!instance_exists(system)){
            return undefined;
        }
        if (stage_id == "preliminary") {
            return undefined;
        }
        var _data = {
            system: is_callable(system.name) ? system.name() : system.name,
            mission: description(),
            time: timer,
            problem: self,
        };

        _data.click_left = method(_data, function() {
            set_map_pan_to_loc(problem.system);
        });

        return _data;
    }

    static __create_popup_option = function(_str1 = "", _func_string = "popup_delete"){
        var _opt = {
            str1 : _str1,
            run_in_popup : false
        }
        if (_func_string == "popup_delete"){
            _opt.choice_func = __popup_delete;
        } else {
            var _func = __popup_choice(_func_string);
            if (!is_undefined(_func)){
                _opt.choice_func = _func;
            } else {
                LOGGER.error($"unknown popup trigger {_func_string} for {p_id}") 
            }
        }

        return _opt;
    }

    static __add_option = function(_str1 = "", _func_string = "popup_delete"){
        add_option(__create_popup_option(_str1, _func_string));
    }

    //triggered at the end of scr_shoot
    static battle_on_enemy_casulties = function(){
        if (!struct_exists(self, "casualty_packet")){
            exit;
        }
        instance_activate_object(obj_star);
        var _func = find_func("on_enemy_casulties");
        __handle_triggered_mission_func(_func);

        struct_remove(self, "casualty_packet");

        instance_deactivate_object(obj_star);  
    }

    //triggers in obj_ncombat alarm 5
    static battle_final_message = function(){
        instance_activate_object(obj_star);
        var _func = find_func("battle_final_message");
        __handle_triggered_mission_func(_func);   
        instance_deactivate_object(obj_star);      
    }

    static after_battle_effects = function(){
        instance_activate_object(obj_star);
        var _func = find_func("battle_aftermath");
        __handle_triggered_mission_func(_func);   
        instance_deactivate_object(obj_star);
    }

        //triggered within drop select
    static before_battle_effects = function(){
        instance_activate_object(obj_star);
        var _func = find_func("setup_battle");
        __handle_triggered_mission_func(_func);   
        instance_deactivate_object(obj_star);   
    }

    static on_squad_selection = function(){
        var _func = find_func("squad_selected");
        __handle_triggered_mission_func(_func);       
        instance_deactivate_object(obj_star);
    }


    static on_unit_selection = function(){
        var _func = find_func("unit_select");
        if (!is_undefined(_func)){
            var _selec_data = obj_controller.selection_data;
            if (struct_exists(_selec_data, "selections")){
                members = _selec_data.selections;
            }
            __handle_triggered_mission_func(_func);   
        }    
        instance_deactivate_object(obj_star);
    }


    static __handle_triggered_mission_func = function(func){
        if (!is_undefined(func)){
            __refresh_data();
            try {
                func();
            } catch (_exception) {
                delete_mission = true;
                ERROR_HANDLER.handle_exception(_exception);
            }
        }
        __check_delete();
        obj_controller.location_viewer.update_mission_log();
    }

    //requires the completion and required_months flag to be in the data struct
    static __increment_mission_completion = function() {
        if (!struct_exists(data, "completion")) {
            data.completion = 0;
        }
        data.completion++;
        if (!struct_exists(data, "required_months") || data.required_months <= 0) {
            LOGGER.error("Invalid required_months in mission_data");
            return 0;
        }
        return (data.completion / data.required_months) * 100;
    }

    static __inquisition_mission_options = function(){
        var _options = [
            {
                str1: "Accept",
                choice_func: function(){
                    var _mission = pop_data.mission
                    var _func_str = _mission.find_func_ref("accept");
                    if (struct_exists(_mission, _func_str)){
                        with(_mission){
                            _mission[$ _func_str]();
                        }
                    } 
                    obj_controller.demanding = 0;
                }
            },
        ];
        if (!obj_controller.demanding){
            array_push(_options, {
                str1: "Refuse",
                choice_func: function(){
                    pop_data.mission.delete_mission = true;
                    popup_default_close();
                }
            })
        }
        return _options
    }
}