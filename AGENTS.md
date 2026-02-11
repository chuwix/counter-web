# Repository Guidelines

## Project Structure & Module Organization
- `src/` holds Gleam application modules (UI flow, scoreboard, HTTP handlers). Mirror OTP supervision by grouping files under namespaces such as `counter/display` and `counter/web`.
- `test/` mirrors `src/` and keeps data builders in `test/support/` so fixtures do not leak into production code.
- `priv/static/` contains the tiny web dashboard assets served by the embedded HTTP server; keep generated bundles in `priv/static/js/`.
- `firmware/` stores AtomVM bundle artifacts (`counter.avm`) plus wiring notes for the three-button + OLED setup.

## Build, Test, and Development Commands
- `gleam deps download && gleam build` compiles Gleam to BEAM bytecode; run whenever dependencies change.
- `gleam run` boots the supervision tree on your host for quick iteration (keyboard shortcuts simulate button events).
- `gleam test` executes the unit/integration suite; combine with `GLEAM_TARGET=erlang` for CI parity.
- `make firmware` (see `firmware/Makefile`) packages `_build/default/avm/*.beam` into an AtomVM image and copies it to the Pi Zero over `scp`.

## Coding Style & Naming Conventions
- Use Gleam formatter (`gleam format`) before committing; indentation stays at two spaces and pipelines are preferred over deeply nested `case` blocks.
- Modules follow `counter_*` prefixes (e.g., `counter_scoreboard`); public functions use verbs (`add_borrow/2`) while records keep noun names.
- Guard every public function with type annotations and favor tagged unions over bare integers for state machines.

## Testing Guidelines
- Co-locate happy-path and edge-case tests under `test/<module>_test.gleam` with descriptive names such as `scratch_fails_when_points_insufficient`.
- Mock button and web inputs via the provided `InputHarness` helpers; never hit actual GPIO in tests.
- Target 90% line coverage for core modules (`scoreboard`, `ui_flow`, `web_api`) and add regression tests for every bugfix.

## Commit & Pull Request Guidelines
- Follow Conventional Commits (`feat: add scratch safeguards`, `fix: debounce buttons`) so release tooling can cut firmware versions automatically.
- Each PR should include: summary of behavior change, testing evidence (`gleam test`, hardware smoke notes), and screenshots/GIFs for UI alterations.
- Reference issue IDs in the PR description and add a deployment checklist when firmware artifacts or wiring docs change.

## Security & Configuration Tips
- Never store secrets in the repo; place Wi-Fi credentials or API keys in device-specific `.env` files ignored by git.
- Validate GPIO pin assignments in `config/pins.toml` before flashing to prevent shorts, and document any wiring changes in `firmware/README.md`.
