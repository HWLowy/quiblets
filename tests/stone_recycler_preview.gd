extends Node

func stone(stone_type:String,power:int,bonuses:Array)->Dictionary:
	return GameData.normalize_power_stone({"type":stone_type,"power":power,"bonuses":bonuses})

func _ready()->void:
	var game=preload("res://main.tscn").instantiate();add_child(game)
	await get_tree().process_frame
	game.persistence_enabled=false
	if is_instance_valid(game.startup_overlay):game.startup_overlay.queue_free();game.startup_overlay=null;game.startup_music.stop()
	var preview_stones:Array[Dictionary]=[
		stone("Attack",410,["Critical Hit Rate","Movement Speed","Health"]),
		stone("Attack",392,["Attack","Evasion","Move Cooldown"]),
		stone("Attack",190,["Healing Received"]),
		stone("Health",118,["Damage Resistance"]),
		stone("Health",300,["Health"]),
		stone("Health",90,[]),
		stone("Health",520,["Evasion","Health"]),
		stone("Attack",640,[]),
		stone("Health",220,["Knockback Resistance"]),
		stone("Attack",330,["Healing Received","Critical Hit Rate"]),
		stone("Health",480,["Evasion"]),
		stone("Attack",120,[]),
	]
	game.power_stone_inventory.clear()
	for preview_stone in preview_stones:game.power_stone_inventory.append(preview_stone)
	game.begin_stone_recycler()
	for index in [0,2,4,6]:game.toggle_recycler_stone(index)
