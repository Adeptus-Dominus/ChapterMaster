/// @desc Loads and queries localized strings stored in datafiles/lang/<language_code>.json.
///       English text is used as the translation key, so missing translations neatly fall back to it.
/// @returns {Struct.LocalizationManager}
function LocalizationManager() constructor {
    CJK_FONT_LOAD_FAILED = -1;
    language = LANG_EN;
    needs_cjk = false;
    translations = {};
    cjk_fonts = {};
    resolved_fonts = {};
    font_styles = {};
    // Keys already warned about as missing this language load, so draw-time arrays do not
    // flood LOGGER.error every frame for the same gap. Reset on each language load.
    reported_missing = {};

    /// @desc Loads translations and font-resolution state for a language.
    /// @param {String} _language Language code: LANG_EN, LANG_ZH, etc.
    /// @returns {Undefined}
    static load_language = function(_language) {
        var _language_changed = self.language != _language;
        self.language = _language;
        self.needs_cjk = _language != LANG_EN && string_count(LANG_ZH, _language) > 0;
        self.translations = self._load_lang_file(_language);
        if (_language_changed) {
            self.resolved_fonts = {};
        }
        self.reported_missing = {};
        self._warn_missing_translations();
    };

    /// @desc Builds the path to a language's JSON file under datafiles/lang/.
    /// @param {string} _language Language code: LANG_EN, LANG_ZH, etc.
    /// @returns {string}
    static _lang_file_path = function(_language) {
        return working_directory + LANG_FILE_DIR + _language + LANG_FILE_EXT;
    };

    /// @desc Loads a language file and returns its translations as a struct, or an
    ///       empty struct (with a warning) when the file is missing or malformed.
    /// @param {string} _language Language code: LANG_EN, LANG_ZH, etc.
    /// @returns {Struct}
    static _load_lang_file = function(_language) {
        var _path = self._lang_file_path(_language);
        if (!file_exists(_path)) {
            LOGGER.warning($"Language file not found: {_path}");
            return {};
        }

        var _parsed = json_to_gamemaker(_path, json_parse);
        if (!is_struct(_parsed)) {
            LOGGER.warning($"Language file parsed to a non-struct: {_path}");
            return {};
        }

        return _parsed;
    };

    /// @desc Compares the loaded translations against the English source keys and
    ///       warns about keys that are missing, so edits to English UI text do not
    ///       silently sever translations across languages.
    static _warn_missing_translations = function() {
        if (self.language == LANG_EN || struct_names_count(self.translations) == 0) {
            return;
        }

        var _en_translations = self._load_lang_file(LANG_EN);
        var _en_keys = struct_get_names(_en_translations);
        var _missing_keys = [];
        for (var i = 0; i < array_length(_en_keys); i++) {
            if (!struct_exists(self.translations, _en_keys[i])) {
                array_push(_missing_keys, _en_keys[i]);
            }
        }

        if (array_length(_missing_keys) > 0) {
            LOGGER.warning($"Language '{self.language}' is missing {array_length(_missing_keys)} translations from '{LANG_EN}': {string_join_ext(", ", _missing_keys)}");
        }
    };

    /// @param {string} _key English text used as the lookup key.
    /// @param {Array} _args (Optional) Values for {0}, {1}, ... placeholders.
    /// @returns {string}
    static translate = function(_key, _args = undefined) {
        if (is_undefined(_key) || !is_string(_key) || !is_struct(self.translations)) {
            return is_string(_key) ? _key : "";
        }

        var _value = self.translations[$ _key];
        if (is_undefined(_value) || !is_string(_value) || _value == "") {
            _value = _key;
        }

        if (_args != undefined) {
            _value = string_substitute_args(_value, _args);
        }

        return _value;
    };

    /// @desc Localizes every entry of an array in one call, returning a new array. Each element
    ///       is treated as an English translation key (or a { text, variables } struct for
    ///       keys with {0}, {1} placeholders). Missing keys fall back to the English value and
    ///       are reported with LOGGER.error so translation gaps surface loudly instead of
    ///       silently showing the wrong language.
    /// @param {Array} _keys Array of English keys and/or { text, variables } structs.
    /// @returns {Array}
    static localize_array = function(_keys) {
        var _result = array_create(array_length(_keys), "");
        for (var i = 0; i < array_length(_keys); i++) {
            var _item = _keys[i];
            _result[i] = self._localize_item(_item);
        }
        return _result;
    };

    /// @desc Reports a missing translation key once per language load. Calling this from
    ///       _localize_item (which may run every draw frame for draw-time arrays) with an
    ///       un-deduplicated LOGGER.error would flood the log, so each key fires at most once
    ///       until the next load_language resets reported_missing.
    /// @param {string} _key The untranslated English key.
    static _report_missing = function(_key) {
        if (struct_exists(self.reported_missing, _key)) {
            return;
        }
        self.reported_missing[$ _key] = true;
        LOGGER.error($"No translation for '{_key}' in language '{self.language}'.");
    };

    /// @desc Localizes a single array entry: an English key, or a { text, variables } struct.
    ///       Empty values pass through untouched; missing keys fall back to English with a
    ///       once-per-language-load LOGGER.error warning.
    /// @param {string|Struct} _item English translation key or struct with placeholder data.
    /// @returns {string}
    static _localize_item = function(_item) {
        if (is_struct(_item)) {
            var _text = _item[$ LANG_ENTRY_TEXT];
            var _variables = struct_exists(_item, LANG_ENTRY_VARIABLES) ? _item[$ LANG_ENTRY_VARIABLES] : undefined;
            if (_text != "" && !struct_exists(self.translations, _text)) {
                self._report_missing(_text);
            }
            return self.translate(_text, _variables);
        }
        if (!is_string(_item) || _item == "") {
            return _item;
        }
        if (!struct_exists(self.translations, _item)) {
            self._report_missing(_item);
        }
        return self.translate(_item);
    };

    /// @desc Rebuilds the localized global faction_names display array from the pristine English
    ///       source (global.faction_names_en), translating once per language change instead of on
    ///       every draw frame. Translating from the constant English source each time makes the
    ///       call fully idempotent and round-trip safe: switching to another language and back to
    ///       English always restores the original English names. Call from
    ///       SettingsManager.apply_language().
    static refresh_locale_globals = function() {
        global.faction_names = self.localize_array(global.faction_names_en);
        global.chapter_strength_ratings = self.localize_array(global.chapter_strength_ratings_en);
        global.chapter_cooperation_ratings = self.localize_array(global.chapter_cooperation_ratings_en);
        global.chapter_geneseed_ratings = self.localize_array(global.chapter_geneseed_ratings_en);
        global.planet_forti = self.localize_array(global.planet_forti_en);
        global.presence_factions = self.localize_array(global.presence_factions_en);
        global.presence_blurbs = self.localize_array(global.presence_blurbs_en);
        global.planet_size = self.localize_array(global.planet_size_en);
    };

    /// @param {Real} _base_font The font asset intended for this text.
    /// @returns {Real}
    static get_font = function(_base_font) {
        if (!self.needs_cjk) {
            return _base_font;
        }

        var _font_id = string(_base_font);
        if (struct_exists(self.resolved_fonts, _font_id)) {
            return self.resolved_fonts[$ _font_id];
        }

        var _size = font_get_size(_base_font);
        var _style = self._get_font_style(_base_font);
        var _key = string(_size) + ":" + string(_style.bold) + ":" + string(_style.italic);
        var _fallback_font = self.CJK_FONT_LOAD_FAILED;
        if (struct_exists(self.cjk_fonts, _key)) {
            _fallback_font = self.cjk_fonts[$ _key];
        } else {
            _fallback_font = font_add(STR_CJK_FALLBACK_FONT, _size, _style.bold, _style.italic, 32, 65535);
            if (!font_exists(_fallback_font)) {
                LOGGER.error($"Failed to load CJK fallback font '{STR_CJK_FALLBACK_FONT}' at size {_size}. Chinese glyphs may render as blank boxes.");
                _fallback_font = self.CJK_FONT_LOAD_FAILED;
            }
            self.cjk_fonts[$ _key] = _fallback_font;
        }

        var _effective_font = _fallback_font == self.CJK_FONT_LOAD_FAILED ? _base_font : _fallback_font;
        self.resolved_fonts[$ _font_id] = _effective_font;
        return _effective_font;
    };

    /// @desc Returns a font's bold/italic style, cached per font asset so detection (and any
    ///       warnings) run once per session rather than on every draw call.
    /// @param {real} _base_font The font asset intended for this text.
    /// @returns {Struct}
    static _get_font_style = function(_base_font) {
        var _font_id = string(_base_font);
        if (struct_exists(self.font_styles, _font_id)) {
            return self.font_styles[$ _font_id];
        }

        var _style = self._font_style(_base_font);
        self.font_styles[$ _font_id] = _style;
        return _style;
    };

    /// @desc Resolves a font's bold/italic style. Styled fonts are declared explicitly in
    ///       font_style_overrides(); the name-suffix heuristic below is only a safety net and logs
    ///       a warning when it detects a styled font that is not declared, so adding or renaming a
    ///       font surfaces loudly instead of silently losing or gaining weight.
    /// @param {real} _base_font The font asset intended for this text.
    /// @returns {Struct}
    static _font_style = function(_base_font) {
        var _name = font_get_name(_base_font);
        var _overrides = font_style_overrides();
        if (struct_exists(_overrides, _name)) {
            return _overrides[$ _name];
        }

        var _style = {
            bold: false,
            italic: false,
        };
        var _len = string_length(_name);
        if (_len == 0) {
            return _style;
        }

        var _is_digit = function(_char) {
            return string_digits(_char) == _char;
        };

        var _last = string_char_at(_name, _len);
        if (_is_digit(_last)) {
            return _style;
        }
        if (_last != "b" && _last != "i") {
            return _style;
        }

        LOGGER.warning($"Font '{_name}' suggests bold/italic via its name suffix but is not declared in font_style_overrides(); add it there so the CJK fallback weight is explicit.");

        _style.bold = _last == "b";
        _style.italic = _last == "i";

        if (_len > 1) {
            var _prev = string_char_at(_name, _len - 1);
            if (_is_digit(_prev)) {
                return _style;
            }
            if (_last == "i" && _prev == "b") {
                _style.bold = true;
            } else if (_last == "b" && _prev == "i") {
                _style.italic = true;
            }
        }
        return _style;
    };
}

/// @desc Replaces {0}, {1}, ... placeholders in a string with the given arguments. Shared by
///       LocalizationManager.translate and the localize() fallback so interpolation behaves the
///       same whether or not the manager is loaded yet.
/// @param {string} _value The template string containing {0}, {1} placeholders.
/// @param {Array} _args Values substituted into the placeholders.
/// @returns {string}
function string_substitute_args(_value, _args) {
    var _count = array_length(_args);
    var _tokens = [];
    for (var i = 0; i < _count; i++) {
        var _token = chr(2) + "LOC_ARG_" + string(i) + chr(2);
        array_push(_tokens, _token);
        _value = string_replace_all(_value, "{" + string(i) + "}", _token);
    }
    for (var i = 0; i < _count; i++) {
        _value = string_replace_all(_value, _tokens[i], string(_args[i]));
    }
    return _value;
}

/// @desc Global shorthand for speaking localized text. Falls back to the English key, still
///       interpolating _args so placeholders never leak as literal "{0}" before the manager loads.
/// @param {string} _key English text used as the localization key.
/// @param {Array} _args (Optional) Values substituted into {0}, {1}, ... placeholders.
/// @returns {string}
function localize(_key, _args = undefined) {
    if (variable_global_exists("localization_manager")) {
        return global.localization_manager.translate(_key, _args);
    }
    if (_args != undefined) {
        return string_substitute_args(_key, _args);
    }
    return _key;
}

/// @desc Global shorthand for localizing every entry of an array in one call, mapping each
///       English element to the current language. Missing keys fall back to English and are
///       flagged with LOGGER.error.
/// @param {Array} _keys Array of English keys and/or { text, variables } structs.
/// @returns {Array}
function localize_array(_keys) {
    if (variable_global_exists("localization_manager")) {
        return global.localization_manager.localize_array(_keys);
    }
    return _keys;
}

/// @desc Global shorthand for a font suitable for the current language, deriving
///       the point size from the base font asset so callers never hardcode sizes.
/// @param {Real} _base_font The font asset intended for this text.
/// @returns {Real}
function cjk_font(_base_font) {
    if (!variable_global_exists("localization_manager") || !global.localization_manager.needs_cjk) {

        return _base_font;
    }

    return global.localization_manager.get_font(_base_font);
}

/// @desc Explicit registry of styled font assets used by the CJK fallback. The CJK runtime font
///       cannot preserve bold/italic, so styled fonts must be declared here; the name-suffix
///       heuristic in LocalizationManager._font_style() is only a safety net and warns loudly if a
///       styled-looking font is missing from this list. Add any future styled font here.
/// @returns {Struct}
function font_style_overrides() {
    static _overrides = {
        fnt_40k_14b: {
            bold: true,
            italic: false,
        },
        fnt_40k_30b: {
            bold: true,
            italic: false,
        },
        fnt_40k_12i: {
            bold: false,
            italic: true,
        },
        fnt_40k_14i: {
            bold: false,
            italic: true,
        },
    };
    return _overrides;
}
