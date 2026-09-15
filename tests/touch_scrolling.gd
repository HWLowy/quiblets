extends SceneTree

var checks := 0
var failures := 0

class FakeExpedition extends Node:
	var loot := {"Bumbleberry": 2}
	var move_stones := {}
	var power_stones: Array[Dictionary] = []

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func touch(at: Vector2, pressed: bool, index := 0) -> InputEventScreenTouch:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = at
	event.pressed = pressed
	return event

func drag(to: Vector2, relative: Vector2, velocity: Vector2, index := 0) -> InputEventScreenDrag:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = to
	event.relative = relative
	event.velocity = velocity
	return event

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	# A standalone stone list verifies the gesture itself and the tap guard.
	var scroll := TouchScrollContainer.new().configure(TouchScrollContainer.AXIS_VERTICAL, "TestTouchScroll")
	scroll.position = Vector2(20, 20)
	scroll.size = Vector2(220, 180)
	root.add_child(scroll)
	var contents := Control.new()
	contents.custom_minimum_size = Vector2(200, 720)
	scroll.add_child(contents)
	var card := StoneInventoryCard.new()
	card.position = Vector2(10, 10)
	card.size = Vector2(80, 80)
	card.setup({"kind":"power_stone", "fitted":false})
	contents.add_child(card)
	await process_frame
	await process_frame
	check(scroll.vertical_scroll_mode == ScrollContainer.SCROLL_MODE_SHOW_NEVER and scroll.horizontal_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED, "A vertical touch list should hide its vertical bar and lock horizontal movement")
	check(scroll.has_scroll_range() and not scroll.get_v_scroll_bar().visible, "Overflowing touch content should remain scrollable without displaying the thin bar")
	var selected: Array[Dictionary] = []
	card.chosen.connect(func(data): selected.append(data))
	var start := Vector2(100, 140)
	scroll._input(touch(start, true))
	scroll._input(drag(start - Vector2(0, 90), Vector2(0, -90), Vector2(0, -700)))
	check(scroll.scroll_vertical > 0 and scroll.is_suppressing_tap(), "Swiping upward on a stone card should move the list itself")
	scroll._input(touch(start - Vector2(0, 90), false))
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	card._gui_input(release)
	check(selected.is_empty(), "Finishing a swipe must not accidentally choose the stone under the finger")
	await process_frame
	scroll._input(touch(start, true))
	scroll._input(touch(start, false))
	card._gui_input(release)
	check(selected.size() == 1, "A short ordinary stone tap must still choose the stone")
	root.remove_child(scroll)
	scroll.free()

	# Horizontal lists claim sideways swipes, while an upward drag remains free for
	# dragging a spice card toward the cooking pot.
	var horizontal := TouchScrollContainer.new().configure(TouchScrollContainer.AXIS_HORIZONTAL, "TestHorizontalTouchScroll")
	horizontal.position = Vector2(20, 20)
	horizontal.size = Vector2(220, 80)
	root.add_child(horizontal)
	var row := Control.new()
	row.custom_minimum_size = Vector2(800, 60)
	horizontal.add_child(row)
	await process_frame
	await process_frame
	check(horizontal.horizontal_scroll_mode == ScrollContainer.SCROLL_MODE_SHOW_NEVER and horizontal.vertical_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED, "A horizontal touch list should hide its horizontal bar and lock vertical movement")
	var horizontal_start := Vector2(100, 60)
	horizontal._input(touch(horizontal_start, true))
	horizontal._input(drag(horizontal_start - Vector2(0, 60), Vector2(0, -60), Vector2(0, -500)))
	check(not horizontal.touch_scrolling and horizontal.scroll_horizontal == 0, "An upward spice-card drag should not be mistaken for a sideways list swipe")
	horizontal._input(touch(horizontal_start - Vector2(0, 60), false))
	horizontal._input(touch(horizontal_start, true))
	horizontal._input(drag(horizontal_start - Vector2(80, 0), Vector2(-80, 0), Vector2(-800, 0)))
	check(horizontal.scroll_horizontal > 0, "A sideways finger swipe should move the cooking spice row")
	horizontal._input(touch(horizontal_start - Vector2(80, 0), false))
	root.remove_child(horizontal)
	horizontal.free()

	# Verify the active screens all use the touch-aware version.
	var game = load("res://main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.ingredients.keys().map(func(name): game.unlocked_ingredients.append(name))
	game.show_resources()
	await process_frame
	check(game.content.find_child("ResourceIngredientScroll",true,false)==null and game.content.find_child("SpecialItemScroll",true,false)==null,"Bright's compact Resources redesign should avoid scrollbars when every item fits on screen")
	check(game.content.find_children("*","IngredientDragCard",true,false).size()==GameData.INGREDIENTS.size(),"The fixed Resources grid should still expose every ingredient without scrolling")
	for spice_name in game.spice_inventory:
		for quality in game.spice_inventory[spice_name]: game.spice_inventory[spice_name][quality] = 1
	game.show_cooking()
	await process_frame
	check(game.content.find_child("CookingSpiceScroll", true, false) is TouchScrollContainer, "Cooking spices should scroll with a sideways swipe")
	game.show_recipes()
	await process_frame
	check(game.content.find_child("RecipeJournalScroll", true, false) is TouchScrollContainer, "The Recipe Journal should use vertical touch scrolling")
	for extra in 16: game.roster.append(GameData.make_quiblet(extra % GameData.SPECIES.size(), 5))
	game.special_items["Move Crystal"] = 1
	game.begin_item_use("Move Crystal")
	game.item_use.roster_index = 0
	game.show_item_use("Move Crystal")
	await process_frame
	for name in ["ItemTargetScroll", "ItemChoiceScroll"]:
		check(game.content.find_child(name, true, false) is TouchScrollContainer, "%s should use vertical touch scrolling" % name)
	game.power_stone_inventory.clear()
	for stone_index in 60:
		game.power_stone_inventory.append(GameData.make_power_stone("Health" if stone_index % 2 == 0 else "Attack", 1 + stone_index % 5, []))
	game.begin_stone_workshop("revitalize")
	game.show_stone_workshop()
	await process_frame
	var workshop: TouchScrollContainer = game.content.find_child("WorkshopStoneScroll", true, false)
	check(workshop != null and workshop.has_scroll_range() and not workshop.get_v_scroll_bar().visible, "The long Power Stone grid should swipe vertically with no visible scrollbar")
	check(game.content.find_child("WorkshopDetailScroll", true, false) is TouchScrollContainer, "Stone Workshop details should use vertical touch scrolling")
	var workshop_start := workshop.get_global_rect().get_center()
	workshop._input(touch(workshop_start, true))
	workshop._input(drag(workshop_start - Vector2(0, 100), Vector2(0, -100), Vector2(0, -800)))
	check(workshop.scroll_vertical > 0, "The actual Revitalize stone grid should move when its cards are swiped")
	workshop._input(touch(workshop_start - Vector2(0, 100), false))
	game.begin_stone_recycler()
	await process_frame
	var recycler: TouchScrollContainer = game.content.find_child("RecyclerStoneScroll", true, false)
	check(recycler != null and recycler.has_scroll_range() and not recycler.get_v_scroll_bar().visible, "The Power Stone Recycler grid should swipe vertically with no visible scrollbar")
	check(game.content.find_child("RecyclerDetailScroll", true, false) is TouchScrollContainer, "The recycler's selected stones and rewards should use vertical touch scrolling")

	var pause_host := Control.new()
	root.add_child(pause_host)
	var fake_expedition := FakeExpedition.new()
	game.add_child(fake_expedition)
	game.expedition = fake_expedition
	game.build_pause_reward_column(pause_host, "INGREDIENTS", Vector2.ZERO, "ingredient")
	await process_frame
	check(pause_host.find_child("PauseIngredientScroll", true, false) is TouchScrollContainer, "Collected rewards should swipe while the expedition is paused")

	print("QUIBLETS_TOUCH_SCROLLING_OK checks=%d failures=%d" % [checks, failures])
	quit(0 if failures == 0 else 1)
