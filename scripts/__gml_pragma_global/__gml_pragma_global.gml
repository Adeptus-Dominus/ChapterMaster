// The "global" pragma permits you to call some GML code formatted as a string, at a global scope,
// at compile time, before the first room of the game executes.
// Note that the GML supplied as the second argument must be a compile-time constant,
// and also note that you cannot use this pragma to create instances
// or perform any operations that require a room (or anything in a room) to function.

gml_pragma("global", "__global_object_depths()");
gml_pragma("global", "__init_action()");
gml_pragma("global", "__init_d3d()");
gml_pragma("global", "__init();");
