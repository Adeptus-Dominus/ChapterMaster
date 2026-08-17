// Feather disable all

/// Request a server shutdown
/// @ignore
function __GitHubRequestServerShutdown() {
    if (time_source_get_state(__GitHubSystem().__authenticationServerShutdownTimesource) != time_source_state_active) {
        time_source_start(__GitHubSystem().__authenticationServerShutdownTimesource);
    } else {
        __GitHubWarn("__GitHubRequestServerShutdown: Server shutdown sequence already started.");
    }
}
