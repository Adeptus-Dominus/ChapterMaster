/// @desc Loads and queries localized strings stored in datafiles/lang/<language_code>.json.
///       English text is used as the translation key, so missing translations neatly fall back to it.
function LocalizationManager() constructor {
    language = LANG_EN;
    needs_cjk = false;
    translations = {};
    cjk_fonts = {};

    /// @param {string} _language Language code: LANG_EN, LANG_ZH, etc.
    static load_language = function(_language) {
        self.language = _language;
        self.needs_cjk = _language != LANG_EN && string_count(LANG_ZH, _language) > 0;

        var _path = working_directory + "/lang/" + _language + ".json";
        if (file_exists(_path)) {
            var _parsed = json_to_gamemaker(_path, json_parse);
            if (is_struct(_parsed)) {
                self.translations = _parsed;
            } else {
                LOGGER.warning($"Language file parsed to a non-struct: {_path}");
                self.translations = {};
            }
        } else {
            LOGGER.warning($"Language file not found: {_path}");
            self.translations = {};
        }

        self._warn_missing_translations();
    };

    /// @desc Compares the loaded translations against the English source keys and
    ///       warns about keys that are missing, so edits to English UI text do not
    ///       silently sever translations across languages.
    static _warn_missing_translations = function() {
        if (self.language == LANG_EN || !is_struct(self.translations)) {
            return;
        }

        var _en_path = working_directory + "/lang/" + LANG_EN + ".json";
        if (!file_exists(_en_path)) {
            return;
        }

        var _en_translations = json_to_gamemaker(_en_path, json_parse);
        if (!is_struct(_en_translations)) {
            return;
        }

        var _en_keys = struct_get_names(_en_translations);
        var _missing_keys = [];
        for (var i = 0; i < array_length(_en_keys); i++) {
            if (!struct_exists(self.translations, _en_keys[i])) {
                array_push(_missing_keys, _en_keys[i]);
            }
        }

        if (array_length(_missing_keys) > 0) {
            LOGGER.warning($"Language '{self.language}' is missing {array_length(_missing_keys)} translations from '{LANG_EN}': {string_join(_missing_keys, ", ")}");
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
            for (var i = 0; i < array_length(_args); i++) {
                _value = string_replace_all(_value, "{" + string(i) + "}", string(_args[i]));
            }
        }

        return _value;
    };

    /// @param {real} _size Point size used for the runtime fallback font.
    /// @param {real} _base_font The font asset intended for this text.
    /// @returns {real}
    static get_font = function(_size, _base_font) {
        if (!self.needs_cjk) {
            return _base_font;
        }

        var _key = string(_size);
        if (struct_exists(self.cjk_fonts, _key)) {
            return self.cjk_fonts[$ _key];
        }

        var _fallback_font = font_add(STR_CJK_FALLBACK_FONT, _size, false, false, 32, 65535);
        if (!font_exists(_fallback_font)) {
            LOGGER.error($"Failed to load CJK fallback font '{STR_CJK_FALLBACK_FONT}' at size {_size}. Chinese glyphs may render as blank boxes.");
            self.cjk_fonts[$ _key] = _base_font;
            return _base_font;
        }

        self.cjk_fonts[$ _key] = _fallback_font;
        return _fallback_font;
    };
}

/// @desc Global shorthand for speaking localized text. Falls back to the raw English key.
/// @param {string} _key English text used as the localization key.
/// @param {Array} _args (Optional) Values substituted into {0}, {1}, ... placeholders.
/// @returns {string}
function localize(_key, _args = undefined) {
    if (variable_global_exists("localization_manager")) {
        return global.localization_manager.translate(_key, _args);
    }
    return _key;
}

/// @desc Global shorthand for a font suitable for the current language, deriving
///       the point size from the base font asset so callers never hardcode sizes.
/// @param {real} _base_font The font asset intended for this text.
/// @returns {real}
function cjk_font(_base_font) {
    var _size = font_get_size(_base_font);
    if (variable_global_exists("localization_manager")) {
        return global.localization_manager.get_font(_size, _base_font);
    }
    return _base_font;
}
