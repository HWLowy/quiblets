# iPad touch-scrolling review

Status: **Deferred**. Brighton plans to address most or all of this work. Recheck
the latest upstream version on a physical iPad before implementing anything.

## Already addressed upstream

The Spice Workshop's old single-row ingredient chooser and tiny horizontal
scrollbar were replaced with a fixed two-row grid. All 16 ingredients now fit
without scrolling. This change is present on `ipad-release`, but was not in the
first Xcode snapshot installed for testing.

## Scrollable areas to retest

The current game still creates scrollable views in these active areas:

1. Resources: ingredient inventory (vertical)
2. Resources: special items and leftovers (vertical)
3. Cooking: crafted spices (horizontal; cards are also draggable)
4. Recipe Journal (vertical)
5. Use Item: Quiblet target list (vertical)
6. Use Item: move or stone choices (vertical)
7. Stone Workshop: stone inventory (vertical)
8. Stone Workshop: selected-stone details (vertical)
9. Paused expedition: collected-reward columns (vertical)

There is also an obsolete legacy team screen with a scroll view. It is not
currently reachable by players and does not need an iPad-specific adjustment.

## Intended iPad behavior

- Swipe the content itself with one finger; never require grabbing a small bar.
- Hide scrollbars while preserving touch scrolling.
- Lock each view to its intended horizontal or vertical direction.
- Use a small movement threshold so taps remain taps.
- Preserve mouse-wheel and trackpad scrolling on desktop builds.
- Carefully test the Cooking spice row because a card must support both
  horizontal swiping and dragging into a pot slot.

## Revisit checklist

1. Merge Brighton's latest upstream work.
2. Export a fresh Xcode project and test all nine areas on a physical iPad.
3. Remove any item from this list that Brighton has already corrected.
4. For remaining Godot `ScrollContainer` views, use hidden-scrollbar modes that
   keep built-in touch dragging enabled; do not remove the internal scrollbars.
5. Add regression checks for direction, hidden bars, and the touch deadzone.
6. Verify tapping, dragging items, and swiping on the physical iPad before
   publishing the next build.

## Completion criteria

Every overflowing list scrolls by swiping anywhere within its content, no thin
scrollbar must be grabbed, ordinary taps still select items, draggable items can
still be placed correctly, and desktop scrolling remains functional.
