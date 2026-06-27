// Excommunicatus Traitorus
instance_activate_object(obj_star);

var witch = obj_controller;
if (instance_exists(obj_turn_end)) {
    witch = obj_turn_end;
}

decare_war_on_imperium_audiences();

if ((obj_controller.faction_gender[10] == 1) && (obj_controller.known[eFACTION.CHAOS] == 0) && (obj_controller.faction_defeated[10] == 0)) {
    scr_audience(10, "intro");
}

with (obj_star) {
    if ((p_owner[1] == 1) || (p_owner[2] == 1) || (p_owner[3] == 1) || (p_owner[4] == 1)) {
        var heh = instance_create(x, y, obj_crusade);
        heh.radius = 64;
        heh.duration = 9999;
        heh.show = false;
        heh.placing = false;
        heh.alarm[1] = -1;
        // The Guard-into-PDF fold was removed here. It used to run, every turn, for
        // each player world: p_pdf += p_guardsmen; p_guardsmen = 0. That quietly ate the
        // Imperial Guard you raise and deploy, folding them back into the abstract PDF and
        // zeroing the deployable pool. Recruited Guard now persist as their own pool until
        // you embark them, and recruitment pulls bodies the other way (PDF into Guard), so
        // folding them back would undo it.
    }
}

if (instance_exists(obj_fleet)) {
    instance_deactivate_object(obj_star);
}
