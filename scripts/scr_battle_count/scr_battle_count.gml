function scr_battle_count(){

    // Check if the count is positive and a multiple of 10
    if (obj_controller.enemies_cleared_count > 0 && (obj_controller.enemies_cleared_count % 10 == 0)) {

        // --- ACTION TO PERFORM EVERY 10 CLEARS ---

        // --- Randomly Choose Flavor Text ---
        var _text_array = [
            {
                alert : "Word of your Chapter's tireless defence of the Sector reaches influential ears within the Imperium.",
                log : "Imperial Factions note the Chapter's continued effectiveness in purging threats."
            },
            {
                alert : "The efficiency of your recent purges has not gone unnoticed. Certain Imperial factions mark your Chapter's progress.",
                log : "Imperial elements acknowledge the Chapter's effectiveness against sector threats."
            },
            {
                alert : "Data-slate communiques confirm receipt of your operational summaries. Standard commendations issued.",
                log : "Administratum logs successful anti-xenos/heretic operations by the Chapter."
            },
            {
                alert : "Your Chapter's righteous fury against the enemies of Man strengthens the faith of nearby Imperial worlds.",
                log : "Tales of the Chapter's victories inspire piety and bolster relations with the faithful."
            },
            {
                alert : "Your Chapter continues its duties effectively.",
                log : "Chapter effectiveness noted by Imperial factions."
            }
        ]
        var _text_choice = array_random_element(_text_array);

        scr_alert(c_blue, $"{_text_choice.alert}");
        scr_event_log(c_blue, $"{_text_choice.log}");

        // --- Apply bonuses
	                obj_controller.loyalty+=5;
	                obj_controller.loyalty_hidden+=5;
        // --- END ACTION TO PERFORM ---
    }
}
