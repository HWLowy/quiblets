extends Node

func stone(stone_type:String,power:int,bonuses:Array=[])->Dictionary:
	return GameData.normalize_power_stone({"type":stone_type,"power":power,"bonuses":bonuses})

func _ready()->void:
	var game=preload("res://main.tscn").instantiate();add_child(game)
	await get_tree().process_frame
	game.persistence_enabled=false
	if is_instance_valid(game.startup_overlay):game.startup_overlay.queue_free();game.startup_overlay=null;game.startup_music.stop()
	while game.roster.size()<2:game.roster.append(GameData.make_quiblet(2,12))
	game.roster[0].level=100;game.power_stone_inventory.clear()
	for preview_stone in [
		stone("Health",520,["Health","Evasion"]),stone("Health",330,["Healing Received"]),stone("Health",190,[]),stone("Health",90,["Movement Speed"]),
		stone("Attack",640,["Attack","Critical Hit Rate"]),stone("Attack",410,["Move Cooldown"]),stone("Attack",220,[]),stone("Attack",118,["Movement Speed"]),
	]:game.power_stone_inventory.append(preview_stone)
	game.move_stone_inventory.clear()
	for move_stone in GameData.MOVE_STONES:game.move_stone_inventory[str(move_stone.effect)]=2
	var owner:Dictionary=game.roster[1];game.ensure_quiblet_equipment(owner)
	var health_slot:=GameData.first_power_slot_accepting(owner,"Health");owner.power_slot_stones[health_slot]=stone("Health",700,["Health","Damage Resistance"])
	var attack_slot:=GameData.first_power_slot_accepting(owner,"Attack");owner.power_slot_stones[attack_slot]=stone("Attack",690,["Attack","Critical Hit Rate"])
	game.selected_roster=0;game.stone_inventory_filter="health";game.selected_inventory_item.clear();game.show_quiblet_edit()
