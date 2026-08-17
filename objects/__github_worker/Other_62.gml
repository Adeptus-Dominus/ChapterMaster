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

        // Get Result
        _requestObject.result = async_load[? "result"];

        // Delete The Header Map
        if (ds_exists(_requestObject.headerMap, ds_type_map)) {
            ds_map_destroy(_requestObject.headerMap);
        }

        // Delete From Active Requests
        variable_struct_remove(_system.__activeRequests, _requestID);

        // Get GitHub Request
        if (variable_struct_exists(_system.__activeGitHubRequests, _requestID)) {
            // Set Status
            _ghRequestObject.httpStatus = async_load[? "http_status"];
            _ghRequestObject.responseHeaders = __DSMapToStruct(async_load[? "response_headers"]);

            // Get GitHub Request Object
            var _ghRequestObject = _system.__activeGitHubRequests[$ _requestID];

            // Parse The Incoming JSON, a status code of 204 means there is nothing to parse
            if (async_load[? "http_status"] != 204) {
                _ghRequestObject.parseResult(_requestObject.result);
            }

            // Now we need to run the callbacks
            if (async_load[? "http_status"] >= 200 && async_load[? "http_status"] <= 299) {
                if (is_method(_ghRequestObject.callback)) {
                    _ghRequestObject.callback(_ghRequestObject.result, _ghRequestObject);
                }
            } else if (async_load[? "http_status"] >= 400 && async_load[? "http_status"] <= 599) {
                if (is_method(_ghRequestObject.errorback)) {
                    _ghRequestObject.errorback(_ghRequestObject.result, _ghRequestObject);
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

            // Delete From Active GitHub Requests
            variable_struct_remove(_system.__activeGitHubRequests, _requestID);
        }
    }
}
