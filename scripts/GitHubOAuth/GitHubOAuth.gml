// Feather disable all

/// @func GitHubOAuth(clientID)
/// @desc Constructor for creating a new instance of GitHubOAuth.
/// @arg {String} clientID The client ID to use for authentication.
/// @arg {String} [clientSecret] The client secret to use for authentication.
function GitHubOAuth(_clientID, _clientSecret = undefined) constructor {
    __GitHubSystem().__clientID = _clientID;
    __GitHubSystem().__clientSecret = _clientSecret;

    // Just make sure the worker exists if this function is run right as the game starts
    __GitHubEnsureInstance();

    /// @func requestAuthenticationViaWebPage(scope, [expireTime])
    /// @desc Request OAuth user authentication via a web page.
    /// @arg {Array.String} scope An array of authentication scopes.
    /// @arg {Real} [expireTime] Expiry time in seconds to allow the authentication request to expire.
    /// @returns {Any}
    static requestAuthenticationViaWebPage = function(_scope, _expireTime = GITHUB_GML_OAUTH_DEFAULT_EXPIRE_SECONDS) {
        // Ensure that we are on a desktop platform
        if (!GITHUB_GML_FOR_DESKTOP) {
            __GitHubError("requestAuthenticationViaWebPage: Web-flow authentication is only supported on desktop platforms, please use device-flow for non-desktop platforms");
        }

        // Ensure worker is available before checking server (deactivated worker hides __server)
        if (!instance_exists(__github_worker)) {
            __GitHubEnsureInstance();
        }

        // Ensure server does not exist
        if (__GitHubSystem().__pollTimesource != undefined || __github_worker.__server != undefined) {
            __GitHubWarn("requestAuthenticationViaWebPage: Request is already in progress, ensure there is not another authentication request in-progress.");
            return;
        }

        // Ensure client secret has been set.
        if (__GitHubSystem().__clientSecret == undefined) {
            __GitHubError("requestAuthenticationViaWebPage: Client secret has not been set, please set this when constructing GitHubOAuth or set using setClientSecret().");
            return;
        }

        // Create the server
        __github_worker.__server = network_create_server_raw(network_socket_tcp, GITHUB_GML_LOCALHOST_PORT, 1);

        // Set the expire time
        __GitHubSystem().__authenticationExpireTime = _expireTime;

        // Open the URL
        url_open($"{GITHUB_GML_ROOT_OAUTH_URL}oauth/authorize?client_id={__GitHubSystem().__clientID}&scope={__constructScopeString(_scope)}");
    };

    /// @func requestAuthentication(scope)
    /// @desc Request OAuth user authentication via the device flow.
    /// @arg {Array.String} scope An array of authentication scopes.
    /// @returns {Struct.GitHubRequest}
    static requestAuthentication = function(_scope) {
        // Ensure worker is available before checking server (deactivated worker hides __server)
        if (!instance_exists(__github_worker)) {
            instance_activate_object(__github_worker);
            if (!instance_exists(__github_worker)) {
                __GitHubEnsureInstance();
            }
        }

        // Ensure server does not exist
        if (__GitHubSystem().__pollTimesource != undefined || __github_worker.__server != undefined) {
            __GitHubWarn("requestAuthentication: Request is already in progress, ensure there is not another authentication request in-progress.");
            return;
        }

        // Set max attempts
        __GitHubSystem().__authenticationAttempts = 0;

        // Create Header
        var _header = __createDefaultHeaders();

        // Build body TODO: create authentication scope enum / bitfield
        var _body = "client_id=" + __GitHubSystem().__clientID + "&scope=" + __constructScopeString(_scope);

        // Send request
        var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "device/code", "POST", _header, _body);

        // Create GitHub Request
        var _githubRequest = new GitHubRequest(_request.requestID);

        // Return Request
        return _githubRequest;
    };

    /// @func pollAuthentication(deviceCode, interval, [maxAttempts])
    /// @desc Start polling the authentication to check if the user as granted it.
    /// @arg {String} deviceCode The device code that was returned back from `requestAuthentication`.
    /// @arg {Real} interval The interval in seconds to poll the authentication.
    /// @arg {Real} [expireTime] The time in seconds in which the current authentication device code will expire.
    /// @arg {Real} [maxAttempts] The maximum number of attempts to make to poll the authentication.
    /// @returns {Any}
    static pollAuthentication = function(_deviceCode, _interval, _expireTime = GITHUB_GML_OAUTH_DEFAULT_EXPIRE_SECONDS, _maxAttempts = 10) {
        // Clamp the interval and max attempts
        _interval = clamp(_interval, 5, GITHUB_GML_OAUTH_MAX_POLL_INTERVAL);
        _maxAttempts = clamp(_maxAttempts, 1, GITHUB_GML_OAUTH_MAX_POLLS);

        // System
        var _system = __GitHubSystem();

        // Save the clamped interval so slow_down responses can lengthen it (RFC 8628)
        _system.__authenticationPollInterval = _interval;

        // Save device code
        _system.__deviceCode = _deviceCode;

        // Reset poll counters and track the configured attempt limit
        _system.__authenticationAttempts = 0;
        _system.__authenticationMaxAttempts = _maxAttempts;

        // Set the expiry time
        _system.__authenticationExpireTime = _expireTime;

        // Create the time source. One extra repetition so the final invocation
        // reports the timeout after all maxAttempts polls have run.
        _system.__pollTimesource = time_source_create(time_source_global, _interval, time_source_units_seconds, __pollAuthentication, [], _maxAttempts + 1, time_source_expire_after);

        // Start the timesource
        time_source_start(_system.__pollTimesource);
    };

    /// @func cancelAuthentication()
    /// @desc Cancels the current authentication request.
    /// @returns {N/A}
    static cancelAuthentication = function() {
        // System
        var _system = __GitHubSystem();

        // Check server for an active web-flow authentication
        __GitHubRequestServerShutdown();

        // Abandon any in-flight device token request
        if (_system.__pollRequest != undefined) {
            var _requestID = _system.__pollRequest.requestID;
            __GitHubRequestCleanup(_requestID);
        }

        // Clear the poll state and stop the timesource
        __GitHubStopPolling();
    };

    /// @func hasActiveRequest()
    /// @desc Returns if there is an active authentication request in-progress.
    /// @returns {Bool}
    static hasActiveRequest = function() {
        if (!instance_exists(__github_worker)) {
            instance_activate_object(__github_worker);
        }
        return __GitHubSystem().__pollTimesource != undefined || (instance_exists(__github_worker) && __github_worker.__server != undefined);
    };

    /// @func setAuthenticationCallback(callback)
    /// @desc Set the authentication callback which will be executed when the authentication is successful.
    /// @arg {Function} callback The method to execute.
    /// @returns {Any}
    static setAuthenticationCallback = function(_callback) {
        __GitHubSystem().__authenticationCallback = _callback;
    };

    /// @func setAuthenticationErrorback(callback)
    /// @desc Set the authentication errorback which will be executed when the authentication is unsuccessful.
    /// @arg {Function} callback The method to execute.
    /// @returns {Any}
    static setAuthenticationErrorback = function(_callback) {
        __GitHubSystem().__authenticationErrorback = _callback;
    };

    /// @func setAuthenticationTimeoutCallback(callback)
    /// @desc Set the authentication callback which will be executed when the authentication times out.
    /// @arg {Function} callback The method to execute.
    /// @returns {Any}
    static setAuthenticationTimeoutCallback = function(_callback) {
        __GitHubSystem().__authenticationTimeoutCallback = _callback;
    };

    /// @func hasAuthentication()
    /// @desc Returns wether we have user authentication or not.
    /// @returns {Bool}
    static hasAuthentication = function() {
        return __GitHubSystem().__currentUserAuthToken != undefined;
    };

    /// @func getAuthenticationToken()
    /// @desc Returns back the current authentication token.
    /// @returns {String}
    static getAuthenticationToken = function() {
        return __GitHubSystem().__currentUserAuthToken;
    };

    /// @func getAuthenticationTokenType()
    /// @desc Returns back the current authentication token type.
    /// @returns {String}
    static getAuthenticationTokenType = function() {
        return __GitHubSystem().__currentUserTokenType;
    };

    /// @func getAuthenticationTokenScope()
    /// @desc Returns back the current authentication token scope.
    /// @returns {String}
    static getAuthenticationTokenScope = function() {
        return __GitHubSystem().__currentUserTokenScope;
    };

    /// @func setAuthenticationSuccessHTML(html)
    /// @desc Set the web-flow success HTML which will be displayed in the browser when authentication is successful.
    /// @arg {String} html The HTML to use.
    /// @returns {N/A}
    static setAuthenticationSuccessHTML = function(_html) {
        // Potentially risky business here.
        __GitHubSystem().__authenticationSuccessHTML = _html;
    };

    /// @func setAuthenticationErrorHTML(html)
    /// @desc Set the web-flow error HTML which will be displayed in the browser when authentication is unsuccessful.
    /// @arg {String} html The HTML to use.
    /// @returns {N/A}
    static setAuthenticationErrorHTML = function(_html) {
        // Potentially risky business here.
        __GitHubSystem().__authenticationErrorHTML = _html;
    };

    /// @func __pollAuthentication()
    /// @desc Authentication poll for the timesource.
    /// @ignore
    static __pollAuthentication = function() {
        // System
        var _system = __GitHubSystem();

        // Check the attempt limit and device code expiry BEFORE scheduling the poll, so the
        // full maxAttempts polls run and the final invocation reports the timeout
        // TODO: Do something about the timeout time that GitHub returns back
        if (_system.__authenticationAttempts >= _system.__authenticationMaxAttempts || (_system.__authenticationExpireTime != undefined && _system.__authenticationExpireTime <= 0)) {
            // Abandon any token request still in-flight when the timeout fires
            if (_system.__pollRequest != undefined) {
                __GitHubRequestCleanup(_system.__pollRequest.requestID);
            }

            // Always clean up the timesource so hasActiveRequest() clears
            __GitHubStopPolling();

            // And we call the timeout callback
            if (_system.__authenticationTimeoutCallback != undefined) {
                _system.__authenticationTimeoutCallback();
            }

            return;
        }

        // Create Header
        var _header = __createDefaultHeaders();

        // Build body
        var _body = "client_id=" + _system.__clientID + "&device_code=" + _system.__deviceCode + "&grant_type=" + GITHUB_GML_OAUTH_GRANT_TYPE;

        // Send request
        var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "oauth/access_token", "POST", _header, _body);

        // Create GitHub Request
        _system.__pollRequest = new GitHubRequest(_request.requestID);

        // Count this attempt once the poll request is scheduled
        _system.__authenticationAttempts++;

        // Create the callback
        _system.__pollRequest
            .setCallback(function(_resultBody, _request) {
                // Get system
                var _system = __GitHubSystem();

                // Ignore stale responses (poll was cancelled or superseded)
                if (_system.__pollTimesource == undefined || _system.__pollRequest == undefined || _request.requestID != _system.__pollRequest.requestID) {
                    return;
                }

                // A 200 response can still carry an OAuth error (user denied, expired device code, ...)
                if (variable_struct_exists(_resultBody, "error")) {
                    // authorization_pending is expected between polls; keep polling
                    if (_resultBody.error == "authorization_pending") {
                        return;
                    }

                    // Terminal error - stop polling
                    __GitHubStopPolling();

                    // Run the poll errorback
                    if (_system.__authenticationErrorback != undefined) {
                        _system.__authenticationErrorback(_resultBody, _request);
                    }

                    return;
                }

                // A 200 response without a token is not a success
                if (!variable_struct_exists(_resultBody, "access_token")) {
                    // Stop polling and report the failure
                    __GitHubStopPolling();

                    // Run the poll errorback
                    if (_system.__authenticationErrorback != undefined) {
                        _system.__authenticationErrorback(_resultBody, _request);
                    }

                    return;
                }

                // Set user authentication
                _system.__currentUserAuthToken = _resultBody.access_token;
                _system.__currentUserTokenType = _resultBody.token_type;
                _system.__currentUserTokenScope = (_resultBody.scope != undefined) ? string_split(_resultBody.scope, ",") : [];

                // Clear timesources
                __GitHubStopPolling();

                // Run the poll callback
                if (_system.__authenticationCallback != undefined) {
                    _system.__authenticationCallback(_resultBody, _request);
                }
            });

        // Create the errorback
        _system.__pollRequest
            .setErrorback(function(_resultBody, _request) {
                // Get system
                var _system = __GitHubSystem();

                // Ignore stale responses (poll was cancelled or superseded)
                if (_system.__pollTimesource == undefined || _system.__pollRequest == undefined || _request.requestID != _system.__pollRequest.requestID) {
                    return;
                }

                // GitHub reports pending polls as HTTP 400 - not failures
                if (is_struct(_resultBody) && variable_struct_exists(_resultBody, "error")) {
                    if (_resultBody.error == "authorization_pending") {
                        return;
                    }

                    // slow_down (RFC 8628 3.5): lengthen the interval by 5s or every
                    // later poll stays throttled. Non-terminal even on the last poll -
                    // the extra timeout invocation reports the exhaustion instead
                    if (_resultBody.error == "slow_down") {
                        _system.__authenticationPollInterval = min(_system.__authenticationPollInterval + 5, GITHUB_GML_OAUTH_MAX_POLL_INTERVAL);

                        // Remaining attempts (this poll already counted) plus the final timeout invocation
                        var _remaining = _system.__authenticationMaxAttempts - _system.__authenticationAttempts + 1;
                        time_source_stop(_system.__pollTimesource);
                        time_source_destroy(_system.__pollTimesource);
                        _system.__pollTimesource = time_source_create(time_source_global, _system.__authenticationPollInterval, time_source_units_seconds, __pollAuthentication, [], _remaining, time_source_expire_after);
                        time_source_start(_system.__pollTimesource);
                        return;
                    }
                }

                // Terminal - stop polling and report
                __GitHubStopPolling();
                if (_system.__authenticationErrorback != undefined) {
                    _system.__authenticationErrorback(_resultBody, _request);
                }
            });
    };

    /// @func __constructScopeString(scope)
    /// @desc Construct a scope string.
    /// @ignore
    static __constructScopeString = function(_scope) {
        // Join between scopes only - a trailing %20 becomes an empty scope item
        return string_join_ext("%20", _scope);
    };

    /// @func __createDefaultHeaders()
    /// @desc Creates default header.
    /// @return {Struct}
    /// @ignore
    static __createDefaultHeaders = function() {
        // Create Header
        var _header = ds_map_create();

        // Build Header
        ds_map_add(_header, "Accept", "application/json");
        ds_map_add(_header, "Content-Type", "application/x-www-form-urlencoded");

        // Return Header
        return _header;
    };
}

/// Stops and destroys the device-flow polling timesource and clears the poll state.
/// Shared by the timeout branch, terminal-error path, success callback, errorback
/// and cancelAuthentication so lifecycle handling cannot diverge.
/// @ignore
function __GitHubStopPolling() {
    // System
    var _system = __GitHubSystem();

    // Reset expire time and attempt counter
    _system.__authenticationExpireTime = undefined;
    _system.__authenticationAttempts = 0;

    // Clear timesources
    if (_system.__pollTimesource != undefined) {
        time_source_stop(_system.__pollTimesource);
        time_source_destroy(_system.__pollTimesource);
        _system.__pollTimesource = undefined;
    }

    // Clear the in-flight request reference
    _system.__pollRequest = undefined;
}

/// Handles a failed token exchange: requests the server shutdown and runs the
/// authentication errorback. Shared by the web-flow success and error callbacks
/// so failure handling cannot diverge.
/// @ignore
function __GitHubAuthenticationFailure(_resultBody, _requestObject) {
    // Request server shutdown and report the failure
    __GitHubRequestServerShutdown();

    // Run the authentication errorback
    var _system = __GitHubSystem();
    if (_system.__authenticationErrorback != undefined) {
        _system.__authenticationErrorback(_resultBody, _requestObject);
    }
}
