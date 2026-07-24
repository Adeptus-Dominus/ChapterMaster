fade_alpha = (global.returned > 0) ? 0 : 1.0;
title_alpha = 0;
cooldown = 0;
update_blink_visible = false;

global.audio_manager.play_playlist(CONTEXT_MENU, (global.returned > 0) ? 0 : 5000);

if (instance_exists(obj_cursor)) {
    obj_cursor.image_alpha = (global.returned > 0) ? 1 : 0;
}
