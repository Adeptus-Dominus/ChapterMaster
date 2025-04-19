function scr_battle_count(){

    // Check if the count is positive and a multiple of 6
    if (obj_controller.enemies_cleared_count > 0 && (obj_controller.enemies_cleared_count % 6 == 0)) {

        // --- ACTION TO PERFORM EVERY 6 CLEARS ---

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
        // Alert doesn't seem to work, probably because of UI
        scr_alert(c_blue, "reward", $"{_text_choice.alert}");
        scr_event_log(c_blue, $"{_text_choice.log}");

        // --- Apply disposition bonuses
             #macro FACT_DISPO obj_controller.disposition
             FACT_DISPO[eFACTION.Imperium] = clamp(FACT_DISPO[eFACTION.Imperium] + 8, -92, 100);
             FACT_DISPO[eFACTION.Mechanicus] = clamp(FACT_DISPO[eFACTION.Mechanicus] + 5, -95, 100);
             FACT_DISPO[eFACTION.Ecclesiarchy] = clamp(FACT_DISPO[eFACTION.Ecclesiarchy] + 6, -94, 100);
             FACT_DISPO[eFACTION.Inquisition] = clamp(FACT_DISPO[eFACTION.Inquisition] + 4, -96, 100);
        // --- END ACTION TO PERFORM ---
    }
}
