// Feather disable all

if (__server != undefined) {
    var _type = async_load[? "type"];
    if (_type == network_type_connect) {
        if (async_load[? "id"] == __server) {
            __socket = async_load[? "socket"];
            __requestData = "";
        }
    } else if (_type == network_type_disconnect) {
        if ((async_load[? "id"] == __server) && (async_load[? "socket"] == __socket)) {
            __socket = undefined;
            __requestData = "";
        }
    } else {
        if (async_load[? "server"] == __server) {
            //Extract the HTTP data and accumulate it until the full request line is available
            var _buffer = async_load[? "buffer"];
            __requestData += buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);

            //Try to find key information from the accumulated HTTP header
            var _codePos = string_pos("GET /?code=", __requestData);
            var _httpPos = string_pos(" HTTP/1.1", __requestData);

            if ((_codePos > 0) && (_httpPos > 0) && (_httpPos > _codePos)) {
                //We found the information we need, fire off a request to GitHub to get our access token
                var _codeEndPos = _codePos + string_length("GET /?code=");
                var _code = string_copy(__requestData, _codeEndPos, _httpPos - _codeEndPos);

                var _body = $"client_id={__GitHubSystem().__clientID}&client_secret={__GitHubSystem().__clientSecret}&code={_code}";

                var _headerMap = ds_map_create();
                _headerMap[? "Accept"] = "application/json";
                _headerMap[? "Content-Type"] = "application/x-www-form-urlencoded";

                var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "oauth/access_token", "POST", _headerMap, _body);
                var _githubRequest = new GitHubRequest(_request.requestID);
                _githubRequest.setCallback(function(_resultBody, _requestObject) {
                    // We can reasonably assume that if the server is in the process of shutting down that we have
                    // the authentication we need or it failed or got cancelled by the user. If this is the case we
                    // can just skip past all of this.
                    if (__GitHubServerShuttingDown()) {
                        return;
                    }

                    // Get system
                    var _system = __GitHubSystem();

                    // A 2xx response can still carry an OAuth error, or lack the token entirely
                    if (variable_struct_exists(_resultBody, "error") || !variable_struct_exists(_resultBody, "access_token")) {
                        // Report the failure and request the server shutdown
                        __GitHubAuthenticationFailure(_resultBody, _requestObject);
                        return;
                    }

                    // Set user authentication
                    _system.__currentUserAuthToken = _resultBody.access_token;
                    _system.__currentUserTokenType = _resultBody.token_type;
                    _system.__currentUserTokenScope = (_resultBody.scope != undefined) ? string_split(_resultBody.scope, ",") : [];

                    // Request server shutdown
                    __GitHubRequestServerShutdown();

                    // Run the authentication callback
                    if (_system.__authenticationCallback != undefined) {
                        _system.__authenticationCallback(_resultBody, _requestObject);
                    }
                });
                _githubRequest.setErrorback(function(_resultBody, _requestObject) {
                    // Ignore the response if the shutdown sequence is already underway
                    if (__GitHubServerShuttingDown()) {
                        return;
                    }

                    // Report the failure and request the server shutdown
                    __GitHubAuthenticationFailure(_resultBody, _requestObject);
                });

                var _status = "200 OK";
                var _content = __GitHubSystem().__authenticationSuccessHTML;
            } else if (string_pos("\r\n\r\n", __requestData) == 0 && string_byte_length(__requestData) < GITHUB_GML_BROWSER_REQUEST_MAX_SIZE) {
                //No full header terminator yet: the request line is still arriving.
                exit;
            } else {
                // Rejected request (oversized or complete without a code)
                var _status = "403 Forbidden";
                var _content = __GitHubSystem().__authenticationErrorHTML;

                if (string_pos("\r\n\r\n", __requestData) == 0) {
                    //Oversized request without a terminator - malformed.
                    // TODO: Add errorbacking in here
                } else {
                    // Complete request without a code (e.g. the user denied access)
                    __GitHubAuthenticationFailure({error: "access_denied"}, undefined);
                }
            }

            //Reset the accumulated request data
            __requestData = "";

            //Send a response back to the browser
            var _buffer = buffer_create(GITHUB_GML_BROWSER_RESPONSE_BUFFER_SIZE, buffer_grow, 1);
            buffer_write(_buffer, buffer_text, $"HTTP/1.1 {_status}\r\nContent-Length: {string_byte_length(_content)}\r\nContent-Type: text/html\r\n\r\n{_content}");
            network_send_raw(__socket, _buffer, buffer_tell(_buffer));
            buffer_delete(_buffer);

            //Disconnect from the browser immediately
            network_destroy(__socket);
        }
    }
}
