function scr_audience(faction_enum, topic, new_disposition = 0, new_status = "", turns_ignored = 0, new_known_value = 0, audience_data = {}) {
    var _audience_instance = instance_exists(obj_turn_end) ? obj_turn_end : obj_controller;

    with (_audience_instance) {
        audiences += 1;
        array_push(audience_stack, {faction: faction_enum, topic: topic, audience_data: audience_data});
    }

    obj_controller.disposition[faction_enum] += new_disposition;

    if (new_status != "") {
        obj_controller.faction_status[faction_enum] = new_status;
    }
    if (turns_ignored != 0) {
        obj_controller.turns_ignored[faction_enum] += turns_ignored;
    }
    if (new_known_value != 0) {
        obj_controller.known[faction_enum] += new_known_value;
    }
}

function decare_war_on_imperium_audiences() {
    var _topic = obj_controller.gene_xeno > 99995 ? "gene_xeno" : "declare_war";
    scr_audience(eFACTION.INQUISITION, _topic, -50, "War", 9999, 4);

    scr_audience(eFACTION.IMPERIUM, "declare_war", -40, "War", 9999, 2);

    scr_audience(eFACTION.MECHANICUS, "declare_war", -30, "War", 9999, 2);

    scr_audience(eFACTION.ECCLESIARCHY, "declare_war", -40, "War", 9999, 2);
}
