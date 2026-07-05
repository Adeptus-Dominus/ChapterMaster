if (feature.f_type == eP_FEATURES.ANCIENT_RUINS) {
    var _newline = "Your marines warily stalk through into the entrance of the ruins";
    var _newline_color = eMSG_COLOR.RED;
    obj_ncombat.combat_log.push(_newline, _newline_color);
    if (feature.ruins_race == 0) {
        feature.determine_race();
        _newline = "Your marines descended into the ancient ruins, mapping them out as they go.  They quickly determine the ruins were once ";
        if (feature.ruins_race == 1) {
            _newline += "a Space Marine fortification from earlier times.";
        }
        if (feature.ruins_race == 2) {
            _newline += "golden-age Imperial ruins, lost to time.";
        }
        if (feature.ruins_race == 5) {
            _newline += "a magnificent temple of the Imperial Cult.";
        }
        if (feature.ruins_race == 6) {
            _newline += "Eldar colonization structures from an unknown time.";
        }
        if (feature.ruins_race == 10) {
            _newline += "golden-age Imperial ruins, since decorated with spikes and bones.";
        }
        obj_ncombat.combat_log.push(_newline, _newline_color);
    } else {
        _newline = "The ruins seem much unchange from the last exploration records";
        obj_ncombat.combat_log.push(_newline, _newline_color);
    }

    var pathway = choose(1, 2, 3);
    if (pathway > 0) {
        _newline = "After exploring for many the exploration team reach a large chamber branching into three halways one of which is sealed by a thick blast door";
        obj_ncombat.combat_log.push(_newline, _newline_color);
    }
}
