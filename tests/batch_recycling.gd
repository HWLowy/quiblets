extends SceneTree

func _initialize():call_deferred("run")

func run():
	var game=load("res://main.tscn").instantiate();root.add_child(game);await process_frame
	assert(game.save_access_blocked())
	game.power_stone_inventory.clear()
	for i in 16:game.power_stone_inventory.append(GameData.make_power_stone("Health" if i%2==0 else "Attack",1,[]))
	game.begin_stone_recycler();await process_frame
	for i in 16:game.toggle_recycler_stone(i)
	assert(game.stone_recycler_selected.size()==15 and not game.stone_recycler_selected.has(15))
	assert(game.recycle_batch_valid(game.stone_recycler_selected))
	# A stored stone snapshot prevents a later inventory change from recycling a
	# different item at the same array position.
	game.power_stone_inventory[0].power=int(game.power_stone_inventory[0].power)+1
	assert(not game.recycle_batch_valid(game.stone_recycler_selected))
	game.recycle_selected_power_stones(.5);await process_frame
	assert(game.power_stone_inventory.size()==16 and game.stone_recycler_selected.is_empty())
	for i in 15:game.toggle_recycler_stone(i)
	var total:=0
	for stone in game.stone_recycler_selected.values():total+=game.power_stone_recycle_count(stone)
	game.request_recycle_selected_power_stones();await process_frame
	assert(game.power_stone_inventory.size()==16 and game.content.find_child("RecyclerConfirmationScroll",true,false)!=null)
	game.content.find_child("CancelRecycleBatch",true,false).pressed.emit();await process_frame
	assert(game.power_stone_inventory.size()==16 and game.stone_recycler_selected.size()==15)
	var before:int=game.ingredients.values().reduce(func(a,b):return a+int(b),0)
	var rng:=RandomNumberGenerator.new();rng.seed=41
	game.recycle_selected_power_stones(.5,rng);await process_frame
	var after:int=game.ingredients.values().reduce(func(a,b):return a+int(b),0)
	assert(game.power_stone_inventory.size()==1 and after-before==total)
	assert(game.content.find_children("RecyclerRewardRow*","",true,false).size()==game.last_recycle_rewards.size())
	assert(game.content.find_children("RecycleRewardFlash*","",true,false).size()==game.last_recycle_rewards.size())
	var recipe:Dictionary=GameData.RECIPES[0]
	game.leftovers[recipe.name]=1
	game.recycle_leftover(recipe);await process_frame
	assert(game.content.find_child("RecyclingResults",true,false)!=null and game.leftovers[recipe.name]==0)
	print("Batch selection limit, snapshot validation, cancellation, confirmation and rewards passed")
	game.queue_free();await process_frame;quit()
