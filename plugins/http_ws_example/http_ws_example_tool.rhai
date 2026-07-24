fn on_plugin_start() {
    register_mcp_tool(
        "http_get_demo",
        "Demonstrates fetching a URL via HTTP GET",
        "{\"type\": \"object\", \"properties\": {\"url\": {\"type\": \"string\"}}, \"required\": [\"url\"]}"
    );
    register_mcp_tool(
        "ws_connect_demo",
        "Connects to a WebSocket URL",
        "{\"type\": \"object\", \"properties\": {\"url\": {\"type\": \"string\"}}, \"required\": [\"url\"]}"
    );
    register_mcp_tool(
        "ws_close_demo",
        "Closes a WebSocket connection",
        "{\"type\": \"object\", \"properties\": {\"url\": {\"type\": \"string\"}}, \"required\": [\"url\"]}"
    );
}

fn execute(tool_name, params) {
    if tool_name == "http_get_demo" {
        let url = params.url;
        let response = http_get(url);
        return response;
    } else if tool_name == "ws_connect_demo" {
        let url = params.url;
        // ws_connect doesn't return anything but it establishes the connection and invokes the callback on message
        ws_connect(PLUGIN_NAME, url, "on_ws_message");
        return "WebSocket connection established. Call ws_close_demo with the same URL to disconnect.";
    } else if tool_name == "ws_close_demo" {
        let url = params.url;
        ws_close(url);
        return "WebSocket connection closed.";
    }
    return "Unknown tool";
}

fn on_ws_message(msg) {
    print("Received WS message in HTTP/WS Example: " + msg);
}

fn on_plugin_stop() {
    print("Stopping HTTP/WS Example plugin...");
}

fn on_all_plugins_loaded() {
    print("HTTP/WS Example plugin fully loaded.");
}
