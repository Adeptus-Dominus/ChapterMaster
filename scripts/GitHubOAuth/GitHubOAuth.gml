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
    static requestAuthenticationViaWebPage = function(_scope, _expireTime = undefined) {
        // Ensure that we are on a desktop platform
        if (!GITHUB_GML_FOR_DESKTOP) {
            __GitHubError("requestAuthenticationViaWebPage: Web-flow authentication is only supported on desktop platforms, please use device-flow for non-desktop platforms");
        }

        // Ensure server does not exist
        if (__github_worker.__server != undefined || __GitHubSystem().__pollTimesource != undefined) {
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
    static pollAuthentication = function(_deviceCode, _interval, _expireTime = 900, _maxAttempts = 10) {
        // Clamp the interval and max attempts
        _interval = clamp(_interval, 5, GITHUB_GML_OAUTH_MAX_POLL_INTERVAL);
        _maxAttempts = clamp(_maxAttempts, 1, GITHUB_GML_OAUTH_MAX_POLLS);

        // System
        var _system = __GitHubSystem();

        // Save device code
        _system.__deviceCode = _deviceCode;

        // Set the expiry time
        _system.__authenticationExpireTime = _expireTime;

        // Create the time source
        _system.__pollTimesource = time_source_create(time_source_global, _interval, time_source_units_seconds, __pollAuthentication, [], _maxAttempts, time_source_expire_after);

        // Start the timesource
        time_source_start(_system.__pollTimesource);
    };

    /// @func cancelAuthentication()
    /// @desc Cancels the current authentication request.
    /// @returns {N/A}
    static cancelAuthentication = function() {
        // Check server for an active web-flow authentication
        __GitHubRequestServerShutdown();

        // Check the timesource for an active device-flow authentication
        if (__GitHubSystem().__pollTimesource != undefined) {
            // Reset expire time
            __GitHubSystem().__authenticationExpireTime = undefined;

            // Clear timesources
            time_source_stop(__GitHubSystem().__pollTimesource);
            time_source_destroy(__GitHubSystem().__pollTimesource);
            __GitHubSystem().__pollTimesource = undefined;
        }
    };

    /// @func hasActiveRequest()
    /// @desc Returns if there is an active authentication request in-progress.
    /// @returns {Bool}
    static hasActiveRequest = function() {
        return __GitHubSystem().__pollTimesource != undefined || __github_worker.__server != undefined;
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
        // Check if we have hit out max attempts or not
        // TODO: Do something about the timeout time that GitHub returns back
        if (__GitHubSystem().__authenticationAttempts >= GITHUB_GML_OAUTH_MAX_POLLS || (__GitHubSystem().__authenticationExpireTime != undefined && __GitHubSystem().__authenticationExpireTime <= 0)) {
            // And we call the timeout callback
            if (__GitHubSystem().__authenticationTimeoutCallback != undefined) {
                __GitHubSystem().__authenticationTimeoutCallback();

                // Reset expire time
                __GitHubSystem().__authenticationExpireTime = undefined;

                // Clear timesources
                time_source_stop(_system.__pollTimesource);
                time_source_destroy(_system.__pollTimesource);
                _system.__pollTimesource = undefined;

                return;
            }
        }

        // Create Header
        var _header = ds_map_create();

        // Build Header
        ds_map_add(_header, "Accept", "application/json");
        ds_map_add(_header, "Content-Type", "application/x-www-form-urlencoded");

        // System
        var _system = __GitHubSystem();

        // Build body
        var _body = "client_id=" + _system.__clientID + "&device_code=" + _system.__deviceCode + "&grant_type=" + GITHUB_GML_OAUTH_GRANT_TYPE;

        // Send request
        var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "oauth/access_token", "POST", _header, _body);

        // Create GitHub Request
        _system.__pollRequest = new GitHubRequest(_request.requestID);

        // Create the callback
        _system.__pollRequest
            .setCallback(function(_resultBody, _request) {
                // Check that the response has come back clean and that there is no error.
                if (_request.httpStatus == 200 && !variable_struct_exists(_resultBody, "error")) {
                    // Get system
                    var _system = __GitHubSystem();

                    // Set user authentication
                    _system.__currentUserAuthToken = _resultBody.access_token;
                    _system.__currentUserTokenType = _resultBody.token_type;
                    _system.__currentUserTokenScope = string_split(_resultBody.scope, ",");

                    // Clear timesources
                    time_source_stop(_system.__pollTimesource);
                    time_source_destroy(_system.__pollTimesource);
                    _system.__pollTimesource = undefined;

                    // Run the poll callback
                    if (_system.__authenticationCallback != undefined) {
                        _system.__authenticationCallback(_resultBody, _request);
                    }
                }
            });

        // Create the errorback
        _system.__pollRequest
            .setErrorback(function(_resultBody, _request) {
                // Get system
                var _system = __GitHubSystem();

                // Clear timesources
                time_source_stop(_system.__pollTimesource);
                time_source_destroy(_system.__pollTimesource);
                _system.__pollTimesource = undefined;

                // Run the poll errorback
                if (_system.__authenticationErrorback != undefined) {
                    _system.__authenticationErrorback(_resultBody, _request);
                }
            });

        // Increment authentication attempts
        __GitHubSystem().__authenticationAttempts++;
    };

    /// @func __constructScopeString(scope)
    /// @desc Construct a scope string.
    /// @ignore
    static __constructScopeString = function(_scope) {
        var _returnString = "";
        var _scopeCount = array_length(_scope);
        var _i = 0;

        repeat (_scopeCount) {
            _returnString += _scope[_i] + "%20";
            _i++;
        }

        return _returnString;
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
