extends SceneTree

func _initialize() -> void:
	var expected := {
		0: "plip_water_drop_body",
		1: "plip_water_drop_body",
		2: "spriggle_leaf_crown_and_vines",
		3: "frondle_leaf_crown_and_vines",
		5: "bloomie_healing_bloom_hat",
		6: "sparko_flame_crown",
		7: "scorchit_flame_crown",
	}
	for species_index in expected:
		var model := QuibletModel3D.new()
		root.add_child(model)
		model.setup(species_index)
		var applied: Array = model.get_meta("visual_overrides", [])
		assert(applied.has(expected[species_index]), "%s lost its maintained iPad visual override" % GameData.species(species_index).name)
		if species_index in [0, 1]:
			assert(model.find_child("VisualOverrideWaterDropBody", true, false) != null, "The Plip family needs its outward-facing water-drop body")
		if species_index in [2, 3]:
			assert(model.find_children("VisualOverrideVineArm*", "MeshInstance3D", true, false).size() == 2, "Spriggle and Frondle need two smooth vine arms")
		if species_index == 2:
			assert(model.find_children("*", "MeshInstance3D", true, false).filter(func(part): return part.mesh is BoxMesh).size() == 1, "Spriggle's leaf crown must replace both original ears")
		if species_index == 5:
			assert(model.find_children("VisualOverrideBloomiePetal*", "MeshInstance3D", true, false).size() == 6, "Bloomie's flat Healing Bloom hat needs six petals")
		if species_index in [6, 7]:
			assert(model.find_children("VisualOverrideFlamePeak*", "MeshInstance3D", true, false).size() == 3, "Sparko and Scorchit need three rounded flame peaks")
		model.free()
	var ordinary := QuibletModel3D.new()
	root.add_child(ordinary)
	ordinary.setup(4)
	assert(ordinary.get_meta("visual_overrides", []).is_empty(), "Unrelated Quiblets should keep Bright's standard model builder")
	ordinary.free()
	print("QUIBLETS_VISUAL_OVERRIDES_OK species=%d" % expected.size())
	quit()
