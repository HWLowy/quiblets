# Quiblets iPad Release Notes

This document records the purpose, decisions, completed work, verification, and
release process for the family iPad edition maintained on the `ipad-release`
branch of `HWLowy/quiblets`.

Status: **Playable family test build**  
Last updated: **September 20, 2026**
Latest integrated upstream commit: **`148cac2`**
Godot entry scene for an actual build: **`res://main.tscn`**

## Purpose of this branch

`ipad-release` follows Brighton's main Quiblets development while preserving a
small set of family-edition changes:

- iPad-friendly input and scrolling
- iOS export and signing configuration
- the approved home-screen icon
- maintained Quiblet model and portrait refinements
- family play-test balance adjustments
- focused regression checks and interactive Godot preview scenes

This branch is intended to remain mergeable with Brighton's work. Features
should be isolated where practical, and every upstream merge should be followed
by the preservation and verification checks below.

## Current iPad and iOS configuration

- The game keeps its 16:9 composition on wider iPad screens, so narrow bars at
  the sides are intentional.
- Touch input emulates mouse input for existing controls.
- The iOS export is ARM64 and exports an Xcode project for signing and device
  installation.
- The minimum deployment target is iOS 15.0, which is supported by Xcode 27
  while remaining far below the family iPads' current operating-system version.
- The current preview bundle identifier is `com.hwl.quiblets.preview`.
- Automatic development signing uses an Apple Development identity. Do not set
  the Release identity to Apple Distribution for a direct development build;
  that conflicts with automatic signing.
- The approved app icon is
  `res://textures/UI/QuibletsAppIcon.png`, showing the first expedition island
  with a Quiblet and scenery.

Before every export, confirm that `project.godot` has:

```ini
run/main_scene="res://main.tscn"
```

Godot can temporarily change this setting after running an individual preview
scene with F6. The export guard in `tests/smoke.gd` detects that mistake.

## Completed work

### September 20 gameplay and interface polish

- Berry Groves now use the regular Expedition music. The unfinished
  `BerryGrove.wav` asset remains in the repository for Brighton to revisit,
  but it is no longer selected during play.
- Expedition result screens consume the complete touch and advance only after
  release, with the screen change deferred until that input is finished. A tap
  at the bottom of the rewards screen can therefore no longer pass through to
  a Quiblet portrait on the Expeditions map.
- Tapping a newly arrived Quiblet's reveal now opens that exact Quiblet's full
  inspection/equipment screen. Back returns to the next arrival when a stew
  produced several Quiblets, or to Base Camp after the final arrival.
- Every spice now has a dependable image-backed icon. Cooking cards display
  both the spice name and quality—for example, `Punch Pepper (Great)`—without
  requiring a hover or long press.
- A spice placed in the pot keeps its icon, quality color, name, and quality in
  the slot instead of appearing invisible.
- Regular battle locations still respect the 22–32-unit walking budget, but
  now favor a broad S-shaped sweep across the island. This exposes more of the
  map and ingredient scenery while avoiding the old cross-map hikes.
- Berry Groves show a small, translucent gold ground arrow beside the team. It
  continuously turns toward the nearest remaining berry patch and disappears
  when every patch is collected.
- Revitalizing now requires four selected stones: the first is improved and
  the other three unfitted Power Stones are consumed. The Workshop explains
  the cost, distinguishes the target from the consumed stones, previews the
  result, and prevents applying an incomplete selection.

### iPad controls and interaction

- Prepared existing drag-and-drop and selection controls for touch input.
- Added direct team membership controls and touch-friendly ways to inspect and
  remove fitted stones and cooking items.
- Added one-finger scrolling throughout every active overflowing resource,
  cooking, recipe, item, workshop, recycler, and expedition-reward list.
- Hidden the thin desktop scrollbars on touch lists while retaining mouse-wheel
  and trackpad behavior on desktop.
- Added direction locking, a movement threshold, and gentle momentum so a swipe
  is not mistaken for a tap or a drag into a slot.
- Replaced the Spice Workshop's old narrow horizontal ingredient row with a
  two-row grid that shows all sixteen ingredients without scrolling.

Detailed scrolling coverage and retest criteria live in
`docs/ipad-touch-scrolling-review.md`.

### Maintained Quiblet designs

Brighton's supplied artwork and imported 3D models now take precedence. The
following family-edition details remain as fallbacks only where Brighton has
not supplied a replacement:

- **Plip:** Brighton's imported model, with the family water-drop portrait as
  a fallback where no supplied icon is available.
- **Swellit:** smooth family-edition water-drop silhouette and portrait.
- **Spriggle:** Brighton's current imported model and supplied portrait.
- **Frondle:** Brighton's current imported model and supplied portrait.
- **Bloomie:** Brighton's imported flower-hat model and supplied portrait.
- **Sparko:** larger three-height flame crown while retaining its tail.
- **Scorchit:** larger rounded three-height flame crown blended into its body.
- **Blubber:** Brighton's imported hovering model.
- Brighton's supplied Bloomie, Frondle, and Spriggle portraits take precedence;
  procedural portraits remain available for species without supplied icons.

The procedural geometry is isolated in
`scripts/quiblet_visual_overrides.gd`. Full preservation instructions and
preview scenes are in `docs/ipad-visual-overrides.md`.

### Power Stone experience

- Added the Power Stone Recycler as a fifth tab inside the Stone Workshop, so
  combining, revitalizing, converting, reforging, and recycling all live in one
  stone-management destination.
- Brighton's red **Recycle** button remains on each Quiblet's equipment screen.
  It opens the same shared Workshop Recycler and returns to that Quiblet when
  the Workshop closes, so recycling is available from both useful locations.
- Up to fifteen unfitted stones can be selected and recycled together.
- Every Stone Workshop mode remembers its own inventory position when a stone
  is selected or removed. The Recycler also remembers the position in its
  selected-stones column, so repeated work no longer jumps back to the top.
- Every stone rolls its reward separately; the full combined result remains on
  screen and pickup-style cards flash what was received.
- A rare spice or special item replaces that stone's ordinary ingredient
  payout.
- Rare reward odds now scale with the recycled stone's tier:

| Stone tier | Special item | Spice |
| --- | ---: | ---: |
| 1 | 0.1% | 1% |
| 2 | 0.2% | 2% |
| 3 | 0.3% | 3% |
| 4 | 0.4% | 4% |
| 5 | 0.5% | 5% |

- Spice quality and ordinary ingredient quality also improve with stone tier.
- The Quiblet equipment screen separates Health, Attack, and Move Stones into
  tabs instead of one long mixed list.
- The previous- and next-page arrows sit together, away from the Back button.
- The persistent **Stone Workshop** button sits deliberately in the upper-right
  inventory frame above those tabs, rather than straddling the two equipment
  frames.
- Selecting an unfitted Power Stone on a Quiblet also offers **Stone Workshop**.
  It opens the Recycler tab with that stone selected, and Back returns to the
  same Quiblet.

### Navigation and player flow

- Resources' **Go to Cooking** button opens the pot when it is available. If a
  stew is already underway, Resources stays open and a brief coral-accented
  **A stew is already in progress!** notice explains why the pot cannot be
  changed.
- Cooking has a **Spice Workshop** shortcut. Returning from it preserves the
  ingredients, spices, and special items already placed in the cooking pot.
- A finished stew now uses Brighton's animated arrival sequence. Each exact new
  Quiblet walks into camp and its full stats, moves, and Power Stones appear
  during the reveal; saved UIDs prevent duplicate species from being confused.
- Expedition islands enter their level route on finger-up, not finger-down, and
  newly created level buttons briefly ignore the remainder of the island
  gesture or a double-tap. A fresh level selection is always required.

### Ingredient and scenery balance

Brighton's new scenery system replaces the earlier exact 25%/10%/5% family
table. In ordinary expeditions about 32% of props bear fruit, while about 90%
do in Berry Groves; breaking a fruit-bearing prop yields 1–2 items and plain
scenery yields nothing. Deliberate harvesting yields 2–4 items. About 6% of
ordinary harvestable props and 16% of Grove props are rich, yielding 5–8 items.
Grove and rich rewards roll as though the stage were eight levels deeper, so
valuable gathering spots can produce more exciting ingredients without making
radius attacks a dependable farming shortcut.

### Training balance

Brighton's September 19 catch-up system replaces the former lifetime-EXP
transfer formula. Each helper now has a relationship-adjusted target based on
its level. If the trainee is below that target, training moves it 90% of the
remaining distance toward it; a trainee already at or above the target receives
a smaller normal reward. The family edition deliberately lowers Brighton's
relationship factors while keeping that mechanism:

| Helper relationship | Family target | Brighton's original target |
| --- | ---: | ---: |
| Same species | 50% | 92% |
| Same evolution family | 46% | 89% |
| Same type | 42% | 85% |
| Unrelated | 38% | 80% |

A level-10 trainee with one level-100 same-species helper therefore reaches
about level 46, compared with about level 84 under Brighton's original factors
and about level 51 under the previous family formula. This remains intentionally
generous enough to make a valuable helper exciting without letting a retained
group instantly power-level an entire team.

Every food-based helper-retention chance remains halved from the original
values:

Current retention chance added by each food:

| Food tier | Poor match | Neutral | Good/excellent match |
| --- | ---: | ---: | ---: |
| 1 | 1.25% | 2.5% | 5% |
| 2 | 2.5% | 5% | 10% |
| 3 | 3.75% | 7.5% | 15% |
| 4 | 5% | 10% | 20% |

Two excellent tier-4 foods therefore give one helper a 40% chance to stay,
down from 80%. Move Training success chances were not changed. These changes
affect future training only; they do not reduce levels already earned.

## Branch history

### September 10, 2026

- **`d35a5ef` — Prepare touch controls for iPad**  
  Added iPad aspect handling, touch-to-mouse behavior, and touch-friendly team,
  equipment, cooking, and training interactions.
- **`31cb67f` — Add approved Quiblets app icon**  
  Added and configured the expedition-island home-screen icon.

### September 11, 2026

- **`d21095b` — Merge upstream Quiblets update into iPad release**  
  Brought Brighton's newest game, expedition, creature, move, and cooking work
  into the iPad branch while retaining its iPad configuration.

### September 12, 2026

- **`c294f99` — Document deferred iPad scrolling review**  
  Recorded the awkward-scrollbar audit before implementation.
- **`6999950` — Give Plip family a water-drop silhouette**  
  Added the first approved creature-shape change and completed the development
  signing values used for the family test export.
- **`31bca48` — Guard iPad exports against preview scenes**  
  Added a regression check that prevents an F6 preview scene from accidentally
  becoming the exported game's startup scene.
- **`65cf293` — Maintain approved Quiblet visual overrides**  
  Isolated the approved model features, added corresponding preview and
  regression coverage, and documented how to preserve them through merges.
- **`4ebf5ac` — Merge upstream main into iPad release**  
  Incorporated the next small upstream expedition update.
- **`baf8fb2` — Add native-feeling iPad touch scrolling**  
  Implemented shared swipe behavior across all active scrolling surfaces.
- **`1b9136d` — Match portraits and rebalance scenery loot**  
  Matched the in-game portraits to the maintained models and reduced scenery
  farming while giving successful scenery drops a modest rarity boost.
- **`a6e356c` — Refine creature portraits and add stone recycler**  
  Refined Spriggle, Sparko, and Scorchit and added single- and multi-stone
  recycling with visible rewards.
- **`f95e909` — Add interactive recycler preview**  
  Added an F6 preview fixture for reviewing the recycler without changing a
  real save.
- **`f7abeb0` — Add stone type tabs to Quiblet equipment**  
  Split the equipment inventory into Health, Attack, and Move tabs and added a
  focused preview and regression test.
- **`1216f22` — Keep stone page arrows together**  
  Moved the next-page arrow beside the previous-page arrow on the equipment
  screen so the Back button cannot cover it.
- **`0dc1f2b` — Rebalance stone recycling and training**  
  Added tier-scaled recycler odds and reduced EXP transfer and helper retention
  to prevent repeated training from overpowering a team.
- **`e1b5d03` — Connect related workshop and expedition flows**
  Centralized recycling in the Stone Workshop, connected Cooking and the Spice
  Workshop, repaired Resources-to-Cooking, added exact arrival inspection, and
  prevented expedition island taps from spilling into a level.
- **`3758068` — Explain when the cooking pot is already busy**
  Kept Resources open and displayed a small notice when Go to Cooking is used
  during an active stew, while preserving normal navigation to an idle pot.

### September 14, 2026

- **`d44b97b` upstream — Expand camp and expeditions, improve Quiblet behavior
  and menus, and protect saves**
  Integrated Brighton's latest models, portraits, animated arrival sequence,
  compact Resources and cooking menus, six-column stone tabs, Combiner Charm,
  revitalizer variation, larger expedition fields, bridge and movement work,
  richer Grove gathering, camp behavior, and explicit test-save protections.
- **Family-edition merge resolution — this merge commit**
  Gave Brighton's replacements priority while preserving iPad swipe scrolling,
  paired stone-page arrows, the five-mode Workshop and batch Recycler, tiered
  recycler rewards, reduced training gains and retention, cooking/workshop
  shortcuts, the active-stew notice, explicit level selection, iOS settings,
  fallback creature refinements, and save compatibility.

### September 17, 2026

- **`5880b4e` upstream — Improve Quiblet arrivals, equipment menus, movement,
  and artwork**
  Adopted Brighton's newer creature models and portraits, move artwork,
  equipment refinements, camp movement, and arrival behavior.
- **`ebe1aab` upstream — Expand regional exploration and refine expeditions and
  stone workshop**
  Adopted Brighton's connected regional map, optional-region discovery,
  expedition refinements, charm equipment, and Stone Workshop improvements.
- **Family-edition merge resolution — this merge commit**
  Brighton's gameplay, artwork, and core interface decisions take precedence.
  The merge preserves the iPad touch controls and signing, family balance,
  five-tab Stone Workshop, tier-scaled mixed recycling rewards, cooking and
  workshop navigation, explicit level selection, and maintained visual
  fallbacks. Recycling now uses Brighton's fifteen-stone limit and verifies
  each selected stone before destroying it. All five Workshop modes preserve
  their list positions while selecting and processing stones.

### September 19, 2026

- **`148cac2` upstream — Add Quiblets and camp gardening, refine moves and
  equipment UI**
  Adopted Brighton's camp garden, new Quiblets and imported models, expanded
  ingredients and recipes, team presets, fitted-equipment display, evolution
  pause, move refinements, and regional-map cache.
- **Family-edition merge resolution — this merge commit**
  Kept Brighton's new artwork and gameplay decisions wherever they overlap the
  family branch. Preserved iPad touch scrolling, Workshop list positions,
  explicit expedition-level selection, cooking and workshop shortcuts, iOS
  settings, and visual fallbacks where Brighton has no supplied art. The red
  equipment-screen Recycler and the Workshop Recycler now open the same shared
  system. Brighton's EXP catch-up mechanism remains, with reduced 50/46/42/38%
  relationship targets and the family edition's reduced helper-retention odds.
  The cached regional map returned in about 14 ms after a roughly 1.4-second
  first build in the headless regression check.

## Upstream merge policy

When Brighton pushes new work:

1. Fetch and merge the upstream `main` branch into `ipad-release`.
2. Resolve conflicts narrowly; do not replace whole iPad-modified files without
   reviewing the family-edition changes they contain.
3. Preserve the visual-override hooks in `scripts/quiblet_model_3d.gd` and the
   implementation in `scripts/quiblet_visual_overrides.gd`.
4. Preserve `TouchScrollContainer` and every active use listed in
   `docs/ipad-touch-scrolling-review.md`.
5. Preserve the iOS bundle identifier, icon, ARM64 export, and development
   signing configuration unless the distribution plan deliberately changes.
6. Recheck the balance tables in this document if upstream work changes
   recycling, scenery rewards, or training.
7. Run the verification suite below and visually inspect both preview scenes.

## Verification

Focused automated checks:

- `tests/smoke.gd` — general startup, core screen, and main-scene export guard
- `tests/touch_scrolling.gd` — touch gestures and scrollbar replacement
- `tests/visual_overrides.gd` — maintained model hooks
- `tests/ingredient_drops.gd` — ordinary and Berry Grove scenery probabilities
- `tests/power_stone_recycling.gd` — batch recycling and tier reward boundaries
- `tests/training.gd` — XP transfer, retention, confirmation, and helper handling
- `tests/stone_inventory_tabs.gd` — stone filtering, paging, and arrow placement
- `tests/stone_workshop_scroll.gd` — per-mode list-position preservation after
  selecting or removing Workshop and Recycler stones
- `tests/navigation_flows.gd` — cross-screen workshop, cooking, and arrival
  inspection routes
- `tests/areas.gd` — explicit island-to-route-to-level gesture separation

Interactive Godot previews:

- `tests/quiblet_visual_overrides_preview.tscn`
- `tests/quiblet_portrait_preview.tscn`
- `tests/stone_recycler_preview.tscn`
- `tests/stone_inventory_tabs_preview.tscn`

Latest verified result on September 20, 2026:

- September 20 navigation flows: **10 checks, 0 failures**
- September 20 cooking and spice display: **160 checks, 0 failures**
- September 20 Stone Workshop and three-stone revitalizing cost:
  **170 checks, 0 failures**
- September 20 encounter pacing and 22–32-unit walk bounds:
  **371 checks, 0 failures**
- September 20 music states, including regular Expedition music in both Berry
  Grove types: **62 checks, 0 failures**

- Power Stone recycling and both entry routes: **22 checks, 0 failures**
- Stone Workshop: **169 checks, 0 failures**
- Stone Workshop scroll memory: **8 checks, 0 failures**
- Navigation flows: **7 checks, 0 failures**
- Touch scrolling: **20 checks, 0 failures**
- Stone inventory tabs: **11 checks, 0 failures**
- Menu updates: **7,494 checks, 0 failures**
- Animated arrivals: **passed**
- Training: **77 checks, 0 failures**
- EXP catch-up formula and reduced relationship targets: **passed**
- Regional-map cache, team refresh, and discovery invalidation: **passed**
- Full smoke check: **passed**
- Brighton's charm equipment, camp navigation, regional progression and
  discovery, and training-equipment refund checks: **passed**

The legacy all-special-items check exceeded four minutes while constructing
its exhaustive expedition-cache sample after the regional expansion. Its
Stone Workshop behavior is covered by the passing focused Workshop checks;
the cache sampling portion should be profiled separately rather than treated
as a functional merge failure.

## Physical iPad release checklist

1. **Synchronize the branch**  
   Success: `ipad-release` contains the intended upstream update and the
   preservation checks pass.  
   Achievement: Brighton's newest features and the family iPad changes coexist.

2. **Open and verify the main game in Godot**  
   Success: the normal game reaches Base Camp and
   `run/main_scene="res://main.tscn"`.  
   Achievement: the export will contain the game rather than a test preview.

3. **Run focused and smoke checks**  
   Success: every listed check exits with zero failures.  
   Achievement: interaction, visuals, rewards, training, and startup remain
   intact after the merge.

4. **Export a fresh iOS Xcode project**  
   Success: Godot completes the iOS project export without errors.  
   Achievement: Xcode receives a current native wrapper and game package.

5. **Confirm signing in Xcode**  
   Success: the Quiblets target uses the intended team, automatic signing, a
   unique bundle identifier, and Apple Development with no provisioning errors.  
   Achievement: Apple permits this Mac to install the test build on the device.

6. **Run on a connected iPad**  
   Success: the device is unlocked and trusted, Xcode's Run triangle installs
   Quiblets, and the game advances beyond the Godot startup screen.  
   Achievement: the newest branch build is playable on physical hardware.

7. **Perform a short touch and balance play test**  
   Success: lists swipe naturally, equipment tabs and arrows are unobstructed,
   creature models and portraits match, and one test of recycling and training
   reports the displayed results correctly.  
   Achievement: the build is ready for broader friends-and-family testing.

## Next planned release

The next device build should include Brighton's upstream commit `148cac2` and
the September 19 family-edition merge resolution. Before installing it, repeat
the physical iPad release checklist rather than reusing an older Godot export
or Xcode snapshot.

Future entries should record the date, commit, reason for the change, exact
player-visible behavior, important values or decisions, tests performed, and
anything that must be preserved during the next upstream merge.
