# Quiblets iPad Project Atlas

This is the handoff document for continuing the Quiblets family iPad edition in
a new Codex task. It records who owns which repository, what the family branch
preserves, the current release state, how upstream updates are reconciled, how
the iPad build is produced, and how Haley prefers to work through changes.

Snapshot date: **September 23, 2026**
Local branch: **`ipad-release`**  
Latest code merge: **`a606c65` — Merge Bright's regional encounter update**
Latest reviewed Brighton commit: **`0008aee` — Add regional encounters and
Quiblets, refine cooking and expedition visuals**

## 1. People, ownership, and intent

- **Bright / Brighton-L** is the primary game creator and maintains the original
  Quiblets repository. His gameplay systems, creature artwork, imported models,
  textures, music, and later revisions are the upstream source of truth.
- **Haley / HWLowy** maintains the family iPad branch and performs the physical
  iPad play tests. She is semi-technical and wants to understand the process,
  not merely receive unexplained commands.
- Haley's husband supplies the Apple Developer account, development team, and
  signing identity used for the current family build.
- Bright created the artwork, creature designs, and music. No replacement
  third-party art or music has been introduced by this branch.
- The goal is to follow Bright's game closely while preserving useful iPad
  controls, family-tested balance, approved fallback creature details, and
  navigation improvements until Bright replaces or adopts them.

## 2. Repository map

| Role | Location | Purpose |
| --- | --- | --- |
| Brighton's original repository | `https://github.com/Brighton-L/quiblets` | Canonical upstream game development |
| Haley's fork | `https://github.com/HWLowy/quiblets` | Family iPad branch and release history |
| Local working copy | `/Users/haleylowy/Documents/Codex/2026-09-10/i/work/quiblets-merge` | Repository to inspect, edit, test, and commit |
| Family branch | `ipad-release` | Mergeable iPad and family-testing edition |
| `upstream` remote | `Brighton-L/quiblets` | Fetch Bright's new `main` commits from here |
| `origin` remote | `HWLowy/quiblets` | Push the maintained `ipad-release` branch here |

Useful mental model:

```text
Brighton-L/quiblets main
          │
          │ reviewed upstream merge
          ▼
HWLowy/quiblets ipad-release
          │
          │ Godot iOS export
          ▼
fresh Xcode project → signed development build → family iPad
```

Do not make family changes directly on Brighton's `main`. Work on
`ipad-release`, then merge Bright's new work into that branch.

## 3. Exact current state

At this snapshot:

- `upstream/main` is at `0008aee` and has been merged.
- Local `ipad-release` and `origin/ipad-release` are synchronized. The published
  history includes Brighton's `0008aee` commit, the `a606c65` family merge
  resolution, and the updated release notes and atlas.
- The merge adopts Brighton's repaired Berry Grove loop and edge indicators,
  restores every spice presentation surface to his default compact symbols,
  and makes placed garden seed/fertilizer ingredients draggable out again.
- The family training targets, reduced helper-retention odds, and three-extra-
  stone revitalizer cost are preserved and verified.
- `project.godot` has been restored to its required committed iPad settings and
  is clean. Both iOS minimum-version entries now specify 15.0.
- No physical iPad build has yet been exported from `a606c65`; the spice,
  gardening, Berry Grove audio, and edge indicators still need device testing.

Seven untracked test `.uid` files remain. They are generated Godot metadata and
were intentionally not swept into the merge commit:

- `tests/area_encounters.gd.uid`
- `tests/navigation_flows.gd.uid`
- `tests/power_stone_recycling.gd.uid`
- `tests/recycler_visual.gd.uid`
- `tests/stone_inventory_tabs.gd.uid`
- `tests/stone_inventory_tabs_preview.gd.uid`
- `tests/stone_recycler_preview.gd.uid`

The first checks in a new task should therefore be:

```bash
cd /Users/haleylowy/Documents/Codex/2026-09-10/i/work/quiblets-merge
git status --short --branch
git diff -- project.godot
git log --oneline --decorate -5
```

Success criterion: the new task reports the same branch, ahead count, and dirty
files before changing anything.  
What this achieves: it protects uncommitted local state and prevents work from
starting on the wrong checkout.

## 4. Primary records and source-of-truth files

- `IPAD_RELEASE_NOTES.md` — detailed chronological release history, values,
  verification results, and player-visible behavior.
- `docs/ipad-visual-overrides.md` — exact maintained creature shapes, hook
  locations, preview scenes, and post-merge checks.
- `docs/ipad-touch-scrolling-review.md` — all touch-scroll surfaces and the
  expected iPad gesture behavior.
- `AGENTS.md` — mandatory player-save protection. Tests and previews must never
  read from or write to the real player save.
- `export_presets.cfg` — iOS architecture, team, bundle identifier, icon, and
  export settings.
- `scripts/quiblet_visual_overrides.gd` — isolated fallback creature geometry.
- `textures/UI/QuibletsAppIcon.png` — approved expedition-island home-screen
  icon.

Read those files before a new upstream merge. This atlas is the map; the release
notes contain the full historical detail.

## 5. What the family branch is intentionally holding

### iPad behavior and packaging

- A 16:9 game composition with intentional side bars on wider iPads.
- Touch-to-pointer compatibility for existing controls.
- One-finger swipe scrolling on active overflowing lists, with thin desktop
  scrollbars hidden on touch surfaces.
- Touch gestures distinguish swipes, taps, and drag-and-drop actions.
- ARM64 iOS export, approved icon, family bundle identifier, and development
  signing configuration.
- A smoke-test guard requiring `res://main.tscn` as the exported start scene.

### Maintained creature details

Bright's supplied models and portraits always take priority. The family branch
keeps these only where Bright has not supplied a comparable replacement:

- Swellit water-drop silhouette/portrait fallback; Plip uses Brighton's model.
- Brighton's supplied Spriggle, Frondle, and Bloomie models take precedence.
  The older procedural definitions remain dormant fallbacks only.
- Sparko and Scorchit rounded, varied-height three-flame crowns.

The hooks are deliberately isolated so an upstream model update can replace the
art without discarding the whole iPad branch.

### Power Stone experience

- Health, Attack, and Move inventory tabs on a Quiblet's equipment screen.
- Paired paging arrows away from the Back button.
- A deliberately positioned Stone Workshop shortcut.
- Stone recycling available both from Bright's equipment-screen location and
  from the Stone Workshop.
- Batch recycling of up to fifteen unfitted stones, visible combined rewards,
  and tier-scaled replacement rewards.
- Recycler special-item odds by tier: 0.1%, 0.2%, 0.3%, 0.4%, 0.5%.
- Recycler spice odds by tier: 1%, 2%, 3%, 4%, 5%.
- Each Workshop mode preserves its own inventory scroll position when a stone
  is selected, removed, or processed.
- Revitalizing one target stone consumes three additional unfitted stones.

### Navigation and presentation

- Resources → Cooking works; if a stew is active, a small message says
  **A stew is already in progress!** instead of opening an unusable pot.
- Cooking has a Spice Workshop shortcut and preserves the pot while visiting it.
- Expedition island taps always stop at the level route so the player explicitly
  chooses a level.
- Expedition reward taps cannot pass through into the next screen.
- Tapping a newly arrived Quiblet opens that exact Quiblet for inspection.
- Berry Groves use Brighton's repaired dedicated loop.
- Berry Groves use Brighton's screen-edge indicators for remaining patches;
  the temporary family ground arrow has been removed.
- Regular encounters follow a broader S-shaped route with a 22–32-unit walking
  budget, preserving exploration without the former long empty walks.
- Every spice surface uses Brighton's default compact symbol display. Names,
  qualities, effects, tooltips, and inventory data remain available without the
  family branch's larger custom overlays.
- Placed garden seeds and fertilizer can be moved between slots or dragged away
  to remove them without consuming inventory or cancelling the planting menu.

### Family balance

- Bright's current fruit-bearing scenery mechanism is used, with the exact
  probabilities and quality behavior documented in `IPAD_RELEASE_NOTES.md`.
- Bright's catch-up training mechanism is used with lower family targets:
  50% same species, 46% same evolution family, 42% same type, 38% unrelated.
- Ingredient-based helper-retention chances remain half of Bright's original
  values. Move Training success rates were not changed.

## 6. What came from Bright and should normally win

The latest merged upstream work includes Bright's:

- four new imported creature models, regional encounter weighting, dual typing,
  expanded recipes, rolling hills, foreground-tree fading, fainted collision,
  and refined combat visuals;
- repaired Berry Grove music and viewport-edge berry patch indicators;
- camp gardening, new Quiblets, imported models, portraits, and ingredients;
- expanded recipes, team presets, fitted-equipment display, and evolution pause;
- regional map, discovery system, map cache, expedition and movement work;
- animated Quiblet arrival sequence and current core cooking presentation;
- current Stone Workshop structure, equipment UI, move mechanics, charms, and
  fifteen-stone recycler limit;
- scenery fruit-bearing and deliberate-harvest systems;
- catch-up-style EXP training mechanism.

Merge rule: **if Bright changed or replaced the same feature, prefer his newer
design unless Haley explicitly decides otherwise. If Bright did not touch the
family change, keep it.** Never settle a meaningful overlap silently—summarize
Bright's version, the family version, and the proposed resolution for Haley.

## 7. Upstream-update procedure

### Step 1 — Establish a clean, understood starting point

Inspect the branch, remotes, pending commits, and every dirty file. Preserve
unrelated user work.

Success criterion: all local changes are accounted for and the correct branch
is active.  
What this achieves: no update or generated file is accidentally lost.

### Step 2 — Fetch both repositories

Fetch `upstream` and `origin`, then compare:

- `HEAD..upstream/main` for Bright's new commits;
- `upstream/main..HEAD` for family-only work;
- file-level diffs for likely overlaps.

Success criterion: the exact latest Bright commit and the local/remote branch
positions are known.  
What this achieves: the merge is based on evidence rather than assumptions.

### Step 3 — Review before merging

Summarize Bright's additions, performance improvements, artwork replacements,
and any files that overlap the family branch. Ask Haley to confirm genuinely
ambiguous product decisions before resolving them.

Success criterion: Haley understands the meaningful conflicts and approves the
resolution policy.  
What this achieves: Bright's work receives priority without silently deleting a
still-needed family improvement.

### Step 4 — Merge narrowly

Merge `upstream/main` into `ipad-release`. Resolve conflicts by behavior, not by
accepting an entire version of a large file. Reapply or adapt only the smallest
family hooks that Bright did not replace.

Success criterion: the merge completes with no conflict markers and both sets
of intended behavior are present.  
What this achieves: the branch remains easy to update again.

### Step 5 — Verify automatically and visually

Run focused checks for every changed system, then the smoke check. For creature
or layout changes, use the dedicated Godot preview scenes before integrating or
exporting.

Success criterion: tests report zero failures and Haley approves relevant visual
previews.  
What this achieves: regressions are found before reaching the iPad.

### Step 6 — Record and commit

Update `IPAD_RELEASE_NOTES.md` and this atlas when the branch state or process
changes. Make scoped commits with rich messages that explain the player-facing
result and preservation decision.

Success criterion: `git log` tells the story of the change, and unrelated dirty
files are not included.  
What this achieves: future merges and handoffs can be reconstructed reliably.

## 8. Test and preview process

Godot binary currently used:

```text
/Users/haleylowy/Documents/Codex/2026-09-10/i/work/tools/Godot.app/Contents/MacOS/Godot
```

Project folder:

```text
/Users/haleylowy/Documents/Codex/2026-09-10/i/work/quiblets-merge
```

Example headless check:

```bash
/Users/haleylowy/Documents/Codex/2026-09-10/i/work/tools/Godot.app/Contents/MacOS/Godot --headless --path /Users/haleylowy/Documents/Codex/2026-09-10/i/work/quiblets-merge --script res://tests/smoke.gd -- --no-save
```

Important focused checks include:

- `tests/smoke.gd`
- `tests/touch_scrolling.gd`
- `tests/visual_overrides.gd`
- `tests/ingredient_drops.gd`
- `tests/power_stone_recycling.gd`
- `tests/training.gd`
- `tests/stone_inventory_tabs.gd`
- `tests/stone_workshop_scroll.gd`
- `tests/navigation_flows.gd`
- `tests/areas.gd`
- `tests/cooking_quality.gd`
- `tests/music_states.gd`
- `tests/encounter_pacing.gd`
- `tests/stone_workshop.gd`

Interactive preview scenes include:

- `tests/quiblet_visual_overrides_preview.tscn`
- `tests/quiblet_portrait_preview.tscn`
- `tests/stone_recycler_preview.tscn`
- `tests/stone_inventory_tabs_preview.tscn`

Never test with the player's real save. Follow `AGENTS.md`, prefer headless
checks, and use `-- --no-save` for graphical test runs. After using F6 on a
preview, confirm the project start scene is still `res://main.tscn` before an
export.

## 9. iPad export and installation process

### Current devices and signing

- Primary test iPad: **Gra Skanegas**, iPad Pro 12.9-inch (6th generation),
  iPadOS 26.6.2.
- Planned second device: Bright's iPad Pro 13-inch (M4), iPadOS 26.6.1.
- Apple development team ID: `J8L78ZF8PC`.
- Bundle identifier: `com.hwl.quiblets.preview`.
- Signing: automatic, using **Apple Development** for both Debug and Release.
- Do not manually select Apple Distribution for this direct development build;
  it conflicts with automatic development signing.

### Step 1 — Verify Godot before export

Open the local `project.godot` in Godot and confirm the normal game reaches Base
Camp. Confirm `run/main_scene="res://main.tscn"`, the iOS preset is selected,
ARM64 is enabled, the icon is correct, and signing values are present.

Success criterion: the main game—not a preview—runs in Godot and the smoke test
passes.  
What this achieves: the exported package contains the real game.

### Step 2 — Export a fresh Xcode project

Always export to a new folder named for the current commit. Do not reuse an old
Xcode snapshot because its `.pck` can contain an earlier game.

The latest successful export was:

```text
/Users/haleylowy/Documents/Codex/2026-09-10/i/work/build/ios-preview-a605ad7-xcode/Quiblets.xcodeproj
```

Success criterion: Godot finishes the iOS export and the new folder contains
`Quiblets.xcodeproj` and a freshly written `Quiblets.pck`.  
What this achieves: Xcode receives the exact tested branch contents.

### Step 3 — Verify the corrected Xcode 27 deployment target

The previous `export_presets.cfg` contained an intended `15.0` entry and a
later legacy `14.0` entry. The generated Xcode project therefore failed under
Xcode 27 with:

```text
The iOS deployment target is set to 14.0, but the supported range starts at 15.0.
```

For the successful `a605ad7` build, all generated
`IPHONEOS_DEPLOYMENT_TARGET` values were changed from `14.0` to `15.0` in the
fresh Xcode project's `project.pbxproj`, after which the build succeeded.

The legacy preset value was corrected to `15.0` in `a606c65`. On the next fresh
export, verify the generated Xcode project says 15.0 everywhere without manual
editing. Do not assume the fix is device-verified until that export succeeds.

Success criterion: the fresh Xcode project uses iOS 15.0 everywhere.  
What this achieves: Xcode 27 can compile the project while both family iPads
remain fully supported.

### Step 4 — Sign and choose the physical iPad

Open the fresh `.xcodeproj`, select the Quiblets target, and check **Signing &
Capabilities**. Select the husband's team, enable automatic signing, and verify
Apple Development. In Xcode's top destination menu, choose the physical device
**Gra Skanegas**, not an iPad simulator.

Success criterion: Xcode shows no provisioning conflict and the physical device
name appears beside the Quiblets scheme.  
What this achieves: the Mac is ready to install the build on the trusted iPad.

### Step 5 — Build, install, and launch

Connect and unlock the iPad, confirm it trusts the Mac, then press Xcode's Run
triangle.

Success criterion: Xcode reports **Build Succeeded**, the app opens on the iPad,
and it progresses beyond the Godot loading screen.  
What this achieves: the current branch is installed as a playable development
build.

The current Xcode warnings about empty camera, microphone, and photo-library
usage descriptions and `#pragma once in main file` did not block the successful
build. They should be cleaned up before a polished public release.

### Step 6 — Physical play test

Check the areas changed in that release plus a short standard route: launch,
Base Camp, Cooking, Spice Workshop, Stone Workshop, Quiblet equipment,
Expeditions, rewards, and save/relaunch.

Success criterion: touch gestures, navigation, visuals, audio, and the player's
existing save all behave correctly.  
What this achieves: the build is ready for wider family testing.

## 10. Preferred way of working with Haley

- Lead with the outcome in plain language; explain technical terms only when
  they help Haley understand the process.
- For every guided step, state:
  1. the exact action and which program/menu to use;
  2. the visible success criterion;
  3. what the step accomplishes.
- Give one step at a time during hands-on Godot, Xcode, signing, or device work.
  Wait for Haley to report success before moving on when she is operating the
  interface.
- Provide copyable Terminal commands without apostrophes or decorative quote
  marks around paths. These project paths contain no spaces and do not need
  quotes.
- Prefer doing code, configuration, comparison, and testing directly. Ask Haley
  to act only when an account decision, device interaction, signing choice, or
  visual approval genuinely needs her.
- For creature art or other visual changes, make and present one change at a
  time for approval unless Haley explicitly asks for a combined first draft.
- Prefer a live Godot preview scene over a separate rendered mockup. Explain how
  to open the modified local project and which scene to run.
- When Bright has pushed an update, inspect and summarize it first. Identify
  overlaps and ask for confirmation before resolving meaningful design
  conflicts.
- Bright's newer implementation and artwork normally override family changes in
  the same area. Preserve family changes only when Bright has not supplied a
  comparable update or Haley explicitly chooses to retain them.
- Keep commit messages and release notes rich: include why, player-visible
  behavior, important values, tests, and what must survive the next merge.
- Never use, reset, migrate, or overwrite the player's real save while testing.
- Do not hide uncertainty. If a GitHub push, device install, or build has not
  actually been verified, say so precisely.

## 11. Immediate continuation checklist

1. Export a fresh Xcode project named for the current commit; do not reuse the
   `a605ad7` project.
2. Confirm the generated Xcode project uses iOS 15.0 everywhere and builds
   without manually editing `project.pbxproj`.
3. On the physical iPad, verify Brighton's spice symbols in the Workshop,
   cooking inventory, and pot; drag a placed seed and fertilizer out of their
   garden slots; and check Berry Grove music and screen-edge indicators.
4. Before merging any newer Bright release, fetch `upstream`, report its commit
   range and overlaps, and obtain Haley's decision on genuine conflicts.
5. Continue updating `IPAD_RELEASE_NOTES.md` for release history and this atlas
   for repository/process/handoff changes.

## 12. Suggested opening message for the next task

> Continue the Quiblets iPad work using `QUIBLETS_IPAD_ATLAS.md` and
> `IPAD_RELEASE_NOTES.md` in the local `quiblets-merge` repository. First inspect
> and report the current branch, remotes, pending commits, dirty files, and
> whether Brighton has pushed anything newer. Do not merge until you summarize
> overlaps. Prefer Brighton's newer work where it overlaps, preserve untouched
> family iPad changes, protect the real player save, and guide me one step at a
> time with a success criterion and purpose for each step.
