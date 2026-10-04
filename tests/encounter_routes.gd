extends SceneTree

func _initialize()->void:call_deferred("run")

func run()->void:
	for seed in [4101,4102,4103,4104]:
		var field:=Expedition3D.new();field.stage_area_index=seed%16;field.stage_node_index=seed%6;field.stage_kind="level";field.stage_level=GameData.expedition_node_level(field.stage_area_index,field.stage_node_index);field.map_seed=seed;root.add_child(field);field.set_process(false);field.build_level()
		var walker:=QuibletActor3D.new();walker.setup(GameData.make_quiblet(0,10));walker.position=Vector3(field.zones[0].center.x,0,field.zones[0].center.y);field.place_actor(walker);walker.set_physics_process(false);field.team.append(walker)
		var previous:Vector2=Vector2(field.zones[0].center);var previous_progress:float=field.route_progress(previous);field.max_waves=7
		var route_length:=field.encounter_route_length()
		assert(route_length>=field.SET_TARGET_WALK_DISTANCE*6.0,"The exploration sweep must fit every regular-stage set")
		for step in 6:
			field.wave=step+1
			var point:Vector2=field.spawn_points[field.pick_spawn_point()]
			var walk:=field.encounter_walk_distance(previous,point);var progress:float=field.spawn_route_progresses.back()
			assert(walk>=field.SET_MIN_TEAM_DISTANCE-.1 and walk<=field.SET_MAX_WALK_DISTANCE+.1,"Encounter walk left the medium 8–10 second band: %.1f"%walk)
			assert(progress>=previous_progress+field.MIN_ROUTE_ADVANCE-.1,"Encounter route doubled back or circled: %.1f -> %.1f"%[previous_progress,progress])
			walker.position=Vector3(point.x,0,point.y);previous=point;previous_progress=progress
		field.free();await process_frame
	print("QUIBLETS_ENCOUNTER_ROUTES_OK seeds=4 steps=24 band=%d-%d"%[Expedition3D.SET_MIN_TEAM_DISTANCE,Expedition3D.SET_MAX_WALK_DISTANCE])
	quit()
