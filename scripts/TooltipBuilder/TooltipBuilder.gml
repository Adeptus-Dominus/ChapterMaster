/// @desc Enum representing the formatting style for tooltip values.
enum eTOOLTIP_VALUE_TYPE {
    DEFAULT,
    SIGNED,
    PERCENTAGE,
    SIGNED_PERCENTAGE,
    MULTIPLIER,
}

/// @desc Universal sectioned tooltip builder with dynamic, insertion-ordered sections.
function TooltipBuilder() constructor {
    __sections = {};
    __section_order = [];
    __header = "";

    /// @desc Explicitly registers a section to guarantee its layout position early.
    /// @param {String} _section_id
    /// @param {String} _section_header optional header displayed above the section's lines
    /// @return {Struct.TooltipBuilder}
    static add_section = function(_section_id, _section_header = "") {
        if (!struct_exists(__sections, _section_id)) {
            __sections[$ _section_id] = {
                header: _section_header,
                lines: [],
            };
            array_push(__section_order, _section_id);
        }

        return self;
    };

    /// @desc Sets the primary header for the tooltip.
    /// @param {String} _text
    /// @return {Struct.TooltipBuilder}
    static set_header = function(_text) {
        __header = _text;
        return self;
    };

    /// @desc Appends a raw line of text directly to a specific section.
    /// @param {String} _section_id
    /// @param {String} _text
    /// @return {Struct.TooltipBuilder}
    static add_line = function(_section_id, _text) {
        add_section(_section_id);
        array_push(__sections[$ _section_id].lines, _text);
        return self;
    };

    /// @desc Formats and adds a labeled entry to a section.
    /// @param {String} _section_id
    /// @param {String} _label
    /// @param {Any} _value
    /// @param {String} _prefix
    /// @param {String} _suffix
    /// @return {Struct.TooltipBuilder}
    static add_entry = function(_section_id, _label, _value, _prefix = "", _suffix = "") {
        return add_line(_section_id, $"{_label}: {_prefix}{_value}{_suffix}");
    };

    /// @desc Formats and adds a labeled entry to a section using a predefined value type.
    /// @param {String} _section_id
    /// @param {String} _label
    /// @param {Any} _value
    /// @param {Enum.eTOOLTIP_VALUE_TYPE} _type
    /// @return {Struct.TooltipBuilder}
    static add_entry_typed = function(_section_id, _label, _value, _type = eTOOLTIP_VALUE_TYPE.DEFAULT) {
        var _val_str = string(_value);
        var _is_num = is_real(_value);

        switch (_type) {
            case eTOOLTIP_VALUE_TYPE.SIGNED:
                if (_is_num && _value > 0) {
                    _val_str = "+" + _val_str;
                }

                break;

            case eTOOLTIP_VALUE_TYPE.PERCENTAGE:
                _val_str = _val_str + "%";
                break;

            case eTOOLTIP_VALUE_TYPE.SIGNED_PERCENTAGE:
                _val_str = _val_str + "%";
                if (_is_num && _value > 0) {
                    _val_str = "+" + _val_str;
                }

                break;

            case eTOOLTIP_VALUE_TYPE.MULTIPLIER:
                _val_str = "x" + _val_str;
                break;

            case eTOOLTIP_VALUE_TYPE.DEFAULT:
            default:
                break;
        }

        return add_line(_section_id, $"{_label}: {_val_str}");
    };

    /// @desc Compiles the registered sections into a single formatted string.
    /// @param {Bool} _separate if true, inserts an empty line between sections
    /// @return {String}
    static build = function(_separate = false) {
        var _parts = [];

        if (__header != "") {
            array_push(_parts, __header);
        }

        var _section_blocks = [];
        for (var i = 0; i < array_length(__section_order); i++) {
            var _section_id = __section_order[i];
            var _section = __sections[$ _section_id];
            var _lines = _section.lines;
            if (array_length(_lines) > 0) {
                var _block = [];
                if (_section.header != "") {
                    array_push(_block, _section.header);
                }

                array_push(_block, string_join_ext("\n", _lines));
                array_push(_section_blocks, string_join_ext("\n", _block));
            }
        }

        if (array_length(_section_blocks) > 0) {
            var _sep = _separate ? "\n\n" : "\n";
            array_push(_parts, string_join_ext(_sep, _section_blocks));
        }

        return string_join_ext("\n", _parts);
    };
}
