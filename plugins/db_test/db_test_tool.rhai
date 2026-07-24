fn on_plugin_start() {
    let schema_str = "{\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"}}}";
    register_mcp_tool(PLUGIN_NAME, "test_db", "Tests the SeaORM integration", schema_str);
    
    // Connect to in-memory sqlite
    db_connect(PLUGIN_NAME, "test_db", "sqlite::memory:");
    
    // Initialize schema
    let create_sql = "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT NOT NULL)";
    db_execute("test_db", create_sql, []);
    
    print("[db_test] Initialized in-memory SQLite database.");
}

fn on_all_plugins_loaded() {
    print("[db_test] Ready.");
}

fn execute(tool_name, args) {
    if tool_name == "test_db" {
        let name = "Chaos";
        if args.contains("name") {
            name = args.name;
        }
        
        let insert_sql = "INSERT INTO users (name) VALUES ($1)";
        let rows = db_execute("test_db", insert_sql, [name]);
        
        let select_sql = "SELECT * FROM users";
        let records = db_query("test_db", select_sql, []);
        
        let result_str = "Inserted " + rows + " row(s). Current records: ";
        for rec in records {
            result_str += " { id: " + rec.id + ", name: '" + rec.name + "' }";
        }
        
        return result_str;
    }
}
