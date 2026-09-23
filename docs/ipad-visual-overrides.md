# Maintained iPad visual overrides

Status: approved family edition, maintained on `ipad-release` until Brighton replaces or adopts the designs.

## Source of truth

- `scripts/quiblet_visual_overrides.gd` contains the custom procedural geometry.
- `scripts/quiblet_portrait.gd` mirrors those features in the game's small 2D portraits.
- `scripts/quiblet_model_3d.gd` contains two small hooks that apply the custom body and species features.
- `tests/quiblet_visual_overrides_preview.tscn` displays every maintained design together.
- `tests/quiblet_portrait_preview.tscn` displays the matching portraits together.
- `tests/visual_overrides.gd` verifies that each override remains connected after a merge.

## Current overrides and fallbacks

- Swellit: smooth water-drop body. Plip now uses Brighton's supplied model.
- Spriggle and Frondle: Brighton's supplied models take precedence. Their
  procedural leaf-crown and vine-arm definitions remain only as fallbacks if
  those supplied model references are ever removed.
- Bloomie: flat six-petal Healing Bloom flower hat.
- Sparko: original tail plus a larger three-peak flame crown.
- Scorchit: larger rounded three-peak flame crown with varied heights.

## Rule when merging Brighton's updates

Merge upstream changes normally into `ipad-release`. Preserve `scripts/quiblet_visual_overrides.gd` and the calls to `QuibletVisualOverrides.build_custom_body()` and `QuibletVisualOverrides.apply_species_features()` in the base model builder. If Brighton changes that same builder, resolve only those small hook locations by hand rather than accepting either whole file blindly.

After every upstream merge:

1. Run `tests/smoke.gd`.
2. Run `tests/visual_overrides.gd`.
3. Open `tests/quiblet_visual_overrides_preview.tscn` with **F6** for a visual check.
4. Open `tests/quiblet_portrait_preview.tscn` with **F6** to check the small icons.
5. Confirm `project.godot` still starts `res://main.tscn` before exporting the iPad build.
