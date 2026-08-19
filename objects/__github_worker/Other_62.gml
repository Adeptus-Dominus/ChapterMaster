// Feather disable all

// Get system
var _system = __GitHubSystem();

if (variable_struct_exists(_system.__activeRequests, async_load[? "id"])) {
    // Request ID
    var _requestID = async_load[? "id"];

    // Get Request Object
    var _requestObject = _system.__activeRequests[$ _requestID];

    // Set Status
    _requestObject.status = async_load[? "status"];

    // Get GitHub Request and Set Its Status
    if (variable_struct_exists(_system.__activeGitHubRequests, _requestID)) {
        // Get GitHub Request Object
        var _ghRequestObject = _system.__activeGitHubRequests[$ _requestID];

        // Set Status
        _ghRequestObject.status = async_load[? "status"];
    }

    // Check Request Status
    if (async_load[? "status"] > 0) {
        // Still Recieving Packets
        _requestObject.contentLength = async_load[? "contentLength"];
        _requestObject.sizeDownloaded = async_load[? "sizeDownloaded"];

        // Get GitHub Request and Set Its Status
        if (variable_struct_exists(_system.__activeGitHubRequests, _requestID)) {
            // Get GitHub Request Object
            var _ghRequestObject = _system.__activeGitHubRequests[$ _requestID];

            // Set Status
            _ghRequestObject.contentLength = async_load[? "contentLength"];
            _ghRequestObject.sizeDownloaded = async_load[? "sizeDownloaded"];
        }
    } else if (async_load[? "status"] == 0) {
        // Recieved All Packets
        // Set HTTP and response headers
        _requestObject.httpStatus = async_load[? "http_status"];
        _requestObject.responseHeaders = __DSMapToStruct(async_load[? "response_headers"]);

        // Get Result
        _requestObject.result = async_load[? "result"];

        // Now we need to run the callbacks
        if (async_load[? "http_status"] >= 200 && async_load[? "http_status"] <= 299) {
            if (is_method(_requestObject.callback)) {
                _requestObject.callback(_requestObject.result, _requestObject);
            }
        } else if (async_load[? "http_status"] >= 400 && async_load[? "http_status"] <= 599) {
            if (is_method(_requestObject.errorback)) {
                _requestObject.errorback(_requestObject.result, _requestObject);
            }
        }

        // Get GitHub Request
        if (variable_struct_exists(_system.__activeGitHubRequests, _requestID)) {
            // Set Status
            _ghRequestObject.httpStatus = async_load[? "http_status"];
            _ghRequestObject.responseHeaders = __DSMapToStruct(async_load[? "response_headers"]);

            // Get GitHub Request Object
            var _ghRequestObject = _system.__activeGitHubRequests[$ _requestID];

            // Parse The Incoming JSON, a status code of 204 means there is nothing to parse
            var _parseSuccess = true;
            if (async_load[? "http_status"] != 204) {
                _parseSuccess = _ghRequestObject.parseResult(_requestObject.result);
            }

            // Now we need to run the callbacks
            // Route HTTP errors and JSON parse failures through the error path
            if (!_parseSuccess || (async_load[? "http_status"] >= 400 && async_load[? "http_status"] <= 599)) {
                if (is_method(_ghRequestObject.errorback)) {
                    // Parse failures carry the raw body; HTTP errors carry the parsed struct
                    var _errorBody = _parseSuccess ? _ghRequestObject.result : _ghRequestObject.resultRaw;
                    _ghRequestObject.errorback(_errorBody, _ghRequestObject);
                }
            } else if (async_load[? "http_status"] >= 200 && async_load[? "http_status"] <= 299) {
                if (is_method(_ghRequestObject.callback)) {
                    _ghRequestObject.callback(_ghRequestObject.result, _ghRequestObject);
                }
            }

            // Do rate limit stuff
            if (variable_struct_exists(_ghRequestObject.responseHeaders, "X-RateLimit-Reset")) {
                // Keep track of rate limits
                _system.__rateLimit = _ghRequestObject.responseHeaders[$ "X-RateLimit-Limit"];
                _system.__rateLimitUsed = _ghRequestObject.responseHeaders[$ "X-RateLimit-Used"];
                _system.__rateLimitRemaining = _ghRequestObject.responseHeaders[$ "X-RateLimit-Remaining"];
                _system.__rateLimitReset = _ghRequestObject.responseHeaders[$ "X-RateLimit-Reset"];
            }
        }

        // Clean up the request (header map and active tables)
        __GitHubRequestCleanup(_requestID);
    } else if (async_load[? "status"] < 0) {
        // Network failure (DNS, refused, timeout): report and clean up so the
        // request cannot leak in the active tables
        _requestObject.httpStatus = async_load[? "http_status"];

        // No response body exists - carry the failure details instead
        var _errorBody = {error: "network_error", status: async_load[? "status"], url: async_load[? "url"]};

        if (is_method(_requestObject.errorback)) {
            _requestObject.errorback(_errorBody, _requestObject);
        }

        if (variable_struct_exists(_system.__activeGitHubRequests, _requestID)) {
            var _ghRequestObject = _system.__activeGitHubRequests[$ _requestID];

            _ghRequestObject.httpStatus = async_load[? "http_status"];

            if (is_method(_ghRequestObject.errorback)) {
                _ghRequestObject.errorback(_errorBody, _ghRequestObject);
            }
        }

        // Clean up the request (header map and active tables)
        __GitHubRequestCleanup(_requestID);
    }
}
