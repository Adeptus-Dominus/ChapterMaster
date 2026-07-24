// https://forum.gamemaker.io/index.php?threads/gml-basics-passing-arguments-to-predicates.123957/

// Usage:
// var _variable = 5;
// var _callback = predicate0(_variable, function(_argument) {
//     `_argument` variable with value `5` exists in this scope now;
// });
// Then pass `_callback` to any function that accepts callback.

/// @desc Return a predicate that runs func with only the provided trailing argument.
/// @param {Any} arg The trailing argument.
/// @param {function} func The function to run (should ideally take 1 argument).
/// @returns {Function}
function predicate0(arg, func) {
    var _self = self;
    return method({
        vals: 0,
        arg: arg,
        func: is_undefined(method_get_self(func)) ? method(_self, func) : func,
    }, function() {
        return func(arg);
    });
}

/// @desc Return a predicate that accepts 1 argument and runs func with it and the provided trailing argument.
/// @param {Any} arg The trailing argument.
/// @param {function} func The function to run (should ideally take 2 arguments).
/// @returns {function}
function predicate1(arg, func) {
    var _self = self;
    return method({
        vals: 1,
        arg: arg,
        func: is_undefined(method_get_self(func)) ? method(_self, func) : func,
    }, function(v) {
        return func(v, arg);
    });
}
