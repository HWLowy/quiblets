# Maintained iPad visual overrides

Status: approved family edition, maintained on `ipad-release` until Brighton replaces or adopts the designs.

## Source of truth

- `scripts/quiblet_visual_overrides.gd` contains the custom procedural geometry.
- `scripts/quiblet_model_3d.gd` contains two small hooks that apply the custom body and species features.
- `tests/quiblet_visual_overrides_preview.tscn` displays every maintained design together.
- `tests/visual_overrides.gd` verifies that each override remains connected after a merge.

## Current overrides

- Plip and Swellit: smooth water-drop body.
- Spriggle: original ears plus a smaller leaf-stem crown and curved vine arms.
- Frondle: leaf-stem crown and curved vine arms.
- Bloomie: flat six-petal Healing Bloom flower hat.
- Sparko: original tail plus a smaller three-peak flame crown.
- Scorchit: rounded three-peak flame crown with varied heights.

## Rule when merging Brighton's updates

Merge upstream changes normally into `ipad-release`. Preserve `scripts/quiblet_visual_overrides.gd` and the calls to `QuibletVisualOverrides.build_custom_body()` and `QuibletVisualOverrides.apply_species_features()` in the base model builder. If Brighton changes that same builder, resolve only those small hook locations by hand rather than accepting either whole file blindly.

After every upstream merge:

1. Run `tests/smoke.gd`.
2. Run `tests/visual_overrides.gd`.
3. Open `tests/quiblet_visual_overrides_preview.tscn` with **F6** for a visual check.
4. Confirm `project.godot` still starts `res://main.tscn` before exporting the iPad build.
