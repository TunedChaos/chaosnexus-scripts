# Shared Rhai libraries (`chaosnexus-scripts/lib/`)

Pure utility modules live here. They must **not** call `register_tool`, `register_cvar`, or other side-effectful plugin APIs at import time.

## Importing from a plugin

Plugin-local helpers (same directory as the loading script):

```rhai
import "helpers" as h;
h::format_reply(args);
```

Shared libraries (this directory):

```rhai
import "lib/string_utils" as su;
su::join_nonempty(["a", "", "b"], "-");
```

Members are accessed with `::` (similar to C++ namespaces).

## Authoring rules

1. Keep modules side-effect free (functions and exported constants only).
2. Use `private fn` for internal helpers you do not want exported.
3. Use `export` for constants that should be visible outside the module.
4. Do not import another plugin's entry script; use `call_native` for runtime cross-plugin calls.

## Load order

`plugin.toml` `dependencies` only controls **startup order**, not imports. Shared code belongs in `chaosnexus-scripts/lib/` or in plugin-local files.
