// chaosnexus-scripts/lib/string_utils.rhai
//
// Shared Rhai utilities importable from any plugin via:
//   import "lib/string_utils" as su;
//   su::join_nonempty(["a", "", "b"], "-");

fn join_nonempty(parts, sep) {
    let out = "";
    for p in parts {
        if p != "" {
            if out != "" {
                out += sep;
            }
            out += p;
        }
    }
    out
}

fn add_ten(x) {
    x + 10
}

export LIB_VERSION;
const LIB_VERSION = 1;
