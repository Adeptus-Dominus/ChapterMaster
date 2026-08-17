// Feather disable all

/// @ignore
function __GitHubWarn(_string) {
    if (GITHUB_GML_RUNNING_FROM_IDE) {
        show_error($" \nGitHub.gml:\n{_string}\n ", true);
    } else {
        show_debug_message($"GitHub.gml: Warning! {_string}");
    }
}
