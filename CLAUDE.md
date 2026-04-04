# MT EA Repository — Claude Code Global Instructions

## Repository Structure
/
├── CLAUDE.md                  ← Global instructions (this file)
├── .memory/
│   └── REPO_MAP.md            ← Master index of all EAs and files
└── <EA-Name>/
    ├── CLAUDE.md              ← EA-specific instructions
    ├── README.md
    ├── .memory/
    │   ├── PROJECT_STATE.md
    │   └── <FileName>.mem.md  ← One memory file per code file
    └── src/
        └── <FileName>.mq5

## Core Workflow — Follow This Every Single Session

### Step 1 — Orient (ALWAYS first, no exceptions)
1. Read /CLAUDE.md (this file)
2. Read /.memory/REPO_MAP.md
3. Read the EA-specific <EA-Name>/CLAUDE.md if working inside a project
4. Read <EA-Name>/.memory/PROJECT_STATE.md
5. Scan all *.mem.md files in the relevant .memory/ folder
6. Identify which source files need changes based on memory files
7. Read ONLY those source files — never read unrelated files

### Step 2 — Plan Before Touching Code
- State your understanding of the required change in one paragraph
- List exactly which files will be created / modified / deleted
- If ambiguous, ask ONE clarifying question before proceeding

### Step 3 — Implement (follow Decoupled Architecture below)

### Step 4 — Update Memory (ALWAYS last, no exceptions)
- Update the .mem.md for every file touched
- Update PROJECT_STATE.md with what changed and why
- Update REPO_MAP.md if new files or folders were created

## Code Architecture — Decoupled Pattern (Mandatory for all EAs)

Every EA must be split into these layers, each in its own file:

| Layer    | File           | Responsibility                            |
|----------|----------------|-------------------------------------------|
| Config   | Config.mqh     | All inputs and constants — nothing else   |
| Market   | Market.mqh     | Price data, indicators, symbol info       |
| Signal   | Signal.mqh     | Entry/exit signal logic only              |
| Risk     | Risk.mqh       | Lot sizing, SL/TP calculation             |
| Trade    | Trade.mqh      | Order placement, modification, close      |
| Utils    | Utils.mqh      | Logging, formatting, shared helpers       |
| Core EA  | <EAName>.mq5   | OnInit/OnDeinit/OnTick — orchestration only |

Rules:
- No layer imports from a layer above it (no circular dependencies)
- OnTick must read like plain English — only function calls, no raw logic
- All magic numbers go in Config.mqh, never inline
- Every function does ONE thing
- Max function length: 40 lines — if longer, split it
- Use CTrade for all order operations
- Use CPositionInfo, COrderInfo for state queries
- Always check GetLastError() after trade operations
- All Print statements must include EA name prefix: [EAName]
- Handle every return value from trade functions

## Memory File Format — <FileName>.mem.md

# Memory: <FileName>.<ext>

## Purpose
One sentence: what this file does.

## Exports (public functions / classes / inputs)
- FunctionName(params) → return type — what it does

## Dependencies
- Imports from: [list of files]
- Imported by: [list of files]

## Key Decisions
- <date> — <decision and reason>

## Known Issues / TODOs
- [ ] <issue>

## Last Modified
- Date: YYYY-MM-DD
- Change: <one-line summary>

## Token & Memory Optimization Rules

Reading:
- NEVER read a file you don't need to modify
- Use memory files to locate changes — read source only to confirm
- When memory files are sufficient, do not re-read source code

Writing:
- Keep memory files under 120 lines — summarize older entries
- If PROJECT_STATE.md exceeds 200 lines, archive old entries under ## Archive
- Prefer targeted edits over full rewrites

Context Management:
- At session start, load: CLAUDE.md + REPO_MAP.md + project memory files (~5 files max before reading code)
- Never load all EA source files at once — lazy-load on demand
- If context is getting large, say so and ask which task to prioritize

## Commit Message Format
[EA-Name] <type>: <short description>
type: feat | fix | refactor | docs | memory | struct

## MQL5 Code Standards
- Use CTrade class for all order operations
- Use CPositionInfo, COrderInfo for state queries
- Always check GetLastError() after trade operations
- Use #define for constants in Config.mqh
- No magic numbers inline ever
- All Print/Log must include EA name prefix
- Handle every possible return value from trade functions
