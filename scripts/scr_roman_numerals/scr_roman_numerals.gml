function scr_roman_numerals(){
	var roman_numerals = [
		"I",
		"II",
		"III",
		"IV",
		"V",
		"VI",
		"VII",
		"VIII",
		"IX",
		"X"
	];
	
	return roman_numerals;
}

function int_to_roman(_num) {
    if (_num < 1 || _num > 100) {
        return "";
    }
    
    var _roman_numerals = [
        100, "C", 90, "XC", 50, "L", 40, "XL",
        10, "X", 9, "IX", 5, "V", 4, "IV", 1, "I"
    ];
    
    var _result = "";
    var i = 0;
    
    while (_num > 0) {
        if (_num >= _roman_numerals[i]) {
            _result += _roman_numerals[i + 1];
            _num -= _roman_numerals[i];
        } else {
            i += 2;
        }
    }
    
    return _result;
}
