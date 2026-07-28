/// @desc Manages runtime-loaded audio (music + SFX) with built-in asset fallback.
/// Intended for use as `global.audio_manager` to handle all audio playback,
/// crossfading, and volume control.
///
/// Audio loading tiers (user overrides shipped):
/// 1. Shipped: `ChapterMaster/Audio/`
/// 2. User: `AppData/Local/ChapterMaster/Custom Files/Audio/`
///
/// Music uses a context/playlist system. Context folders under `Audio/Music/<context>/`
/// are scanned on discovery. Each context picks a random track from its folder.
/// Falls back to built-in `snd_*` assets if no external files are found.

// Context names for playlist-based playback.
#macro CONTEXT_MENU "menu"
#macro CONTEXT_SECTOR "sector"
#macro CONTEXT_BATTLE "battle"
#macro CONTEXT_CREATION "creation"
#macro CONTEXT_DEFEAT "defeat"
#macro CONTEXT_DIPLOMACY "diplomacy"
#macro CONTEXT_POSTBATTLE "postbattle"

// Music track names for built-in fallback and playlist resolution.
#macro MUSIC_PROLOGUE "prologue"
#macro MUSIC_ROYAL "royal"
#macro MUSIC_BLOOD "blood"
#macro MUSIC_BATTLE "battle"
#macro MUSIC_DIBOZ "diboz"
#macro MUSIC_DEFEAT "defeat"
#macro MUSIC_POSTBATTLE "postbattle"

// SFX name macros for use with play_sfx().
#macro SFX_CLICK "click"
#macro SFX_CLICK_SMALL "click_small"
#macro SFX_ERROR "error"
#macro SFX_BUZZ "buzz"
#macro SFX_END_TURN "end_turn"
#macro SFX_IDENTIFY "identify"
#macro SFX_STC "stc"

function AudioManager() constructor {
    audio_group_set_gain(audiogroup_music, 1.0);
    audio_group_set_gain(audiogroup_sfx, 1.0);

    // ###### Constants ######

    AUDIO_DIR = working_directory + "Audio/";
    MUSIC_DIR = AUDIO_DIR + "Music/";
    SFX_DIR = AUDIO_DIR + "SFX/";

    USER_AUDIO_DIR = "Custom Files/Audio/";
    USER_MUSIC_DIR = USER_AUDIO_DIR + "Music/";
    USER_SFX_DIR = USER_AUDIO_DIR + "SFX/";

    DEFAULT_CROSSFADE_MS = 2000;
    DEFAULT_STOP_FADE_MS = 500;

    FILE_EXT = ".ogg";

    // Maps a logical name to the compile-time `snd_*` asset.
    // Used when no external file exists for that name.
    BUILTIN_MUSIC = {
        MUSIC_PROLOGUE: snd_prologue,
        MUSIC_ROYAL: snd_royal,
        MUSIC_BLOOD: snd_blood,
        MUSIC_BATTLE: snd_battle,
        MUSIC_DIBOZ: snd_diboz,
        MUSIC_DEFEAT: snd_defeat,
        MUSIC_POSTBATTLE: snd_postbattle,
    };

    BUILTIN_SFX = {
        SFX_CLICK: snd_click,
        SFX_CLICK_SMALL: snd_click_small,
        SFX_ERROR: snd_error,
        SFX_BUZZ: snd_buzz,
        SFX_END_TURN: snd_end_turn,
        SFX_IDENTIFY: snd_identify,
        SFX_STC: snd_stc,
    };

    // Maps context name to built-in track names for fallback.
    // When no external files are found, a random track from this list is used.
    CONTEXT_FALLBACK = {
        CONTEXT_MENU: [MUSIC_PROLOGUE],
        CONTEXT_SECTOR: [MUSIC_ROYAL],
        CONTEXT_BATTLE: [MUSIC_BATTLE],
        CONTEXT_CREATION: [MUSIC_DIBOZ],
        CONTEXT_DEFEAT: [MUSIC_DEFEAT],
        CONTEXT_DIPLOMACY: [MUSIC_BLOOD],
        CONTEXT_POSTBATTLE: [MUSIC_POSTBATTLE],
    };

    // ###### Public ######

    /// @type {String}
    /// Name of the currently playing music track (empty = none).
    current_audio_name = "";

    /// @type {Real}
    /// Audio instance index of the currently playing music, or -1.
    current_audio_id = -1;

    /// @type {String}
    /// Context of the currently playing music ("battle", "menu", ...).
    /// Empty if the last call was to `play_track()`.
    current_context = "";

    // ###### Private ######

    /// @type {Real}
    /// Volume applied to music (0-1).
    __music_volume = 1.0;

    /// @type {Real}
    /// Volume applied to SFX (0-1).
    __sfx_volume = 1.0;

    // Map: filename (no extension) -> externally-loaded audio index.
    __music_cache = {};
    __sfx_cache = {};

    // Map: context name -> array of track names in that context's playlist.
    __context_playlists = {};

    // Map: context name -> array of tracks
    __context_queues = {};

    // ###### Private Methods ######

    /// @desc Scans a directory for .ogg files and adds their names (without extension) to a map.
    /// @param {String} _dir The directory to scan (must end with a slash)
    /// @param {Struct} _map The struct to populate with track names
    /// @returns {Real} The number of files found in this directory
    static __scan_audio_dir = function(_dir, _map) {
        var _count = 0;
        try {
            var _file = file_find_first(_dir + "*" + FILE_EXT, fa_none);
            while (_file != "") {
                var _name = filename_name(_file);
                _name = string_replace(_name, FILE_EXT, "");
                _map[$ _name] = true;
                _count++;
                _file = file_find_next();
            }

            return _count;
        } catch (_ex) {
            ERROR_HANDLER.handle_exception(_ex);
            return _count;
        } finally {
            file_find_close();
        }
    };

    /// @desc Attempts to load and cache a streamed sound from two candidate paths.
    /// @param {Struct} _cache The cache struct to use
    /// @param {String} _key The cache key/track name
    /// @param {String} _user_path The user file path
    /// @param {String} _shipped_path The shipped file path
    /// @returns {Real} audio index, or -1 if neither path produces a valid stream.
    static __load_stream = function(_cache, _key, _user_path, _shipped_path) {
        if (struct_exists(_cache, _key)) {
            return _cache[$ _key];
        }

        var _paths = [
            _user_path,
            _shipped_path,
        ];

        for (var i = 0; i < 2; i++) {
            if (!file_exists(_paths[i])) {
                continue;
            }

            var _id = audio_create_stream(_paths[i]);
            if (_id >= 0) {
                _cache[$ _key] = _id;
                return _id;
            }

            LOGGER.warning($"AudioManager: failed to stream '{_key}' from ${_paths[i]}");
        }

        return -1;
    };

    /// @desc Resolves a music track name to an audio index.
    /// Priority: cached external > user external > shipped external > built-in.
    /// Does not search context sub-folders; use `__resolve_context_track()` for playlist tracks.
    /// @param {String} _name track name (without extension)
    /// @returns {Real} audio index, or -1 if nothing found
    static __get_music = function(_name) {
        var _user_path = USER_MUSIC_DIR + _name + FILE_EXT;
        var _shipped_path = MUSIC_DIR + _name + FILE_EXT;
        var _id = __load_stream(__music_cache, _name, _user_path, _shipped_path);

        if (_id >= 0) {
            return _id;
        }

        if (struct_exists(BUILTIN_MUSIC, _name)) {
            return BUILTIN_MUSIC[$ _name];
        }

        return -1;
    };

    /// @desc Resolves an SFX name to an audio index.
    /// Priority: cached external > user external > shipped external > built-in.
    /// @param {String} _name sound name (without extension)
    /// @returns {Real} audio index, or -1 if nothing found
    static __get_sfx = function(_name) {
        var _user_path = USER_SFX_DIR + _name + FILE_EXT;
        var _shipped_path = SFX_DIR + _name + FILE_EXT;
        var _id = __load_stream(__sfx_cache, _name, _user_path, _shipped_path);

        if (_id >= 0) {
            return _id;
        }

        if (struct_exists(BUILTIN_SFX, _name)) {
            return BUILTIN_SFX[$ _name];
        }

        return -1;
    };

    /// @desc Resolves a context track name to an audio index.
    /// Checks user context dir first, then shipped context dir.
    /// Results are cached with a compound key to avoid collisions.
    /// @param {String} _context context name
    /// @param {String} _name    track name
    /// @returns {Real} audio index, or -1 if not found
    static __resolve_context_track = function(_context, _name) {
        var _user_path = USER_MUSIC_DIR + _context + "/" + _name + FILE_EXT;
        var _shipped_path = MUSIC_DIR + _context + "/" + _name + FILE_EXT;
        var _id = __load_stream(__music_cache, _context + "/" + _name, _user_path, _shipped_path);

        return _id;
    };

    /// @desc Destroys all streamed audio in the given cache.
    static __flush_cache = function(_cache) {
        var _keys = struct_get_names(_cache);
        for (var i = 0; i < array_length(_keys); i++) {
            var _id = _cache[$ _keys[i]];
            if (_id >= 0) {
                audio_destroy_stream(_id);
            }
        }
    };

    // ###### Public Methods ######

    /// @desc Scans shipped and user audio directories, builds track lists for
    /// root music/SFX and per-context playlists. Safe to call multiple times.
    /// @returns {Real} total number of audio files found
    static discover = function() {
        cleanup();

        var _total = 0;
        var _map = {};

        // Ensure all base directories exist
        file_ensure_directory(AUDIO_DIR);
        file_ensure_directory(MUSIC_DIR);
        file_ensure_directory(SFX_DIR);
        file_ensure_directory(USER_AUDIO_DIR);
        file_ensure_directory(USER_MUSIC_DIR);
        file_ensure_directory(USER_SFX_DIR);

        var _contexts = struct_get_names(CONTEXT_FALLBACK);
        for (var i = 0; i < array_length(_contexts); i++) {
            file_ensure_directory(MUSIC_DIR + _contexts[i] + "/");
            file_ensure_directory(USER_MUSIC_DIR + _contexts[i] + "/");
        }

        // Root music files (shipped + user)
        _map = {};
        _total += __scan_audio_dir(MUSIC_DIR, _map);
        _total += __scan_audio_dir(USER_MUSIC_DIR, _map);

        // Root SFX files (shipped + user)
        _map = {};
        _total += __scan_audio_dir(SFX_DIR, _map);
        _total += __scan_audio_dir(USER_SFX_DIR, _map);

        // Context playlists (shipped + user, user same-name overrides)
        for (var i = 0; i < array_length(_contexts); i++) {
            var _ctx = _contexts[i];
            _map = {};

            _total += __scan_audio_dir(MUSIC_DIR + _ctx + "/", _map);
            _total += __scan_audio_dir(USER_MUSIC_DIR + _ctx + "/", _map);

            __context_playlists[$ _ctx] = struct_get_names(_map);
        }

        return _total;
    };

    /// @desc Plays a specific named track with crossfade.
    /// Resolves the name from root music dirs + built-in fallback.
    /// When `_audio_id` is provided (by `play_playlist` for context tracks),
    /// the lookup is bypassed and the given audio index is used directly.
    /// @param {String} _name track name (without extension)
    /// @param {Real} _fade_ms crossfade duration in ms (default DEFAULT_CROSSFADE_MS)
    /// @param {Real} _audio_id optional pre-resolved audio index (internal)
    /// @param {String} _context optional context name (internal)
    /// @returns {Real} audio instance index, or -1 on failure
    static play_track = function(_name, _fade_ms = DEFAULT_CROSSFADE_MS, _audio_id = -1, _context = "") {
        if (_name == current_audio_name && current_audio_id >= 0 && audio_is_playing(current_audio_id)) {
            return current_audio_id;
        }

        var _id = _audio_id;
        if (_id < 0) {
            _id = __get_music(_name);
            if (_id < 0) {
                return -1;
            }
        }

        if (current_audio_id >= 0 && audio_is_playing(current_audio_id)) {
            audio_sound_gain(current_audio_id, 0, _fade_ms);

            var _old_id = current_audio_id;
            var _callback = predicate0(_old_id, function(_id_to_stop) {
                if (audio_exists(_id_to_stop)) {
                    audio_stop_sound(_id_to_stop);
                }
            });

            call_later(_fade_ms / 1000, time_source_units_seconds, _callback);
        }

        current_context = _context;
        current_audio_name = _name;
        current_audio_id = audio_play_sound(_id, 0, true, 0);
        audio_sound_gain(current_audio_id, __music_volume, _fade_ms);
        return current_audio_id;
    };

    /// @desc Plays a random track from a music context (playlist) with crossfade.
    /// External files in `audio/music/<context>/` are picked from first;
    /// if empty, a random built-in fallback is chosen instead.
    /// @param {String} _context context name (CONTEXT_* constant, e.g. CONTEXT_MENU)
    /// @param {Real} _fade_ms crossfade duration in ms (default DEFAULT_CROSSFADE_MS)
    /// @returns {Real} audio instance index, or -1 on failure
    static play_playlist = function(_context, _fade_ms = DEFAULT_CROSSFADE_MS) {
        if (!struct_exists(__context_queues, _context) || array_length(__context_queues[$ _context]) == 0) {
            var _tracks = struct_exists(__context_playlists, _context) ? __context_playlists[$ _context] : [];

            if (array_length(_tracks) == 0) {
                if (!struct_exists(CONTEXT_FALLBACK, _context)) {
                    LOGGER.warning($"AudioManager: no tracks or fallbacks for context '{_context}'");
                    return -1;
                }

                var _fallbacks = CONTEXT_FALLBACK[$ _context];
                return play_track(_fallbacks[irandom(array_length(_fallbacks) - 1)], _fade_ms, -1, _context);
            }

            var _queue = array_create(array_length(_tracks));
            array_copy(_queue, 0, _tracks, 0, array_length(_tracks));

            for (var i = array_length(_queue) - 1; i > 0; i--) {
                var j = irandom(i);
                var _temp = _queue[i];
                _queue[i] = _queue[j];
                _queue[j] = _temp;
            }

            // Prevent immediate repeat when the queue refills:
            // if the next-to-pop track matches the currently playing one, swap it out.
            if (current_audio_name != "" && array_length(_queue) > 1 && _queue[array_length(_queue) - 1] == current_audio_name) {
                var _swap = irandom(array_length(_queue) - 2);
                var _temp = _queue[array_length(_queue) - 1];
                _queue[array_length(_queue) - 1] = _queue[_swap];
                _queue[_swap] = _temp;
            }

            __context_queues[$ _context] = _queue;
        }

        var _chosen = array_pop(__context_queues[$ _context]);
        var _audio_id = __resolve_context_track(_context, _chosen);

        current_context = _context;
        return play_track(_chosen, _fade_ms, _audio_id, _context);
    };

    /// @desc Plays a sound effect once.
    /// @param {String} _name sound name (without extension)
    /// @param {Real} _priority  priority (default 0); lower = easier to cut
    /// @param {Bool} _loop loop the sound? (default false)
    /// @param {Real} _gain per-instance gain multiplier (default 1.0)
    /// @returns {Real} audio instance index, or -1 on failure
    static play_sfx = function(_name, _priority = 0, _loop = false, _gain = 1.0) {
        var _id = __get_sfx(_name);
        if (_id < 0) {
            return -1;
        }

        var _total_gain = _gain * __sfx_volume;
        return audio_play_sound(_id, _priority, _loop, _total_gain);
    };

    /// @desc Stops the current music with an optional fade-out.
    /// @param {Real} _fade_ms fade-out duration in ms (default DEFAULT_STOP_FADE_MS)
    static stop_music = function(_fade_ms = DEFAULT_STOP_FADE_MS) {
        if (current_audio_id >= 0 && audio_is_playing(current_audio_id)) {
            audio_sound_gain(current_audio_id, 0, _fade_ms);

            var _old_id = current_audio_id;
            var _callback = predicate0(_old_id, function(_id_to_stop) {
                if (audio_exists(_id_to_stop)) {
                    audio_stop_sound(_id_to_stop);
                }
            });

            call_later(_fade_ms / 1000, time_source_units_seconds, _callback);
        }

        current_audio_name = "";
        current_context = "";
        current_audio_id = -1;
    };

    /// @desc Updates the volume for music.
    /// Applies to both built-in and external tracks via per-sound gain.
    /// @param {Real} _vol volume (0-1)
    static set_music_volume = function(_vol) {
        __music_volume = clamp(_vol, 0, 1);
        if (current_audio_id >= 0 && audio_is_playing(current_audio_id)) {
            audio_sound_gain(current_audio_id, __music_volume, DEFAULT_STOP_FADE_MS);
        }
    };

    /// @desc Updates the volume for runtime-loaded SFX.
    /// Note: Does not retroactively adjust SFX that are already playing.
    /// @param {Real} _vol volume (0-1)
    static set_sfx_volume = function(_vol) {
        __sfx_volume = clamp(_vol, 0, 1);
    };

    /// @desc Frees all runtime-loaded audio resources.
    /// Call during game exit or when reloading audio assets.
    static cleanup = function() {
        __flush_cache(__music_cache);
        __flush_cache(__sfx_cache);

        __music_cache = {};
        __sfx_cache = {};
        __context_playlists = {};
        __context_queues = {};
        current_audio_name = "";
        current_context = "";
        current_audio_id = -1;
    };
}
