# chaosnexus-scripts/README.md

# ChaosNexus Scripts

Shared Rhai plugins and libraries consumed by **ChaosNexus Anvil**.

In the monorepo this directory lives at `chaosnexus-scripts/`. On Codeberg it is published as [chaosnexus-scripts](https://codeberg.org/TunedChaos/chaosnexus-scripts) ([GitHub mirror](https://github.com/TunedChaos/chaosnexus-scripts)).

Point Anvil `scripts_dir` at this tree (monorepo default: `../chaosnexus-scripts` from `chaosnexus-anvil/`). Standalone clones of this repo should set `scripts_dir` to the checkout root.

Docs: [chaosnexus.ai/guide/chaosnexus-scripts/about](https://chaosnexus.ai/guide/chaosnexus-scripts/about)

> **Status:** early public alpha launch (pre-1.0).

## Layout

- `plugins/` - hot-reloadable Rhai plugins
- `lib/` - shared Rhai libraries

Maintainer alpha-launch helpers live in the monorepo at `tools/launch/` (not published here).

## AI assistance

Some code in this project was generated with assistance from AI. Humans directed architecture, review, and maintenance. See [AI_ASSISTANCE.md](AI_ASSISTANCE.md).

## License

AGPL-3.0-or-later (same as ChaosNexus Anvil). Contribute on Codeberg.
