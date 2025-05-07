// This will execute before the first room of the game executes.
gml_pragma("global", "__global_object_depths()");

// @stitch-ignore-next-line: unused-function
function __global_object_depths() {
    // Initialise the global array that allows the lookup of the depth of a given object
    // GM2.0 does not have a depth on objects so on import from 1.x a global array is created
    // NOTE: MacroExpansion is used to insert the array initialisation at import time

    // insert the generated arrays here
    global.__objectDepths[0] = -10000; // obj_fleet
    global.__objectDepths[1] = 0; // obj_circular
    global.__objectDepths[2] = -9999; // obj_fleet_spawner
    global.__objectDepths[3] = 8; // obj_fleet_controller
    global.__objectDepths[4] = 5; // obj_p_ship
    global.__objectDepths[5] = 0; // obj_p_capital
    global.__objectDepths[6] = 0; // obj_p_cruiser
    global.__objectDepths[7] = 0; // obj_p_escort
    global.__objectDepths[8] = 0; // obj_p_small
    global.__objectDepths[9] = 0; // obj_p_th
    global.__objectDepths[10] = -3; // obj_p_assra
    global.__objectDepths[11] = 5; // obj_en_ship
    global.__objectDepths[12] = -2000; // obj_en_capital
    global.__objectDepths[13] = -2000; // obj_en_cruiser
    global.__objectDepths[14] = 0; // obj_en_inter
    global.__objectDepths[15] = 0; // obj_en_in
    global.__objectDepths[16] = 5; // obj_en_husk
    global.__objectDepths[17] = 5; // obj_al_ship
    global.__objectDepths[18] = 0; // obj_al_capital
    global.__objectDepths[19] = 0; // obj_al_cruiser
    global.__objectDepths[20] = 0; // obj_al_in
    global.__objectDepths[21] = 6; // obj_p_round
    global.__objectDepths[22] = 6; // obj_en_round
    global.__objectDepths[23] = 6; // obj_al_round
    global.__objectDepths[24] = 3; // obj_en_pulse
    global.__objectDepths[25] = -50; // obj_explosion
    global.__objectDepths[26] = -25000; // obj_ncombat
    global.__objectDepths[27] = -50000; // obj_centerline
    global.__objectDepths[28] = -30001; // obj_pnunit
    global.__objectDepths[29] = -30000; // obj_enunit
    global.__objectDepths[30] = -30000; // obj_nfort
    global.__objectDepths[31] = 0; // obj_temp1
    global.__objectDepths[32] = 0; // obj_temp2
    global.__objectDepths[33] = 0; // obj_temp3
    global.__objectDepths[34] = 0; // obj_ground_mission
    global.__objectDepths[35] = -9999999; // obj_temp5
    global.__objectDepths[36] = 0; // obj_temp6
    global.__objectDepths[37] = 0; // obj_temp7
    global.__objectDepths[38] = -5000; // obj_temp8
    global.__objectDepths[39] = 0; // obj_temp_inq
    global.__objectDepths[40] = 0; // obj_temp_arti
    global.__objectDepths[41] = 0; // obj_temp_build
    global.__objectDepths[42] = 0; // obj_temp_meeting
    global.__objectDepths[43] = -19990; // obj_credits
    global.__objectDepths[44] = -49; // obj_creation
    global.__objectDepths[45] = -50001; // obj_creation_popup
    global.__objectDepths[46] = -50; // obj_main_menu_buttons
    global.__objectDepths[47] = -1500; // obj_new_button
    global.__objectDepths[48] = -1102; // obj_managment_panel
    global.__objectDepths[49] = 0; // obj_restart_game
    global.__objectDepths[50] = 0; // obj_restart_vars
    global.__objectDepths[51] = -1005; // obj_formation_bar
    global.__objectDepths[52] = -21000; // obj_dropdown_sel
    global.__objectDepths[53] = 0; // obj_enemy_leftest
    global.__objectDepths[54] = 0; // obj_marine
    global.__objectDepths[55] = -3; // obj_p1_bullet
    global.__objectDepths[56] = -3; // obj_p1_bullet_miss
    global.__objectDepths[57] = 0; // obj_ork
    global.__objectDepths[58] = 0; // obj_main_menu
    global.__objectDepths[59] = -9999999; // obj_cuicons
    global.__objectDepths[60] = -9999999; // obj_img
    global.__objectDepths[61] = -999999; // obj_lol_version
    global.__objectDepths[62] = -20000; // obj_ingame_menu
    global.__objectDepths[63] = -7273799; // obj_fade
    global.__objectDepths[64] = -5; // obj_defeat
    global.__objectDepths[65] = 0; // obj_ini
    global.__objectDepths[66] = -21; // obj_controller
    global.__objectDepths[67] = -1001; // obj_mass_equip
    global.__objectDepths[68] = -999; // obj_turn_end
    global.__objectDepths[69] = -19990; // obj_saveload
    global.__objectDepths[70] = -60000; // obj_cursor
    global.__objectDepths[71] = -10; // obj_all_fleet
    global.__objectDepths[72] = -10; // obj_p_fleet
    global.__objectDepths[73] = -10; // obj_en_fleet
    global.__objectDepths[74] = -9; // obj_fleet_select
    global.__objectDepths[75] = -20; // obj_star_select
    global.__objectDepths[76] = -30; // obj_drop_select
    global.__objectDepths[77] = -30; // obj_bomb_select
    global.__objectDepths[78] = -19999; // obj_popup
    global.__objectDepths[79] = -19998; // obj_popup_dialogue
    global.__objectDepths[80] = -21000; // obj_event
    global.__objectDepths[81] = -900; // obj_event_log
    global.__objectDepths[82] = -1002; // obj_shop
    global.__objectDepths[83] = -1; // obj_crusade
    global.__objectDepths[84] = 0; // obj_star
    global.__objectDepths[85] = -1; // obj_star_event
    global.__objectDepths[86] = -999999999; // obj_halp
    global.__objectDepths[87] = -11; // obj_fleet_show


    global.__objectNames[0] = "obj_fleet";
    global.__objectNames[1] = "obj_circular";
    global.__objectNames[2] = "obj_fleet_spawner";
    global.__objectNames[3] = "obj_fleet_controller";
    global.__objectNames[4] = "obj_p_ship";
    global.__objectNames[5] = "obj_p_capital";
    global.__objectNames[6] = "obj_p_cruiser";
    global.__objectNames[7] = "obj_p_escort";
    global.__objectNames[8] = "obj_p_small";
    global.__objectNames[9] = "obj_p_th";
    global.__objectNames[10] = "obj_p_assra";
    global.__objectNames[11] = "obj_en_ship";
    global.__objectNames[12] = "obj_en_capital";
    global.__objectNames[13] = "obj_en_cruiser";
    global.__objectNames[14] = "obj_en_inter";
    global.__objectNames[15] = "obj_en_in";
    global.__objectNames[16] = "obj_en_husk";
    global.__objectNames[17] = "obj_al_ship";
    global.__objectNames[18] = "obj_al_capital";
    global.__objectNames[19] = "obj_al_cruiser";
    global.__objectNames[20] = "obj_al_in";
    global.__objectNames[21] = "obj_p_round";
    global.__objectNames[22] = "obj_en_round";
    global.__objectNames[23] = "obj_al_round";
    global.__objectNames[24] = "obj_en_pulse";
    global.__objectNames[25] = "obj_explosion";
    global.__objectNames[26] = "obj_ncombat";
    global.__objectNames[27] = "obj_centerline";
    global.__objectNames[28] = "obj_pnunit";
    global.__objectNames[29] = "obj_enunit";
    global.__objectNames[30] = "obj_nfort";
    global.__objectNames[31] = "obj_temp1";
    global.__objectNames[32] = "obj_temp2";
    global.__objectNames[33] = "obj_temp3";
    global.__objectNames[34] = "obj_ground_mission";
    global.__objectNames[35] = "obj_temp5";
    global.__objectNames[36] = "obj_temp6";
    global.__objectNames[37] = "obj_temp7";
    global.__objectNames[38] = "obj_temp8";
    global.__objectNames[39] = "obj_temp_inq";
    global.__objectNames[40] = "obj_temp_arti";
    global.__objectNames[41] = "obj_temp_build";
    global.__objectNames[42] = "obj_temp_meeting";
    global.__objectNames[43] = "obj_credits";
    global.__objectNames[44] = "obj_creation";
    global.__objectNames[45] = "obj_creation_popup";
    global.__objectNames[46] = "obj_main_menu_buttons";
    global.__objectNames[47] = "obj_new_button";
    global.__objectNames[48] = "obj_managment_panel";
    global.__objectNames[49] = "obj_restart_game";
    global.__objectNames[50] = "obj_restart_vars";
    global.__objectNames[51] = "obj_formation_bar";
    global.__objectNames[52] = "obj_dropdown_sel";
    global.__objectNames[53] = "obj_enemy_leftest";
    global.__objectNames[54] = "obj_marine";
    global.__objectNames[55] = "obj_p1_bullet";
    global.__objectNames[56] = "obj_p1_bullet_miss";
    global.__objectNames[57] = "obj_ork";
    global.__objectNames[58] = "obj_main_menu";
    global.__objectNames[59] = "obj_cuicons";
    global.__objectNames[60] = "obj_img";
    global.__objectNames[61] = "obj_lol_version";
    global.__objectNames[62] = "obj_ingame_menu";
    global.__objectNames[63] = "obj_fade";
    global.__objectNames[64] = "obj_defeat";
    global.__objectNames[65] = "obj_ini";
    global.__objectNames[66] = "obj_controller";
    global.__objectNames[67] = "obj_mass_equip";
    global.__objectNames[68] = "obj_turn_end";
    global.__objectNames[69] = "obj_saveload";
    global.__objectNames[70] = "obj_cursor";
    global.__objectNames[71] = "obj_all_fleet";
    global.__objectNames[72] = "obj_p_fleet";
    global.__objectNames[73] = "obj_en_fleet";
    global.__objectNames[74] = "obj_fleet_select";
    global.__objectNames[75] = "obj_star_select";
    global.__objectNames[76] = "obj_drop_select";
    global.__objectNames[77] = "obj_bomb_select";
    global.__objectNames[78] = "obj_popup";
    global.__objectNames[79] = "obj_popup_dialogue";
    global.__objectNames[80] = "obj_event";
    global.__objectNames[81] = "obj_event_log";
    global.__objectNames[82] = "obj_shop";
    global.__objectNames[83] = "obj_crusade";
    global.__objectNames[84] = "obj_star";
    global.__objectNames[85] = "obj_star_event";
    global.__objectNames[86] = "obj_halp";
    global.__objectNames[87] = "obj_fleet_show";


    // create another array that has the correct entries
    var len = array_length_1d(global.__objectDepths);
    global.__objectID2Depth = [];
    for( var i=0; i<len; ++i ) {
        var objID = asset_get_index( global.__objectNames[i] );
        if (objID >= 0) {
            global.__objectID2Depth[ objID ] = global.__objectDepths[i];
        } // end if
    } // end for


}
