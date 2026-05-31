#macro UPDATE_CHECKER global.update_checker

/// @desc Checks GitHub for newer game releases. Create with `new UpdateChecker()`.
/// Encapsulates HTTP request lifecycle and update state.
function UpdateChecker() constructor {
    request_id = undefined;
    repo = "Adeptus-Dominus/ChapterMaster";

    /// Latest version tag from GitHub (e.g. "main/2026-05-28-2011")
    latest_version = "";
    /// URL to the release page on GitHub
    latest_release_url = "";
    /// Whether a newer version than current is available
    update_available = false;
    /// Debug or release build
    compiled = false;

    /// @desc Fires HTTP request to GitHub releases API.
    /// Called once at startup after global.game_version is set.
    static check = function() {
        var _url = $"https://api.github.com/repos/{repo}/releases/latest";
        var _headers = ds_map_create();
        _headers[? "Accept"] = "application/json";
        _headers[? "User-Agent"] = "ChapterMaster-UpdateChecker";
        request_id = http_request(_url, "GET", _headers, "");
        ds_map_destroy(_headers);
    };

    /// @desc Handles async HTTP response. Called from HTTP async event.
    /// @param {Id.DsMap} _async_map async_load map
    /// @return {Bool} true if update available, false otherwise
    static handle = function(_async_map) {
        if (ds_map_find_value(_async_map, "id") != request_id) {
            return false;
        }

        var _http_status = ds_map_find_value(_async_map, "http_status");
        if (_http_status != 200) {
            LOGGER.error($"HTTP {_http_status}, skipping");
            update_available = false;
            return update_available;
        }

        var _result = ds_map_find_value(_async_map, "result");
        if (_result == "") {
            LOGGER.error("Empty response body, skipping");
            update_available = false;
            return update_available;
        }

        var _json;
        try {
            _json = json_parse(_result);
        } catch (_e) {
            LOGGER.error("json_parse failed, skipping", _e);
            update_available = false;
            return update_available;
        }

        var _latest_tag = _json[$ "tag_name"] ?? "";
        if (_latest_tag == "") {
            LOGGER.error("No tag_name in response, skipping");
            update_available = false;
            return update_available;
        }

        update_available = _latest_tag != $"{global.game_version}/{global.build_date}";
        latest_version = _latest_tag;
        latest_release_url = _json[$ "html_url"] ?? "";

        return update_available;
    };
}
