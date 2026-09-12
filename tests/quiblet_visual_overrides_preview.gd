extends Node3D

func _ready() -> void:
	add_environment()
	add_floor()
	add_lighting()
	add_camera()
	add_quiblet(0, -4.8, "PLIP")
	add_quiblet(1, -3.2, "SWELLIT")
	add_quiblet(2, -1.6, "SPRIGGLE")
	add_quiblet(3, 0.0, "FRONDLE")
	add_quiblet(5, 1.6, "BLOOMIE")
	add_quiblet(6, 3.2, "SPARKO")
	add_quiblet(7, 4.8, "SCORCHIT")
	add_heading()

func add_environment() -> void:
	var world := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("edf6ee")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color.WHITE
	environment.ambient_light_energy = 0.85
	world.environment = environment
	add_child(world)

func add_floor() -> void:
	var floor := MeshInstance3D.new()
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(13.0, 4.5)
	floor.mesh = floor_mesh
	floor.material_override = preview_material(Color("d7ead4"))
	add_child(floor)

func add_lighting() -> void:
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-48.0, -28.0, 0.0)
	light.light_energy = 1.2
	light.shadow_enabled = true
	add_child(light)

func add_camera() -> void:
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 6.4
	camera.position = Vector3(0.0, 4.2, 9.0)
	add_child(camera)
	camera.look_at(Vector3(0.0, 1.0, 0.0))
	camera.current = true

func add_quiblet(species_index: int, x_position: float, display_name: String) -> void:
	var model := QuibletModel3D.new()
	add_child(model)
	model.position = Vector3(x_position, 0.02, 0.0)
	model.setup(species_index, false, 0.82)

	var name_label := Label3D.new()
	name_label.text = display_name
	name_label.position = Vector3(x_position, 2.08, 0.0)
	name_label.font_size = 22
	name_label.modulate = Color("253548")
	name_label.outline_size = 8
	name_label.outline_modulate = Color("f7fbf5")
	name_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(name_label)

func add_heading() -> void:
	var heading := Label3D.new()
	heading.text = "QUIBLETS — iPAD VISUAL OVERRIDES"
	heading.position = Vector3(0.0, 3.0, 0.0)
	heading.font_size = 30
	heading.modulate = Color("253548")
	heading.outline_size = 8
	heading.outline_modulate = Color("f7fbf5")
	heading.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(heading)

func preview_material(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.9
	return mat
