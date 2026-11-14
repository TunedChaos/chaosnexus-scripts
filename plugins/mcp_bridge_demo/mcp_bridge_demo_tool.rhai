// scripts/plugins/mcp_bridge_demo/mcp_bridge_demo_tool.rhai
//
// Demonstrates the outbound MCP client bridge (Phase 3): a Rhai script that
// reaches OUT to an external MCP server, discovers its tools, and invokes one.
//
// This makes ChaosNexus Anvil a bidirectional MCP node: it serves its own tools to
// orchestrators (see other plugins) AND can consume any external MCP server,
// as long as a script can describe how to launch and call it.
//
// Native functions used (registered by native_api/mcp_client.rs):
//   mcp_connect(PLUGIN_NAME, conn_id, command, args[])  -> ()
//   mcp_list_tools(conn_id)                             -> Array<Map>
//   mcp_call_tool(conn_id, tool_name, args_map)         -> Map (structured result)
//   mcp_read_resource(conn_id, uri)                     -> String
//   mcp_disconnect(conn_id)                             -> ()

// --- [NODE: on_plugin_start] ---
fn on_plugin_start() {
    // "mcp_bridge_probe": launch an external MCP server, list its tools, then
    // shut it down. The caller supplies the launch command and arguments, so
    // this single tool can probe ANY stdio MCP server.
    let probe_schema = "{\"type\":\"object\",\"properties\":{" +
        "\"command\":{\"type\":\"string\",\"description\":\"Executable to launch the MCP server (e.g. npx).\"}," +
        "\"args\":{\"type\":\"array\",\"items\":{\"type\":\"string\"},\"description\":\"Arguments passed to the executable.\"}" +
        "},\"required\":[\"command\"]}";
    register_mcp_tool(PLUGIN_NAME, "mcp_bridge_probe", "Launch an external MCP server and list the tools it exposes.", probe_schema);

    // "mcp_bridge_relay": launch an external MCP server and invoke one of its
    // tools, relaying the structured result back to the orchestrator.
    let relay_schema = "{\"type\":\"object\",\"properties\":{" +
        "\"command\":{\"type\":\"string\",\"description\":\"Executable to launch the MCP server.\"}," +
        "\"args\":{\"type\":\"array\",\"items\":{\"type\":\"string\"},\"description\":\"Arguments passed to the executable.\"}," +
        "\"tool\":{\"type\":\"string\",\"description\":\"Name of the downstream tool to invoke.\"}," +
        "\"tool_args\":{\"type\":\"object\",\"description\":\"Arguments object forwarded to the downstream tool.\"}" +
        "},\"required\":[\"command\",\"tool\"]}";
    register_mcp_tool(PLUGIN_NAME, "mcp_bridge_relay", "Launch an external MCP server and call one of its tools, returning the result.", relay_schema);
}

// --- [NODE: probe] ---
fn probe(args) {
    let command = args.command;
    let cmd_args = if args.contains("args") { args.args } else { [] };

    mcp_connect(PLUGIN_NAME, "probe_conn", command, cmd_args);
    let tools = mcp_list_tools("probe_conn");
    mcp_disconnect("probe_conn");

    let names = [];
    for t in tools {
        names.push(t.name);
    }
    return "Downstream tools: " + names.to_string();
}

// --- [NODE: relay] ---
fn relay(args) {
    let command = args.command;
    let cmd_args = if args.contains("args") { args.args } else { [] };
    let tool_args = if args.contains("tool_args") { args.tool_args } else { #{} };

    mcp_connect(PLUGIN_NAME, "relay_conn", command, cmd_args);
    let result = mcp_call_tool("relay_conn", args.tool, tool_args);
    mcp_disconnect("relay_conn");

    return result.to_string();
}

// --- [NODE: execute] ---
fn execute(tool_name, args) {
    if tool_name == "mcp_bridge_probe" {
        return probe(args);
    } else if tool_name == "mcp_bridge_relay" {
        return relay(args);
    }
    return "Unknown tool: " + tool_name;
}
