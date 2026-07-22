function awaken_tomb_event() {
    LOGGER.info("RE: Necron Tomb Awakens");
    var stars = scr_get_stars();

    var valid_stars = array_filter_ext(stars, function(star, index) {
        var tomb_world = scr_get_planet_with_feature(star, eP_FEATURES.NECRON_TOMB);

        if (tomb_world == -1) {
            return false;
        } else {
            return awake_tomb_world(star.p_feature[tomb_world]) == 0;
        }
    });

    if (valid_stars == 0) {
        LOGGER.info("RE: Necron Tomb Awakens, couldn't find a sleeping necron tomb");
        return false;
    }

    var star_index = irandom(valid_stars - 1);
    var star = stars[star_index];
    var planet = -1;
    for (var i = 1; i <= star.planets; i++) {
        if (awake_tomb_world(star.p_feature[i]) == 0) {
            awaken_tomb_world(star.p_feature[i]);
            planet = i;
            break;
        }
    }

    if (planet == -1) {
        LOGGER.info("RE: Necron Tomb Awakens, couldn't find a sleeping necron tomb planet");
        return false;
    }

    var text = string(star.name) + string(scr_roman(planet));
    scr_event_log("red", "The Necron Tomb on " + string(text) + " has surged into activity.");
    scr_popup("Necron Awakening", "The Necron Tomb on " + string(text) + " has surged into activity.  Rank upon rank of the abominations are pouring out from their tunnels.", "necron_tomb", "");
    var star_alert = instance_create(star.x + 16, star.y - 24, obj_star_event);
    star_alert.image_alpha = 1;
    star_alert.image_speed = 1;
    star_alert.col = "red";
    star.p_pdf[planet] = 0;
    // Necrons AWAKEN SLOWLY (§16b): the tomb surges to life, but the legions rise over turns rather than
    // instantly at full strength. Seed a starting awakened population; end_turn_race_population_growth
    // grows it while the tomb is awake, and that POPULATION (not a 0-6 level) drives the Necron force.
    if (variable_instance_exists(star, "p_race_pop")) {
        var _seed = necron_awaken_seed(star.p_type[planet]);
        star.p_race_pop[planet][eFACTION.NECRONS] = max(star.p_race_pop[planet][eFACTION.NECRONS], _seed);
        star.p_necrons[planet] = count_to_level(eFACTION.NECRONS, star.p_race_pop[planet][eFACTION.NECRONS]);
    } else {
        star.p_necrons[planet] = 6;
    }

    if (star.p_guardsmen[planet] < 2000000) {
        star.p_guardsmen[planet] = 0;
    }
    if (star.p_guardsmen[planet] >= 2000000) {
        star.p_guardsmen[planet] = round(star.p_guardsmen[planet] / 2);
    }
    return true;
}
