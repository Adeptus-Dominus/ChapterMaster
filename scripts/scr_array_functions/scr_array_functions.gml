

function array_iter_length(choice_array, offset, length){
	if (length == 0){
		if (offset==0){
			length = array_length(choice_array);
		}
		else if (offset){
			length = array_length(choice_array) - offset;
		} else {
			length = offset*-1;
		}
	}
	return length;
}
function array_sum(choice_array,start_value=0, offset=0,length=0){
	function arraysum(_prev, _curr, _index) {
	    return _prev + _curr;
	}

	length = array_iter_length(choice_array,offset,length);

	return array_reduce(choice_array,arraysum,start_value,offset,length)
}

function array_join(){
	var new_array = [];
	var add_array;
    for (var i = 0; i < argument_count; i ++)
    {
        add_array = argument[i];
        for (var r=0;r<array_length(add_array);r++){
        	array_push(new_array, add_array[r]);
        }
    }
    return 	new_array;
}

function array_find_value(search_array, value){
	var loc = -1;
	for (var i=0;i<array_length(search_array);i++){
		if (search_array[i] == value){
			loc = i;
			break;
		}
	}
	return loc;
}

function array_set_value(choice_array, value){
	for (var i=0;i<array_length(choice_array);i++){
		choice_array[@ i] = value;
	}
}

function array_replace_value(choice_array, value, r_value){
	for (var i=0;i<array_length(choice_array);i++){
		if (choice_array[i] == value ){
			choice_array[@ i] = r_value;
		}
	}
}

function array_random_element(choice_array){
	return choice_array[irandom(array_length(choice_array) - 1)];
}

function array_random_index(choice_array){
	return irandom(array_length(choice_array) - 1);
}

/// @function array_to_string_list
/// @description Converts an array into a string, with each element on a newline.
/// @param {array} stacktrace stacktrace.
/// @return {string}
function array_to_string_list(_array) {
    var _string_list = "";

    if (!is_array(_array)) {
        return;
    }
    for (var i = 0; i < array_length(_array); i++) {
        _string_list += string(_array[i]);
        if (i < array_length(_array) - 1) {
            _string_list += "\n";
        }
    }
    return _string_list;
}

/// @function array_to_string_order
/// @description Converts an array into a string, with "," after each member and "and" before the last one.
/// @param {array} _strings_array An array of strings.
/// @return {string}
function array_to_string_order(_strings_array) {
    var result = "";
    var length = array_length(_strings_array);

    // Loop through the array
    for (var i = 0; i < length; i++) {
        // Append the current string
        result += _strings_array[i];
        
        // Check if it's the last string
        if (i < length - 1) {
            // If it's the second last item, add " and " before the last one
            if (i == length - 2) {
                result += " and ";
            } else {
                result += ", ";
            }
        }
    }

    return result;
}
