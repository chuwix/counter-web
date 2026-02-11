# Implementation Plan

This roadmap defines sequential levels (L1–L5). Do not start a level until the previous one is complete and approved.

| Level | Goal | Acceptance Criteria | Required Verification |
| --- | --- | --- | --- |
| **L1** | Featureless working prototype | 1) `gleam build` and `gleam test` succeed, 2) AtomVM image renders a placeholder splash on the OLED, 3) Button presses are logged over UART, 4) Embedded web server responds `200 OK` on `/health`, 5) README documents build/run steps | - Capture `gleam test` output.<br>- Provide UART log snippet proving button events.<br>- `curl` output for `/health`.<br>- Photo/screenshot of placeholder screen or simulator. |
| **L2** | Persistent nickname list & local display | 1) Buttons allow creating/selecting nicknames, 2) Nicknames persist via `priv/data/scoreboard.cbor` with checksum rollover, 3) `GET /stats` mirrors on-device data, 4) Unit tests for add/select/persist flows, 5) README updated with nickname usage | - `gleam test` suite covering persistence.<br>- Dump of CBOR file showing checksum.<br>- `curl /stats` output.<br>- Manual verification log entry. |
| **L3** | Borrow increments across UI & API | 1) Confirm button increments borrow counter with debounce, 2) `POST /nicknames/:id/borrow` updates storage atomically, 3) Data survives reboot, 4) Property test enforces monotonic increments, 5) OLED/web reflect updated totals in real time | - Test logs for unit/property tests.<br>- Reboot test notes.<br>- Video/photo of increment in UI.<br>- API call transcript. |
| **L4** | Scratch functionality | 1) Hold-Down gesture enters Scratch mode with bounds enforcement, 2) `POST /nicknames/:id/scratch` subtracts up to current total, 3) Regression tests prevent underflow, 4) Hardware log proving gesture works, 5) README documents scratch workflow | - Test suite output.<br>- UART/OLED evidence.<br>- API regression logs.<br>- Updated docs diff reference. |
| **L5** | Full web dashboard parity | 1) Static dashboard mirrors OLED data via polling/SSE, 2) Mutation endpoints require shared token, 3) Automated browser test (Playwright) covers dashboard flows, 4) Telemetry/monitoring notes captured, 5) README and `priv/static/README` updated | - Playwright test log.<br>- Screenshot of dashboard.<br>- Security review checklist.<br>- Documentation updates referenced. |

## Phase Completion Checklist
1. Implement features for the level.
2. Run automated and manual tests listed above.
3. Log results in `PROGRESS.md` under the corresponding level.
4. Update `README.md` with current functionality and status.
5. Create MR via `gh pr create --fill --base main --head <branch>` and wait for approval.
