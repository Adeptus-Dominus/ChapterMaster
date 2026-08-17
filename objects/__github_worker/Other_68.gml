// Feather disable all

if (__server != undefined && async_load[? "port"] == GITHUB_GML_LOCALHOST_PORT) {
    var _type = async_load[? "type"];
    if (_type == network_type_connect) {
        if (async_load[? "id"] == __server) {
            __socket = async_load[? "socket"];
        }
    } else if (_type == network_type_disconnect) {
        if ((async_load[? "id"] == __server) && (async_load[? "socket"] == __socket)) {
            __socket = undefined;
        }
    } else {
        if (async_load[? "server"] == __server) {
            //Extract the HTTP body
            var _buffer = async_load[? "buffer"];
            var _string = buffer_read(_buffer, buffer_text);
            buffer_delete(_buffer);

            //Try to find key information from the HTTP header
            var _codePos = string_pos("GET /?code=", _string);
            var _httpPos = string_pos(" HTTP/1.1", _string);

            if ((_codePos > 0) && (_httpPos > 0) && (_httpPos > _codePos)) {
                //We found the information we need, fire off a request to GitHub to get our access token
                var _codeEndPos = _codePos + string_length("GET /?code=");
                var _code = string_copy(_string, _codeEndPos, _httpPos - _codeEndPos);

                var _params = $"client_id={__GitHubSystem().__clientID}&client_secret={__GitHubSystem().__clientSecret}&code={_code}";

                var _headerMap = ds_map_create();
                _headerMap[? "Accept"] = "application/json";

                var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "oauth/access_token?" + _params, "POST", _headerMap, "");
                var _githubRequest = new GitHubRequest(_request.requestID);
                _githubRequest.setCallback(function(_resultBody, _request) {
                    // We can reasonably assume that if the server is in the process of shutting down that we have
                    // the authentication we need or it failed or got cancelled by the user. If this is the case we
                    // can just skip past all of this.
                    if (__GitHubServerShuttingDown()) {
                        return;
                    }

                    // Get system
                    var _system = __GitHubSystem();

                    // Set user authentication
                    _system.__currentUserAuthToken = _resultBody.access_token;
                    _system.__currentUserTokenType = _resultBody.token_type;
                    _system.__currentUserTokenScope = string_split(_resultBody.scope, ",");

                    // Request server shutdown
                    __GitHubRequestServerShutdown();

                    // Run the authentication callback
                    if (_system.__authenticationCallback != undefined) {
                        _system.__authenticationCallback(_resultBody, _request);
                    }
                });

                var _status = "200 OK";
                var _content = __GitHubSystem().__authenticationSuccessHTML;
            } else {
                var _status = "403 Forbidden";
                var _content = __GitHubSystem().__authenticationErrorHTML;

                // TODO: Add errorbacking in here
            }

            //Send a response back to the browser
            var _buffer = buffer_create(GITHUB_GML_BROWSER_RESPONSE_BUFFER_SIZE, buffer_grow, 1);
            buffer_write(_buffer, buffer_text, $"HTTP/1.1 {_status}\nContent-Length: {string_length(_content)}\nContent-Type: text/html\n\n{_content}");
            network_send_raw(__socket, _buffer, buffer_tell(_buffer));
            buffer_delete(_buffer);

            //Disconnect from the browser immediately
            network_destroy(__socket);
        }
    }
}
