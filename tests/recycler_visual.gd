extends SceneTree
# Visual check of selection and rewards in the Power Stone Recycler. Run non-headless.

func _initialize()->void:call_deferred("run")

func stone(stone_type:String,power:int,bonuses:Array)->Dictionary:
	return GameData.normalize_power_stone({"type":stone_type,"power":power,"bonuses":bonuses})

func fixtures()->Array[Dictionary]:
	return [
		stone("Attack",410,["Critical Hit Rate","Movement Speed","Health"]),
		stone("Attack",392,["Attack","Evasion","Move Cooldown"]),
		stone("Attack",190,["Healing Received"]),
		stone("Health",118,["Damage Resistance"]),
		stone("Health",300,["Health"]),
		stone("Health",90,[]),
		stone("Health",520,["Evasion","Health"]),
		stone("Attack",640,[]),
	]

func run()->void:
	var game=load("res://main.tscn").instantiate();root.add_child(game);await process_frame;await create_timer(2.5).timeout
	game.power_stone_inventory=fixtures();game.begin_stone_recycler()
	for index in [0,2,4,6]:game.toggle_recycler_stone(index)
	await create_timer(.4).timeout;await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/private/tmp/quiblets-stone-recycler.png")
	var rng:=RandomNumberGenerator.new();rng.seed=42;game.recycle_selected_power_stones(.5,rng)
	await create_timer(.4).timeout;await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/private/tmp/quiblets-stone-recycler-result.png")
	print("QUIBLETS_RECYCLER_VISUAL_OK")
	quit()
