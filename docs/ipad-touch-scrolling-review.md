# iPad touch-scrolling review

Status: **Implemented on `ipad-release`**. Retest on a physical iPad before the
next family build is distributed.

## Already addressed upstream

The Spice Workshop's old single-row ingredient chooser and tiny horizontal
scrollbar were replaced with a fixed two-row grid. All 16 ingredients now fit
without scrolling. This change is present on `ipad-release`, but was not in the
first Xcode snapshot installed for testing.

## Touch-enabled areas

The shared `TouchScrollContainer` now provides one-finger swiping in these
active areas:

1. Resources: ingredient inventory (vertical)
2. Resources: special items and leftovers (vertical)
3. Cooking: crafted spices (horizontal; cards are also draggable)
4. Recipe Journal (vertical)
5. Use Item: Quiblet target list (vertical)
6. Use Item: move or stone choices (vertical)
7. Stone Workshop: stone inventory (vertical)
8. Stone Workshop: selected-stone details (vertical)
9. Power Stone Recycler: stone inventory (vertical)
10. Power Stone Recycler: selected stones and received rewards (vertical)
11. Paused expedition: collected-reward columns (vertical)

There is also an obsolete legacy team screen with a scroll view. It is not
currently reachable by players and does not need an iPad-specific adjustment.

## Implemented iPad behavior

- Swipe the content itself with one finger; never require grabbing a small bar.
- Hide scrollbars while preserving touch scrolling.
- Lock each view to its intended horizontal or vertical direction.
- Use a small movement threshold so taps remain taps.
- Preserve mouse-wheel and trackpad scrolling on desktop builds.
- The Cooking spice row claims sideways swipes, while an upward drag remains
  available for dragging a spice into the pot.
- A short tap still selects a Power Stone; a swipe suppresses the emulated
  mouse release so it cannot select the stone under the finger.
- A gentle inertial glide continues briefly after a quick swipe.

## Release checklist

1. Run `tests/touch_scrolling.gd` and `tests/smoke.gd`.
2. Export a fresh Xcode project and test all eleven areas on a physical iPad.
3. Verify tapping, dragging items, and swiping before publishing the next build.

## Completion criteria

Every overflowing list scrolls by swiping anywhere within its content, no thin
scrollbar must be grabbed, ordinary taps still select items, draggable items can
still be placed correctly, and desktop scrolling remains functional.
