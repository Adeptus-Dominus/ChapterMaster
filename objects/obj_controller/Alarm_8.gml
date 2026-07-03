// Excommunicatus Traitorus
instance_activate_object(obj_star);

decare_war_on_imperium_audiences();

if ((faction_gender[10] == 1) && (known[eFACTION.CHAOS] == 0) && (faction_defeated[10] == 0)) {
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
        if (p_owner[1] == 1) {
            p_pdf[1] += p_guardsmen[1];
            p_guardsmen[1] = 0;
        }
        if (p_owner[2] == 1) {
            p_pdf[2] += p_guardsmen[2];
            p_guardsmen[2] = 0;
        }
        if (p_owner[3] == 1) {
            p_pdf[3] += p_guardsmen[3];
            p_guardsmen[3] = 0;
        }
        if (p_owner[4] == 1) {
            p_pdf[4] += p_guardsmen[4];
            p_guardsmen[4] = 0;
        }
    }
}

if (instance_exists(obj_fleet)) {
    instance_deactivate_object(obj_star);
}
