// Feather disable all

/// Request a server shutdown
/// @ignore
function __GitHubRequestServerShutdown() {
    // Only schedule a shutdown when a web-flow server exists. Starting the delayed shutdown
    // without a server would destroy a server created by a later request.
    if (__github_worker.__server == undefined) {
        return;
    }

    if (time_source_get_state(__GitHubSystem().__authenticationServerShutdownTimesource) != time_source_state_active) {
        time_source_start(__GitHubSystem().__authenticationServerShutdownTimesource);
    } else {
        __GitHubWarn("__GitHubRequestServerShutdown: Server shutdown sequence already started.");
    }
}
