// Feather disable all

/// Check if the server shutdown is in progress
/// @ignore
function __GitHubServerShuttingDown() {
    return time_source_get_state(__GitHubSystem().__authenticationServerShutdownTimesource) == time_source_state_active;
}
