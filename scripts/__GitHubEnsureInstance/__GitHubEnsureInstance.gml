// Feather ignore all

/// @ignore
function __GitHubEnsureInstance() {
    if (!instance_exists(__github_worker)) {
        instance_activate_object(__github_worker);
        if (instance_exists(__github_worker)) {
            __GitHubWarn("`__github_worker` was deactivated. Please ensure that this object instance is never deactivated.");
        } else {
            instance_create_depth(0, 0, 0, __github_worker);
        }
    }
}
