# ChaosNexus Scripts

Shared Rhai plugins and libraries consumed by **ChaosNexus Anvil**.

It is published on GitHub as [chaosnexus-scripts](https://github.com/TunedChaos/chaosnexus-scripts).

- **Support:** [Tuned Chaos supporters](https://tunedchaos.com/supporters/) or [GitHub Sponsors](https://github.com/sponsors/TunedChaos)

GitHub is the primary public host. Please open issues and pull requests on **GitHub**.

Point Anvil `scripts_dir` at this tree (workspace default: `../chaosnexus-scripts` from `chaosnexus-anvil/`). Standalone clones of this repo should set `scripts_dir` to the checkout root. The ChaosNexus Suite installer ships a pruned copy of this tree next to Forge.

Docs: [chaosnexus.ai/guide/chaosnexus-scripts/about](https://chaosnexus.ai/guide/chaosnexus-scripts/about)

> **Status:** early public alpha launch (pre-1.0).

## Layout

- `plugins/` - hot-reloadable Rhai plugins
- `lib/` - shared Rhai libraries

### Bundled examples

| Plugin | Role |
|--------|------|
| `translation_test` | Hello-world i18n / translation layer |
| `terminal` | Allowlisted commands via argv `run_command` (no shell `-c`) |
| `time` | System clock + optional NTP |
| `http_get_demo` | HTTP GET against host `net_allowlist` |
| `mcp_bridge_demo` | Outbound MCP client probe/relay |
| `noaa_ghcn_demo` | Twelve-city NOAA GHCN-Daily demo helpers |

All examples are **deny-by-default**: grant capabilities and explicit `net_allowlist` / `shell` entries in host `[plugins.<name>]` config. Never use bare `*` for network unless you opt in with `CHAOSNEXUS_ANVIL_ALLOW_NET_STAR=1`.

Add your own plugins under `plugins/<name>/` with a `plugin.toml` and entry `.rhai` script. Forge may also keep canvas sidecars under `.chaosnexus-forge/` (editor metadata only).

Maintainer alpha-launch helpers live in the workspace at `tools/launch/` (not published here).

## AI assistance

Some code in this project was generated with assistance from AI. Humans directed architecture, review, and maintenance. See [AI_ASSISTANCE.md](AI_ASSISTANCE.md).

## Support

ChaosNexus is built by Tuned Chaos, a small independent studio. Support goes to the studio as a whole and keeps every Tuned Chaos project online. There is no support SLA.

- Monthly or one-time: [GitHub Sponsors](https://github.com/sponsors/TunedChaos)
- Card, any amount, with an optional ChaosNexus pick at checkout, or Chia (XCH): [Tuned Chaos supporters page](https://tunedchaos.com/supporters/)

File bugs on [chaosnexus-suite Issues](https://github.com/TunedChaos/chaosnexus-suite/issues) (pick a Component).


## License

AGPL-3.0-or-later (same as ChaosNexus Anvil). Contribute on GitHub.
