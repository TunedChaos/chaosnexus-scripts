// chaosnexus-scripts/plugins/noaa_ghcn_demo/noaa_ghcn_demo_tool.rhai
// Twelve-city GHCN-Daily station set used by the ChaosNexus demo.

fn stations() {
    return [
        #{ city: "New York", station: "Central Park", id: "USW00094728" },
        #{ city: "Chicago", station: "O'Hare Intl", id: "USW00094846" },
        #{ city: "Los Angeles", station: "LAX", id: "USW00023174" },
        #{ city: "Seattle", station: "Sea-Tac", id: "USW00024233" },
        #{ city: "Dallas", station: "DFW", id: "USW00003927" },
        #{ city: "Houston", station: "IAH", id: "USW00012960" },
        #{ city: "Austin", station: "Bergstrom Intl", id: "USW00013904" },
        #{ city: "Orlando", station: "Orlando Intl", id: "USW00012815" },
        #{ city: "San Diego", station: "San Diego Intl", id: "USW00023188" },
        #{ city: "Phoenix", station: "Sky Harbor Intl", id: "USW00023183" },
        #{ city: "Anchorage", station: "Ted Stevens Intl", id: "USW00026451" },
        #{ city: "Honolulu", station: "Honolulu Intl", id: "USW00022521" }
    ];
}

fn station_url(id) {
    return "https://www.ncei.noaa.gov/pub/data/ghcn/daily/by_station/" + id + ".csv.gz";
}

fn on_plugin_start() {
    register_mcp_tool(
        PLUGIN_NAME,
        "list_demo_stations",
        "List the twelve NOAA GHCN-Daily demo stations",
        "{\"type\":\"object\",\"properties\":{}}"
    );
    register_mcp_tool(
        PLUGIN_NAME,
        "station_csv_url",
        "Build the GHCN-Daily by_station CSV.gz URL for a station id",
        "{\"type\":\"object\",\"properties\":{\"id\":{\"type\":\"string\"}},\"required\":[\"id\"]}"
    );
    register_mcp_tool(
        PLUGIN_NAME,
        "fetch_station_csv_head",
        "HTTP GET a station CSV.gz (host must allowlist www.ncei.noaa.gov); returns response body/bytes summary",
        "{\"type\":\"object\",\"properties\":{\"id\":{\"type\":\"string\"}},\"required\":[\"id\"]}"
    );
}

fn execute(tool_name, args) {
    if tool_name == "list_demo_stations" {
        return stations().to_string();
    } else if tool_name == "station_csv_url" {
        return station_url(args.id);
    } else if tool_name == "fetch_station_csv_head" {
        let url = station_url(args.id);
        return http_get(url);
    }
    return "Unknown tool: " + tool_name;
}

fn on_all_plugins_loaded() {
    print("[noaa_ghcn_demo] Twelve-city GHCN helpers ready.");
}
