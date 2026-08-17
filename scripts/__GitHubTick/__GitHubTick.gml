// Function disable all

/// @ignore
function __GitHubTick() {
    if (__GitHubSystem().__authenticationExpireTime != undefined && __GitHubSystem().__authenticationExpireTime > 0) {
        __GitHubSystem().__authenticationExpireTime--;
    } else if (__GitHubSystem().__authenticationExpireTime <= 0 && __github_worker.__server != undefined) {
        // TODO: Figure out what to do for the timeout callback
        __GitHubSystem().__authenticationTimeoutCallback();
        __GitHubRequestServerShutdown();
    }
}
