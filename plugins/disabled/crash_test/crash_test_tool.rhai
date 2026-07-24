fn on_plugin_start() {
    throw "FATAL ERROR INTENTIONALLY THROWN!";
    throw "FATAL ERROR INTENTIONALLY THROWN!";
}
fn on_all_plugins_loaded() {
    print("This should not run if on_plugin_start fails");
}
