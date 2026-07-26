// chaosnexus-scripts/plugins/mcp_bridge_demo/mcp_bridge_demo_tool.rhai
//
// Demonstrates the outbound MCP client bridge: a Rhai script that
// reaches OUT to an external MCP server, discovers its tools, and invokes one.
//
// This makes ChaosNexus Anvil a bidirectional MCP node: it serves its own tools to
// orchestrators AND can consume any external MCP server,
// as long as a script can describe how to launch and call it.

/// Lifecycle hook executed when the mcp_bridge_demo plugin starts.
/// Registers mcp_bridge_probe and mcp_bridge_relay tools.
// --- [NODE: on_plugin_start] ---
fn on_plugin_start() {
    let probe_schema = "{\"type\":\"object\",\"properties\":{" +
        "\"command\":{\"type\":\"string\",\"description\":\"Executable to launch the MCP server (e.g. npx).\"}," +
        "\"args\":{\"type\":\"array\",\"items\":{\"type\":\"string\"},\"description\":\"Arguments passed to the executable.\"}" +
        "},\"required\":[\"command\"]}";
    register_mcp_tool(PLUGIN_NAME, "mcp_bridge_probe", "Launch an external MCP server and list the tools it exposes.", probe_schema);

    let relay_schema = "{\"type\":\"object\",\"properties\":{" +
        "\"command\":{\"type\":\"string\",\"description\":\"Executable to launch the MCP server.\"}," +
        "\"args\":{\"type\":\"array\",\"items\":{\"type\":\"string\"},\"description\":\"Arguments passed to the executable.\"}," +
        "\"tool\":{\"type\":\"string\",\"description\":\"Name of the downstream tool to invoke.\"}," +
        "\"tool_args\":{\"type\":\"object\",\"description\":\"Arguments object forwarded to the downstream tool.\"}" +
        "},\"required\":[\"command\",\"tool\"]}";
    register_mcp_tool(PLUGIN_NAME, "mcp_bridge_relay", "Launch an external MCP server and call one of its tools, returning the result.", relay_schema);
}

/// Launches an external MCP stdio server and queries its available tool definitions.
/// @param args Map containing `command` and optional `args` list.
// --- [NODE: probe] ---
fn probe(args) {
    let command = args.command;
    let cmd_args = if args.contains("args") { args.args } else { [] };

    mcp_connect("probe_conn", command, cmd_args);
    let tools = mcp_list_tools("probe_conn");
    mcp_disconnect("probe_conn");

    let names = [];
    for t in tools {
        names.push(t.name);
    }
    return "Downstream tools: " + names.to_string();
}

/// Launches an external MCP stdio server and forwards a tool call request to it.
/// @param args Map containing `command`, `args`, `tool`, and `tool_args`.
// --- [NODE: relay] ---
fn relay(args) {
    let command = args.command;
    let cmd_args = if args.contains("args") { args.args } else { [] };
    let tool_args = if args.contains("tool_args") { args.tool_args } else { #{} };

    mcp_connect("relay_conn", command, cmd_args);
    let result = mcp_call_tool("relay_conn", args.tool, tool_args);
    mcp_disconnect("relay_conn");

    return result.to_string();
}

/// Tool execution router for MCP bridge demo tools.
// --- [NODE: execute] ---
fn execute(tool_name, args) {
    if tool_name == "mcp_bridge_probe" || tool_name.ends_with("mcp_bridge_probe") {
        return probe(args);
    } else if tool_name == "mcp_bridge_relay" || tool_name.ends_with("mcp_bridge_relay") {
        return relay(args);
    }
    return "Unknown tool: " + tool_name;
}
