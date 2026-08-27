// Function disable all

/// @ignore
function __GitHubTick() {
    var _system = __GitHubSystem();
    var _expire = _system.__authenticationExpireTime;

    if (_expire != undefined && _expire > 0) {
        _system.__authenticationExpireTime--;
        return;
    }

    if (_expire == undefined || _expire > 0) {
        return;
    }

    __GitHubEnsureInstance();

    if (__github_worker.__server == undefined || __GitHubServerShuttingDown()) {
        return;
    }

    // Always request the shutdown first so a throwing timeout callback
    // cannot leave the authentication server active
    __GitHubRequestServerShutdown();

    // Fire the timeout callback only once per shutdown sequence.
    if (is_callable(_system.__authenticationTimeoutCallback)) {
        _system.__authenticationTimeoutCallback();
    }
}
