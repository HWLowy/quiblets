extends SceneTree

var checks:=0
var failures:=0

func check(condition:bool,message:String)->void:
	checks+=1
	if not condition:
		failures+=1
		push_error(message)

func _initialize()->void:call_deferred("run")

func wait_for_layout()->void:
	await process_frame
	await process_frame

func scroll_to_middle(scroll:ScrollContainer)->int:
	var target:=mini(220,scroll.get_v_scroll_bar().max_value-scroll.size.y)
	scroll.scroll_vertical=target
	return scroll.scroll_vertical

func run()->void:
	var game=load("res://main.tscn").instantiate();root.add_child(game);await process_frame
	assert(game.save_access_blocked())
	game.power_stone_inventory.clear()
	for index in 72:
		var bonuses:Array=[]
		if index%3==0:bonuses=["Health"]
		game.power_stone_inventory.append(GameData.make_power_stone("Health" if index%2==0 else "Attack",1+index%5,bonuses))

	# Every workshop operation rebuilds its stone cards after a choice. The list
	# should return to the same place instead of jumping to its first row.
	for mode in ["combine","revitalize","convert","reforge"]:
		game.begin_stone_workshop(mode);game.show_stone_workshop();await wait_for_layout()
		var before_scroll:ScrollContainer=game.content.find_child("WorkshopStoneScroll",true,false)
		var before:=scroll_to_middle(before_scroll)
		game.workshop_pick_stone(40);await wait_for_layout()
		var after_scroll:ScrollContainer=game.content.find_child("WorkshopStoneScroll",true,false)
		check(before>0 and abs(after_scroll.scroll_vertical-before)<=2,"%s should keep the stone-list position after choosing a stone."%mode.capitalize())

	# Each tab remembers its own list position while moving among Workshop tools.
	game.begin_stone_workshop("combine");game.show_stone_workshop();await wait_for_layout()
	var combine_scroll:ScrollContainer=game.content.find_child("WorkshopStoneScroll",true,false)
	combine_scroll.scroll_vertical=160;var combine_position:=combine_scroll.scroll_vertical
	game.set_stone_workshop_mode("revitalize");await wait_for_layout()
	var revitalize_scroll:ScrollContainer=game.content.find_child("WorkshopStoneScroll",true,false)
	revitalize_scroll.scroll_vertical=300;var revitalize_position:=revitalize_scroll.scroll_vertical
	game.set_stone_workshop_mode("combine");await wait_for_layout()
	check(abs(game.content.find_child("WorkshopStoneScroll",true,false).scroll_vertical-combine_position)<=2,"Returning to Combine should restore its own list position.")
	game.set_stone_workshop_mode("revitalize");await wait_for_layout()
	check(abs(game.content.find_child("WorkshopStoneScroll",true,false).scroll_vertical-revitalize_position)<=2,"Returning to Revitalize should restore its own list position.")

	# Recycler choices rebuild both columns, so preserve the inventory and selected
	# stone lists independently—including after enough selections to overflow.
	game.begin_stone_recycler();await wait_for_layout()
	var recycler_scroll:ScrollContainer=game.content.find_child("RecyclerStoneScroll",true,false)
	var recycler_before:=scroll_to_middle(recycler_scroll)
	game.toggle_recycler_stone(40);await wait_for_layout()
	check(abs(game.content.find_child("RecyclerStoneScroll",true,false).scroll_vertical-recycler_before)<=2,"Recycler should keep the inventory position after selecting a stone.")
	for index in range(41,55):game.toggle_recycler_stone(index)
	await wait_for_layout()
	var detail_scroll:ScrollContainer=game.content.find_child("RecyclerDetailScroll",true,false)
	var detail_before:=scroll_to_middle(detail_scroll)
	game.toggle_recycler_stone(54);await wait_for_layout()
	check(detail_before>0 and abs(game.content.find_child("RecyclerDetailScroll",true,false).scroll_vertical-detail_before)<=2,"Recycler should keep the selected-stone detail position after removing a stone.")

	print("QUIBLETS_STONE_WORKSHOP_SCROLL_OK checks=%d failures=%d"%[checks,failures])
	quit(0 if failures==0 else 1)
