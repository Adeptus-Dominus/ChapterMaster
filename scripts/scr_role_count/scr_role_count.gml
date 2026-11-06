function scr_role_count(_target_role, _search_location = "", _return_type = "count") {
    var _search = {role:_target_role};
    if (is_real(_search_location)){
        _search.company = _search_location;
        _search_location  = "";
    }
    var _units = collect_role_group("all", _search_location, false,  _search, true);

    if (_return_type == "units"){
        return _units.units;
    } else if _return_type == "count"{
        return _units.number();
    }else if _return_type == "group"{
        return _units;
    }
}

function scr_group_count(_role_group,_search_location = "", _return_type = "count"){
     var _search = {};
    if (is_real(_search_location)){
        _search.company = _search_location;
        _search_location  = "";
    }
    var _units = collect_role_group(_role_group, _search_location, false,  _search, true); 

    if (_return_type == "units"){
        return _units.units;
    } else if _return_type == "count"{
        return _units.number();
    }else if _return_type == "group"{
        return _units;
    }
}
