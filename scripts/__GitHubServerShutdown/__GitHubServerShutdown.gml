// Feather disable all

/// Actual shutdown
/// @ignore
function __GitHubServerShutdown() {
    if (!instance_exists(__github_worker)) {
        instance_activate_object(__github_worker);
        if (!instance_exists(__github_worker)) {
            return;
        }
    }

    // Check server for an active web-flow authentication
    if (__github_worker.__server != undefined) {
        // Destroy the network
        network_destroy(__github_worker.__server);
        __github_worker.__server = undefined;

        // Reset expire time
        __GitHubSystem().__authenticationExpireTime = undefined;
    }
}
