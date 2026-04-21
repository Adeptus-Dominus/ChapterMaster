if (num > 0) {
    // Hmmmmmmm
    var stah;
    stah = instance_nearest(x, y, obj_star);
    obj_controller.menu = 0;

    if (planet_feature_bool(stah.p_feature[num], eP_FEATURES.STC_FRAGMENT) == 1) {
        // STC is present
    }

    if (planet_feature_bool(stah.p_feature[num], eP_FEATURES.ARTIFACT) == 1) {
        // Artifact is present
    }
}
