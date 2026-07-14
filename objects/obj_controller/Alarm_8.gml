// Excommunicatus Traitorus
instance_activate_object(obj_star);

decare_war_on_imperium_audiences();

if ((faction_gender[10] == 1) && (known[eFACTION.CHAOS] == 0) && (faction_defeated[10] == 0)) {
    scr_audience(10, "intro");
}

with (obj_star) {
    if ((p_owner[1] == eFACTION.PLAYER) || (p_owner[2] == eFACTION.PLAYER) || (p_owner[3] == eFACTION.PLAYER) || (p_owner[4] == eFACTION.PLAYER)) {
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
