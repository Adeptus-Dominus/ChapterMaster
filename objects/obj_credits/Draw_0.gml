draw_set_color(0);
draw_rectangle(918, 102, 1110, 610, 0);
draw_sprite(spr_credits_bg, 0, 0, 0);

draw_set_font(fnt_cul_18);
draw_set_halign(fa_center);
draw_set_color(c_gray);

draw_text_transformed(172, 373, string_hash_to_newline("LEAD PROGRAMMERS"), 0.85, 0.85, 0);
draw_set_font(fnt_cul_14);
draw_text(172, 397, string_hash_to_newline("ZAB#Mystic#NelsonH#EttyKitty"));
draw_set_font(fnt_cul_18);
draw_text_transformed(172, 472, string_hash_to_newline("CONTRIBUTORS&#SPECIAL THANKS"), 0.85, 0.85, 0);

draw_text(172, 526, string_hash_to_newline("vbcoder, Batat#Xorcon#IRC AFK'ers#/TG/"));

draw_text_transformed(492 - 100, 373, string_hash_to_newline("LEAD WRITERS"), 0.85, 0.85, 0);

draw_text(492 - 100, 397, string_hash_to_newline("Neddy#Nenjin#Pilz"));

draw_text_transformed(492 - 100, 472, string_hash_to_newline("ASSISTANT WRITERS"), 0.85, 0.85, 0);

draw_text(492 - 100, 498, string_hash_to_newline("Earthflame#Bludhawk#UCO Agent"));

draw_text_transformed(802 - 200, 373, string_hash_to_newline("LEAD ARTISTS"), 0.85, 0.85, 0);

draw_text(802 - 200, 397, string_hash_to_newline("Duke"));

draw_text_transformed(802 - 200, 472, string_hash_to_newline("ASSISTANT ARTISTS"), 0.85, 0.85, 0);

draw_text(802 - 200, 498, string_hash_to_newline("sinndogg#efngn#Toni ''TrashMan'' Stanicic"));

draw_text_transformed(802, 373, string_hash_to_newline("SUPPORTERS AND LEGACY CODERS"), 0.85, 0.85, 0);
// draw_text_transformed(802,472,"FORMER SUPPORTERS",0.85,0.85,0);

draw_text(802, 397, string_hash_to_newline("Duke#Paul-Ross#MANDOZERTHEGREAT#Alex Norry#Carli"));
// draw_text(802,496,"");

draw_set_font(fnt_cul_18);
draw_set_halign(fa_center);
draw_text_ext(room_width / 2, 706 - 25, string_hash_to_newline(obj_main_menu.legal_text), -1, 1406);

draw_set_font(fnt_cul_14);
draw_set_halign(fa_left);
draw_text_ext(991, 92 + 15, string_hash_to_newline(@"  Late 2011 /tg/ came up with the idea of Chapter Master- a Space Marine Chapter simulation game, set in the grim darkness of the 40k universe.  One good attempt was made to create it, and accomplished some very cool framework, but never progressed beyond a demo. 

  Starting over with a simpler programming language, this version is an almost one-man project, meant to bring what the discussions and threads always imagined.  It's been a year of keyboard face-rolling, but the amused reactions of neckbeards have been all worth it.  Hopefully you have as much fun playing Chapter Master as I did making it.

-Duke"), -1, 570);

// 253,96

var bhih;
bhih = 0;
if ((scr_hit(319, 307, 393, 324) == false) && (obj_main_menu.browser == 1)) {
    obj_main_menu.browser = 0;
}
if (scr_hit(319, 307, 393, 324) == true) {
    bhih = 1;
    if ((obj_main_menu.browser == 0) && scr_click_left()) {
        /*switch(show_question("Open your browser?")) {
        case 1:*/
        // url_open_ext( "http://planetofthebrandons.com/donate.html", "_blank");browser=1;
        if (obj_main_menu.blog_url != "Error") {
            url_open_ext(obj_main_menu.blog_url, "_blank");
        }
        obj_main_menu.browser = 1;
        // break;
        // }
    }
}
draw_text(257, 96, string_hash_to_newline("DukeFluffy"));
draw_text_ext_transformed(257, 96, string_hash_to_newline("#A hobbyist game producer with insomnia and way too much time on his hands.  Duke has created several pen and paper RPG's, namely ChromeStrike and the Morrowind RPG.  He has aspirations of one day working on robots."), -1, 208 * 1.1, 0.9, 0.9, 0);
draw_sprite(spr_blog, bhih, 319, 307);

if (fade_in > 0) {
    draw_set_color(0);
    draw_set_alpha(fade_in / 40);
    draw_rectangle(0, 0, room_width, room_height, 0);
    draw_set_alpha(1);
}

if (instance_exists(obj_main_menu_buttons)) {
    if (obj_main_menu_buttons.fade > 0) {
        draw_set_color(0);
        draw_set_alpha(obj_main_menu_buttons.fade / 40);
        draw_rectangle(0, 0, room_width, room_height, 0);
    }
    draw_set_alpha(1);
}
/* */
/*  */
