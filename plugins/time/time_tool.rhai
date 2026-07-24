// chaosnexus-scripts/plugins/time/time_tool.rhai

/// Lifecycle hook executed when the time plugin starts.
/// Registers get_system_time and get_ntp_time tools.
// --- [NODE: on_plugin_start] ---
fn on_plugin_start() {
    let schema_str = "{\"type\":\"object\",\"properties\":{\"timezone\":{\"type\":\"string\",\"description\":\"Optional timezone string\"}}}";
    register_mcp_tool(PLUGIN_NAME, "get_system_time", "Get system time", schema_str);
    
    let ntp_schema = "{\"type\":\"object\",\"properties\":{\"server\":{\"type\":\"string\",\"description\":\"Optional server. Default: pool.ntp.org\"}}}";
    register_mcp_tool(PLUGIN_NAME, "get_ntp_time", "Get time from NTP server", ntp_schema);
}

/// Lifecycle hook executed after all plugins are loaded.
// --- [NODE: on_all_plugins_loaded] ---
fn on_all_plugins_loaded() {
    print("[time] Time plugin is ready!");
}

/// Retrieves the current system timestamp in the specified timezone.
/// @param args Map with optional `timezone` key.
// --- [NODE: get_system_time] ---
fn get_system_time(args) {
    let tz = "UTC";
    if args.contains("timezone") {
        tz = args.timezone;
    }
    return system_time(tz);
}

/// Fetches accurate network timestamp from an NTP server pool.
/// @param args Map with optional `server` domain key.
// --- [NODE: get_ntp_time] ---
fn get_ntp_time(args) {
    let srv = "pool.ntp.org";
    if args.contains("server") {
        srv = args.server;
    }
    return ntp_request(srv, 123);
}

/// Tool execution router for time tools.
// --- [NODE: execute] ---
fn execute(tool_name, args) {
    if tool_name == "get_system_time" || tool_name.ends_with("get_system_time") {
        return get_system_time(args);
    } else if tool_name == "get_ntp_time" || tool_name.ends_with("get_ntp_time") {
        return get_ntp_time(args);
    }
    return "Unknown tool";
}
