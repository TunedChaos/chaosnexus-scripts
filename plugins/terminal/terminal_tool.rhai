// chaosnexus-scripts/plugins/terminal/terminal_tool.rhai

// --- [NODE: on_plugin_start] ---
fn on_plugin_start() {
    let cfg = load_config(PLUGIN_NAME, "config.toml");
    
    // keys() gives us all the keys in the map
    let keys = cfg.commands.keys();
    
    for key in keys {
        let desc = "Run terminal command: " + key;
        let schema_str = "{\"type\":\"object\",\"properties\":{\"args\":{\"type\":\"array\",\"items\":{\"type\":\"string\"},\"description\":\"Arguments\"}}}";
        register_mcp_tool(PLUGIN_NAME, key, desc, schema_str);
    }
}


// --- [NODE: on_all_plugins_loaded] ---
fn on_all_plugins_loaded() {
    print("[terminal] Ready to execute configured commands.");
}

// --- [NODE: execute] ---
fn execute(tool_name, args) {
    let cfg = load_config(PLUGIN_NAME, "config.toml");
    let key = tool_name;
    let prefix = "cn_a_" + PLUGIN_NAME + "_";
    if key.starts_with(prefix) {
        key = key.sub_string(prefix.len());
    }
    let legacy_prefix = "chaoswrench_" + PLUGIN_NAME + "_";
    if key.starts_with(legacy_prefix) {
        key = key.sub_string(legacy_prefix.len());
    }

    let cmd = cfg.commands[key].command;
    
    let full_cmd = cmd;
    if args.contains("args") {
        let arr = args["args"];
        for a in arr {
            full_cmd += " " + a;
        }
    }
    
    let shell = "sh";
    let os = sys_os();
    
    if os == "windows" {
        shell = "powershell";
    } else if os == "macos" {
        shell = "zsh";
    } else {
        let env_shell = get_env("SHELL");
        if env_shell != "" {
            shell = env_shell;
        } else {
            shell = "sh";
        }
    }
    
    if cfg.contains("default_shell") {
        shell = cfg.default_shell;
    }
    
    if cfg.commands[key].contains("shell") {
        shell = cfg.commands[key].shell;
    }
    
    return run_command(shell, full_cmd);
}