// Fork guard: the fork combat object does not create combat_debugger (upstream
// debug system); skip this upstream-added event when it is absent.
if (!variable_instance_exists(self, "combat_debugger")) {
    exit;
}
combat_debugger.cleanup();
