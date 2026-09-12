# Quiblets iPad Release Notes

This document records the purpose, decisions, completed work, verification, and
release process for the family iPad edition maintained on the `ipad-release`
branch of `HWLowy/quiblets`.

Status: **Playable family test build**  
Last updated: **September 12, 2026**  
Latest recorded gameplay commit: **`e1b5d03`**
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

The following approved model details are intentionally maintained on this
branch until Brighton adopts or replaces them:

- **Plip and Swellit:** smooth water-drop silhouette.
- **Spriggle:** leaf-stem crown, curved vine arms, and removal of the old horns.
- **Frondle:** leaf-stem crown and smooth curved vine arms.
- **Bloomie:** flat six-petal Healing Bloom flower hat.
- **Sparko:** larger three-height flame crown while retaining its tail.
- **Scorchit:** larger rounded three-height flame crown blended into its body.
- The small in-game portraits mirror these model features.

The procedural geometry is isolated in
`scripts/quiblet_visual_overrides.gd`. Full preservation instructions and
preview scenes are in `docs/ipad-visual-overrides.md`.

### Power Stone experience

- Added the Power Stone Recycler as a fifth tab inside the Stone Workshop, so
  combining, revitalizing, converting, reforging, and recycling all live in one
  stone-management destination.
- Up to ten unfitted stones can be selected and recycled together.
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
- Selecting an unfitted Power Stone on a Quiblet now offers **Stone Workshop**
  instead of a separate recycling action. It opens the Recycler tab with that
  stone selected, and Back returns to the same Quiblet.

### Navigation and player flow

- Resources' **Go to Cooking** button opens Cooking even while a stew is already
  underway, where its remaining-expedition status is visible.
- Cooking has a **Spice Workshop** shortcut. Returning from it preserves the
  ingredients, spices, and special items already placed in the cooking pot.
- A finished stew now offers both **Cook Again** and **Inspect Quiblet**. Inspect
  opens the exact newly arrived Quiblet's stats, moves, and Power Stones; its UID
  is stored in the completed-stew result so duplicate species cannot confuse the
  selection.
- Expedition islands enter their level route on finger-up, not finger-down, and
  newly created level buttons briefly ignore the remainder of the island
  gesture or a double-tap. A fresh level selection is always required.

### Ingredient and scenery balance

Destroying trees, bushes, rocks, and other harvestable scenery with area attacks
is no longer a dependable source of large ingredient stacks.

| Scenery type | Nothing | 1 item | 2 items | 3 items |
| --- | ---: | ---: | ---: | ---: |
| Ordinary expedition scenery | 60% | 25% | 10% | 5% |
| Berry Grove scenery | 45% | 30% | 15% | 10% |

A successful scenery drop is rolled as though the stage were four levels
higher, preserving the excitement of finding a slightly better ingredient.
Deliberately harvesting a feature still provides the richer harvest payout.

### Training balance

The initial training values allowed a small group of retained helpers to be
reused often enough to rapidly overpower an entire main team. The September 12
rebalance changed two parts of the system:

- EXP Training now transfers 15% of each helper's lifetime EXP before applying
  the relationship multiplier, down from 30%.
- Every food-based helper-retention chance was halved.

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
- `tests/navigation_flows.gd` — cross-screen workshop, cooking, and arrival
  inspection routes
- `tests/areas.gd` — explicit island-to-route-to-level gesture separation

Interactive Godot previews:

- `tests/quiblet_visual_overrides_preview.tscn`
- `tests/quiblet_portrait_preview.tscn`
- `tests/stone_recycler_preview.tscn`
- `tests/stone_inventory_tabs_preview.tscn`

Latest verified result on September 12, 2026:

- Power Stone recycling: **19 checks, 0 failures**
- Stone Workshop: **80 checks, 0 failures**
- Navigation flows: **7 checks, 0 failures**
- Expedition areas and routes: **509 checks, 0 failures**
- Touch scrolling: **20 checks, 0 failures**
- Cooking quality and flow: **147 checks, 0 failures**
- Stone inventory tabs: **11 checks, 0 failures**
- Special items: **103 checks, 0 failures**
- Training: **71 checks, 0 failures**
- Full smoke check: **passed**

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

The next device build should include everything through `e1b5d03`, followed by
any later commits recorded below this line. Before installing it, repeat the
physical iPad release checklist rather than reusing an older Godot export or
Xcode snapshot.

Future entries should record the date, commit, reason for the change, exact
player-visible behavior, important values or decisions, tests performed, and
anything that must be preserved during the next upstream merge.
