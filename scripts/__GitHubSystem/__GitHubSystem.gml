__GitHubSystem();

/// @ignore
function __GitHubSystemData() constructor {
    __GitHubTrace("GitHub.gml implemented by Alun Jones with help from Juju Adams. v" + GITHUB_GML_VERSION + " - " + GITHUB_GML_DATE);

    // These are to keep track of active requests because GameMakers async handling is bad
    /// @type {Struct<Struct.HTTPRequest>}
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
    __authenticationMaxAttempts = undefined;
    __pollTimesource = undefined;
    __pollRequest = undefined;

    // Web-flow
    __authenticationSuccessHTML = "Please return to the game.";
    __authenticationErrorHTML = "Error!";
    __authenticationServerShutdownTimesource = undefined;
}

/// @ignore
/// @returns {Struct.__GitHubSystemData}
function __GitHubSystem() {
    /// @type {Undefined|Struct.__GitHubSystemData}
    static _system = undefined;
    if (_system != undefined) {
        return _system;
    }

    _system = new __GitHubSystemData();

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
    _system.__authenticationServerShutdownTimesource = time_source_create(time_source_global, GITHUB_GML_SERVER_SHUTDOWN_TIME, time_source_units_seconds, function() {
        __GitHubServerShutdown();
    });

    return _system;
}

/// Removes a request from the active request tables and frees its header map.
/// Shared by the worker completion handler and the cancellation/timeout paths
/// so the cleanup contract lives in one place.
/// @ignore
function __GitHubRequestCleanup(_requestID) {
    // System
    var _system = __GitHubSystem();

    if (variable_struct_exists(_system.__activeRequests, _requestID)) {
        var _httpRequest = _system.__activeRequests[$ _requestID];

        // headerMap is undefined for HTTPGet/HTTPGetFile, and ds handles can be
        // int64 - guard the type before destroying
        var _headerMap = _httpRequest.headerMap;
        if ((is_real(_headerMap) || is_int64(_headerMap)) && ds_exists(_headerMap, ds_type_map)) {
            ds_map_destroy(_headerMap);
        }

        variable_struct_remove(_system.__activeRequests, _requestID);
    }

    if (variable_struct_exists(_system.__activeGitHubRequests, _requestID)) {
        variable_struct_remove(_system.__activeGitHubRequests, _requestID);
    }
}
