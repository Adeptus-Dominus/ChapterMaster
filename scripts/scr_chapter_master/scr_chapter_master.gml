function ChapterMaster() constructor {
    favours = {
        faction_leaders: array_create(15, 0),
        minor_characters: {},
    };

    static get_struct = function() {
        return fetch_unit([0, 0]);
    };

    static check_alive = function() {
        if (obj_controller.alarm[7] != -1) {
            exit;
        }
        var _alive = true;
        if (array_length(obj_ini.TTRPG[0]) == 0) {
            _alive = false;
        }

        if (_alive) {
            var _cm = get_struct();
            if (!is_struct(_cm) || !_cm.has_role(eROLE.CHAPTERMASTER)) {
                _alive = false;
            }
        }

        if (!_alive) {
            obj_controller.alarm[7] = 15;
        }
    };
}

function cm_obj() {
    return obj_controller.chapter_master;
}

function has_faction_favour(diplomacy_faction) {
    return cm_obj().favours.faction_leaders[diplomacy_faction] > 0;
}

function get_faction_favour(diplomacy_faction) {
    return cm_obj().favours.faction_leaders[diplomacy_faction];
}

function edit_faction_favour(diplomacy_faction, edit_val) {
    with (cm_obj().favours) {
        var _val = faction_leaders[diplomacy_faction];
        faction_leaders[diplomacy_faction] = clamp(_val + edit_val, 0, 100000);
        return faction_leaders[diplomacy_faction];
    }
}
