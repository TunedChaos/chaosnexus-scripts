// chaosnexus-scripts/plugins/http_get_demo/http_get_demo_tool.rhai

fn on_plugin_start() {
    register_mcp_tool(
        PLUGIN_NAME,
        "http_get_demo",
        "Fetch a URL via HTTP GET (host must allowlist the domain)",
        "{\"type\": \"object\", \"properties\": {\"url\": {\"type\": \"string\"}}, \"required\": [\"url\"]}"
    );
}

fn execute(tool_name, params) {
    if tool_name == "http_get_demo" {
        return http_get(params.url);
    }
    return "Unknown tool";
}

fn on_all_plugins_loaded() {
    print("[http_get_demo] Ready.");
}
