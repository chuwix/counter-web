# Counter Web Design

## Overview
Counter Web is a Gleam application compiled to BEAM bytecode and executed through AtomVM on a Raspberry Pi Zero. It lets users pick a nickname, add “borrow” points, scratch points, and view everyone’s totals via both a physical interface and a lightweight web dashboard.

## Hardware Topology
- Single Pi Zero hosts the runtime; no co-processor is required.
- SPI OLED (e.g., SH1106/SSD1306) provides the mini display.
- Three momentary buttons wired to GPIO act as Up, Down, and Confirm; long presses unlock advanced actions.
- Optional UART logging offers developer telemetry while running headless.

## Runtime & Supervision
- Gleam modules mirror OTP conventions and are bundled into AtomVM images for deployment.
- Supervision tree components:
  - `DisplayServer` drives the OLED refresh loop.
  - `InputServer` debounces and translates button presses into events.
  - `Scoreboard` manages nickname structs and persistence.
  - `UIFlow` orchestrates state transitions and view changes.
  - `WebEndpoint` exposes REST handlers and serves static assets.

## Persistence Strategy
- Nicknames live in-memory as `%Nickname{name, points}` records.
- A dual-slot CBOR file (e.g., `priv/data/scoreboard.cbor`) persists state after every N mutations, each slot guarded by CRC to recover from power loss.
- The device never depends on cloud services; all state stays on-disk locally.

## UI & Interaction Flow
- Home view lists up to three nicknames; Up/Down scroll, Confirm selects or creates.
- Tapping Confirm on “Borrow” increments a point; holding Confirm enables rapid increments.
- Holding Down enters Scratch mode where Up/Down choose how many points to remove before Confirm applies.
- Holding Up+Down opens an “All Stats” carousel cycling every nickname and total.

## Web Interface
- Embedded HTTP server (Cowboy-like adapter for AtomVM) provides:
  - `GET /stats` to list current nicknames and points.
  - `POST /nicknames` to create/select names.
  - `POST /nicknames/:id/borrow` and `POST /nicknames/:id/scratch` for point mutations.
- Static dashboard assets live in `priv/static/` and mirror the OLED display for remote monitoring.
- LAN deployment assumes implicit trust; upgrade paths include adding token headers or mTLS if exposed beyond the local network.

## Implementation Plan
Development progresses through five levels documented in `PLAN.md`, each ending with a merge request:
1. **L1** – Bootable placeholder prototype with health check and IO logging.
2. **L2** – Nickname creation/selection with persisted scoreboard.
3. **L3** – Borrow increments across buttons and web API.
4. **L4** – Scratch gestures/API with underflow protection.
5. **L5** – Web dashboard parity plus basic authentication.

Refer to `PLAN.md` for full acceptance criteria and verification steps before advancing.

## Current Progress
- Active level: **L1** (featureless working prototype).
- Latest log entries and verification evidence live in `PROGRESS.md`. Update this file after every notable milestone (tests, manual checks, MR submission) so the next agent understands remaining work.
- Each phase concludes with `gh pr create --fill --base main --head <branch>` once all acceptance criteria pass and the user grants a greenlight.
