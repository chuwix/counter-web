# Repository Guidelines

## Project Structure & Module Organization
- `src/` holds Gleam application modules (UI flow, scoreboard, HTTP handlers). Mirror OTP supervision by grouping files under namespaces such as `counter/display` and `counter/web`.
- `test/` mirrors `src/` and keeps data builders in `test/support/` so fixtures do not leak into production code.
- `priv/static/` contains the tiny web dashboard assets served by the embedded HTTP server; keep generated bundles in `priv/static/js/`.
- `firmware/` stores AtomVM bundle artifacts (`counter.avm`) plus wiring notes for the three-button + OLED setup.

## Worktree Workflow
- Every phase runs in its own worktree under `.worktrees/<branch_name>`; create one with `git worktree add .worktrees/<branch> -b <branch> main`.
- Do not commit directly on `main`; checkout the worktree (e.g., `cd .worktrees/phase-1`) before editing, testing, or building firmware.
- Push the worktree branch after each meaningful milestone or commit (`git push -u origin <branch>` for the first push, `git push` thereafter) so intermediate results are shared.
- When a phase finishes, push the branch and prune stale worktrees via `git worktree remove .worktrees/<branch>` once merged.

## Implementation Workflow & Phases
- Follow the level-based roadmap in `PLAN.md` (L1 featureless prototype through L5 full dashboard). Each level builds strictly on the previous one.
- Before starting work, record the intended tasks for the level inside `PROGRESS.md` so other agents can see in-flight efforts.
- After each milestone, update `PROGRESS.md` and push the branch so intermediate results are visible to other agents.
- A level is considered complete only when all acceptance criteria listed in `PLAN.md` are satisfied, automated/manual tests are logged in `PROGRESS.md`, and the user grants an explicit greenlight.
- Never advance to the next level until the current one is marked “Complete” both in `PLAN.md` and under “Current Status” in `PROGRESS.md`.

## Testing Methodology
- Default automation: `gleam test` (with `GLEAM_TARGET=erlang`) for unit/integration tests, plus `gleam format --check` to enforce style.
- Hardware-in-loop script (`scripts/hil_smoke.sh`) must run for levels requiring physical validation; capture UART snippets or photos in `PROGRESS.md`.
- Web API regression tests (`test/web_api_test.gleam`) should accompany any REST change; add property tests (`gleam check`) for invariants like monotonic borrow counts.
- Manual OLED/button verification steps must be documented with timestamp and tester initials in the “Verification Log” section of `PROGRESS.md`.

## Merge Request Process
- Each level ends with a merge request (MR) from its worktree branch into `main`. Use GitHub CLI for consistency: `gh pr create --fill --base main --head <branch>`.
- Include in the MR description: link to the level in `PLAN.md`, summary of acceptance criteria, test results (command outputs), and screenshots/logs for hardware features.
- Ensure `PLAN.md`, `PROGRESS.md`, and `README.md` are updated and ready for approval before opening the MR.
- Await reviewer approval or explicit user greenlight before merging; once merged, prune the worktree.

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
