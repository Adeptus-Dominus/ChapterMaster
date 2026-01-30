/// @function string_upper_first
/// @description Capitalizes the first character in a string.
/// @param {string} _string
/// @returns {string}
function string_upper_first(_string) {
    try {
        var _first_char = string_char_at(_string, 1);
        var _modified_string = _string;
    
        _first_char = string_upper(_first_char);
        
        _modified_string = string_delete(_modified_string, 1, 1);
        _modified_string = string_insert(_first_char, _modified_string, 1);
    
        return _modified_string;
	}
    catch(_exception) {
        handle_exception(_exception);
	}
}

function string_gender_third_person(gender){
    var _string = "they";
    switch(gender){
        case GENDER.Female:
            _string = "she";
            break;
        case GENDER.Male:
            _string = "he";
            break;
    }

    return _string;
}


function string_gender_pronouns(gender){
     var _string = "their";
    switch(gender){
        case GENDER.Female:
            _string ="her"
            break;
        case GENDER.Male:
            _string ="his"
            break;
        case GENDER.Neutral:
            _string = "their";
            break;
    }

    return _string;
}


/// @function string_plural
/// @description This function formats a string into a plural form by adding affixes following common rules.
/// @param {string} _string
/// @param {real} _variable (Optional) Variable to check if more than 1 before converting to plural.
/// @returns {string} Modified string.
function string_plural(_string, _variable = 2) {
    if (_variable < 2) {
        return _string;
    }

    var _last_char = string_char_at(_string, string_length(_string));
    var _last_two_chars = string_copy(_string, string_length(_string) - 1, 2);
    if (_last_char == "y") {
        return string_copy(_string, 1, string_length(_string) - 1) + "ies";
    }
    else if (array_contains(["s", "x", "z", "ch", "sh"], _last_char)) {
        return _string + "es";
    }
    else if (_last_char == "f" || _last_two_chars == "fe") {
        return string_copy(_string, 1, string_length(_string) - string_length(_last_two_chars)) + "ves";
    }
    else {
        return _string + "s";
    }
}

/// @function string_plural_count
/// @description This function formats a string into a plural form by adding affixes following common rules, and adds the x(variable) text at the start.
/// @param {string} _string
/// @param {real} _variable Variable to check if more than 1 before converting to plural, and add at the start.
/// @returns {string} Modified string.
function string_plural_count(_string, _variable, _use_x = true) {
    var _x = _use_x ? "x" : "";
    var _modified_string = $"{_variable}{_x} {string_plural(_string, _variable)}";
    return _modified_string;
}

/// @function string_truncate
/// @description Truncates a string to fit within a specified pixel width, appending "..." if the string was truncated.
/// @param {string} _string
/// @param {real} _max_width The maximum allowable pixel width for the string.
/// @returns {string}
function string_truncate(_string, _max_width) {
    var _ellipsis = "...";
    var _ellipsis_width = string_width(_ellipsis);
    var _text_width = string_width(_string);
    if (_text_width > _max_width) {
        var i = string_length(_string);
        while (_text_width + _ellipsis_width > _max_width && i > 0) {
            i--;
            _string = string_delete(_string, i+1, 1);
            _text_width = string_width(_string + _ellipsis);
        }
        return _string + _ellipsis;
    } else {
        return _string;
    }
}

/// @function integer_to_words
/// @description Converts an integer to an english word.
/// @param {real} _integer
/// @param {bool} _capitalize_first Capitalize first letter of the resulting word?
/// @param {bool} _ordinal Use ordinal form?
/// @returns {string}
function integer_to_words(_integer, _capitalize_first = false, _ordinal = false) {
    var _ones = [];
    var _teens = [];
    var _tens = [];
    var _thousands = [];

    if (_ordinal) {
        _ones = ["zeroth", "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth"];
        _teens = ["tenth", "eleventh", "twelfth", "thirteenth", "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth", "nineteenth"];
        _tens = ["", "tenth", "twentieth", "thirtieth", "fortieth", "fiftieth", "sixtieth", "seventieth", "eightieth", "ninetieth"];
        _thousands = ["", "thousandth", "millionth", "billionth"];
    } else {
        _ones = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
        _teens = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"];
        _tens = ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];
        _thousands = ["", "thousand", "million", "billion"];
    }

    var _num_str = "";
    var _num_int = floor(real(_integer));

    if (_num_int < 10) {
        _num_str += _ones[_num_int];
    } else if (_num_int < 20) {
        _num_str += _teens[_num_int - 10];
    } else if (_num_int < 100) {
        _num_str += _tens[floor(_num_int / 10)] + (_num_int % 10 != 0 ? " " + _ones[_num_int % 10] : "");
    } else if (_num_int < 1000) {
        _num_str += _ones[floor(_num_int / 100)] + " hundred" + (_num_int % 100 != 0 ? " " + integer_to_words(_num_int % 100) : "");
    } else {
        for (var _i = 0; _num_int > 0; _i += 1) {
            if (_num_int % 1000 != 0) {
                var _part = integer_to_words(_num_int % 1000);
                _num_str = _part + " " + _thousands[_i] + (_num_str != "" ? " " : "") + _num_str;
            }
            _num_int = floor(_num_int / 1000);
        }
    }

    _num_str = string_trim(_num_str);

    if (_capitalize_first) {
        _num_str = string_upper_first(_num_str);
    }

    return _num_str;
}

/// @function string_reverse
/// @description Returns the string written backwards.
/// @param {string} _string
/// @returns {string}
function string_reverse(_string) {
	var str,length,i,out,char;
	str=_string
	out=""
	length=string_length(_string)
	for(i=0;i<string_length(_string);i+=1){
        char=string_char_at(str,length-i)
        out+=char
	}
	return out;
}

/// @function string_rpos
/// @description Returns the right-most position of the given substring within the given string.
/// @param {string} _sub_string
/// @param {string} _string
/// @returns {real}
function string_rpos(_sub_string, _string) {
	/*
	**  Usage:
	**      string_rpos(substr,str)
	**
	**  Arguments:
	**      substr      a substring of text
	**      str         a string of text
	**
	**  Returns:
	**      the right-most position of the given
	**      substring within the given string
	*/

    var sub,str,pos,ind;
    sub = _sub_string;
    str = _string;
    pos = 0;
    ind = 0;
    do {
        pos += ind;
        ind = string_pos(sub,str);
        str = string_delete(str,1,ind);
    } until (ind == 0);
    return pos;
}

/// @function scr_convert_company_to_string
/// @description Accepts a number and adds an affix to convert it to ordinal form.
/// @param {real} company_num Company number.
/// @param {bool} possessive Add 's affix?
/// @param {bool} flavour Add company designation text (Veteran, Battle, Reserve, etc.)?
/// @returns {string}
function scr_convert_company_to_string(company_num, possessive = false, flavour=false){
	var _company_num = company_num;
	var _suffixes = ["st", "nd", "rd", "th", "th", "th", "th", "th", "th", "th", "th"];
	var _flavours = ["Veteran", "Battle", "Battle", "Battle", "Battle", "Reserve", "Reserve", "Reserve", "Reserve", "Scout"];
	var _str_company = possessive ? "Company's" : "Company";

	if (_company_num < 1) || (_company_num > 10) {
		return "";	
	} else {
		var _flavour_text = flavour ? _flavours[_company_num - 1] : "";
		_company_num = string(_company_num) + _suffixes[_company_num - 1];
		var _converted_string = string_join(" ", _company_num, _flavour_text, _str_company);
		return _converted_string;
	}
}

/* This was used to generate random game seed. Now randomise() and random_get_seed() are used.
/// @function string_to_integer
/// @description Converts a string into an integer sum where a=1, b=2, ..., z=26.
/// @param {string} _string The input text to convert.
/// @returns {real}
// The purpose of this is to allow a marine's
// name to generate a semi-unique variable for the future display of veterency
// decorations when inspected in management.  Whether it is odd, from 0-9, and so
// on can determine what shows on their picture at certain experience values.
function string_to_integer(_string) {
    var _total_val = 0;
    var _lower_str = string_lower(_string);
    var _len = string_length(_lower_str);

    for (var i = 1; i <= _len; i++) {
        // Get the ASCII/UTF-8 value of the character (1-indexed in GML)
        var _char_code = string_ord_at(_lower_str, i);

        // In ASCII: 'a' is 97. Subtracting 96 makes 'a' = 1, 'b' = 2, etc.
        if (_char_code >= 97 && _char_code <= 122) {
            _total_val += (_char_code - 96);
        }
    }

    return _total_val;
}
 */

/// @description Replaces underscores with spaces and capitalizes the first letter of each word.
function format_underscore_string(input_string) {
    // Split the string into words
    var words = string_split(input_string, "_");
    var result = "";
    
    // Loop through each word and capitalize the first letter
    for (var i = 0; i < array_length(words); i++)
    {
        // Capitalize the first character and concatenate it with the rest of the word
        var word = string_upper_first(words[i]);
        result += word;
        
        // Add a space after each word (except for the last one)
        if (i < array_length(words) - 1) {
            result += " ";
        }
    }
    
    return result;
}

/// @description This function will convert a string into a base64 format encoded string, using an intermediate buffer, to prevent stack overflow due to big input strings.
/// @param {string} input_string
/// @return {string}
function base64_encode_advanced(input_string) {
    var _buffer = buffer_create(1, buffer_grow, 1);
    buffer_write(_buffer, buffer_string, input_string);
    var _encoded_string = buffer_base64_encode(_buffer, 0, buffer_get_size(_buffer));
    buffer_delete(_buffer);

    return _encoded_string;
}

/// @description Transforms a verb based on the plurality of a variable.
/// @param {string} _verb The verb to be transformed (e.g., "was", "is", "has", etc.).
/// @param {number} _variable A value determining singular (1) or plural (any value other than 1).
/// @returns {string}
function smart_verb(_verb, _variable) {
    var _result = _verb;

    if (_variable != 1) {
        switch (_verb) {
            case "was":
                _result = "were";
                break;
            case "is":
                _result = "are";
                break;
            case "has":
                _result = "have";
                break;
            case "do":
                _result = "do";
                break;
            default:
                _result = _verb;
                break;
        }
    }

    return _result;
}

/// @desc Checks if a string starts with any prefix in the given array.
/// @param {string} _str - The string to check.
/// @param {array<string>} _prefixes - An array of string prefixes to match against.
/// @returns {boolean}
function string_starts_with_any(_str, _prefixes) {
    for (var i = 0, _len = array_length(_prefixes); i < _len; ++i) {
        if (string_starts_with(_str, _prefixes[i])) {
            return true;
        }
    }
    return false;
}


//this can be way more efficient nby reading the string and finding keys rather than the other way around but until it satrts to cause issues i ccan;t be assed
function string_interpolate_from_struct(interpolate_string,data){
    var _names=struct_get_names(data);
    var _name_length = array_length(_names);
    global.logger.debug(_names);
    for (var i=0;i<_name_length;i++){
        var _name=_names[i];
        var _replace_string = "{" + $"{_name}" + "}";
        global.logger.debug(_replace_string);
        interpolate_string = string_replace_all(interpolate_string, _replace_string, data[$_name]);
    }

    return interpolate_string;
}
