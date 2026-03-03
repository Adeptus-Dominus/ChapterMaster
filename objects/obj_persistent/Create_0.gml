randomize();

global.settings = new SettingsManager();
global.settings.load();
global.settings.apply_video();
global.settings.apply_audio();

global.save_version = 0;
global.returned = 0;
global.debug = 0;
global.current_music = -1;
global.load = 0;
global.restart = 0;
global.cheat_req = false;
global.cheat_gene = false;
global.cheat_disp = false;
global.cheat_debug = false;
global.language = "en";

instance_create_depth(0, 0, 0, obj_garbage_collector);
instance_create_depth(0, 0, 0, obj_img);

audio_group_load(audiogroup_sfx);
audio_group_load(audiogroup_music);
