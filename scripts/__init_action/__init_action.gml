// This will execute before the first room of the game executes.
gml_pragma("global", "__init_action()");

// @stitch-ignore-next-line: unused-function
function __init_action() {
    global.__part_syst = -1;
    global.__part_emit = [];
    global.__argument_relative = false;
    global.__part_type = [];

    for (var i = 0; i < 16; i++) {
        global.__part_type[i] = -1;
        global.__part_emit[i] = -1;
    }
}
