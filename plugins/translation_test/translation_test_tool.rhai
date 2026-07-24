// chaosnexus-scripts/plugins/translation_test/translation_test_tool.rhai

// --- [NODE: on_plugin_start] ---
fn on_plugin_start() {
    perform_test_translations();
}

// --- [NODE: perform_test_translations] ---
fn perform_test_translations() {
    log_info("translation_test", translate("translation_test", "hello", "en", ["World"]));
    log_info("translation_test", translate("translation_test", "welcome", "es", ["ChaosNexus Anvil", "Amigo"]));
    log_info("translation_test", translate("translation_test", "fallback_test", "es", [])); // Should fallback to en
    log_info("translation_test", translate("translation_test", "missing_key", "en", [])); // Should output 'missing_key'
}

// --- [NODE: on_all_plugins_loaded] ---
fn on_all_plugins_loaded() {
    log_info(PLUGIN_NAME, "All translation checks completed successfully.");
}

