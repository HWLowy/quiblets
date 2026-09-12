extends SceneTree

var failures:=0
var checks:=0

func check(condition:bool,message:String)->void:
	checks+=1
	if not condition:failures+=1;push_error(message)

func _initialize()->void:call_deferred("run")

func stone(stone_type:String,tier:int,bonuses:Array=[])->Dictionary:
	var power_range:Vector2i=GameData.POWER_STONE_RANGES[tier-1]
	return GameData.normalize_power_stone({"type":stone_type,"tier":tier,"power":power_range.x,"bonuses":bonuses})

func ingredient_total(game)->int:
	var total:=0
	for amount in game.ingredients.values():total+=int(amount)
	return total

func special_total(game)->int:
	var total:=0
	for amount in game.special_items.values():total+=int(amount)
	return total

func spice_total(game)->int:
	var total:=0
	for spice_name in game.spice_inventory:
		for quality in game.spice_inventory[spice_name]:total+=int(game.spice_inventory[spice_name][quality])
	return total

func run()->void:
	var game=load("res://main.tscn").instantiate();root.add_child(game);await process_frame
	var rng:=RandomNumberGenerator.new();rng.seed=90210
	var tier_five:=stone("Attack",5,["Attack","Movement Speed"])
	var special_rewards:Array=game.power_stone_recycle_rewards(tier_five,.0049,rng)
	var spice_rewards:Array=game.power_stone_recycle_rewards(tier_five,.005,rng)
	var ingredient_rewards:Array=game.power_stone_recycle_rewards(tier_five,.055,rng)
	check(special_rewards.size()==1 and special_rewards[0].kind=="special" and GameData.SPECIAL_ITEM_DROP_WEIGHTS.has(special_rewards[0].name),"The lowest 0.5% recycle roll should award exactly one existing special item")
	check(spice_rewards.size()==1 and spice_rewards[0].kind=="spice" and spice_rewards[0].quality=="special" and GameData.SPICES.has(spice_rewards[0].name),"The next 5% should award one spice, with tier 5 producing Special quality")
	check(ingredient_rewards.size()==game.power_stone_recycle_count(tier_five) and ingredient_rewards.all(func(reward):return reward.kind=="ingredient"),"All other rolls should award the stone's full ingredient payout")
	check(game.power_stone_recycle_spice_quality(stone("Health",1))=="basic" and game.power_stone_recycle_spice_quality(stone("Health",4))=="great","Recycled spice quality should improve with Power Stone tier")

	game.power_stone_inventory.clear()
	for index in 12:game.power_stone_inventory.append(stone("Health" if index%2==0 else "Attack",index%5+1,["Health"] if index%3==0 else []))
	game.show_resources();await process_frame
	check(game.content.find_child("OpenStoneRecycler",true,false)!=null,"Resources should have a dedicated Recycle Stones button")
	game.begin_stone_recycler();await process_frame
	check(game.screen=="stone_recycler" and game.content.find_child("RecyclerStoneScroll",true,false)!=null and game.content.find_children("RecyclerStone*","StoneInventoryCard",true,false).size()==12,"The recycler should show every unfitted stone in a touch-scrollable grid")
	for index in 10:game.toggle_recycler_stone(index)
	game.toggle_recycler_stone(10);await process_frame
	check(game.stone_recycler_selected.size()==10 and not game.stone_recycler_selected.has(10),"The recycler must refuse an eleventh selected stone")
	var expected_ingredients:int=int(game.recycler_normal_ingredient_total())
	var before_ingredients:=ingredient_total(game)
	game.request_recycle_selected_power_stones();await process_frame
	var confirmation=game.content.find_child("RecycleBatchConfirmation",true,false)
	check(confirmation!=null and confirmation.find_child("ConfirmRecycleBatch",true,false)!=null and game.power_stone_inventory.size()==12,"A batch asks for confirmation without destroying anything")
	confirmation.find_child("CancelRecycleBatch",true,false).pressed.emit();await process_frame
	check(game.power_stone_inventory.size()==12 and game.stone_recycler_selected.size()==10,"Cancelling keeps all selected stones")
	game.recycle_selected_power_stones(.5,rng);await process_frame
	var awarded:=0
	for reward in game.last_recycle_rewards:awarded+=int(reward.amount)
	check(game.power_stone_inventory.size()==2 and ingredient_total(game)-before_ingredients==expected_ingredients and awarded==expected_ingredients,"Recycling ten normal outcomes should remove exactly those ten stones and grant the full combined payout")
	check(game.screen=="stone_recycler" and game.stone_recycler_selected.is_empty() and game.content.find_children("RecyclerRewardRow*","",true,false).size()==game.last_recycle_rewards.size() and game.content.find_children("RecycleRewardFlash*","",true,false).size()==game.last_recycle_rewards.size(),"The complete reward list should remain visible while pickup-style reward cards flash")

	var before_specials:=special_total(game);game.stone_recycler_selected.clear();game.stone_recycler_selected.append(0);game.recycle_selected_power_stones(0.0,rng);await process_frame
	check(special_total(game)==before_specials+1 and game.last_recycle_rewards.size()==1 and game.last_recycle_rewards[0].kind=="special","A batch special roll should replace ingredients and enter the special-item inventory")
	game.power_stone_inventory.append(tier_five);var spice_index:int=game.power_stone_inventory.size()-1;var before_spices:=spice_total(game);game.stone_recycler_selected.clear();game.stone_recycler_selected.append(spice_index);game.recycle_selected_power_stones(.01,rng);await process_frame
	check(spice_total(game)==before_spices+1 and game.last_recycle_rewards.size()==1 and game.last_recycle_rewards[0].kind=="spice" and game.unlocked_spices.has(game.last_recycle_rewards[0].name),"A batch spice roll should replace ingredients, enter inventory, and reveal that spice")
	print("QUIBLETS_POWER_STONE_RECYCLING_OK checks=",checks," failures=",failures)
	quit(0 if failures==0 else 1)
