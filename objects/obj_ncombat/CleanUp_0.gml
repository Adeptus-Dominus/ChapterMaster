// combat_debugger is initialized in Create_0 (as upstream does) since the merged
// enemy targeting alarm calls it. The guard stays as belt and braces for any
// battle instance that predates the initialization.
if (!variable_instance_exists(self, "combat_debugger")) {
    exit;
}
combat_debugger.cleanup();
