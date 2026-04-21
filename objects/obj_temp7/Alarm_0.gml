if (num > 0) {
    // Hmmmmmmm
    var stah;
    stah = instance_nearest(x, y, obj_star);
    obj_controller.menu = 0;

    if (has_problem_planet(num, "recon", stah)) {
        var pop;
        pop = instance_create(0, 0, obj_popup);
        pop.image = "inquisition";
        pop.title = "Investigation Completed";
        pop.text = "Your marines have scouted out " + string(stah.name) + " " + string(scr_roman(num)) + " and satisfied the mission requirements.";

        pop.add_option("Reload Marines");
        pop.add_option("Do Nothing");

        scr_event_log("", "Inquisition Mission Completed: Your Astartes have succesfully scouted " + string(stah.name) + " " + scr_roman(num) + ".");

        remove_planet_problem(num, "recon", stah);
    }
}
