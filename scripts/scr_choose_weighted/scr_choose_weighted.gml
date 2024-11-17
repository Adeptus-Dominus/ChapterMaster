/// @function choose_weighted(_choices)
/// @description Randomly selects one item from the provided array, taking into account the weight of each item.
/// @param _choices an array of arrays, where each sub array contains two items: the item to be picked and its weight. Example: `[[sword,5], [mace,2]]`.

function choose_weighted(_choices){
    var total = 0;

    // Calculate the total weight
    for (var i = 0; i < array_length(_choices); i++) {
        total += _choices[i, 1];
    }

    // Choose a random value between 0 and total
    var random_value = random(total);

    // Find the choice that this random value falls into
    for (var i = 0; i < array_length(_choices); i++) {
        if (random_value < _choices[i, 1]) {
            return _choices[i, 0];
        } else {
            random_value -= _choices[i, 1];
        }
    }
}

/// @function choose_weighted_range(_choices)
/// @description Randomly selects a random number from a range, based on the provided weights of each range.
/// @param _choices an array of arrays, where each sub-array contains a number range and its weight. Example: `[[0, 4, 10], [5, 10, 5]]`.
function choose_weighted_range(_choices) {
    var total = 0;

    // Calculate the total weight
    for (var i = 0; i < array_length(_choices); i++) {
        total += _choices[i, 2];
    }

    // Choose a random value between 0 and total
    var random_value = random(total);

    // Find the range that this random value falls into
    for (var i = 0; i < array_length(_choices); i++) {
        if (random_value < _choices[i, 2]) {
            var range_start = _choices[i, 0];
            var range_end = _choices[i, 1];
            return irandom_range(range_start, range_end);
        } else {
            random_value -= _choices[i, 2];
        }
    }
}

function choose_array(choice_array){
    return choice_array[irandom(array_length(choice_array)-1)];
}
