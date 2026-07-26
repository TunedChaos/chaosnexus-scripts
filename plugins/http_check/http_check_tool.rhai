// Rhai entry script for http_check tool
// Purpose: Perform an HTTP GET request to the supplied URL, extract the HTTP status code and a JSON field (e.g., 'url' from the response), and print a formatted summary.
// Input: A JSON object with a single key 'url' containing the target URL.
// Output: A string summarizing the request result.

// Import the HTTP client library provided by Rhai (assumed to be available as `http` module).
import http

// Function to perform the request and return a summary string.
fn check_url(url) {
    // Perform GET request; assume `http.get` returns a map with `status` and `body` keys.
    let resp = http.get(url)
    // Extract status code (numeric) from response map.
    let status = resp.status
    // Parse JSON body into a map.
    let json_body = json::parse(resp.body)
    // Example: extract the 'url' field from the JSON response (common in httpbin).
    let extracted_field = json_body.url
    // Build a formatted summary string.
    let summary = format! "HTTP {} request to {} succeeded. Extracted JSON field 'url' = {}.\n", status, url, extracted_field
    summary
}

// Main entry point: expects input as a JSON object.
let input = json::parse(input_json)
let url = input.url
let result = check_url(url)
println(result)
