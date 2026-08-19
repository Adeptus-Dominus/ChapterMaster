// Function disable all

/// @ignore
function __GitHubTick() {
    var _system = __GitHubSystem();

    if (_system.__authenticationExpireTime != undefined && _system.__authenticationExpireTime > 0) {
        _system.__authenticationExpireTime--;
    } else if (_system.__authenticationExpireTime != undefined && _system.__authenticationExpireTime <= 0 && __github_worker.__server != undefined && !__GitHubServerShuttingDown()) {
        // Always request the shutdown first so a throwing timeout callback
        // cannot leave the authentication server active
        __GitHubRequestServerShutdown();

        // Fire the timeout callback only once per shutdown sequence.
        if (is_callable(_system.__authenticationTimeoutCallback)) {
            _system.__authenticationTimeoutCallback();
        }
    }
}
