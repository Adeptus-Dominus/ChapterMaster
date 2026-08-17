__GitHubSystem();

/// @ignore
function __GitHubSystem() {
    static _system = undefined;
    if (_system != undefined) {
        return _system;
    }

    _system = {};
    with (_system) {
        __GitHubTrace("GitHub.gml implemented by Alun Jones with help from Juju Adams. v" + GITHUB_GML_VERSION + " - " + GITHUB_GML_DATE);

        // These are to keep track of active requests because GameMakers async handling is bad
        __activeRequests = {};
        __activeGitHubRequests = {};

        // Rate limits
        __rateLimit = undefined;
        __rateLimitUsed = undefined;
        __rateLimitRemaining = undefined;
        __rateLimitReset = undefined;

        // Current user authorization token
        __currentUserAuthToken = undefined;
        __currentUserTokenType = undefined;
        __currentUserTokenScope = undefined;

        // OAuth Secrets
        __clientID = undefined;
        __clientSecret = undefined;
        __deviceCode = undefined;

        // Authentication callbacks
        __authenticationCallback = undefined;
        __authenticationErrorback = undefined;
        __authenticationTimeoutCallback = undefined;

        // Other authentication stuff
        __authenticationExpireTime = undefined;
        __authenticationAttempts = undefined;
        __pollTimesource = undefined;

        // Web-flow
        __authenticationSuccessHTML = "Please return to the game.";
        __authenticationErrorHTML = "Error!";
        __authenticationServerShutdownTimesource = undefined;

        // Create worker
        __GitHubEnsureInstance();

        // Create early destruction detection timesource, essentially a "keep alive" to make sure the worker exists at all times when GitHub exists
        time_source_start(
            time_source_create(
                time_source_global,
                1,
                time_source_units_frames,
                function() {
                    __GitHubEnsureInstance();
                },
                [],
                -1,
            ),
        );

        // Now we run the seconds tick
        time_source_start(
            time_source_create(
                time_source_global,
                1,
                time_source_units_seconds,
                function() {
                    __GitHubTick();
                },
                [],
                -1,
            ),
        );

        // Authentication server shutdown server
        __GitHubSystem().__authenticationServerShutdownTimesource = time_source_create(time_source_global, GITHUB_GML_SERVER_SHUTDOWN_TIME, time_source_units_seconds, function() {
            __GitHubServerShutdown();
        });
    }

    return _system;
}
