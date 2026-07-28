# chaosnexus-scripts/README.md

# ChaosNexus Scripts

Shared Rhai plugins and libraries consumed by **ChaosNexus Anvil**.

In the monorepo this directory lives at `chaosnexus-scripts/`. On Codeberg it is published as [chaosnexus-scripts](https://codeberg.org/TunedChaos/chaosnexus-scripts) ([GitHub mirror](https://github.com/TunedChaos/chaosnexus-scripts)).

Point Anvil `scripts_dir` at this tree (monorepo default: `../chaosnexus-scripts` from `chaosnexus-anvil/`). Standalone clones of this repo should set `scripts_dir` to the checkout root. The ChaosNexus Suite installer ships a pruned copy of this tree next to Forge.

Docs: [chaosnexus.ai/guide/chaosnexus-scripts/about](https://chaosnexus.ai/guide/chaosnexus-scripts/about)

> **Status:** early public alpha launch (pre-1.0).

## Layout

- `plugins/` - hot-reloadable Rhai plugins
- `lib/` - shared Rhai libraries

### Bundled example

Suite and this polyrepo ship **one** example plugin:

- `plugins/translation_test/` - hello-world style demo of the plugin translation / i18n layer

Add your own plugins under `plugins/<name>/` with a `plugin.toml` and entry `.rhai` script. Forge may also keep canvas sidecars under `.chaosnexus-forge/` (editor metadata only).

Maintainer alpha-launch helpers live in the monorepo at `tools/launch/` (not published here). Forge canvas parity fixtures (for example `terminal`) live under `chaosnexus-forge/fixtures/scripts/` in the monorepo and are not published here.

## AI assistance

Some code in this project was generated with assistance from AI. Humans directed architecture, review, and maintenance. See [AI_ASSISTANCE.md](AI_ASSISTANCE.md).

## License

AGPL-3.0-or-later (same as ChaosNexus Anvil). Contribute on Codeberg.
