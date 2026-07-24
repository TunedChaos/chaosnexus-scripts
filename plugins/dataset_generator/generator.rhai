// chaosnexus-scripts/plugins/dataset_generator/generator.rhai
//
// Native Rhai dataset generator plugin for ChaosNexus Tuned.
// Generates industrial automation training dataset pairs (ChatML JSONL, Alpaca, and ShareGPT)
// natively inside ChaosNexus Anvil with zero external Python dependencies.

/// Lifecycle hook executed when the dataset_generator plugin starts.
/// Registers the `generate_synthetic_datasets` MCP tool.
// --- [NODE: on_plugin_start] ---
fn on_plugin_start() {
    let schema_str = "{\"type\":\"object\",\"properties\":{" +
        "\"output_dir\":{\"type\":\"string\",\"description\":\"Target output directory relative to scripts root (default: chaosnexus-tuned/datasets/core).\"}" +
        "}}";
    register_mcp_tool(PLUGIN_NAME, "generate_synthetic_datasets", "Generate fine-tuning dataset JSONL files natively inside ChaosNexus Anvil.", schema_str);
}

/// Helper function to create a ChatML turn.
fn make_turn(role, content) {
    return #{ "role": role, "content": content };
}

/// Helper function to create an Alpaca instruction entry.
fn make_alpaca_entry(instruction, input_text, output_text) {
    return #{
        "instruction": instruction,
        "input": input_text,
        "output": output_text
    };
}

/// Helper function to create a ShareGPT conversation entry.
fn make_sharegpt_entry(human_val, gpt_val) {
    return #{
        "conversations": [
            #{ "from": "human", "value": human_val },
            #{ "from": "gpt", "value": gpt_val }
        ]
    };
}

/// Main logic for generating dataset files natively.
/// @param args Map containing optional `output_dir`.
// --- [NODE: generate_synthetic_datasets] ---
fn generate_synthetic_datasets(args) {
    let out_dir = "chaosnexus-tuned/datasets/core";
    if args.contains("output_dir") && args.output_dir != "" {
        out_dir = args.output_dir;
    }

    let sys_prompt = "You are ChaosNexus Tuned, the industrial automation brain of the Tuned Chaos ecosystem.\n\n" +
        "# GLOBAL RULES\n" +
        "1. NARRATIVE COMMENTING: All generated code MUST include thorough, narrative comments explaining the logic.\n" +
        "# MATRIX C: AGENTIC JSON TOOL PROTOCOL\n" +
        "1. Output valid JSON objects representing tool calls.\n" +
        "2. Format: {\"tool_calls\": [{\"name\": \"tool_name\", \"arguments\": {\"arg1\": \"val1\"}}]}\n";

    // Scenario 1: Simple Web Request
    let prompt1 = "Write and execute a Rhai script that makes a GET request to http://localhost:1420/ and logs status.";
    let script1 = "// We use native HTTP client to perform a GET request\nlet response = http_get(\"http://localhost:1420/\");\nprint(\"Server Status: \" + response.status);\n";
    let gpt_res1 = "{\"tool_calls\": [{\"name\": \"check_server\", \"arguments\": {\"url\": \"http://localhost:1420/\"}}]}";

    // Scenario 2: File Processing & Filtering
    let prompt2 = "Write and execute a Rhai script that searches for .toml or .json files in the directory and logs lines with port.";
    let script2 = "// Scan directory for config files\nlet files = fs_list_dir(\".\");\nfor file in files {\n    if file.ends_with(\".toml\") {\n        let content = fs_read(file);\n        print(\"Read: \" + file);\n    }\n}\n";
    let gpt_res2 = "{\"tool_calls\": [{\"name\": \"config_scanner\", \"arguments\": {\"dir\": \".\"}}]}";

    let chatml_entries = [
        #{
            "messages": [
                make_turn("system", sys_prompt),
                make_turn("user", prompt1),
                make_turn("assistant", gpt_res1)
            ]
        },
        #{
            "messages": [
                make_turn("system", sys_prompt),
                make_turn("user", prompt2),
                make_turn("assistant", gpt_res2)
            ]
        }
    ];

    let alpaca_entries = [
        make_alpaca_entry(prompt1, "", script1),
        make_alpaca_entry(prompt2, "", script2)
    ];

    let sharegpt_entries = [
        make_sharegpt_entry(prompt1, gpt_res1),
        make_sharegpt_entry(prompt2, gpt_res2)
    ];

    // Build output JSON strings
    let jsonl_content = "";
    for item in chatml_entries {
        jsonl_content += to_json(item) + "\n";
    }

    let alpaca_json = to_json(alpaca_entries);
    let sharegpt_json = to_json(sharegpt_entries);

    // Save outputs using native Rhai fs_write
    fs_write(out_dir + "/train_rhai.jsonl", jsonl_content);
    fs_write(out_dir + "/train_alpaca_rhai.json", alpaca_json);
    fs_write(out_dir + "/train_sharegpt_rhai.json", sharegpt_json);

    return "Successfully generated datasets natively in " + out_dir + ": train_rhai.jsonl, train_alpaca_rhai.json, train_sharegpt_rhai.json";
}

/// Tool execution router.
// --- [NODE: execute] ---
fn execute(tool_name, args) {
    if tool_name == "generate_synthetic_datasets" || tool_name.ends_with("generate_synthetic_datasets") {
        return generate_synthetic_datasets(args);
    }
    return "Unknown tool: " + tool_name;
}
