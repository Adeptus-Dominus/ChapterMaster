/// @desc Loads and queries localized strings stored in datafiles/lang/<language_code>.json.
///       English text is used as the translation key, so missing translations neatly fall back to it.
function LocalizationManager() constructor {
    language = "en";
    needs_cjk = false;
    translations = {};
    cjk_fonts = {};

    /// @param {string} _language Language code: "en", "zh", etc.
    static load_language = function(_language) {
        self.language = _language;
        self.needs_cjk = _language != "en" && string_count("zh", _language) > 0;

        var _path = working_directory + "/lang/" + _language + ".json";
        if (file_exists(_path)) {
            self.translations = json_to_gamemaker(_path, json_parse);
        } else {
            LOGGER.warning($"Language file not found: {_path}");
            self.translations = {};
        }
    };

    /// @param {string} _key English text used as the lookup key.
    /// @param {Array} _args (Optional) Values for {0}, {1}, ... placeholders.
    /// @returns {string}
    static translate = function(_key, _args = undefined) {
        var _value = self.translations[$ _key];
        if (is_undefined(_value) || !is_string(_value)) {
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