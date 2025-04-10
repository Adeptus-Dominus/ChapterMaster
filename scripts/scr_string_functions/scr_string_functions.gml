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

/// @function scr_convert_company_to_string
/// @description This script converts a word or longer string into an integer, with each letter corresponding to a value from 1-26.
/// @param {string} _string
/// @returns {real}
function string_to_integer(_string) {
	// The purpose of this is to allow a marine's
	// name to generate a semi-unique variable for the future display of veterency
	// decorations when inspected in management.  Whether it is odd, from 0-9, and so
	// on can determine what shows on their picture at certain experience values.

	var lol,m1,val;
	lol=_string;val=0;
	m1=string_length(lol);

    repeat(m1){
        if (string_lower(string_char_at(lol,0))="a") then val+=1;
        if (string_lower(string_char_at(lol,0))="b") then val+=2;
        if (string_lower(string_char_at(lol,0))="c") then val+=3;
        if (string_lower(string_char_at(lol,0))="d") then val+=4;
        if (string_lower(string_char_at(lol,0))="e") then val+=5;
        if (string_lower(string_char_at(lol,0))="f") then val+=6;
        if (string_lower(string_char_at(lol,0))="g") then val+=7;
        if (string_lower(string_char_at(lol,0))="h") then val+=8;
        if (string_lower(string_char_at(lol,0))="i") then val+=9;
        if (string_lower(string_char_at(lol,0))="j") then val+=10;
        if (string_lower(string_char_at(lol,0))="k") then val+=11;
        if (string_lower(string_char_at(lol,0))="l") then val+=12;
        if (string_lower(string_char_at(lol,0))="m") then val+=13;
        if (string_lower(string_char_at(lol,0))="n") then val+=14;
        if (string_lower(string_char_at(lol,0))="o") then val+=15;
        if (string_lower(string_char_at(lol,0))="p") then val+=16;
        if (string_lower(string_char_at(lol,0))="q") then val+=17;
        if (string_lower(string_char_at(lol,0))="r") then val+=18;
        if (string_lower(string_char_at(lol,0))="s") then val+=19;
        if (string_lower(string_char_at(lol,0))="t") then val+=20;
        if (string_lower(string_char_at(lol,0))="u") then val+=21;
        if (string_lower(string_char_at(lol,0))="v") then val+=22;
        if (string_lower(string_char_at(lol,0))="w") then val+=23;
        if (string_lower(string_char_at(lol,0))="x") then val+=24;
        if (string_lower(string_char_at(lol,0))="y") then val+=25;
        if (string_lower(string_char_at(lol,0))="z") then val+=26;
        lol=string_delete(lol,0,1);
    }
    return(val);
}

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
